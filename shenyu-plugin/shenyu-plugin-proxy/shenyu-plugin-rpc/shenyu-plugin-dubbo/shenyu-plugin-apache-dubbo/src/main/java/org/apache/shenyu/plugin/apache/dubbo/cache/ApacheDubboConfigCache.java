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

package org.apache.shenyu.plugin.apache.dubbo.cache;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.cache.RemovalListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import jakarta.annotation.Nonnull;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.dubbo.common.constants.CommonConstants;
import org.apache.dubbo.config.ApplicationConfig;
import org.apache.dubbo.config.ConsumerConfig;
import org.apache.dubbo.config.MethodConfig;
import org.apache.dubbo.config.ReferenceConfig;
import org.apache.dubbo.config.RegistryConfig;
import org.apache.dubbo.rpc.service.GenericService;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.convert.plugin.DubboRegisterConfig;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.plugin.dubbo.common.cache.DubboConfigCache;
import org.apache.shenyu.plugin.dubbo.common.cache.DubboMethodParam;
import org.apache.shenyu.plugin.dubbo.common.cache.DubboParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The type Application config cache.
 */
public final class ApacheDubboConfigCache extends DubboConfigCache {

    private static final Logger LOG = LoggerFactory.getLogger(ApacheDubboConfigCache.class);

    private ApplicationConfig applicationConfig;

    private RegistryConfig registryConfig;

    private ConsumerConfig consumerConfig;

    private final LoadingCache<String, ReferenceConfig<GenericService>> cache = CacheBuilder.newBuilder()
            .maximumSize(Constants.CACHE_MAX_COUNT)
            .removalListener((RemovalListener<Object, ReferenceConfig<GenericService>>) notification -> {
                ReferenceConfig<GenericService> config = notification.getValue();
                if (Objects.nonNull(config)) {
                    // After the configuration change, Dubbo destroys the instance, but does not empty it. If it is not handled,
                    // it will get NULL when reinitializing and cause a NULL pointer problem.
                    config.destroy();
                }
            })
            .build(new CacheLoader<>() {
                @Override
                @Nonnull
                public ReferenceConfig<GenericService> load(@Nonnull final String key) {
                    return new ReferenceConfig<>();
                }
            });

    /**
     * Gets instance.
     *
     * @return the instance
     */
    public static ApacheDubboConfigCache getInstance() {
        return ApplicationConfigCacheInstance.INSTANCE;
    }

    /**
     * Init.
     *
     * @param dubboRegisterConfig the dubbo register config
     */
    public void init(final DubboRegisterConfig dubboRegisterConfig) {
        if (Objects.isNull(applicationConfig)) {
            applicationConfig = new ApplicationConfig("shenyu_proxy");
        }
        if (needUpdateRegistryConfig(dubboRegisterConfig)) {
            RegistryConfig registryConfigTemp = new RegistryConfig();
            registryConfigTemp.setProtocol(dubboRegisterConfig.getProtocol());
            registryConfigTemp.setId("shenyu_proxy");
            registryConfigTemp.setRegister(false);
            registryConfigTemp.setAddress(dubboRegisterConfig.getRegister());
            Optional.ofNullable(dubboRegisterConfig.getGroup()).ifPresent(registryConfigTemp::setGroup);
            registryConfig = registryConfigTemp;
        }
        if (Objects.isNull(consumerConfig)) {
            consumerConfig = new ConsumerConfig();
            consumerConfig.refresh();
            Optional.ofNullable(dubboRegisterConfig.getThreadpool()).ifPresent(consumerConfig::setThreadpool);
            Optional.ofNullable(dubboRegisterConfig.getCorethreads()).ifPresent(consumerConfig::setCorethreads);
            Optional.ofNullable(dubboRegisterConfig.getThreads()).ifPresent(consumerConfig::setThreads);
            Optional.ofNullable(dubboRegisterConfig.getQueues()).ifPresent(consumerConfig::setQueues);
        }
    }

    private boolean needUpdateRegistryConfig(final DubboRegisterConfig dubboRegisterConfig) {
        if (Objects.isNull(registryConfig)) {
            return true;
        }
        return !Objects.equals(dubboRegisterConfig.getProtocol(), registryConfig.getProtocol())
                || !Objects.equals(dubboRegisterConfig.getRegister(), registryConfig.getAddress());
    }

    /**
     * Init ref reference config.
     *
     * @param metaData the meta data
     * @return the reference config
     */
    public ReferenceConfig<GenericService> initRef(final MetaData metaData) {
        try {
            ReferenceConfig<GenericService> referenceConfig = cache.get(metaData.getPath());
            if (StringUtils.isNoneBlank(referenceConfig.getInterface())) {
                return referenceConfig;
            }
        } catch (ExecutionException e) {
            LOG.error("init dubbo ref exception", e);
        }
        return build(metaData, "");
    }

    /**
     * Init ref reference config.
     *
     * @param metaData  the meta data.
     * @param namespace namespace
     * @return the reference config
     */
    public ReferenceConfig<GenericService> initRefN(final MetaData metaData, final String namespace) {
        if (StringUtils.isBlank(namespace)) {
            return initRef(metaData);
        }
        try {
            ReferenceConfig<GenericService> referenceConfig = cache.get(namespace + ":" + metaData.getPath());
            if (StringUtils.isNoneBlank(referenceConfig.getInterface())) {
                return referenceConfig;
            }
        } catch (ExecutionException e) {
            LOG.error("initRefN dubbo ref exception", e);
        }
        return build(metaData, namespace);
    }

    /**
     * build with dynamic namespace.
     *
     * @param metaData  metaData
     * @param namespace namespace
     * @return the reference config
     */
    @SuppressWarnings("deprecation")
    public ReferenceConfig<GenericService> build(final MetaData metaData, final String namespace) {
        if (Objects.isNull(applicationConfig) || Objects.isNull(registryConfig)) {
            return new ReferenceConfig<>();
        }
        ReferenceConfig<GenericService> reference = buildReference(metaData, namespace);
        try {
            Object obj = reference.get();
            if (Objects.nonNull(obj)) {
                LOG.info("buildN init apache dubbo reference success there meteData is :{}", metaData);
                cache.put(StringUtils.isNotBlank(namespace) ? namespace + ":" + metaData.getPath() : metaData.getPath(), reference);
            }
        } catch (Exception e) {
            LOG.error("buildN init apache dubbo reference exception", e);
        }
        return reference;
    }

    /**
     * buildReference param.
     *
     * @param metaData metaData
     * @param namespace namespace
     * @return the reference config
     */
    private ReferenceConfig<GenericService> buildReference(final MetaData metaData, final String namespace) {
        ReferenceConfig<GenericService> reference = new ReferenceConfig<>();
        reference.setGeneric("true");
        reference.setAsync(true);

        reference.setApplication(applicationConfig);
        reference.setRegistry(registryConfig);
        reference.setConsumer(consumerConfig);
        reference.setInterface(metaData.getServiceName());
        
        // Fix dubbo application discover cannot get service provider information #5708
        try {
            ConfigManager configManager = reference.getApplicationModel().getApplicationConfigManager();
            if (CollectionUtils.isEmpty(configManager.getDefaultRegistries())){
                configManager.addRegistry(registryConfig);
            }
        }catch (Throwable e){
            //  no supported , do noting
            LOG.error("dubbo version no supported", e);
        }
        // default protocol is dubbo
        reference.setProtocol("dubbo");
        reference.setCheck(false);
        reference.setLoadbalance("gray");

        Map<String, String> parameters = new HashMap<>(2);
        parameters.put("dispatcher", "direct");
        reference.setParameters(parameters);

        String rpcExt = metaData.getRpcExt();
        DubboParam dubboParam = parserToDubboParam(rpcExt);
        if (Objects.nonNull(dubboParam)) {
            if (StringUtils.isNoneBlank(dubboParam.getVersion())) {
                reference.setVersion(dubboParam.getVersion());
            }
            if (StringUtils.isNoneBlank(dubboParam.getGroup())) {
                reference.setGroup(dubboParam.getGroup());
            }
            if (StringUtils.isNoneBlank(dubboParam.getUrl())) {
                reference.setUrl(dubboParam.getUrl());
            }
            if (StringUtils.isNoneBlank(dubboParam.getCluster())) {
                reference.setCluster(dubboParam.getCluster());
            }
            if (StringUtils.isNoneBlank(dubboParam.getLoadbalance())) {
                reference.getParameters().put(Constants.DUBBO_LOAD_BALANCE, dubboParam.getLoadbalance());
            }
            if ("protobuf".equals(dubboParam.getSerialization())) {
                reference.setGeneric(CommonConstants.GENERIC_SERIALIZATION_PROTOBUF);
            }
            // set dubbo sub protocol
            Optional.ofNullable(dubboParam.getProtocol()).ifPresent(reference::setProtocol);
            Optional.ofNullable(dubboParam.getTimeout()).ifPresent(reference::setTimeout);
            Optional.ofNullable(dubboParam.getRetries()).ifPresent(reference::setRetries);
            Optional.ofNullable(dubboParam.getSent()).ifPresent(reference::setSent);
            // methods
            if (CollectionUtils.isNotEmpty(dubboParam.getMethods())) {
                reference.setMethods(new ArrayList<>());
                for (DubboMethodParam dubboMethodParam : dubboParam.getMethods()) {
                    MethodConfig methodConfig = new MethodConfig();
                    methodConfig.setName(dubboMethodParam.getName());
                    methodConfig.setLoadbalance("gray");
                    methodConfig.setRetries(dubboMethodParam.getRetries());
                    methodConfig.setTimeout(dubboMethodParam.getTimeout());
                    methodConfig.setSent(dubboMethodParam.getSent());
                    Map<String, String> methodsParameters = new HashMap<>(1);
                    methodsParameters.put(Constants.DUBBO_LOAD_BALANCE, dubboMethodParam.getLoadbalance());
                    methodConfig.setParameters(methodsParameters);
                    reference.getMethods().add(methodConfig);
                }
            }
        }
        if (StringUtils.isNotBlank(namespace)) {
            RegistryConfig registryConfig = new RegistryConfig();
            registryConfig.setRegister(false);
            if (!this.registryConfig.getAddress().contains(Constants.NAMESPACE)) {
                registryConfig.setAddress(this.registryConfig.getAddress() + "?" + Constants.NAMESPACE + "=" + namespace);
                reference.setRegistry(registryConfig);
            } else {
                String newAddress = this.registryConfig.getAddress().substring(0, this.registryConfig.getAddress().indexOf(Constants.NAMESPACE) + 1) + Constants.NAMESPACE + "=" + namespace;
                registryConfig.setAddress(newAddress);
                reference.setRegistry(registryConfig);
            }
        } else {
            reference.setRegistry(registryConfig);
        }
        return reference;
    }

    /**
     * Get reference config.
     *
     * @param path the path
     * @return the reference config
     */
    public ReferenceConfig<GenericService> get(final String path) {
        try {
            return cache.get(path);
        } catch (ExecutionException e) {
            throw new ShenyuException(e.getCause());
        }
    }

    /**
     * Invalidate.
     *
     * @param path the path
     */
    public void invalidate(final String path) {
        cache.invalidate(path);
    }

    /**
     * Invalidate all.
     */
    public void invalidateAll() {
        cache.invalidateAll();
    }

    /**
     * The type Application config cache instance.
     */
    static final class ApplicationConfigCacheInstance {
        /**
         * The Instance.
         */
        static final ApacheDubboConfigCache INSTANCE = new ApacheDubboConfigCache();

        private ApplicationConfigCacheInstance() {

        }
    }
}
