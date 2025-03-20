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

package org.apache.shenyu.admin.service;

import org.apache.shenyu.admin.model.dto.InstanceInfoDTO;
import org.apache.shenyu.admin.model.page.CommonPager;
import org.apache.shenyu.admin.model.query.InstanceQuery;
import org.apache.shenyu.admin.model.query.InstanceQueryCondition;
import org.apache.shenyu.admin.model.vo.InstanceInfoVO;
import org.apache.shenyu.register.common.dto.InstanceInfoRegisterDTO;

public interface InstanceInfoService extends PageService<InstanceQueryCondition, InstanceInfoVO> {
    
    /**
     * registerInstanceInfo.
     * <p>
     * instance info register info .
     * </p>
     *
     * @param instanceInfoRegisterDTO instanceInfoRegisterDTO
     */
    void registerInstanceInfo(InstanceInfoRegisterDTO instanceInfoRegisterDTO);
    
    /**
     * Creates or updates an instance information record.
     *
     * @param instanceInfoDTO the instance information data transfer object
     */
    void createOrUpdate(InstanceInfoDTO instanceInfoDTO);
    
    CommonPager<InstanceInfoVO> listByPage(InstanceQuery instanceQuery);
    
    InstanceInfoVO findById(String id);
}
