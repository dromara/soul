/*
 *   Licensed to the Apache Software Foundation (ASF) under one or more
 *   contributor license agreements.  See the NOTICE file distributed with
 *   this work for additional information regarding copyright ownership.
 *   The ASF licenses this file to You under the Apache License, Version 2.0
 *   (the "License"); you may not use this file except in compliance with
 *   the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 */

package org.apache.shenyu.register.common.dto;

import org.apache.shenyu.register.common.type.DataType;
import org.apache.shenyu.register.common.type.DataTypeParent;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;

/**
 * The type Meta data dto.
 */
public class MetaDataRegisterDTO implements DataTypeParent, Serializable {

    private static final long serialVersionUID = -9179185443399391316L;

    private String appName;

    private String contextPath;

    private String path;

    private String pathDesc;

    private String rpcType;

    private String serviceName;

    private String methodName;

    private String ruleName;

    private String parameterTypes;

    private String rpcExt;

    private boolean enabled;

    private boolean wrap;

    private String host;

    private Integer port;

    private List<String> pluginNames;

    private boolean registerMetaData;

    public MetaDataRegisterDTO(final String appName, final String contextPath,
                               final String path, final String pathDesc,
                               final String rpcType, final String serviceName,
                               final String methodName, final String ruleName,
                               final String parameterTypes, final String rpcExt,
                               final boolean enabled, final boolean wrap,
                               final String host, final Integer port,
                               final List<String> pluginNames,
                               final boolean registerMetaData) {
        this.appName = appName;
        this.contextPath = contextPath;
        this.path = path;
        this.pathDesc = pathDesc;
        this.rpcType = rpcType;
        this.serviceName = serviceName;
        this.methodName = methodName;
        this.ruleName = ruleName;
        this.parameterTypes = parameterTypes;
        this.rpcExt = rpcExt;
        this.enabled = enabled;
        this.wrap = wrap;
        this.host = host;
        this.port = port;
        this.pluginNames = pluginNames;
        this.registerMetaData = registerMetaData;
    }

    public MetaDataRegisterDTO() {
    }

    private MetaDataRegisterDTO(final Builder builder) {
        appName = builder.appName;
        contextPath = builder.contextPath;
        path = builder.path;
        pathDesc = builder.pathDesc;
        rpcType = builder.rpcType;
        serviceName = builder.serviceName;
        methodName = builder.methodName;
        ruleName = builder.ruleName;
        parameterTypes = builder.parameterTypes;
        rpcExt = builder.rpcExt;
        enabled = builder.enabled;
        wrap = builder.wrap;
        host = builder.host;
        port = builder.port;
        pluginNames = builder.pluginNames;
        registerMetaData = builder.registerMetaData;
    }

    /**
     * builder.
     *
     * @return Builder
     */
    public static Builder builder() {
        return new Builder();
    }

    @Override
    public DataType getType() {
        return DataType.META_DATA;
    }

    /**
     * getAppName.
     *
     * @return String of appName
     */
    public String getAppName() {
        return appName;
    }

    /**
     * setAppName.
     *
     * @param appName appName
     */
    public void setAppName(final String appName) {
        this.appName = appName;
    }

    /**
     * getContextPath.
     *
     * @return String of contextPath
     */
    public String getContextPath() {
        return contextPath;
    }

    /**
     * setContextPath.
     *
     * @param contextPath contextPath
     */
    public void setContextPath(final String contextPath) {
        this.contextPath = contextPath;
    }

    /**
     * getPath.
     *
     * @return String of path
     */
    public String getPath() {
        return path;
    }

    /**
     * setPath.
     *
     * @param path path
     */
    public void setPath(final String path) {
        this.path = path;
    }

    /**
     * getPathDesc.
     *
     * @return String of pathDesc
     */
    public String getPathDesc() {
        return pathDesc;
    }

    /**
     * setPath.
     *
     * @param pathDesc pathDesc
     */
    public void setPathDesc(final String pathDesc) {
        this.pathDesc = pathDesc;
    }

    /**
     * getRpcType.
     *
     * @return String of rpcType
     */
    public String getRpcType() {
        return rpcType;
    }

    /**
     * setPath.
     *
     * @param rpcType rpcType
     */
    public void setRpcType(final String rpcType) {
        this.rpcType = rpcType;
    }

    /**
     * getServiceName.
     *
     * @return String of serviceName
     */
    public String getServiceName() {
        return serviceName;
    }

    /**
     * setPath.
     *
     * @param serviceName serviceName
     */
    public void setServiceName(final String serviceName) {
        this.serviceName = serviceName;
    }

    /**
     * getMethodName.
     *
     * @return String of methodName
     */
    public String getMethodName() {
        return methodName;
    }

    /**
     * setPath.
     *
     * @param methodName methodName
     */
    public void setMethodName(final String methodName) {
        this.methodName = methodName;
    }

    /**
     * getRuleName.
     *
     * @return String of ruleName
     */
    public String getRuleName() {
        return ruleName;
    }

    /**
     * setPath.
     *
     * @param ruleName ruleName
     */
    public void setRuleName(final String ruleName) {
        this.ruleName = ruleName;
    }

    /**
     * getParameterTypes.
     *
     * @return String of parameterTypes
     */
    public String getParameterTypes() {
        return parameterTypes;
    }

    /**
     * setPath.
     *
     * @param parameterTypes parameterTypes
     */
    public void setParameterTypes(final String parameterTypes) {
        this.parameterTypes = parameterTypes;
    }

    /**
     * getRpcExt.
     *
     * @return String of rpcExt
     */
    public String getRpcExt() {
        return rpcExt;
    }

    /**
     * setPath.
     *
     * @param rpcExt rpcExt
     */
    public void setRpcExt(final String rpcExt) {
        this.rpcExt = rpcExt;
    }

    /**
     * isEnabled.
     *
     * @return boolean
     */
    public boolean isEnabled() {
        return enabled;
    }

    /**
     * isWrap.
     *
     * @return boolean
     */
    public boolean isWrap() {
        return wrap;
    }

    /**
     * setEnabled.
     *
     * @param enabled enabled
     */
    public void setEnabled(final boolean enabled) {
        this.enabled = enabled;
    }

    /**
     * setWrap.
     *
     * @param wrap wrap
     */
    public void setWrap(final boolean wrap) {
        this.wrap = wrap;
    }

    /**
     * getHost.
     *
     * @return String
     */
    public String getHost() {
        return host;
    }

    /**
     * setPath.
     *
     * @param host host
     */
    public void setHost(final String host) {
        this.host = host;
    }

    /**
     * getPort.
     *
     * @return Integer
     */
    public Integer getPort() {
        return port;
    }

    /**
     * setPort.
     *
     * @param port port
     */
    public void setPort(final Integer port) {
        this.port = port;
    }

    /**
     * getPluginNames.
     *
     * @return List
     */
    public List<String> getPluginNames() {
        return pluginNames;
    }

    /**
     * setPluginNames.
     *
     * @param pluginNames pluginNames
     */
    public void setPluginNames(final List<String> pluginNames) {
        this.pluginNames = pluginNames;
    }

    /**
     * isRegisterMetaData.
     *
     * @return boolean
     */
    public boolean isRegisterMetaData() {
        return registerMetaData;
    }

    /**
     * setRegisterMetaData.
     *
     * @param registerMetaData registerMetaData
     */
    public void setRegisterMetaData(final boolean registerMetaData) {
        this.registerMetaData = registerMetaData;
    }

    public static final class Builder {

        private String appName;

        private String contextPath;

        private String path;

        private String pathDesc;

        private String rpcType;

        private String serviceName;

        private String methodName;

        private String ruleName;

        private String parameterTypes;

        private String rpcExt;

        private boolean enabled;

        private boolean wrap;

        private String host;

        private Integer port;

        private List<String> pluginNames = Collections.emptyList();

        private boolean registerMetaData;

        private Builder() {
        }

        /**
         * appName.
         *
         * @param appName appName
         *
         * @return Builder
         */
        public Builder appName(final String appName) {
            this.appName = appName;
            return this;
        }

        /**
         * contextPath.
         *
         * @param contextPath contextPath
         *
         * @return Builder
         */
        public Builder contextPath(final String contextPath) {
            this.contextPath = contextPath;
            return this;
        }

        /**
         * path.
         *
         * @param path path
         *
         * @return Builder
         */
        public Builder path(final String path) {
            this.path = path;
            return this;
        }

        /**
         * pathDesc.
         *
         * @param pathDesc pathDesc
         *
         * @return Builder
         */
        public Builder pathDesc(final String pathDesc) {
            this.pathDesc = pathDesc;
            return this;
        }

        /**
         * rpcType.
         *
         * @param rpcType rpcType
         *
         * @return Builder
         */
        public Builder rpcType(final String rpcType) {
            this.rpcType = rpcType;
            return this;
        }

        /**
         * serviceName.
         *
         * @param serviceName serviceName
         *
         * @return Builder
         */
        public Builder serviceName(final String serviceName) {
            this.serviceName = serviceName;
            return this;
        }

        /**
         * methodName.
         *
         * @param methodName methodName
         *
         * @return Builder
         */
        public Builder methodName(final String methodName) {
            this.methodName = methodName;
            return this;
        }

        /**
         * ruleName.
         *
         * @param ruleName ruleName
         *
         * @return Builder
         */
        public Builder ruleName(final String ruleName) {
            this.ruleName = ruleName;
            return this;
        }

        /**
         * parameterTypes.
         *
         * @param parameterTypes parameterTypes
         *
         * @return Builder
         */
        public Builder parameterTypes(final String parameterTypes) {
            this.parameterTypes = parameterTypes;
            return this;
        }

        /**
         * rpcExt.
         *
         * @param rpcExt rpcExt
         *
         * @return Builder
         */
        public Builder rpcExt(final String rpcExt) {
            this.rpcExt = rpcExt;
            return this;
        }

        /**
         * enabled.
         *
         * @param enabled enabled
         *
         * @return Builder
         */
        public Builder enabled(final boolean enabled) {
            this.enabled = enabled;
            return this;
        }

        /**
         * wrap the rpc response.
         *
         * @param wrap wrap
         *
         * @return Builder
         */
        public Builder wrap(final boolean wrap) {
            this.wrap = wrap;
            return this;
        }

        /**
         * appName.
         *
         * @param host host
         *
         * @return Builder
         */
        public Builder host(final String host) {
            this.host = host;
            return this;
        }

        /**
         * port.
         *
         * @param port port
         *
         * @return Builder
         */
        public Builder port(final Integer port) {
            this.port = port;
            return this;
        }

        /**
         * pluginNames.
         *
         * @param pluginNames pluginNames
         *
         * @return Builder
         */
        public Builder pluginNames(final List<String> pluginNames) {
            this.pluginNames = pluginNames;
            return this;
        }

        /**
         * registerMetaData.
         *
         * @param registerMetaData registerMetaData
         *
         * @return Builder
         */
        public Builder registerMetaData(final boolean registerMetaData) {
            this.registerMetaData = registerMetaData;
            return this;
        }

        /**
         * build.
         *
         * @return MetaDataRegisterDTO
         */
        public MetaDataRegisterDTO build() {
            return new MetaDataRegisterDTO(this);
        }
    }
}
