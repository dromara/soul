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
import java.util.Objects;

public class MetaDataVO implements Serializable {

    private static final long serialVersionUID = -2658925954317878033L;

    private String appName;

    private String path;

    private String pathDesc;

    private String rpcType;

    private String serviceName;

    private String methodName;

    private String parameterTypes;

    private String rpcExt;

    /**
     * primary key.
     */
    private String id;

    /**
     * created time.
     */
    private String dateCreated;

    /**
     * updated time.
     */
    private String dateUpdated;

    private Boolean enabled;

    private Boolean wrap;

    public MetaDataVO() {
    }

    public MetaDataVO(final String appName,
                      final String path,
                      final String pathDesc,
                      final String rpcType,
                      final String serviceName,
                      final String methodName,
                      final String parameterTypes,
                      final String rpcExt,
                      final String id,
                      final String dateCreated,
                      final String dateUpdated,
                      final Boolean enabled,
                      final Boolean wrap) {
        this.appName = appName;
        this.path = path;
        this.pathDesc = pathDesc;
        this.rpcType = rpcType;
        this.serviceName = serviceName;
        this.methodName = methodName;
        this.parameterTypes = parameterTypes;
        this.rpcExt = rpcExt;
        this.id = id;
        this.dateCreated = dateCreated;
        this.dateUpdated = dateUpdated;
        this.enabled = enabled;
        this.wrap = wrap;
    }

    /**
     * Gets the value of appName.
     *
     * @return the value of appName
     */
    public String getAppName() {
        return appName;
    }

    /**
     * Sets the appName.
     *
     * @param appName appName
     */
    public void setAppName(final String appName) {
        this.appName = appName;
    }

    /**
     * Gets the value of path.
     *
     * @return the value of path
     */
    public String getPath() {
        return path;
    }

    /**
     * Sets the path.
     *
     * @param path path
     */
    public void setPath(final String path) {
        this.path = path;
    }

    /**
     * Gets the value of pathDesc.
     *
     * @return the value of pathDesc
     */
    public String getPathDesc() {
        return pathDesc;
    }

    /**
     * Sets the pathDesc.
     *
     * @param pathDesc pathDesc
     */
    public void setPathDesc(final String pathDesc) {
        this.pathDesc = pathDesc;
    }

    /**
     * Gets the value of rpcType.
     *
     * @return the value of rpcType
     */
    public String getRpcType() {
        return rpcType;
    }

    /**
     * Sets the rpcType.
     *
     * @param rpcType rpcType
     */
    public void setRpcType(final String rpcType) {
        this.rpcType = rpcType;
    }

    /**
     * Gets the value of serviceName.
     *
     * @return the value of serviceName
     */
    public String getServiceName() {
        return serviceName;
    }

    /**
     * Sets the serviceName.
     *
     * @param serviceName serviceName
     */
    public void setServiceName(final String serviceName) {
        this.serviceName = serviceName;
    }

    /**
     * Gets the value of methodName.
     *
     * @return the value of methodName
     */
    public String getMethodName() {
        return methodName;
    }

    /**
     * Sets the methodName.
     *
     * @param methodName methodName
     */
    public void setMethodName(final String methodName) {
        this.methodName = methodName;
    }

    /**
     * Gets the value of parameterTypes.
     *
     * @return the value of parameterTypes
     */
    public String getParameterTypes() {
        return parameterTypes;
    }

    /**
     * Sets the parameterTypes.
     *
     * @param parameterTypes parameterTypes
     */
    public void setParameterTypes(final String parameterTypes) {
        this.parameterTypes = parameterTypes;
    }

    /**
     * Gets the value of rpcExt.
     *
     * @return the value of rpcExt
     */
    public String getRpcExt() {
        return rpcExt;
    }

    /**
     * Sets the rpcExt.
     *
     * @param rpcExt rpcExt
     */
    public void setRpcExt(final String rpcExt) {
        this.rpcExt = rpcExt;
    }

    /**
     * Gets the value of id.
     *
     * @return the value of id
     */
    public String getId() {
        return id;
    }

    /**
     * Sets the id.
     *
     * @param id id
     */
    public void setId(final String id) {
        this.id = id;
    }

    /**
     * Gets the value of dateCreated.
     *
     * @return the value of dateCreated
     */
    public String getDateCreated() {
        return dateCreated;
    }

    /**
     * Sets the dateCreated.
     *
     * @param dateCreated dateCreated
     */
    public void setDateCreated(final String dateCreated) {
        this.dateCreated = dateCreated;
    }

    /**
     * Gets the value of dateUpdated.
     *
     * @return the value of dateUpdated
     */
    public String getDateUpdated() {
        return dateUpdated;
    }

    /**
     * Sets the dateUpdated.
     *
     * @param dateUpdated dateUpdated
     */
    public void setDateUpdated(final String dateUpdated) {
        this.dateUpdated = dateUpdated;
    }

    /**
     * Gets the value of enabled.
     *
     * @return the value of enabled
     */
    public Boolean getEnabled() {
        return enabled;
    }

    /**
     * Sets the enabled.
     *
     * @param enabled enabled
     */
    public void setEnabled(final Boolean enabled) {
        this.enabled = enabled;
    }

    /**
     * Gets the value of wrap.
     *
     * @return the value of wrap
     */
    public Boolean getWrap() {
        return wrap;
    }

    /**
     * Sets the wrap.
     *
     * @param wrap wrap
     */
    public void setWrap(final Boolean wrap) {
        this.wrap = wrap;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof MetaDataVO)) {
            return false;
        }
        MetaDataVO that = (MetaDataVO) o;
        return Objects.equals(appName, that.appName)
                && Objects.equals(path, that.path)
                && Objects.equals(pathDesc, that.pathDesc)
                && Objects.equals(rpcType, that.rpcType)
                && Objects.equals(serviceName, that.serviceName)
                && Objects.equals(methodName, that.methodName)
                && Objects.equals(parameterTypes, that.parameterTypes)
                && Objects.equals(rpcExt, that.rpcExt)
                && Objects.equals(id, that.id)
                && Objects.equals(dateCreated, that.dateCreated)
                && Objects.equals(dateUpdated, that.dateUpdated)
                && Objects.equals(enabled, that.enabled)
                && Objects.equals(wrap, that.wrap);
    }

    @Override
    public int hashCode() {
        return Objects.hash(appName, path, pathDesc, rpcType, serviceName, methodName, parameterTypes, rpcExt, id, dateCreated, dateUpdated, enabled, wrap);
    }

    @Override
    public String toString() {
        return "MetaDataVO{"
                + "appName='" + appName + '\''
                + ", path='" + path + '\''
                + ", pathDesc='" + pathDesc + '\''
                + ", rpcType='" + rpcType + '\''
                + ", serviceName='" + serviceName + '\''
                + ", methodName='" + methodName + '\''
                + ", parameterTypes='" + parameterTypes + '\''
                + ", rpcExt='" + rpcExt + '\''
                + ", id='" + id + '\''
                + ", dateCreated='" + dateCreated + '\''
                + ", dateUpdated='" + dateUpdated + '\''
                + ", enabled=" + enabled
                + ", wrap=" + wrap
                + '}';
    }
}
