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

package org.apache.shenyu.plugin.ai.proxy.strategy.openai;

import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.convert.plugin.AiProxyConfig;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.plugin.ai.proxy.strategy.AiModel;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.exception.ResponsiveException;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.apache.shenyu.plugin.base.utils.ServerWebExchangeUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;

/**
 * The OpenAI model.
 */
public class OpenAI implements AiModel {
    
    @Override
    public Mono<Void> invoke(final AiProxyConfig aiProxyConfig, final ServerWebExchange exchange,
                             final ShenyuPluginChain chain,
                             final List<HttpMessageReader<?>> messageReaders) {
        ServerWebExchange modifiedExchange = exchange.mutate()
                .request(originalRequest -> originalRequest
                        .headers(httpHeaders -> convertHeader(httpHeaders, aiProxyConfig))
                        .method(exchange.getRequest().getMethod())
                )
                .build();
        return ServerWebExchangeUtils.rewriteRequestBody(modifiedExchange, messageReaders, originalBody ->
                        Mono.just(convertBody(originalBody, aiProxyConfig))
                ).flatMap(chain::execute)
                .onErrorResume(error -> {
                    if (error instanceof ResponsiveException) {
                        return WebFluxResultUtils.failedResult((ResponsiveException) error);
                    }
                    return Mono.error(error);
                });
    }
    
    
    private static void convertHeader(final HttpHeaders httpHeaders, final AiProxyConfig aiProxyConfig) {
        if (!httpHeaders.containsKey("Authorization")) {
            httpHeaders.add("Authorization", "Bearer " + aiProxyConfig.getApiKey());
        }
        if (aiProxyConfig.getStream()) {
            httpHeaders.add(HttpHeaders.CONTENT_TYPE, MediaType.TEXT_EVENT_STREAM_VALUE);
            httpHeaders.add(HttpHeaders.CACHE_CONTROL, "no-cache");
            httpHeaders.add(HttpHeaders.CONNECTION, "keep-alive");
        }
    }
    
    private String convertBody(final String originalBody, final AiProxyConfig aiProxyConfig) {
        Map<String, Object> requestBodyMap = GsonUtils.getInstance().convertToMap(originalBody);
        requestBodyMap.put(Constants.MODEL, aiProxyConfig.getModel());
        requestBodyMap.put(Constants.STREAM, aiProxyConfig.getStream());
        return GsonUtils.getInstance().toJson(requestBodyMap);
    }
    
}
