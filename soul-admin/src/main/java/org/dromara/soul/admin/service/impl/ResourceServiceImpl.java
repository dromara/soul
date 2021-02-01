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

package org.dromara.soul.admin.service.impl;

import org.apache.commons.lang3.StringUtils;
import org.dromara.soul.admin.dto.PermissionDTO;
import org.dromara.soul.admin.dto.ResourceDTO;
import org.dromara.soul.admin.entity.PermissionDO;
import org.dromara.soul.admin.entity.ResourceDO;
import org.dromara.soul.admin.mapper.PermissionMapper;
import org.dromara.soul.admin.mapper.ResourceMapper;
import org.dromara.soul.admin.page.CommonPager;
import org.dromara.soul.admin.page.PageResultUtils;
import org.dromara.soul.admin.query.ResourceQuery;
import org.dromara.soul.admin.service.ResourceService;
import org.dromara.soul.admin.vo.ResourceVO;
import org.dromara.soul.common.constant.AdminConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * this Resource Service Impl.
 *
 * @author nuo-promise
 */
@Service("resourceService")
public class ResourceServiceImpl implements ResourceService {

    private final ResourceMapper resourceMapper;

    private final PermissionMapper permissionMapper;

    @Autowired(required = false)
    public ResourceServiceImpl(final ResourceMapper resourceMapper, final PermissionMapper permissionMapper) {
        this.resourceMapper = resourceMapper;
        this.permissionMapper = permissionMapper;
    }

    /**
     *  create or update resource.
     *
     * @param resourceDTO {@linkplain ResourceDTO}
     * @return rows int
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int createOrUpdate(final ResourceDTO resourceDTO) {
        ResourceDO resourceDO = ResourceDO.buildResourceDO(resourceDTO);
        if (StringUtils.isEmpty(resourceDTO.getId())) {
            permissionMapper.insertSelective(PermissionDO.buildPermissionDO(PermissionDTO.builder()
                    .objectId(AdminConstants.ROLE_SUPER_ID)
                    .resourceId(resourceDO.getId()).build()));
            return resourceMapper.insertSelective(resourceDO);
        } else {
            return resourceMapper.updateSelective(resourceDO);
        }
    }

    /**
     * delete resource info.
     *
     * @param ids {@linkplain List}
     * @return rows int
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int delete(final List<String> ids) {
        Map<String, String> deleteResourceMap = new HashMap<>();
        List<ResourceVO> resourceVOList = resourceMapper.selectAll().stream().map(ResourceVO::buildResourceVO).collect(Collectors.toList());
        getDeleteResourceIds(deleteResourceMap, ids, resourceVOList);
        List<String> deleteResourceIds = new ArrayList<>(deleteResourceMap.keySet());
        permissionMapper.deleteByResourceId(deleteResourceIds);
        return resourceMapper.delete(deleteResourceIds);
    }

    /**
     * find resource info by id.
     *
     * @param id resource id
     * @return {@linkplain ResourceVO}
     */
    @Override
    public ResourceVO findById(final String id) {
        return ResourceVO.buildResourceVO(resourceMapper.selectById(id));
    }

    /**
     * find page of role by query.
     *
     * @param resourceQuery {@linkplain ResourceQuery}
     * @return {@linkplain CommonPager}
     */
    @Override
    public CommonPager<ResourceVO> listByPage(final ResourceQuery resourceQuery) {
        return PageResultUtils.result(resourceQuery.getPageParameter(),
            () -> resourceMapper.countByQuery(resourceQuery),
            () -> resourceMapper.selectByQuery(resourceQuery)
                            .stream()
                            .map(ResourceVO::buildResourceVO)
                            .collect(Collectors.toList()));
    }

    /**
     * get delete resource ids.
     *
     * @param resourceIds resource ids
     * @param metaList all resource object
     */
    private void getDeleteResourceIds(final Map<String, String> deleteResourceIds, final List<String> resourceIds, final List<ResourceVO> metaList) {
        List<String> matchResourceIds = new ArrayList<>();
        resourceIds.forEach(item -> {
            matchResourceIds.clear();
            metaList.forEach(resource -> {
                if (resource.getParentId().equals(item)) {
                    matchResourceIds.add(resource.getId());
                }
                if (resource.getId().equals(item) || resource.getParentId().equals(item)) {
                    deleteResourceIds.put(resource.getId(), resource.getTitle());
                    metaList.removeIf(resourceId -> resourceId.equals(item));
                }
            });
            if (matchResourceIds.size() > 0) {
                getDeleteResourceIds(deleteResourceIds, matchResourceIds, metaList);
            }
        });
    }
}
