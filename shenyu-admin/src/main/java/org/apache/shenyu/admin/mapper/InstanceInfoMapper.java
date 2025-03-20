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

package org.apache.shenyu.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.shenyu.admin.model.entity.InstanceInfoDO;
import org.apache.shenyu.admin.model.query.InstanceQuery;
import org.apache.shenyu.admin.validation.ExistProvider;

import java.io.Serializable;
import java.util.List;

/**
 * InstanceInfoMapper.
 */
@Mapper
public interface InstanceInfoMapper extends ExistProvider {

    /**
     * existed.
     *
     * @param id id
     * @return existed
     */
    @Override
    Boolean existed(@Param("id") Serializable id);

    /**
     * selectAll.
     *
     * @return instanceInfoDOList
     */
    List<InstanceInfoDO> selectAll();

    /**
     * selectAllByNamespaceId.
     *
     * @param namespaceId the namespaceId
     * @return instanceInfoDOList
     */
    List<InstanceInfoDO> findAllByNamespaceId(String namespaceId);

    /**
     * selectById.
     *
     * @param id the id
     * @return instanceInfoDO
     */
    InstanceInfoDO selectById(String id);
    
    /**
     * select instance list by query.
     *
     * @param instanceQuery {@linkplain InstanceQuery}
     * @return the instance list
     */
    List<InstanceInfoDO> selectByQuery(InstanceQuery instanceQuery);
    
    /**
     * insert instanceInfoDO.
     *
     * @param instanceInfoDO instanceInfoDO.
     * @return rows
     */
    int insert(InstanceInfoDO instanceInfoDO);

    /**
     * delete discovery by id.
     *
     * @param id primary key.
     * @return rows.
     */
    int delete(String id);
    
    /**
     * update instanceInfoDO.
     *
     * @param instanceInfoDO instanceInfoDO.
     * @return rows
     */
    int updateById(InstanceInfoDO instanceInfoDO);
}
