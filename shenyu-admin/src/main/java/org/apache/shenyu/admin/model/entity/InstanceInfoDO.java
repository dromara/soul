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

package org.apache.shenyu.admin.model.entity;

import org.apache.shenyu.admin.model.dto.InstanceInfoDTO;

import java.sql.Timestamp;
import java.util.Objects;

/**
 * InstanceInfoDO.
 */
public final class InstanceInfoDO extends BaseDO {
    
    private String instanceIp;
    
    private String instanceType;
    
    private String instanceInfo;
    
    private String namespaceId;
    
    public InstanceInfoDO() {
        
    }
    
    /**
     * InstanceInfoDO.
     *
     * @param instanceIp instanceIp
     * @param instanceType instanceType
     * @param instanceInfo instanceInfo
     */
    public InstanceInfoDO(final String instanceIp, final String instanceType, final String instanceInfo) {
        this.instanceIp = instanceIp;
        this.instanceType = instanceType;
        this.instanceInfo = instanceInfo;
    }
    
    /**
     * InstanceInfoDO.
     *
     * @param id id
     * @param dateCreated dateCreated
     * @param dateUpdated dateUpdated
     * @param instanceIp instanceIp
     * @param instanceType instanceType
     * @param instanceInfo instanceInfo
     */
    public InstanceInfoDO(final String id, final Timestamp dateCreated, final Timestamp dateUpdated,
                          final String instanceIp, final String instanceType, final String instanceInfo) {
        super(id, dateCreated, dateUpdated);
        this.instanceIp = instanceIp;
        this.instanceType = instanceType;
        this.instanceInfo = instanceInfo;
    }
    
    /**
     * InstanceInfoDO.
     *
     * @param id id
     * @param dateCreated dateCreated
     * @param dateUpdated dateUpdated
     * @param instanceIp instanceIp
     * @param instanceType instanceType
     * @param instanceInfo instanceInfo
     * @param namespaceId namespaceId
     */
    public InstanceInfoDO(final String id, final Timestamp dateCreated, final Timestamp dateUpdated,
                          final String instanceIp, final String instanceType, final String instanceInfo,
                          final String namespaceId) {
        super(id, dateCreated, dateUpdated);
        this.instanceIp = instanceIp;
        this.instanceType = instanceType;
        this.instanceInfo = instanceInfo;
        this.namespaceId = namespaceId;
    }
    
    /**
     * build InstanceInfoDO.
     *
     * @param instanceInfoDTO instanceInfoDTO
     * @return InstanceInfoDO
     */
    public static InstanceInfoDO buildInstanceInfoDO(final InstanceInfoDTO instanceInfoDTO) {
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        return InstanceInfoDO.builder()
                .id(instanceInfoDTO.getId())
                .instanceIp(instanceInfoDTO.getInstanceIp())
                .instanceType(instanceInfoDTO.getInstanceType())
                .instanceInfo(instanceInfoDTO.getInstanceInfo())
                .namespaceId(instanceInfoDTO.getNamespaceId())
                .dateCreated(currentTime)
                .dateUpdated(currentTime)
                .build();
    }
    
    /**
     * get instanceIp.
     *
     * @return instanceIp
     */
    public String getInstanceIp() {
        return instanceIp;
    }
    
    /**
     * set instanceIp.
     *
     * @param instanceIp instanceIp
     */
    public void setInstanceIp(final String instanceIp) {
        this.instanceIp = instanceIp;
    }
    
    /**
     * get instanceType.
     *
     * @return instanceType
     */
    public String getInstanceType() {
        return instanceType;
    }
    
    /**
     * set instanceType.
     *
     * @param instanceType instanceType
     */
    public void setInstanceType(final String instanceType) {
        this.instanceType = instanceType;
    }
    
    /**
     * get instanceInfo.
     *
     * @return instanceInfo
     */
    public String getInstanceInfo() {
        return instanceInfo;
    }
    
    /**
     * set instanceInfo.
     *
     * @param instanceInfo instanceInfo
     */
    public void setInstanceInfo(final String instanceInfo) {
        this.instanceInfo = instanceInfo;
    }
    
    /**
     * get namespaceId.
     *
     * @return namespaceId
     */
    public String getNamespaceId() {
        return namespaceId;
    }
    
    /**
     * set namespaceId.
     *
     * @param namespaceId namespaceId
     */
    public void setNamespaceId(final String namespaceId) {
        this.namespaceId = namespaceId;
    }
    
    /**
     * builder.
     *
     * @return InstanceInfoDOBuilder
     */
    public static InstanceInfoDOBuilder builder() {
        return new InstanceInfoDOBuilder();
    }
    
    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (Objects.isNull(o) || getClass() != o.getClass()) {
            return false;
        }
        if (!super.equals(o)) {
            return false;
        }
        InstanceInfoDO instanceInfoDO = (InstanceInfoDO) o;
        return Objects.equals(instanceIp, instanceInfoDO.instanceIp)
                && Objects.equals(instanceType, instanceInfoDO.instanceType)
                && Objects.equals(instanceInfo, instanceInfoDO.instanceInfo)
                && Objects.equals(namespaceId, instanceInfoDO.namespaceId);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), instanceIp, instanceType, instanceInfo, namespaceId);
    }
    
    public static final class InstanceInfoDOBuilder {
        
        private String id;
        
        private Timestamp dateCreated;
        
        private Timestamp dateUpdated;
        
        private String instanceIp;
        
        private String instanceType;
        
        private String instanceInfo;
        
        private String namespaceId;
        
        private InstanceInfoDOBuilder() {
            
        }
        
        /**
         * id.
         *
         * @param id the id
         * @return InstanceInfoDOBuilder.
         */
        public InstanceInfoDOBuilder id(final String id) {
            this.id = id;
            return this;
        }
        
        /**
         * dateCreated.
         *
         * @param dateCreated the dateCreated.
         * @return InstanceInfoDOBuilder.
         */
        public InstanceInfoDOBuilder dateCreated(final Timestamp dateCreated) {
            this.dateCreated = dateCreated;
            return this;
        }
        
        /**
         * dateUpdated.
         *
         * @param dateUpdated the dateUpdated.
         * @return InstanceInfoDOBuilder.
         */
        public InstanceInfoDOBuilder dateUpdated(final Timestamp dateUpdated) {
            this.dateUpdated = dateUpdated;
            return this;
        }
        
        /**
         * instanceIp.
         *
         * @param instanceIp instanceIp
         * @return InstanceInfoDOBuilder
         */
        public InstanceInfoDOBuilder instanceIp(final String instanceIp) {
            this.instanceIp = instanceIp;
            return this;
        }
        
        /**
         * instanceType.
         *
         * @param instanceType instanceType
         * @return InstanceInfoDOBuilder
         */
        public InstanceInfoDOBuilder instanceType(final String instanceType) {
            this.instanceType = instanceType;
            return this;
        }
        
        /**
         * instanceInfo.
         *
         * @param instanceInfo instanceInfo
         * @return InstanceInfoDOBuilder
         */
        public InstanceInfoDOBuilder instanceInfo(final String instanceInfo) {
            this.instanceInfo = instanceInfo;
            return this;
        }
        
        
        /**
         * namespaceId.
         *
         * @param namespaceId namespaceId
         * @return InstanceInfoDOBuilder
         */
        public InstanceInfoDOBuilder namespaceId(final String namespaceId) {
            this.namespaceId = namespaceId;
            return this;
        }
        
        
        /**
         * build InstanceInfoDO.
         *
         * @return InstanceInfoDO
         */
        public InstanceInfoDO build() {
            InstanceInfoDO instanceInfoDO = new InstanceInfoDO();
            instanceInfoDO.setId(id);
            instanceInfoDO.setDateCreated(dateCreated);
            instanceInfoDO.setDateUpdated(dateUpdated);
            instanceInfoDO.setInstanceIp(instanceIp);
            instanceInfoDO.setInstanceType(instanceType);
            instanceInfoDO.setInstanceInfo(instanceInfo);
            instanceInfoDO.setNamespaceId(namespaceId);
            return instanceInfoDO;
        }
    }
}
