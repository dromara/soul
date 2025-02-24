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

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.annotation.Resource;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.shenyu.admin.model.dto.ApiDTO;
import org.apache.shenyu.admin.model.dto.TagDTO;
import org.apache.shenyu.admin.model.vo.TagVO;
import org.apache.shenyu.admin.service.ApiService;
import org.apache.shenyu.admin.service.TagService;
import org.apache.shenyu.admin.service.manager.RegisterApiDocService;
import org.apache.shenyu.common.utils.UUIDUtils;
import org.apache.shenyu.register.common.dto.ApiDocRegisterDTO;
import org.apache.shenyu.register.common.enums.EventType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * Implementation of the {@link org.apache.shenyu.admin.service.manager.RegisterApiDocService}.
 */
@Service
public class RegisterApiDocServiceImpl implements RegisterApiDocService {
    private static final Logger LOG = LoggerFactory.getLogger(RegisterApiDocServiceImpl.class);

    @Resource
    private ApiService apiService;

    @Resource
    private TagService tagService;

    @Override
    public void registerApiDocument(final ApiDocRegisterDTO apiDocRegisterDTO) {
        if (apiDocRegisterDTO.getEventType().equals(EventType.REGISTER)) {
            ApiDTO apiDTO = buildApiDTO(apiDocRegisterDTO);
            apiService.deleteByApiPathHttpMethodRpcType(apiDTO.getApiPath(), apiDTO.getHttpMethod(), apiDTO.getRpcType());
            List<String> tagsIds = new ArrayList<>();
            List<String> tags = Collections.singletonList(apiDocRegisterDTO.getContextPath());
            if (CollectionUtils.isNotEmpty(apiDocRegisterDTO.getTags())) {
                tags = apiDocRegisterDTO.getTags();
            }
            for (String tag : tags) {
                // tag value is contextPath,so remove first char '/'
                String appName = tag.substring(1);
                List<TagVO> byQuery = tagService.findByQuery(appName);
                if (CollectionUtils.isNotEmpty(byQuery)) {
                    tagsIds.addAll(byQuery.stream().map(TagVO::getId).collect(Collectors.toList()));
                } else {
                    TagDTO tagDTO = new TagDTO();
                    String id = UUIDUtils.getInstance().generateShortUuid();
                    tagDTO.setTagDesc(appName);
                    tagDTO.setName(appName);
                    tagDTO.setId(id);
                    tagService.createRootTag(tagDTO, null);
                    tagsIds.add(id);
                }
            }
            apiDTO.setTagIds(tagsIds);
            apiService.createOrUpdate(apiDTO);
        } else if (apiDocRegisterDTO.getEventType().equals(EventType.OFFLINE)) {
            apiService.offlineByContextPath(apiDocRegisterDTO.getContextPath());
        }
    }

    private ApiDTO buildApiDTO(final ApiDocRegisterDTO apiDocRegisterDTO) {
        ApiDTO apiDTO = new ApiDTO();
        apiDTO.setApiPath(apiDocRegisterDTO.getApiPath());
        apiDTO.setApiSource(apiDocRegisterDTO.getApiSource());
        apiDTO.setApiOwner(apiDocRegisterDTO.getApiOwner());
        apiDTO.setDocument(apiDocRegisterDTO.getDocument());
        apiDTO.setExt(apiDocRegisterDTO.getExt());
        apiDTO.setVersion(apiDocRegisterDTO.getVersion());
        apiDTO.setRpcType(apiDocRegisterDTO.getRpcType());
        apiDTO.setConsume(apiDocRegisterDTO.getConsume());
        apiDTO.setProduce(apiDocRegisterDTO.getProduce());
        apiDTO.setContextPath(apiDocRegisterDTO.getContextPath());
        apiDTO.setHttpMethod(apiDocRegisterDTO.getHttpMethod());
        apiDTO.setState(apiDocRegisterDTO.getState());
        apiDTO.setApiDesc(apiDocRegisterDTO.getApiDesc());
        return apiDTO;
    }
}
