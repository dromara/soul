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

package org.apache.shenyu.plugin.cryptor.request;

import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.impl.CryptorRuleHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.result.ShenyuResultEnum;
import org.apache.shenyu.plugin.api.result.ShenyuResultWrap;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.support.BodyInserterContext;
import org.apache.shenyu.plugin.base.support.CachedBodyOutputMessage;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.cryptor.decorator.RequestDecorator;
import org.apache.shenyu.plugin.cryptor.handler.CryptorRequestPluginDataHandler;
import org.apache.shenyu.plugin.cryptor.strategy.CryptorStrategyFactory;
import org.apache.shenyu.plugin.cryptor.utils.HttpUtil;
import org.apache.shenyu.plugin.cryptor.utils.JsonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.http.server.reactive.ServerHttpRequestDecorator;
import org.springframework.web.reactive.function.BodyInserter;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.server.HandlerStrategies;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.function.Function;

/**
 * Cryptor request plugin.
 */
public class CryptorRequestPlugin extends AbstractShenyuPlugin {

    private static final Logger LOG = LoggerFactory.getLogger(CryptorRequestPlugin.class);

    private static final List<HttpMessageReader<?>> MESSAGE_READERS = HandlerStrategies.builder().build().messageReaders();

    @Override
    @SuppressWarnings("unchecked")
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        CryptorRuleHandle ruleHandle = CryptorRequestPluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
        if (Objects.isNull(ruleHandle)) {
            LOG.error("Cryptor request rule configuration is null :{}", rule.getId());
            return chain.execute(exchange);
        }
        CachedBodyOutputMessage outputMessage = HttpUtil.newCachedBodyOutputMessage(exchange);
        if (JsonUtil.checkParam(ruleHandle.toJson())) {
            Object error = ShenyuResultWrap.error(ShenyuResultEnum.CRYPTOR_REQUEST_ERROR_CONFIGURATION.getCode(),
                    ShenyuResultEnum.CRYPTOR_REQUEST_ERROR_CONFIGURATION.getMsg()
                    + "[" + JsonUtil.getErrorCollector() + "]", null);
            return WebFluxResultUtils.result(exchange, error);
        }

        ServerRequest serverRequest = ServerRequest.create(exchange, MESSAGE_READERS);
        Mono<String> mono = serverRequest.bodyToMono(String.class)
                .switchIfEmpty(Mono.defer(() -> Mono.just("")))
                .flatMap(originalBody -> strategyMatch(ruleHandle, originalBody, exchange));

        BodyInserter<Mono<String>, ReactiveHttpOutputMessage> bodyInserter = BodyInserters.fromPublisher(mono, String.class);
        return bodyInserter.insert(outputMessage, new BodyInserterContext())
                .then(Mono.defer(() -> {
                    ServerHttpRequestDecorator decorator = new RequestDecorator(exchange, outputMessage);
                    return chain.execute(exchange.mutate().request(decorator).build());
                })).onErrorResume((Function<Throwable, Mono<Void>>) throwable -> HttpUtil.release(outputMessage, throwable));

    }

    @Override
    public int getOrder() {
        return PluginEnum.CRYPTOR_REQUEST.getCode();
    }

    @Override
    public String named() {
        return PluginEnum.CRYPTOR_REQUEST.getName();
    }

    private Mono strategyMatch(final CryptorRuleHandle ruleHandle, final String originalBody, final ServerWebExchange exchange) {
        String parseBody = JsonUtil.parser(originalBody, ruleHandle.getFieldNames());
        if (null == parseBody) {
            Object error = ShenyuResultWrap.error(ShenyuResultEnum.CRYPTOR_REQUEST_ERROR_CONFIGURATION.getCode(),
                    ShenyuResultEnum.CRYPTOR_REQUEST_ERROR_CONFIGURATION.getMsg() + "[fieldNames]", null);
            return WebFluxResultUtils.result(exchange, error);
        }
        String modifiedBody = CryptorStrategyFactory.match(ruleHandle, parseBody);
        if (modifiedBody == null) {
            return HttpUtil.fail(ruleHandle.getWay(), exchange);
        }
        return HttpUtil.success(originalBody, modifiedBody, ruleHandle.getWay(), ruleHandle.getFieldNames());
    }

}
