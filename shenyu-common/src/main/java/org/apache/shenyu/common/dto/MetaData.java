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

package org.apache.shenyu.common.dto;

import org.apache.commons.lang3.StringUtils;

import java.util.Objects;

public class MetaData {

    private String id;

    private String appName;

    private String contextPath;

    private String path;

    private String rpcType;

    private String serviceName;

    private String methodName;

    private String parameterTypes;

    private String rpcExt;

    private Boolean enabled;

    private Boolean wrap;

    /**
     * no args constructor.
     */
    public MetaData() {
    }

    /**
     * all args constructor.
     *
     * @param id             id
     * @param appName        appName
     * @param contextPath    contextPath
     * @param path           path
     * @param rpcType        rpcType
     * @param serviceName    serviceName
     * @param methodName     methodName
     * @param parameterTypes parameterTypes
     * @param rpcExt         rpcExt
     * @param enabled        enabled
     */
    public MetaData(final String id, final String appName, final String contextPath, final String path, final String rpcType, final String serviceName,
                    final String methodName, final String parameterTypes, final String rpcExt, final Boolean enabled, final Boolean wrap) {
        this.id = id;
        this.appName = appName;
        this.contextPath = contextPath;
        this.path = path;
        this.rpcType = rpcType;
        this.serviceName = serviceName;
        this.methodName = methodName;
        this.parameterTypes = parameterTypes;
        this.rpcExt = rpcExt;
        this.enabled = enabled;
        this.wrap = wrap;
    }

    /**
     * builder constructor.
     *
     * @param builder builder
     */
    private MetaData(final Builder builder) {
        this.id = builder.id;
        this.appName = builder.appName;
        this.contextPath = builder.contextPath;
        this.path = builder.path;
        this.rpcType = builder.rpcType;
        this.serviceName = builder.serviceName;
        this.methodName = builder.methodName;
        this.parameterTypes = builder.parameterTypes;
        this.rpcExt = builder.rpcExt;
        this.enabled = builder.enabled;
        this.wrap = builder.wrap;
    }

    /**
     * class builder.
     *
     * @return Builder
     */
    public static Builder builder() {
        return new Builder();
    }

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
     * get appName.
     *
     * @return appName
     */
    public String getAppName() {
        return appName;
    }

    /**
     * set appName.
     *
     * @param appName appName
     */
    public void setAppName(final String appName) {
        this.appName = appName;
    }

    /**
     * get contextPath.
     *
     * @return contextPath
     */
    public String getContextPath() {
        return contextPath;
    }

    /**
     * set contextPath.
     *
     * @param contextPath contextPath
     */
    public void setContextPath(final String contextPath) {
        this.contextPath = contextPath;
    }

    /**
     * get path.
     *
     * @return path
     */
    public String getPath() {
        return path;
    }

    /**
     * set path.
     *
     * @param path path
     */
    public void setPath(final String path) {
        this.path = path;
    }

    /**
     * get rpcType.
     *
     * @return rpcType
     */
    public String getRpcType() {
        return rpcType;
    }

    /**
     * set rpcType.
     *
     * @param rpcType rpcType
     */
    public void setRpcType(final String rpcType) {
        this.rpcType = rpcType;
    }

    /**
     * get serviceName.
     *
     * @return serviceName
     */
    public String getServiceName() {
        return serviceName;
    }

    /**
     * set serviceName.
     *
     * @param serviceName serviceName
     */
    public void setServiceName(final String serviceName) {
        this.serviceName = serviceName;
    }

    /**
     * get methodName.
     *
     * @return methodName
     */
    public String getMethodName() {
        return methodName;
    }

    /**
     * set methodName.
     *
     * @param methodName methodName
     */
    public void setMethodName(final String methodName) {
        this.methodName = methodName;
    }

    /**
     * get parameterTypes.
     *
     * @return parameterTypes
     */
    public String getParameterTypes() {
        return parameterTypes;
    }

    /**
     * set parameterTypes.
     *
     * @param parameterTypes parameterTypes
     */
    public void setParameterTypes(final String parameterTypes) {
        this.parameterTypes = parameterTypes;
    }

    /**
     * get rpcExt.
     *
     * @return rpcExt
     */
    public String getRpcExt() {
        return rpcExt;
    }

    /**
     * set rpcExt.
     *
     * @param rpcExt rpcExt
     */
    public void setRpcExt(final String rpcExt) {
        this.rpcExt = rpcExt;
    }

    /**
     * get enabled.
     *
     * @return enabled
     */
    public Boolean getEnabled() {
        return enabled;
    }

    /**
     * set enabled.
     *
     * @param enabled enabled
     */
    public void setEnabled(final Boolean enabled) {
        this.enabled = enabled;
    }

    /**
     * get wrap.
     *
     * @return wrap
     */
    public Boolean getWrap() {
        return wrap;
    }

    /**
     * set wrap.
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
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        MetaData metaData = (MetaData) o;
        return Objects.equals(id, metaData.id) && Objects.equals(appName, metaData.appName) && Objects.equals(contextPath, metaData.contextPath)
                && Objects.equals(path, metaData.path) && Objects.equals(rpcType, metaData.rpcType) && Objects.equals(serviceName, metaData.serviceName)
                && Objects.equals(methodName, metaData.methodName) && Objects.equals(parameterTypes, metaData.parameterTypes)
                && Objects.equals(rpcExt, metaData.rpcExt) && Objects.equals(enabled, metaData.enabled) && Objects.equals(wrap, metaData.wrap);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, appName, contextPath, path, rpcType, serviceName, methodName, parameterTypes, rpcExt, enabled, wrap);
    }

    @Override
    public String toString() {
        return "MetaData{"
                + "id='"
                + id
                + '\''
                + ", appName='"
                + appName
                + '\''
                + ", contextPath='"
                + contextPath
                + '\''
                + ", path='"
                + path
                + '\''
                + ", rpcType='"
                + rpcType
                + '\''
                + ", serviceName='"
                + serviceName
                + '\''
                + ", methodName='"
                + methodName
                + '\''
                + ", parameterTypes='"
                + parameterTypes
                + '\''
                + ", rpcExt='"
                + rpcExt
                + '\''
                + ", enabled="
                + enabled
                + ", wrap="
                + wrap
                + '}';
    }

    /**
     * update ContextPath.
     */
    public void updateContextPath() {
        if (StringUtils.isNoneBlank(this.path)) {
            this.contextPath = StringUtils.indexOf(path, "/", 1) > -1
                    ? this.path.substring(0, StringUtils.indexOf(path, "/", 1)) : path;
        }
    }

    /**
     * class builder.
     */
    public static final class Builder {

        /**
         * id.
         */
        private String id;

        /**
         * appName.
         */
        private String appName;

        /**
         * contextPath.
         */
        private String contextPath;

        /**
         * path.
         */
        private String path;

        /**
         * rpcType.
         */
        private String rpcType;

        /**
         * serviceName.
         */
        private String serviceName;

        /**
         * methodName.
         */
        private String methodName;

        /**
         * parameterTypes.
         */
        private String parameterTypes;

        /**
         * rpcExt.
         */
        private String rpcExt;

        /**
         * enabled.
         */
        private Boolean enabled;

        /**
         * wrap.
         */
        private Boolean wrap;

        /**
         * no args constructor.
         */
        private Builder() {
        }

        /**
         * build new Object.
         *
         * @return MetaData
         */
        public MetaData build() {
            return new MetaData(this);
        }

        /**
         * build id.
         *
         * @param id id
         * @return this
         */
        public Builder id(final String id) {
            this.id = id;
            return this;
        }

        /**
         * build appName.
         *
         * @param appName appName
         * @return this
         */
        public Builder appName(final String appName) {
            this.appName = appName;
            return this;
        }

        /**
         * build contextPath.
         *
         * @param contextPath contextPath
         * @return this
         */
        public Builder contextPath(final String contextPath) {
            this.contextPath = contextPath;
            return this;
        }

        /**
         * build path.
         *
         * @param path path
         * @return this
         */
        public Builder path(final String path) {
            this.path = path;
            return this;
        }

        /**
         * build rpcType.
         *
         * @param rpcType rpcType
         * @return this
         */
        public Builder rpcType(final String rpcType) {
            this.rpcType = rpcType;
            return this;
        }

        /**
         * build serviceName.
         *
         * @param serviceName serviceName
         * @return this
         */
        public Builder serviceName(final String serviceName) {
            this.serviceName = serviceName;
            return this;
        }

        /**
         * build methodName.
         *
         * @param methodName methodName
         * @return this
         */
        public Builder methodName(final String methodName) {
            this.methodName = methodName;
            return this;
        }

        /**
         * build parameterTypes.
         *
         * @param parameterTypes parameterTypes
         * @return this
         */
        public Builder parameterTypes(final String parameterTypes) {
            this.parameterTypes = parameterTypes;
            return this;
        }

        /**
         * build rpcExt.
         *
         * @param rpcExt rpcExt
         * @return this
         */
        public Builder rpcExt(final String rpcExt) {
            this.rpcExt = rpcExt;
            return this;
        }

        /**
         * build enabled.
         *
         * @param enabled enabled
         * @return this
         */
        public Builder enabled(final Boolean enabled) {
            this.enabled = enabled;
            return this;
        }

        /**
         * build wrap.
         *
         * @param wrap wrap
         * @return this
         */
        public Builder wrap(final Boolean wrap) {
            this.wrap = wrap;
            return this;
        }
    }
}
