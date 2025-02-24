/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.shenyu.admin.service.manager.impl;

import com.google.common.collect.Interner;
import com.google.common.collect.Interners;

import okhttp3.Response;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.http.HttpStatus;
import org.apache.shenyu.admin.model.bean.UpstreamInstance;
import org.apache.shenyu.admin.model.dto.TagDTO;
import org.apache.shenyu.admin.model.entity.TagDO;
import org.apache.shenyu.admin.model.vo.TagVO;
import org.apache.shenyu.admin.service.TagService;
import org.apache.shenyu.admin.service.manager.DocManager;
import org.apache.shenyu.admin.service.manager.PullSwaggerDocService;
import org.apache.shenyu.admin.utils.HttpUtils;
import org.apache.shenyu.common.constant.AdminConstants;
import org.apache.shenyu.common.utils.GsonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import jakarta.annotation.Resource;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

/**
 * ServiceDocManagerImpl.
 */
@Service
public class PullSwaggerDocServiceImpl implements PullSwaggerDocService {
    private static final Logger LOG = LoggerFactory.getLogger(PullSwaggerDocServiceImpl.class);

    private static final HttpUtils HTTP_UTILS = new HttpUtils();

    private static final String SWAGGER_V3_PATH = "/v3/api-docs";

    private static final long PULL_MIN_INTERVAL_TIME = 30 * 1000;

    private static final long DOC_LOCK_EXPIRED_TIME = 60 * 1000;

    private final Interner<Object> interner = Interners.newWeakInterner();

    @Resource
    private DocManager docManager;

    @Resource
    private TagService tagService;

    @Override
    public void pullApiDocument(final Set<UpstreamInstance> currentServices) {
        currentServices.forEach(this::pullApiDocument);
    }

    /**
     * pullApiDocument.
     *
     * @param instance UpstreamInstance.
     */
    @Override
    @SuppressWarnings("unchecked")
    public void pullApiDocument(final UpstreamInstance instance) {
        TagVO tagVO = null;
        synchronized (interner.intern(instance.getClusterName())) {
            tagVO = saveTagVOAndAcquireLock(instance);
            if (!canPull(instance, tagVO)) {
                LOG.info("api document has been pulled and cannot be pulled again，instance: {}", instance.getClusterName());
                return;
            }
        }
        TagDO.TagExt tagExt = tagVO.getTagExt();
        long newRefreshTime = System.currentTimeMillis();
        String url = getSwaggerRequestUrl(instance);
        try (Response response = HTTP_UTILS.requestForResponse(url, Collections.EMPTY_MAP, Collections.EMPTY_MAP, HttpUtils.HTTPMethod.GET)) {
            if (response.code() == HttpStatus.SC_NOT_FOUND) {
                LOG.warn("add api document not found. clusterName={} url={}", instance.getClusterName(), url);
                return;
            }
            if (response.code() != HttpStatus.SC_OK) {
                throw new IOException(response.toString());
            }
            final String body = response.body().string();
            docManager.addDocInfo(
                instance,
                body,
                tagExt.getApiDocMd5(),
                callback -> {
                    LOG.info("save api document successful，clusterName={}, ipPort={}", instance.getClusterName(), instance.getIp() + ":" + instance.getPort());
                    tagExt.setApiDocMd5(callback.getDocMd5());
                }
            );
            tagExt.setRefreshTime(newRefreshTime);
        } catch (Exception e) {
            LOG.error("add api document fail. clusterName={} url={} error", instance.getClusterName(), url, e);
        } finally {
            tagExt.setDocLock(null);
            //Save the time of the last updated document and the newMd5 of apidoc.
            tagService.updateTagExt(tagVO.getId(), tagExt);
        }
    }

    private boolean canPull(final UpstreamInstance instance, final TagVO tagVO) {
        boolean canPull = false;
        if (Objects.isNull(tagVO) || Objects.isNull(tagVO.getTagExt()) || StringUtils.isEmpty(tagVO.getTagExt().getDocLock())) {
            LOG.info("Unable to obtain lock for {}, retry after {} seconds.", instance.getClusterName(), DOC_LOCK_EXPIRED_TIME / 1000);
            return false;
        }
        Long cacheLastStartUpTime = tagVO.getTagExt().getRefreshTime();
        if (Objects.isNull(cacheLastStartUpTime) || instance.getStartupTime() > cacheLastStartUpTime + PULL_MIN_INTERVAL_TIME) {
            canPull = true;
        }
        return canPull;
    }

    private TagVO saveTagVOAndAcquireLock(final UpstreamInstance instance) {
        List<TagVO> tagVOList = tagService.findByQuery(instance.getClusterName(), AdminConstants.TAG_ROOT_PARENT_ID);
        if (CollectionUtils.isNotEmpty(tagVOList)) {
            TagVO tagVO = tagVOList.get(0);
            TagDO.TagExt tagExt = convertTagExt(tagVO.getExt());
            tagVO.setTagExt(tagExt);
            if (StringUtils.isNotEmpty(tagExt.getDocLock()) && NumberUtils.toLong(tagExt.getDocLock(), 0) > System.currentTimeMillis()) {
                tagExt.setDocLock(null);
                return tagVO;
            }
            tagExt.setDocLock(this.generateDocLock());
            tagService.updateTagExt(tagVO.getId(), tagExt);
            return tagVO;
        }
        return createRootTagAndAcquireLock(instance);
    }

    private TagVO createRootTagAndAcquireLock(final UpstreamInstance instance) {
        TagDTO tagDTO = new TagDTO();
        tagDTO.setTagDesc(instance.getClusterName());
        tagDTO.setName(instance.getClusterName());
        tagDTO.setParentTagId(AdminConstants.TAG_ROOT_PARENT_ID);
        TagDO.TagExt tagExt = new TagDO.TagExt();
        tagExt.setDocLock(this.generateDocLock());
        tagService.createRootTag(tagDTO, tagExt);

        TagVO tagVO = new TagVO();
        tagVO.setId(tagDTO.getId());
        tagVO.setTagExt(tagExt);
        return tagVO;
    }

    private String generateDocLock() {
        return String.valueOf(System.currentTimeMillis() + DOC_LOCK_EXPIRED_TIME);
    }

    private TagDO.TagExt convertTagExt(final String ext) {
        return StringUtils.isNotEmpty(ext) ? GsonUtils.getInstance().fromJson(ext, TagDO.TagExt.class) : new TagDO.TagExt();
    }

    private String getSwaggerRequestUrl(final UpstreamInstance instance) {
        UriComponentsBuilder uriComponentsBuilder = UriComponentsBuilder.newInstance();
        uriComponentsBuilder.scheme("http");
        uriComponentsBuilder.host(instance.getIp());
        uriComponentsBuilder.port(instance.getPort());
        uriComponentsBuilder.path(Optional.ofNullable(instance.getContextPath()).orElse(""));
        uriComponentsBuilder.path(SWAGGER_V3_PATH);
        return uriComponentsBuilder.build().toUriString();
    }

}
