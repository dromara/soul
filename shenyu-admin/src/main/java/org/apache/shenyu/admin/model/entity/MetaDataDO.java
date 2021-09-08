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

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Objects;

/**
 * The type Meta data do.
 */
public final class MetaDataDO extends BaseDO implements Serializable {

    private static final long serialVersionUID = 3566656950011853160L;

    private String appName;

    private String path;

    private String pathDesc;

    private String rpcType;

    private String serviceName;

    private String methodName;

    private String parameterTypes;

    private String rpcExt;

    /**
     * whether enabled.
     */
    private Boolean enabled;

    /**
     * whether wrap.
     */
    private Boolean wrap;

    public MetaDataDO() {
    }

    public MetaDataDO(final String appName,
                      final String path,
                      final String pathDesc,
                      final String rpcType,
                      final String serviceName,
                      final String methodName,
                      final String parameterTypes,
                      final String rpcExt,
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

    /**
     * builder method.
     *
     * @return builder object.
     */
    public static MetaDataDO.MetaDataDOBuilder builder() {
        return new MetaDataDO.MetaDataDOBuilder();
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof MetaDataDO)) {
            return false;
        }
        if (!super.equals(o)) {
            return false;
        }
        MetaDataDO that = (MetaDataDO) o;
        return Objects.equals(appName, that.appName)
                && Objects.equals(path, that.path)
                && Objects.equals(pathDesc, that.pathDesc)
                && Objects.equals(rpcType, that.rpcType)
                && Objects.equals(serviceName, that.serviceName)
                && Objects.equals(methodName, that.methodName)
                && Objects.equals(parameterTypes, that.parameterTypes)
                && Objects.equals(rpcExt, that.rpcExt)
                && Objects.equals(enabled, that.enabled)
                && Objects.equals(wrap, that.wrap);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), appName, path, pathDesc, rpcType, serviceName, methodName, parameterTypes, rpcExt, enabled, wrap);
    }

    public static final class MetaDataDOBuilder {

        private String id;

        private Timestamp dateCreated;

        private Timestamp dateUpdated;

        private String appName;

        private String path;

        private String pathDesc;

        private String rpcType;

        private String serviceName;

        private String methodName;

        private String parameterTypes;

        private String rpcExt;

        private Boolean enabled;

        private Boolean wrap;

        private MetaDataDOBuilder() {
        }

        /**
         * id.
         *
         * @param id the id.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder id(final String id) {
            this.id = id;
            return this;
        }

        /**
         * dateCreated.
         *
         * @param dateCreated the dateCreated.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder dateCreated(final Timestamp dateCreated) {
            this.dateCreated = dateCreated;
            return this;
        }

        /**
         * dateUpdated.
         *
         * @param dateUpdated the dateUpdated.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder dateUpdated(final Timestamp dateUpdated) {
            this.dateUpdated = dateUpdated;
            return this;
        }

        /**
         * appName.
         *
         * @param appName the appName.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder appName(final String appName) {
            this.appName = appName;
            return this;
        }

        /**
         * path.
         *
         * @param path the path.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder path(final String path) {
            this.path = path;
            return this;
        }

        /**
         * pathDesc.
         *
         * @param pathDesc the pathDesc.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder pathDesc(final String pathDesc) {
            this.pathDesc = pathDesc;
            return this;
        }

        /**
         * rpcType.
         *
         * @param rpcType the rpcType.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder rpcType(final String rpcType) {
            this.rpcType = rpcType;
            return this;
        }

        /**
         * serviceName.
         *
         * @param serviceName the serviceName.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder serviceName(final String serviceName) {
            this.serviceName = serviceName;
            return this;
        }

        /**
         * methodName.
         *
         * @param methodName the methodName.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder methodName(final String methodName) {
            this.methodName = methodName;
            return this;
        }

        /**
         * parameterTypes.
         *
         * @param parameterTypes the parameterTypes.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder parameterTypes(final String parameterTypes) {
            this.parameterTypes = parameterTypes;
            return this;
        }

        /**
         * rpcExt.
         *
         * @param rpcExt the rpcExt.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder rpcExt(final String rpcExt) {
            this.rpcExt = rpcExt;
            return this;
        }

        /**
         * enabled.
         *
         * @param enabled the enabled.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder enabled(final Boolean enabled) {
            this.enabled = enabled;
            return this;
        }

        /**
         * wrap.
         *
         * @param wrap the wrap.
         * @return MetaDataDOBuilder.
         */
        public MetaDataDOBuilder wrap(final Boolean wrap) {
            this.wrap = wrap;
            return this;
        }

        /**
         * build method.
         *
         * @return build object.
         */
        public MetaDataDO build() {
            MetaDataDO metaDataDO = new MetaDataDO();
            metaDataDO.setId(id);
            metaDataDO.setDateCreated(dateCreated);
            metaDataDO.setDateUpdated(dateUpdated);
            metaDataDO.setAppName(appName);
            metaDataDO.setPath(path);
            metaDataDO.setPathDesc(pathDesc);
            metaDataDO.setRpcType(rpcType);
            metaDataDO.setServiceName(serviceName);
            metaDataDO.setMethodName(methodName);
            metaDataDO.setParameterTypes(parameterTypes);
            metaDataDO.setRpcExt(rpcExt);
            metaDataDO.setEnabled(enabled);
            metaDataDO.setWrap(wrap);
            return metaDataDO;
        }
    }
}
