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

package org.apache.shenyu.plugin.rewrite;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.RewriteHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.base.cache.MetaDataCache;
import org.apache.shenyu.plugin.base.utils.PathMatchUtils;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.rewrite.handler.RewritePluginDataHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Rewrite Plugin.
 */
public class RewritePlugin extends AbstractShenyuPlugin {

    private static final Logger LOG = LoggerFactory.getLogger(RewritePlugin.class);
    
    @Override
    protected String getRawPath(final ServerWebExchange exchange) {
        String rewriteContextPath = exchange.getAttribute(Constants.REWRITE_CONTEXT_PATH);
        if (StringUtils.isBlank(rewriteContextPath)) {
            return super.getRawPath(exchange);
        }
        // match the new selector/rule of RewritePlugin
        ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        return rewriteContextPath + shenyuContext.getRealUrl();
    }
    
    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        String handle = rule.getHandle();
        RewriteHandle rewriteHandle = RewritePluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
        if (Objects.isNull(rewriteHandle)) {
            LOG.error("uri rewrite rule can not configuration：{}", handle);
            return chain.execute(exchange);
        }
        String rewriteUri = this.getRawPath(exchange);
        // the default percentage compatible with older versions is 100
        final Integer percentage = Optional.ofNullable(rewriteHandle.getPercentage()).orElse(100);
        if (StringUtils.isNoneBlank(rewriteHandle.getRegex(), rewriteHandle.getReplace())
                && ThreadLocalRandom.current().nextInt(100) < percentage) {
            rewriteUri = rewriteHandle.getReplace().contains("{")
                    ? PathMatchUtils.replaceAll(rewriteHandle.getReplace(), rewriteHandle.getRegex().substring(rewriteHandle.getRegex().indexOf("{")),
                            rewriteUri.substring(rewriteHandle.getRegex().indexOf("{") + 1))
                    : rewriteUri.replaceAll(rewriteHandle.getRegex(), rewriteHandle.getReplace());
            Map<String, Object> attributes = exchange.getAttributes();
            if (Optional.ofNullable(rewriteHandle.getRewriteMetaData()).orElse(false)) {
                // when the rewritten uri crosses plugins, this is necessary
                final String contextPath = Optional.ofNullable((String) exchange.getAttribute(Constants.REWRITE_CONTEXT_PATH))
                        .orElseGet(() -> exchange.getAttribute(Constants.CONTEXT_PATH));
                MetaData metaData = MetaDataCache.getInstance().obtain(contextPath + rewriteUri);
                Optional.ofNullable(exchange.getAttribute(Constants.META_DATA))
                        .ifPresent(metadata -> attributes.put(Constants.OLD_CONTEXT_PATH_META_DATA, metadata));
                if (Objects.nonNull(metaData)) {
                    attributes.put(Constants.META_DATA, metaData);
                }
                ShenyuContext context = exchange.getAttribute(Constants.CONTEXT);
                Objects.requireNonNull(context);
                if (Objects.nonNull(metaData) && Boolean.TRUE.equals(metaData.getEnabled())) {
                    context.setRpcType(metaData.getRpcType());
                } else {
                    context.setRpcType(RpcTypeEnum.HTTP.getName());
                }
            }
            attributes.put(Constants.REWRITE_URI, rewriteUri);
        }
        return chain.execute(exchange);
    }

    @Override
    public String named() {
        return PluginEnum.REWRITE.getName();
    }

    @Override
    public int getOrder() {
        return PluginEnum.REWRITE.getCode();
    }
}
