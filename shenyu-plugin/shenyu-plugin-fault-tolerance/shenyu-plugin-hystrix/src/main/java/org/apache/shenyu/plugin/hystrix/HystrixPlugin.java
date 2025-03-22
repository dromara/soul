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

package org.apache.shenyu.plugin.hystrix;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.HystrixHandle;
import org.apache.shenyu.common.enums.HystrixIsolationModeEnum;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.ResultEnum;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.hystrix.builder.HystrixBuilder;
import org.apache.shenyu.plugin.hystrix.command.Command;
import org.apache.shenyu.plugin.hystrix.command.HystrixCommand;
import org.apache.shenyu.plugin.hystrix.command.HystrixCommandOnThread;
import org.apache.shenyu.plugin.hystrix.handler.HystrixPluginDataHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import rx.Subscription;

import java.util.Objects;
import java.util.Optional;
import java.util.function.Consumer;

/**
 * Hystrix Plugin.
 */
public class HystrixPlugin extends AbstractShenyuPlugin {

    private static final Logger LOG = LoggerFactory.getLogger(HystrixPlugin.class);

    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        final ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        final HystrixHandle hystrixHandle = HystrixPluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
        String groupKey = hystrixHandle.getGroupKey();
        if (StringUtils.isBlank(hystrixHandle.getGroupKey())) {
            groupKey = Objects.requireNonNull(shenyuContext).getModule();
        }
        String commandKey = hystrixHandle.getCommandKey();
        if (StringUtils.isBlank(hystrixHandle.getCommandKey())) {
            commandKey = Objects.requireNonNull(shenyuContext).getMethod();
        }
        Command command = fetchCommand(hystrixHandle, exchange, chain, commandKey, groupKey);
        return Mono.create(s -> {
            Subscription sub = command.fetchObservable().subscribe(s::success,
                    s::error, s::success);
            s.onCancel(sub::unsubscribe);
            if (command.isCircuitBreakerOpen()) {
                LOG.error("hystrix execute have circuitBreaker is Open! groupKey:{},commandKey:{}", hystrixHandle.getGroupKey(), hystrixHandle.getCommandKey());
            }
        }).doOnError(throwable -> {
            LOG.error("hystrix execute exception:", throwable);
            exchange.getAttributes().put(Constants.CLIENT_RESPONSE_RESULT_TYPE, ResultEnum.ERROR.getName());
            chain.execute(exchange);
        }).then().doFinally(monoV -> {
            final Consumer<HttpStatusCode> consumer = exchange.getAttribute(Constants.METRICS_HYSTRIX);
            Optional.ofNullable(consumer).ifPresent(c -> c.accept(exchange.getResponse().getStatusCode()));
        });
    }

    private Command fetchCommand(final HystrixHandle hystrixHandle, final ServerWebExchange exchange, final ShenyuPluginChain chain, final String commandKey, final String groupKey) {
        if (hystrixHandle.getExecutionIsolationStrategy() == HystrixIsolationModeEnum.SEMAPHORE.getCode()) {
            return new HystrixCommand(HystrixBuilder.build(hystrixHandle, commandKey, groupKey),
                    exchange, chain, hystrixHandle.getCallBackUri());
        }
        return new HystrixCommandOnThread(HystrixBuilder.buildForHystrixCommand(hystrixHandle, commandKey, groupKey),
                exchange, chain, hystrixHandle.getCallBackUri());
    }

    @Override
    public String named() {
        return PluginEnum.HYSTRIX.getName();
    }

    @Override
    public int getOrder() {
        return PluginEnum.HYSTRIX.getCode();
    }

}
