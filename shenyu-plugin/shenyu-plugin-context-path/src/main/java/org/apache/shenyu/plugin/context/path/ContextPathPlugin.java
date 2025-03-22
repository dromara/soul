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

package org.apache.shenyu.plugin.context.path;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.impl.ContextMappingRuleHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.cache.MetaDataCache;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.context.path.handler.ContextPathPluginDataHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

/**
 * ContextPath Plugin.
 */
public class ContextPathPlugin extends AbstractShenyuPlugin {
    
    private static final Logger LOG = LoggerFactory.getLogger(ContextPathPlugin.class);
    
    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        ContextMappingRuleHandle ruleHandle = buildRuleHandle(rule);
        if (Objects.isNull(ruleHandle)) {
            LOG.error("context path rule configuration is null ：{}", rule);
            return chain.execute(exchange);
        }
        buildRealURI(exchange, shenyuContext, ruleHandle);
        return chain.execute(exchange);
    }
    
    @Override
    public int getOrder() {
        return PluginEnum.CONTEXT_PATH.getCode();
    }
    
    @Override
    public String named() {
        return PluginEnum.CONTEXT_PATH.getName();
    }
    
    private ContextMappingRuleHandle buildRuleHandle(final RuleData rule) {
        return ContextPathPluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
    }
    
    /**
     * Build the realUrl.
     *
     * @param context context
     * @param handle  handle
     */
    private void buildRealURI(final ServerWebExchange exchange, final ShenyuContext context, final ContextMappingRuleHandle handle) {
        Map<String, Object> attributes = exchange.getAttributes();
        String realURI = "";
        String contextPath = handle.getContextPath();
        if (StringUtils.isNoneBlank(contextPath)) {
            realURI = context.getPath().substring(contextPath.length());
            attributes.put(Constants.CONTEXT_PATH, contextPath);
        }
        final Integer percentage = Optional.ofNullable(handle.getPercentage()).orElse(100);
        final String rewriteContextPath = handle.getRewriteContextPath();
        if (StringUtils.isNoneBlank(rewriteContextPath) && ThreadLocalRandom.current().nextInt(100) < percentage) {
            // when the rewritten uri crosses plugins, this is necessary
            MetaData metaData = MetaDataCache.getInstance().obtain(rewriteContextPath + realURI);
            Optional.ofNullable(exchange.getAttribute(Constants.META_DATA))
                    .ifPresent(metadata -> attributes.put(Constants.OLD_CONTEXT_PATH_META_DATA, metadata));
            if (Objects.nonNull(metaData)) {
                attributes.put(Constants.META_DATA, metaData);
            }
            attributes.put(Constants.REWRITE_CONTEXT_PATH, rewriteContextPath);
        }
        String addPrefix = handle.getAddPrefix();
        if (StringUtils.isNoneBlank(addPrefix)) {
            if (StringUtils.isNotBlank(realURI)) {
                realURI = addPrefix + realURI;
            } else {
                realURI = addPrefix + context.getPath();
            }
        }
        context.setRealUrl(realURI);
    }
}
