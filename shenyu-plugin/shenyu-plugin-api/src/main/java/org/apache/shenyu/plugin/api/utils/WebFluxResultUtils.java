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

package org.apache.shenyu.plugin.api.utils;

import org.apache.shenyu.common.utils.ObjectTypeUtils;
import org.apache.shenyu.plugin.api.exception.ResponsiveException;
import org.apache.shenyu.plugin.api.result.ShenyuResult;
import org.apache.shenyu.plugin.api.result.ShenyuResultEnum;
import org.apache.shenyu.plugin.api.result.ShenyuResultWrap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.util.Objects;

/**
 * The type Shenyu result utils.
 */
public final class WebFluxResultUtils {

    /**
     * result utils log.
     */
    private static final Logger LOG = LoggerFactory.getLogger(WebFluxResultUtils.class);

    private WebFluxResultUtils() {
    }

    /**
     * Response result.
     *
     * @param exchange the exchange
     * @param result   the result
     * @return the result
     */
    public static Mono<Void> result(final ServerWebExchange exchange, final Object result) {
        if (Objects.isNull(result)) {
            return Mono.empty();
        }
        final ShenyuResult<?> shenyuResult = ShenyuResultWrap.shenyuResult();
        Object resultData = shenyuResult.format(exchange, result);
        // basic data use text/plain
        MediaType mediaType = MediaType.TEXT_PLAIN;
        if (!ObjectTypeUtils.isBasicType(result)) {
            mediaType = shenyuResult.contentType(exchange, resultData);
        }
        exchange.getResponse().getHeaders().setContentType(mediaType);
        final Object responseData = shenyuResult.result(exchange, resultData);
        Objects.requireNonNull(responseData);
        final byte[] bytes = (responseData instanceof byte[])
                ? (byte[]) responseData : responseData.toString().getBytes(StandardCharsets.UTF_8);
        return exchange.getResponse().writeWith(Mono.just(exchange.getResponse()
                .bufferFactory().wrap(bytes))
                .doOnNext(data -> exchange.getResponse().getHeaders().setContentLength(data.readableByteCount())));
    }

    /**
     * get no selector result.
     *
     * @param pluginName the plugin name
     * @param exchange   the exchange
     * @return the mono
     */
    public static Mono<Void> noSelectorResult(final String pluginName, final ServerWebExchange exchange) {
        LOG.error("can not match selector data: {} , path is {}", pluginName, exchange.getRequest().getURI().getRawPath());
        Object error = ShenyuResultWrap.error(exchange, ShenyuResultEnum.SELECTOR_NOT_FOUND.getCode(), pluginName + ":" + ShenyuResultEnum.SELECTOR_NOT_FOUND.getMsg(), null);
        return WebFluxResultUtils.result(exchange, error);
    }

    /**
     * get no rule result.
     *
     * @param pluginName the plugin name
     * @param exchange   the exchange
     * @return the mono
     */
    public static Mono<Void> noRuleResult(final String pluginName, final ServerWebExchange exchange) {
        LOG.error("can not match rule data: {} , path is {}", pluginName, exchange.getRequest().getURI().getRawPath());
        Object error = ShenyuResultWrap.error(exchange, ShenyuResultEnum.RULE_NOT_FOUND.getCode(), pluginName + ":" + ShenyuResultEnum.RULE_NOT_FOUND.getMsg(), null);
        return WebFluxResultUtils.result(exchange, error);
    }

    /**
     * get failed result.
     *
     * @param responsiveException responsiveException
     * @return the mono.
     */
    public static Mono<Void> failedResult(final ResponsiveException responsiveException) {
        return failedResult(responsiveException.getCode(),
                responsiveException.getMessage(),
                responsiveException.getWebExchange());
    }

    /**
     * get failed result.
     *
     * @param code     code
     * @param reason   reason
     * @param exchange exchange
     * @return the mono.
     */
    public static Mono<Void> failedResult(final int code, final String reason, final ServerWebExchange exchange) {
        Object error = ShenyuResultWrap.error(exchange, code, reason, null);
        return WebFluxResultUtils.result(exchange, error);
    }

}
