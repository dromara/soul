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

package org.apache.shenyu.register.common.dto;

import org.apache.shenyu.register.common.type.DataType;
import org.apache.shenyu.register.common.type.DataTypeParent;

/**
 * InstanceInfoRegisterDTO.
 */
public class InstanceInfoRegisterDTO implements DataTypeParent {
    
    /**
     * session id.
     */
    private String sessionId;
    
    /**
     * instance ip.
     */
    private String instanceIp;
    
    /**
     * instance type.
     */
    private String instanceType;
    
    /**
     * instance info.
     */
    private String instanceInfo;
    
    /**
     * namespace id.
     */
    private String namespaceId;
    
    public InstanceInfoRegisterDTO(final String sessionId, final String instanceIp, final String instanceType, final String instanceInfo, final String namespaceId) {
        this.sessionId = sessionId;
        this.instanceIp = instanceIp;
        this.instanceType = instanceType;
        this.instanceInfo = instanceInfo;
        this.namespaceId = namespaceId;
    }
    
    private InstanceInfoRegisterDTO(final Builder builder) {
        this.sessionId = builder.sessionId;
        this.instanceIp = builder.instanceIp;
        this.instanceType = builder.instanceType;
        this.instanceInfo = builder.instanceInfo;
        this.namespaceId = builder.namespaceId;
    }
    
    /**
     * builder method.
     *
     * @return builder object.
     */
    public static InstanceInfoRegisterDTO.Builder builder() {
        return new InstanceInfoRegisterDTO.Builder();
    }
    
    /**
     * get session id.
     *
     * @return session id
     */
    public String getSessionId() {
        return sessionId;
    }
    
    /**
     * set session id.
     *
     * @param sessionId session id
     */
    public void setSessionId(final String sessionId) {
        this.sessionId = sessionId;
    }
    
    /**
     * get instance ip.
     *
     * @return instance ip
     */
    public String getInstanceIp() {
        return instanceIp;
    }
    
    /**
     * set instance ip.
     *
     * @param instanceIp instance ip
     */
    public void setInstanceIp(final String instanceIp) {
        this.instanceIp = instanceIp;
    }
    
    /**
     * get instance type.
     *
     * @return instance type
     */
    public String getInstanceType() {
        return instanceType;
    }
    
    /**
     * set instance type.
     *
     * @param instanceType instance type
     */
    public void setInstanceType(final String instanceType) {
        this.instanceType = instanceType;
    }
    
    /**
     * get instance info.
     *
     * @return instance info
     */
    public String getInstanceInfo() {
        return instanceInfo;
    }
    
    /**
     * set instance info.
     *
     * @param instanceInfo instance info
     */
    public void setInstanceInfo(final String instanceInfo) {
        this.instanceInfo = instanceInfo;
    }
    
    /**
     * get namespace id.
     *
     * @return namespace id
     */
    public String getNamespaceId() {
        return namespaceId;
    }
    
    /**
     * set namespace id.
     *
     * @param namespaceId namespace id
     */
    public void setNamespaceId(final String namespaceId) {
        this.namespaceId = namespaceId;
    }
    
    
    @Override
    public DataType getType() {
        return DataType.INSTANCE_INFO;
    }
    
    
    public static final class Builder {
        
        /**
         * sessionId.
         */
        private String sessionId;
        
        /**
         * instance ip.
         */
        private String instanceIp;
        
        /**
         * instance type.
         */
        private String instanceType;
        
        /**
         * instance info.
         */
        private String instanceInfo;
        
        /**
         * namespace id.
         */
        private String namespaceId;
        
        private Builder() {
        }
        
        /**
         * sessionId.
         *
         * @param sessionId sessionId
         * @return InstanceInfoRegisterDTO.Builder
         */
        public InstanceInfoRegisterDTO.Builder sessionId(final String sessionId) {
            this.sessionId = sessionId;
            return this;
        }
        
        /**
         * instance type.
         *
         * @param instanceType instance type
         * @return InstanceInfoRegisterDTO.Builder
         */
        public InstanceInfoRegisterDTO.Builder instanceType(final String instanceType) {
            this.instanceType = instanceType;
            return this;
        }
        
        /**
         * instance info.
         *
         * @param instanceInfo instance info
         * @return InstanceInfoRegisterDTO.Builder
         */
        public InstanceInfoRegisterDTO.Builder instanceInfo(final String instanceInfo) {
            this.instanceInfo = instanceInfo;
            return this;
        }
        
        /**
         * instance ip.
         *
         * @param instanceIp instance ip
         * @return InstanceInfoRegisterDTO.Builder
         */
        public InstanceInfoRegisterDTO.Builder instanceIp(final String instanceIp) {
            this.instanceIp = instanceIp;
            return this;
        }
        
        /**
         * namespace id.
         *
         * @param namespaceId namespace id
         * @return InstanceInfoRegisterDTO.Builder
         */
        public InstanceInfoRegisterDTO.Builder namespaceId(final String namespaceId) {
            this.namespaceId = namespaceId;
            return this;
        }
        
        /**
         * build.
         *
         * @return InstanceInfoRegisterDTO instance info register dto
         */
        public InstanceInfoRegisterDTO build() {
            return new InstanceInfoRegisterDTO(this);
        }
        
    }
}
