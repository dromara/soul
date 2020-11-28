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

package org.dromara.soul.plugin.resilience4j.executor;

import io.github.resilience4j.circuitbreaker.CallNotPermittedException;
import io.github.resilience4j.ratelimiter.RequestNotPermitted;
import org.apache.commons.lang3.StringUtils;
import org.dromara.soul.plugin.api.result.SoulResultEnum;
import org.dromara.soul.plugin.base.utils.SoulResultWrap;
import org.dromara.soul.plugin.base.utils.SpringBeanUtils;
import org.dromara.soul.plugin.base.utils.UriUtils;
import org.dromara.soul.plugin.base.utils.WebFluxResultUtils;
import org.dromara.soul.plugin.resilience4j.ResilencePlugin;
import org.dromara.soul.plugin.resilience4j.conf.ResilienceConf;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.web.reactive.DispatcherHandler;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.concurrent.TimeoutException;
import java.util.function.Function;

/**
 * Executor.
 *
 * @author zhanglei
 */
public interface Executor {

    /**
     * resilience run.
     *
     * @param toRun    not null
     * @param fallback not null
     * @param conf     not null
     * @param <T>      not null
     * @return mono
     */
    <T> Mono<T> run(Mono<T> toRun, Function<Throwable, Mono<T>> fallback, ResilienceConf conf);

    /**
     * do fallback.
     *
     * @param exchange not null
     * @param uri      not null
     * @param t        not null
     * @return Mono
     */
    default Mono<Void> fallback(ServerWebExchange exchange, String uri, Throwable t) {
        if (StringUtils.isBlank(uri)) {
            return withoutFallback(exchange, t);
        }
        DispatcherHandler dispatcherHandler = SpringBeanUtils.getInstance().getBean(DispatcherHandler.class);
        ServerHttpRequest request = exchange.getRequest().mutate().uri(UriUtils.createUri(uri)).build();
        ServerWebExchange mutated = exchange.mutate().request(request).build();
        return dispatcherHandler.handle(mutated);
    }

    /**
     * do fallback with not  fallback method.
     *
     * @param exchange not null
     * @param t        not null
     * @return Mono
     */
    default Mono<Void> withoutFallback(ServerWebExchange exchange, Throwable t) {
        Object error;
        if (TimeoutException.class.isInstance(t)) {
            exchange.getResponse().setStatusCode(HttpStatus.GATEWAY_TIMEOUT);
            error = SoulResultWrap.error(SoulResultEnum.SERVICE_TIMEOUT.getCode(), SoulResultEnum.SERVICE_TIMEOUT.getMsg(), null);
        } else if (ResilencePlugin.CircuitBreakerStatusCodeException.class.isInstance(t)) {
            return Mono.error(t);
        } else if (CallNotPermittedException.class.isInstance(t)) {
            exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
            error = SoulResultWrap.error(SoulResultEnum.SERVICE_RESULT_ERROR.getCode(), SoulResultEnum.SERVICE_RESULT_ERROR.getMsg(), null);
        } else if (RequestNotPermitted.class.isInstance(t)) {
            exchange.getResponse().setStatusCode(HttpStatus.TOO_MANY_REQUESTS);
            error = SoulResultWrap.error(SoulResultEnum.TOO_MANY_REQUESTS.getCode(), SoulResultEnum.TOO_MANY_REQUESTS.getMsg(), null);
        } else {
            exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
            error = SoulResultWrap.error(SoulResultEnum.SERVICE_RESULT_ERROR.getCode(), SoulResultEnum.SERVICE_RESULT_ERROR.getMsg(), null);
        }
        return WebFluxResultUtils.result(exchange, error);
    }

    /**
     * default error.
     *
     * @param exchange not null
     * @return Mono
     */
    default Mono<Void> error(ServerWebExchange exchange) {
        exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
        Object error = SoulResultWrap.error(SoulResultEnum.SERVICE_RESULT_ERROR.getCode(), SoulResultEnum.SERVICE_RESULT_ERROR.getMsg(), null);
        return WebFluxResultUtils.result(exchange, error);
    }

}
