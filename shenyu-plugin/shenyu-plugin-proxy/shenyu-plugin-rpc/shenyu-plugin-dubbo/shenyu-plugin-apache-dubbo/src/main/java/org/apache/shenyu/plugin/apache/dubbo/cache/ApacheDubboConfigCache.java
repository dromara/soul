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
import java.util.Set;
import java.util.StringJoiner;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import jakarta.annotation.Nonnull;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.ObjectUtils;
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
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.convert.plugin.DubboRegisterConfig;
import org.apache.shenyu.common.dto.convert.rule.impl.DubboRuleHandle;
import org.apache.shenyu.common.dto.convert.selector.DubboUpstream;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.common.utils.DigestUtils;
import org.apache.shenyu.plugin.dubbo.common.cache.DubboConfigCache;
import org.apache.shenyu.plugin.dubbo.common.cache.DubboMethodParam;
import org.apache.shenyu.plugin.dubbo.common.cache.DubboParam;
import org.apache.shenyu.plugin.dubbo.common.handler.AbstractDubboPluginDataHandler;
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
            applicationConfig = new ApplicationConfig(Constants.DUBBO_DEFAULT_APPLICATION_NAME);
            applicationConfig.setQosEnable(false);
            applicationConfig.setRegisterConsumer(true);
        }
        if (needUpdateRegistryConfig(dubboRegisterConfig)) {
            RegistryConfig registryConfigTemp = new RegistryConfig();
            registryConfigTemp.setProtocol(dubboRegisterConfig.getProtocol());
            registryConfigTemp.setId(Constants.DUBBO_DEFAULT_APPLICATION_NAME);
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
     * Init ref reference config use dubboUpstream.
     *
     * @param selectorId    the selectorId
     * @param ruleData      the rule data
     * @param metaData      the meta data
     * @param namespace     namespace
     * @param dubboUpstream dubboUpstream
     * @return the reference config
     */
    public ReferenceConfig<GenericService> initRefN(final String selectorId, final RuleData ruleData, final MetaData metaData, final String namespace, final DubboUpstream dubboUpstream) {
        try {
            String cacheKey = generateUpstreamCacheKey(selectorId, ruleData.getId(), metaData.getId(), namespace, dubboUpstream);
            ReferenceConfig<GenericService> referenceConfig = cache.get(cacheKey);
            if (StringUtils.isNoneBlank(referenceConfig.getInterface())) {
                return referenceConfig;
            }
        } catch (ExecutionException e) {
            LOG.error("initRefN dubbo ref exception", e);
        }
        return build(metaData, ruleData, namespace, selectorId, dubboUpstream);
    }

    /**
     * generate dubbo upstream reference cache key.
     *
     * @param selectorId    selectorId
     * @param ruleId        ruleId
     * @param metaDataId    metaDataId
     * @param namespace     namespace
     * @param dubboUpstream dubboUpstream
     * @return the reference config cache key
     */
    public String generateUpstreamCacheKey(final String selectorId, final String ruleId, final String metaDataId, final String namespace, final DubboUpstream dubboUpstream) {
        StringJoiner stringJoiner = new StringJoiner(Constants.SEPARATOR_UNDERLINE);
        if (StringUtils.isNotBlank(namespace)) {
            stringJoiner.add(namespace);
        }
        stringJoiner.add(selectorId);
        stringJoiner.add(ruleId);
        stringJoiner.add(metaDataId);
        if (StringUtils.isNotBlank(dubboUpstream.getProtocol())) {
            stringJoiner.add(dubboUpstream.getProtocol());
        }

        // use registry hash to short reference cache key
        String registryHash = DigestUtils.md5Hex(dubboUpstream.getRegistry());
        stringJoiner.add(registryHash);

        if (StringUtils.isNotBlank(dubboUpstream.getVersion())) {
            stringJoiner.add(dubboUpstream.getVersion());
        }
        if (StringUtils.isNotBlank(dubboUpstream.getGroup())) {
            stringJoiner.add(dubboUpstream.getGroup());
        }
        return stringJoiner.toString();
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
     * build with dynamic namespace and selectorData's dubboUpstream、ruleData's custom param.
     *
     * @param metaData      metaData
     * @param ruleData      ruleData
     * @param namespace     namespace
     * @param selectorId    selectorId
     * @param dubboUpstream dubboUpstream
     * @return the reference config
     */
    @SuppressWarnings("deprecation")
    public ReferenceConfig<GenericService> build(final MetaData metaData, final RuleData ruleData, final String namespace, final String selectorId, final DubboUpstream dubboUpstream) {
        if (Objects.isNull(dubboUpstream)) {
            return this.build(metaData, namespace);
        }

        ReferenceConfig<GenericService> reference = buildReference(metaData, ruleData, namespace, dubboUpstream);
        try {
            Object obj = reference.get();
            if (Objects.nonNull(obj)) {
                LOG.info("buildN init apache dubbo reference success there meteData is :{}", metaData);
                String cacheKey = this.generateUpstreamCacheKey(selectorId, ruleData.getId(), metaData.getId(), namespace, dubboUpstream);
                cache.put(cacheKey, reference);
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
        // default protocol is dubbo
        reference.setProtocol(CommonConstants.DUBBO);
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
            if (Constants.DUBBO_SERIALIZATION_PROTOBUF.equals(dubboParam.getSerialization())) {
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
     * buildReference param with dubboUpstream.
     *
     * @param metaData      metaData
     * @param ruleData      ruleData
     * @param namespace     namespace
     * @param dubboUpstream dubboUpstream
     * @return the reference config
     */
    private ReferenceConfig<GenericService> buildReference(final MetaData metaData, final RuleData ruleData, final String namespace, final DubboUpstream dubboUpstream) {
        if (Objects.isNull(dubboUpstream)) {
            return this.buildReference(metaData, namespace);
        }

        ReferenceConfig<GenericService> reference = new ReferenceConfig<>();
        reference.setGeneric("true");
        reference.setAsync(true);
        reference.setApplication(applicationConfig);

        RegistryConfig registryConfigTemp = new RegistryConfig();
        registryConfigTemp.setProtocol(dubboUpstream.getProtocol());
        registryConfigTemp.setId(Constants.DUBBO_DEFAULT_APPLICATION_NAME);
        registryConfigTemp.setRegister(false);
        registryConfigTemp.setAddress(dubboUpstream.getRegistry());
        Optional.ofNullable(dubboUpstream.getGroup()).ifPresent(registryConfigTemp::setGroup);
        Optional.ofNullable(dubboUpstream.getVersion()).ifPresent(registryConfigTemp::setVersion);
        if (StringUtils.isNotBlank(namespace)) {
            if (!registryConfigTemp.getAddress().contains(Constants.NAMESPACE)) {
                registryConfigTemp.setAddress(registryConfigTemp.getAddress() + "?" + Constants.NAMESPACE + "=" + namespace);
            } else {
                String newAddress = registryConfigTemp.getAddress().substring(0, registryConfigTemp.getAddress().indexOf(Constants.NAMESPACE) + 1) + Constants.NAMESPACE + "=" + namespace;
                registryConfigTemp.setAddress(newAddress);
            }
        }
        reference.setRegistry(registryConfigTemp);

        DubboRuleHandle dubboRuleHandle = AbstractDubboPluginDataHandler.RULE_CACHED_HANDLE.get().obtainHandle(ruleData.getId());
        ConsumerConfig consumerConfigTmp = new ConsumerConfig();
        if (ObjectUtils.isNotEmpty(dubboRuleHandle)) {
            consumerConfigTmp.refresh();
            Optional.ofNullable(consumerConfig.getThreadpool()).ifPresent(consumerConfigTmp::setThreadpool);
            Optional.ofNullable(consumerConfig.getCorethreads()).ifPresent(consumerConfigTmp::setCorethreads);
            Optional.ofNullable(consumerConfig.getThreads()).ifPresent(consumerConfigTmp::setThreads);
            Optional.ofNullable(consumerConfig.getQueues()).ifPresent(consumerConfigTmp::setQueues);
            consumerConfigTmp.setRetries(dubboRuleHandle.getRetries());
            consumerConfigTmp.setTimeout((int) dubboRuleHandle.getTimeout());
        }

        reference.setConsumer(consumerConfigTmp);
        reference.setInterface(metaData.getServiceName());
        // default protocol is dubbo
        reference.setProtocol(CommonConstants.DUBBO);
        reference.setCheck(false);

        Map<String, String> parameters = new HashMap<>(2);
        parameters.put("dispatcher", "direct");
        reference.setParameters(parameters);

        this.configReferenceConfigWithMetaDataRpcExt(metaData.getRpcExt(), reference);
        return reference;
    }

    /**
     * Config ReferenceConfig dubbo param with metaData rpc ext.
     *
     * @param rpcExt  the rpc ext
     * @param reference the reference
     */
    private void configReferenceConfigWithMetaDataRpcExt(final String rpcExt, final ReferenceConfig<GenericService> reference) {
        DubboParam dubboParam = parserToDubboParam(rpcExt);
        if (Objects.isNull(dubboParam)) {
            return;
        }

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
        if (Constants.DUBBO_SERIALIZATION_PROTOBUF.equals(dubboParam.getSerialization())) {
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
     * Invalidate when dubbo selector update.
     *
     * @param selectorId the selectorId
     */
    public void invalidateWithSelectorId(final String selectorId) {
        ConcurrentMap<String, ReferenceConfig<GenericService>> map = cache.asMap();
        Set<String> allKeys = map.keySet();
        Set<String> needInvalidateKeys = allKeys.stream().filter(key -> key.contains(selectorId)).collect(Collectors.toSet());
        needInvalidateKeys.forEach(cache::invalidate);
    }

    /**
     * Invalidate when dubbo rule update.
     *
     * @param ruleId the ruleId
     */
    public void invalidateWithRuleId(final String ruleId) {
        ConcurrentMap<String, ReferenceConfig<GenericService>> map = cache.asMap();
        Set<String> allKeys = map.keySet();
        Set<String> needInvalidateKeys = allKeys.stream().filter(key -> key.contains(ruleId)).collect(Collectors.toSet());
        needInvalidateKeys.forEach(cache::invalidate);
    }

    /**
     * Invalidate when dubbo metadata update.
     *
     * @param metadataId the metadataId
     */
    public void invalidateWithMetadataId(final String metadataId) {
        ConcurrentMap<String, ReferenceConfig<GenericService>> map = cache.asMap();
        Set<String> allKeys = map.keySet();
        Set<String> needInvalidateKeys = allKeys.stream().filter(key -> key.contains(metadataId)).collect(Collectors.toSet());
        needInvalidateKeys.forEach(cache::invalidate);
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
