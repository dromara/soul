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

package org.apache.shenyu.admin.model.vo;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Objects;

/**
 * InstanceInfoVO.
 */
public class InstanceInfoVO implements Serializable {

    private static final long serialVersionUID = -5798225577222473005L;

    /**
     * id.
     */
    private String id;
    
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
     * namespaceId.
     */
    private String namespaceId;
    
    /**
     * created time.
     */
    private Timestamp dateCreated;
    
    /**
     * updated time.
     */
    private Timestamp dateUpdated;
    
    /**
     * get id.
     *
     * @return id
     */
    public String getId() {
        return id;
    }
    
    /**
     * set id.
     *
     * @param id id
     */
    public void setId(final String id) {
        this.id = id;
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
     * get dateCreated.
     *
     * @return dateCreated
     */
    public Timestamp getDateCreated() {
        return dateCreated;
    }
    
    /**
     * set dateCreated.
     *
     * @param dateCreated dateCreated
     */
    public void setDateCreated(final Timestamp dateCreated) {
        this.dateCreated = dateCreated;
    }
    
    /**
     * get dateUpdated.
     *
     * @return dateUpdated
     */
    public Timestamp getDateUpdated() {
        return dateUpdated;
    }
    
    /**
     * set dateUpdated.
     *
     * @param dateUpdated dateUpdated
     */
    public void setDateUpdated(final Timestamp dateUpdated) {
        this.dateUpdated = dateUpdated;
    }
    
    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (Objects.isNull(o) || getClass() != o.getClass()) {
            return false;
        }

        InstanceInfoVO that = (InstanceInfoVO) o;
        return Objects.equals(id, that.id)
                && Objects.equals(instanceIp, that.instanceIp)
                && Objects.equals(instanceType, that.instanceType)
                && Objects.equals(instanceInfo, that.instanceInfo)
                && Objects.equals(namespaceId, that.namespaceId)
                && Objects.equals(dateCreated, that.dateCreated)
                && Objects.equals(dateUpdated, that.dateUpdated);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, instanceIp, instanceType, instanceInfo, namespaceId, dateCreated, dateUpdated);
    }
}
