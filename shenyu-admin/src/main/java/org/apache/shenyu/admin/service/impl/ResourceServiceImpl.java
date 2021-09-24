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

package org.apache.shenyu.admin.service.impl;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.aspect.annotation.Pageable;
import org.apache.shenyu.admin.mapper.PermissionMapper;
import org.apache.shenyu.admin.mapper.ResourceMapper;
import org.apache.shenyu.admin.model.dto.PermissionDTO;
import org.apache.shenyu.admin.model.dto.ResourceDTO;
import org.apache.shenyu.admin.model.entity.PermissionDO;
import org.apache.shenyu.admin.model.entity.ResourceDO;
import org.apache.shenyu.admin.model.page.CommonPager;
import org.apache.shenyu.admin.model.page.PageResultUtils;
import org.apache.shenyu.admin.model.query.ResourceQuery;
import org.apache.shenyu.admin.model.vo.PermissionMenuVO.MenuInfo;
import org.apache.shenyu.admin.model.vo.ResourceVO;
import org.apache.shenyu.admin.service.ResourceService;
import org.apache.shenyu.common.constant.AdminConstants;
import org.apache.shenyu.common.enums.AdminResourceEnum;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * Implementation of the {@link org.apache.shenyu.admin.service.ResourceService}.
 */
@Service
public class ResourceServiceImpl implements ResourceService {

    private final ResourceMapper resourceMapper;

    private final PermissionMapper permissionMapper;

    public ResourceServiceImpl(final ResourceMapper resourceMapper, final PermissionMapper permissionMapper) {
        this.resourceMapper = resourceMapper;
        this.permissionMapper = permissionMapper;
    }

    /**
     * create resource and return data.
     *
     * @param resourceDO {@linkplain ResourceDO}
     */
    @Override
    public void createResource(final ResourceDO resourceDO) {
        insertResource(resourceDO);
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
            return insertResource(resourceDO);
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
     * find resource info by title.
     *
     * @param title resource title
     * @return {@linkplain ResourceVO}
     */
    @Override
    public ResourceVO findByTitle(final String title) {
        return ResourceVO.buildResourceVO(resourceMapper.selectByTitle(title));
    }

    /**
     * find page of role by query.
     *
     * @param resourceQuery {@linkplain ResourceQuery}
     * @return {@linkplain CommonPager}
     */
    @Override
    @Pageable
    public CommonPager<ResourceVO> listByPage(final ResourceQuery resourceQuery) {
        return PageResultUtils.result(resourceQuery.getPageParameter(),
            () -> resourceMapper.selectByQuery(resourceQuery)
                            .stream()
                            .map(ResourceVO::buildResourceVO)
                            .collect(Collectors.toList()));
    }

    /**
     * get menu info.
     *
     * @return {@linkplain List}
     */
    @Override
    public List<MenuInfo> getMenuTree() {
        List<ResourceVO> resourceVOList = resourceMapper.selectAll().stream().map(ResourceVO::buildResourceVO).collect(Collectors.toList());
        if (CollectionUtils.isNotEmpty(resourceVOList)) {
            List<MenuInfo> menuInfoList = new ArrayList<>();
            getMenuInfo(menuInfoList, resourceVOList, null);
            return menuInfoList;
        }
        return null;
    }

    /**
     * get button by parent id.
     *
     * @param id resource id
     * @return {@linkplain List}
     */
    @Override
    public List<ResourceVO> findByParentId(final String id) {
        return resourceMapper.selectByParentId(id).stream()
                .filter(item -> item.getResourceType().equals(AdminResourceEnum.THREE_MENU.getCode()))
                .map(ResourceVO::buildResourceVO).collect(Collectors.toList());
    }

    /**
     * get Menu Info.
     *
     * @param menuInfoList {@linkplain List} menu info.
     * @param metaList {@linkplain List} resource list
     * @param menuInfo {@linkplain MenuInfo}
     */
    @Override
    public void getMenuInfo(final List<MenuInfo> menuInfoList, final List<ResourceVO> metaList, final MenuInfo menuInfo) {
        for (ResourceVO resourceVO : metaList) {
            String parentId = resourceVO.getParentId();
            MenuInfo tempMenuInfo = MenuInfo.buildMenuInfo(resourceVO);
            if (ObjectUtils.isEmpty(tempMenuInfo)) {
                continue;
            }
            if (ObjectUtils.isEmpty(menuInfo) && reactor.util.StringUtils.isEmpty(parentId)) {
                menuInfoList.add(tempMenuInfo);
                if (Objects.equals(resourceVO.getIsLeaf(), Boolean.FALSE)) {
                    getMenuInfo(menuInfoList, metaList, tempMenuInfo);
                }
            } else if (!ObjectUtils.isEmpty(menuInfo) && StringUtils.isNotEmpty(parentId) && parentId.equals(menuInfo.getId())) {
                menuInfo.getChildren().add(tempMenuInfo);
                if (Objects.equals(resourceVO.getIsLeaf(), Boolean.FALSE)) {
                    getMenuInfo(menuInfoList, metaList, tempMenuInfo);
                }
            }
        }
    }

    /**
     * get delete resource ids.
     *
     * @param resourceIds resource ids
     * @param metaList all resource object
     */
    private void getDeleteResourceIds(final Map<String, String> deleteResourceIds, final List<String> resourceIds,
                                      final List<ResourceVO> metaList) {
        List<String> matchResourceIds = new ArrayList<>();
        resourceIds.forEach(item -> {
            matchResourceIds.clear();
            metaList.forEach(resource -> {
                if (item.equals(resource.getParentId())) {
                    matchResourceIds.add(resource.getId());
                }
                if (item.equals(resource.getId()) || item.equals(resource.getParentId())) {
                    deleteResourceIds.put(resource.getId(), resource.getTitle());
                }
            });
            if (CollectionUtils.isNotEmpty(matchResourceIds)) {
                getDeleteResourceIds(deleteResourceIds, matchResourceIds, metaList);
            }
        });
    }

    /**
     * insert Resource.
     *
     * @param resourceDO {@linkplain ResourceDO}
     * @return row int
     */
    private int insertResource(final ResourceDO resourceDO) {
        permissionMapper.insertSelective(PermissionDO.buildPermissionDO(PermissionDTO.builder()
                .objectId(AdminConstants.ROLE_SUPER_ID)
                .resourceId(resourceDO.getId()).build()));
        return resourceMapper.insertSelective(resourceDO);
    }
}
