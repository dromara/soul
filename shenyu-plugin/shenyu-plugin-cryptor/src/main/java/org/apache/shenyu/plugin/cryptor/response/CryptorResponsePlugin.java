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

package org.apache.shenyu.plugin.cryptor.response;

import org.apache.shenyu.common.constant.Constants;
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
import org.apache.shenyu.plugin.cryptor.decorator.ResponseDecorator;
import org.apache.shenyu.plugin.cryptor.handler.CryptorResponsePluginDataHandler;
import org.apache.shenyu.plugin.cryptor.strategy.CryptorStrategyFactory;
import org.apache.shenyu.plugin.cryptor.utils.HttpUtil;
import org.apache.shenyu.plugin.cryptor.utils.JsonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.server.reactive.ServerHttpResponseDecorator;
import org.springframework.web.reactive.function.BodyInserter;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Objects;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;

/**
 * Cryptor response plugin.
 */
public class CryptorResponsePlugin extends AbstractShenyuPlugin {

    private static final Logger LOG = LoggerFactory.getLogger(CryptorResponsePlugin.class);

    @Override
    @SuppressWarnings("unchecked")
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        CryptorRuleHandle ruleHandle = CryptorResponsePluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
        if (Objects.isNull(ruleHandle)) {
            LOG.error("Cryptor response rule configuration is null :{}", rule.getId());
            return chain.execute(exchange);
        }
        if (JsonUtil.checkParam(ruleHandle.toJson())) {
            Object error = ShenyuResultWrap.error(ShenyuResultEnum.CRYPTOR_RESPONSE_ERROR_CONFIGURATION.getCode(),
                    ShenyuResultEnum.CRYPTOR_RESPONSE_ERROR_CONFIGURATION.getMsg() + "[" + JsonUtil.getErrorCollector() + "]", null);
            return WebFluxResultUtils.result(exchange, error);
        }

        CachedBodyOutputMessage outputMessage = HttpUtil.newCachedBodyOutputMessage(exchange);
        ClientResponse clientResponse = exchange.getAttribute(Constants.CLIENT_RESPONSE_ATTR);
        if (clientResponse == null) {
            return Mono.empty();
        }
        Mono<String> mono = clientResponse.bodyToMono(String.class)
                .flatMap(originalBody ->
                        strategyMatch(originalBody, ruleHandle, exchange));
        BodyInserter<Mono<String>, ReactiveHttpOutputMessage> bodyInserter = BodyInserters.fromPublisher(mono, String.class);
        return bodyInserter.insert(outputMessage, new BodyInserterContext())
                .then(Mono.defer(() -> {
                    ServerHttpResponseDecorator decorator = new ResponseDecorator(exchange, outputMessage);
                    return chain.execute(exchange.mutate().response(decorator).build());
                })).onErrorResume((Function<Throwable, Mono<Void>>) throwable -> HttpUtil.release(outputMessage, throwable));

    }

    @Override
    public int getOrder() {
        return PluginEnum.CRYPTOR_RESPONSE.getCode();
    }

    @Override
    public String named() {
        return PluginEnum.CRYPTOR_RESPONSE.getName();
    }

    private Mono strategyMatch(final String originalBody, final CryptorRuleHandle ruleHandle, final ServerWebExchange exchange) {
        String parseBody = JsonUtil.parser(originalBody, ruleHandle.getFieldNames());
        if (parseBody == null) {
            return Mono.just(originalBody);
        }
        String modifiedBody = CryptorStrategyFactory.match(ruleHandle, parseBody);
        if (modifiedBody == null) {
            return HttpUtil.fail(ruleHandle.getWay(), exchange);
        }
        return HttpUtil.success(originalBody, modifiedBody, ruleHandle.getWay(), ruleHandle.getFieldNames());
    }
}
