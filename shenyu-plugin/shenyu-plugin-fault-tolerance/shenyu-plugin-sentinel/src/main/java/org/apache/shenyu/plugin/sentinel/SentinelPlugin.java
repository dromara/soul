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

package org.apache.shenyu.plugin.sentinel;

import com.alibaba.csp.sentinel.adapter.reactor.SentinelReactorTransformer;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.SentinelHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.utils.UriUtils;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.fallback.FallbackHandler;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.sentinel.handler.SentinelRuleHandle;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Objects;
import java.util.Optional;
import java.util.function.Consumer;

/**
 * Sentinel Plugin.
 */
public class SentinelPlugin extends AbstractShenyuPlugin {

    private final FallbackHandler fallbackHandler;

    public SentinelPlugin(final FallbackHandler fallbackHandler) {
        this.fallbackHandler = fallbackHandler;
    }

    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        final ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        String resourceName = CacheKeyUtils.INST.getKey(rule);
        SentinelHandle sentinelHandle = SentinelRuleHandle.CACHED_HANDLE.get().obtainHandle(resourceName);
        sentinelHandle.checkData();
        exchange.getAttributes().put(Constants.WATCHER_HTTP_STATUS, (Consumer<HttpStatus>) status -> {
            if (Objects.isNull(status) || !status.is2xxSuccessful()) {
                throw new SentinelFallbackException(Objects.isNull(status) ? HttpStatus.INTERNAL_SERVER_ERROR : status);
            }
        });
        return chain.execute(exchange).transform(new SentinelReactorTransformer<>(resourceName)).onErrorResume(throwable ->
                fallbackHandler.fallback(exchange, UriUtils.createUri(sentinelHandle.getFallbackUri()), throwable)).doFinally(monoV -> {
                    final Consumer<HttpStatusCode> consumer = exchange.getAttribute(Constants.METRICS_SENTINEL);
                    Optional.ofNullable(consumer).ifPresent(c -> c.accept(exchange.getResponse().getStatusCode()));
                }
        );
    }

    @Override
    public String named() {
        return PluginEnum.SENTINEL.getName();
    }

    @Override
    public int getOrder() {
        return PluginEnum.SENTINEL.getCode();
    }

    public static class SentinelFallbackException extends HttpStatusCodeException {

        public SentinelFallbackException(final HttpStatus statusCode) {
            super(statusCode);
        }
    }
}
