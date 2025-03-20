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

package org.apache.shenyu.admin.model.query;

import org.apache.shenyu.admin.model.page.PageParameter;

import java.io.Serializable;
import java.util.Objects;

/**
 * this is instance query.
 */
public class InstanceQuery implements Serializable {

    private static final long serialVersionUID = 6666008171280192709L;

    /**
     * namespace id.
     */
    private String namespaceId;
    
    /**
     * instance type.
     */
    private String instanceType;
    
    
    /**
     * instance ip.
     */
    private String instanceIp;
    
    /**
     * page parameter.
     */
    private PageParameter pageParameter;
    

    public InstanceQuery() {
    }

    public InstanceQuery(final PageParameter pageParameter, final String instanceType, final String instanceIp, final String namespaceId) {
        this.instanceIp = instanceIp;
        this.namespaceId = namespaceId;
        this.instanceType = instanceType;
        this.pageParameter = pageParameter;
    }
    
    /**
     * Gets the value of instanceType.
     *
     * @return the value of instanceType
     */
    public String getInstanceType() {
        return instanceType;
    }
    
    /**
     * Sets the instanceType.
     *
     * @param instanceType instanceType
     */
    public void setInstanceType(final String instanceType) {
        this.instanceType = instanceType;
    }
    
    /**
     * Gets the value of instanceIp.
     *
     * @return the value of instanceIp
     */
    public String getInstanceIp() {
        return instanceIp;
    }
    
    /**
     * Sets the instanceIp.
     *
     * @param instanceIp instanceIp
     */
    public void setInstanceIp(final String instanceIp) {
        this.instanceIp = instanceIp;
    }
    
    /**
     * Gets the value of name.
     *
     * @return the value of name
     */
    public String getNamespaceId() {
        return namespaceId;
    }

    /**
     * Sets the namespaceId.
     *
     * @param namespaceId namespaceId
     */
    public void setNamespaceId(final String namespaceId) {
        this.namespaceId = namespaceId;
    }
    
    /**
     * Gets the value of pageParameter.
     *
     * @return the value of pageParameter
     */
    public PageParameter getPageParameter() {
        return pageParameter;
    }
    
    /**
     * Sets the pageParameter.
     *
     * @param pageParameter pageParameter
     */
    public void setPageParameter(final PageParameter pageParameter) {
        this.pageParameter = pageParameter;
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
        InstanceQuery that = (InstanceQuery) o;
        return Objects.equals(namespaceId, that.namespaceId)
                && Objects.equals(pageParameter, that.pageParameter);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), namespaceId, pageParameter);
    }
}
