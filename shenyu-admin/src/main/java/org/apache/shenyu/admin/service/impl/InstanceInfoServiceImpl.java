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

import org.apache.shenyu.admin.mapper.InstanceInfoMapper;
import org.apache.shenyu.admin.model.dto.InstanceInfoDTO;
import org.apache.shenyu.admin.model.entity.InstanceInfoDO;
import org.apache.shenyu.admin.model.page.CommonPager;
import org.apache.shenyu.admin.model.page.PageResultUtils;
import org.apache.shenyu.admin.model.query.InstanceQuery;
import org.apache.shenyu.admin.model.vo.InstanceInfoVO;
import org.apache.shenyu.admin.service.InstanceInfoService;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.register.common.dto.InstanceInfoRegisterDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.Objects;

/**
 * Implementation of the {@link org.apache.shenyu.admin.service.InstanceInfoService}.
 */
@Service
public class InstanceInfoServiceImpl implements InstanceInfoService {
    
    private static final Logger LOG = LoggerFactory.getLogger(InstanceInfoServiceImpl.class);
    
    private final InstanceInfoMapper instanceInfoMapper;
    
    public InstanceInfoServiceImpl(final InstanceInfoMapper instanceInfoMapper) {
        this.instanceInfoMapper = instanceInfoMapper;
    }
    
    @Override
    public void registerInstanceInfo(final InstanceInfoRegisterDTO instanceInfoRegisterDTO) {
        LOG.info("Instance info registered: {}", GsonUtils.getInstance().toJson(instanceInfoRegisterDTO));
        InstanceInfoDTO instanceInfoDTO = buildInstanceInfoDTO(instanceInfoRegisterDTO);
        createOrUpdate(instanceInfoDTO);
    }
    
    @Override
    public void createOrUpdate(final InstanceInfoDTO instanceInfoDTO) {
        InstanceInfoDO infoDO = instanceInfoMapper.selectById(instanceInfoDTO.getId());
        if (Objects.isNull(infoDO)) {
            LOG.info("Register new instance info: {}", GsonUtils.getInstance().toJson(instanceInfoDTO));
            InstanceInfoDO instanceInfoDO = InstanceInfoDO.buildInstanceInfoDO(instanceInfoDTO);
            try {
                instanceInfoMapper.insert(instanceInfoDO);
            } catch (Exception e) {
                LOG.error("Failed to register instance info", e);
            }
            return;
        }
        LOG.info("Update instance info: {}", GsonUtils.getInstance().toJson(instanceInfoDTO));
        infoDO.setInstanceIp(instanceInfoDTO.getInstanceIp());
        infoDO.setInstanceType(instanceInfoDTO.getInstanceType());
        infoDO.setInstanceInfo(instanceInfoDTO.getInstanceInfo());
        infoDO.setNamespaceId(instanceInfoDTO.getNamespaceId());
        infoDO.setDateUpdated(Timestamp.from(Instant.now()));
        instanceInfoMapper.updateById(infoDO);
    }
    
    @Override
    public CommonPager<InstanceInfoVO> listByPage(final InstanceQuery instanceQuery) {
        List<InstanceInfoDO> instanceInfoDOList = instanceInfoMapper.selectByQuery(instanceQuery);
        return PageResultUtils.result(instanceQuery.getPageParameter(), () -> this.buildInstanceInfoVO(instanceInfoDOList));
    }
    
    @Override
    public InstanceInfoVO findById(final String id) {
        return null;
    }
    
    private InstanceInfoDTO buildInstanceInfoDTO(final InstanceInfoRegisterDTO instanceInfoRegisterDTO) {
        InstanceInfoDTO instanceInfoDTO = new InstanceInfoDTO();
        instanceInfoDTO.setId(instanceInfoRegisterDTO.getSessionId());
        instanceInfoDTO.setInstanceIp(instanceInfoRegisterDTO.getInstanceIp());
        instanceInfoDTO.setInstanceType(instanceInfoRegisterDTO.getInstanceType());
        instanceInfoDTO.setInstanceInfo(instanceInfoRegisterDTO.getInstanceInfo());
        instanceInfoDTO.setNamespaceId(instanceInfoRegisterDTO.getNamespaceId());
        return instanceInfoDTO;
    }
    
    private List<InstanceInfoVO> buildInstanceInfoVO(final List<InstanceInfoDO> instanceInfoDOList) {
        if (instanceInfoDOList.isEmpty()) {
            return List.of();
        }
        return instanceInfoDOList.stream()
                .map(this::buildInstanceInfoVO)
                .toList();
    }
    
    private InstanceInfoVO buildInstanceInfoVO(final InstanceInfoDO instanceInfoDO) {
        InstanceInfoVO instanceInfoVO = new InstanceInfoVO();
        instanceInfoVO.setId(instanceInfoDO.getId());
        instanceInfoVO.setInstanceIp(instanceInfoDO.getInstanceIp());
        instanceInfoVO.setInstanceType(instanceInfoDO.getInstanceType());
        instanceInfoVO.setInstanceInfo(instanceInfoDO.getInstanceInfo());
        instanceInfoVO.setNamespaceId(instanceInfoDO.getNamespaceId());
        instanceInfoVO.setDateCreated(instanceInfoDO.getDateCreated());
        instanceInfoVO.setDateUpdated(instanceInfoDO.getDateUpdated());
        return instanceInfoVO;
    }
}
