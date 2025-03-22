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

package org.apache.shenyu.plugin.ai.proxy;

import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.plugin.AiProxyConfig;
import org.apache.shenyu.common.dto.convert.rule.AiProxyHandle;
import org.apache.shenyu.common.enums.AiModelProviderEnum;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.common.utils.Singleton;
import org.apache.shenyu.plugin.ai.proxy.handler.AiProxyPluginHandler;
import org.apache.shenyu.plugin.ai.proxy.strategy.AiModel;
import org.apache.shenyu.plugin.ai.proxy.strategy.AiModelFactory;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;

/**
 * this is ai proxy plugin.
 */
public class AiProxyPlugin extends AbstractShenyuPlugin {
    
    private static final Logger LOG = LoggerFactory.getLogger(AiProxyPlugin.class);
    
    private final List<HttpMessageReader<?>> messageReaders;
    
    public AiProxyPlugin(final List<HttpMessageReader<?>> messageReaders) {
        this.messageReaders = messageReaders;
    }
    
    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain,
                                   final SelectorData selector, final RuleData rule) {
        AiProxyConfig aiProxyConfig = Singleton.INST.get(AiProxyConfig.class);
        if (Objects.isNull(aiProxyConfig)) {
            return chain.execute(exchange);
        }
        final ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        
        String rpcType = shenyuContext.getRpcType();
        String realUrl = shenyuContext.getRealUrl();
        // Get selector handle from cache
        AiProxyHandle selectorHandle = AiProxyPluginHandler.SELECTOR_CACHED_HANDLE.get()
                .obtainHandle(CacheKeyUtils.INST.getKey(selector.getId(), Constants.DEFAULT_RULE));
        
        // Create final config with selector handle taking precedence
        if (Objects.nonNull(selectorHandle)) {
            aiProxyConfig.setProvider(selectorHandle.getProvider());
            aiProxyConfig.setBaseUrl(selectorHandle.getBaseUrl());
            aiProxyConfig.setApiKey(selectorHandle.getApiKey());
            aiProxyConfig.setModel(selectorHandle.getModel());
            aiProxyConfig.setTemperature(selectorHandle.getTemperature());
            aiProxyConfig.setMaxTokens(selectorHandle.getMaxTokens());
            aiProxyConfig.setPrompt(selectorHandle.getPrompt());
            aiProxyConfig.setStream(selectorHandle.getStream());
        }
        
        shenyuContext.setRpcType(RpcTypeEnum.AI.getName());
        exchange.getAttributes().put(Constants.CONTEXT, shenyuContext);
        
        // set domain
        exchange.getAttributes().put(Constants.HTTP_DOMAIN, aiProxyConfig.getBaseUrl());
        // set the http timeout
        exchange.getAttributes().put(Constants.HTTP_TIME_OUT, 60 * 3000L);
        exchange.getAttributes().put(Constants.HTTP_RETRY, 0);
        
        String provider = aiProxyConfig.getProvider();
        AiModelProviderEnum providerEnum = AiModelProviderEnum.getByName(provider);
        if (Objects.isNull(providerEnum)) {
            return Mono.error(new IllegalArgumentException("Invalid AI model provider"));
        }
        AiModel aiModel = AiModelFactory.createAiModel(providerEnum);
        if (Objects.isNull(aiModel)) {
            return Mono.error(new IllegalStateException("Failed to create AI model"));
        }
        return aiModel.invoke(aiProxyConfig, exchange, chain, messageReaders);
        
    }
    
    
    @Override
    public int getOrder() {
        return PluginEnum.AI_PROXY.getCode();
    }
    
    @Override
    public String named() {
        return PluginEnum.AI_PROXY.getName();
    }
}
