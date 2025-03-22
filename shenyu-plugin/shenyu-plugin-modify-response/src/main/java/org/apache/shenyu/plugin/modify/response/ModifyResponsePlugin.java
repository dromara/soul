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

package org.apache.shenyu.plugin.modify.response;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.MapUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.impl.ModifyResponseRuleHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.modify.response.handler.ModifyResponsePluginDataHandler;
import org.reactivestreams.Publisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpResponseDecorator;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.util.annotation.NonNull;

import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * ModifyResponse plugin.
 */
public class ModifyResponsePlugin extends AbstractShenyuPlugin {

    private static final Logger LOG = LoggerFactory.getLogger(ModifyResponsePlugin.class);

    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        ModifyResponseRuleHandle ruleHandle = ModifyResponsePluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
        if (Objects.isNull(ruleHandle)) {
            return chain.execute(exchange);
        }
        return chain.execute(exchange.mutate()
                .response(new ModifyResponseDecorator(exchange, ruleHandle)).build());
    }

    @Override
    public int getOrder() {
        return PluginEnum.MODIFY_RESPONSE.getCode();
    }

    @Override
    public String named() {
        return PluginEnum.MODIFY_RESPONSE.getName();
    }

    static class ModifyResponseDecorator extends ServerHttpResponseDecorator {

        private final ServerWebExchange exchange;

        private final ModifyResponseRuleHandle ruleHandle;

        ModifyResponseDecorator(final ServerWebExchange exchange,
                                final ModifyResponseRuleHandle ruleHandle) {
            super(exchange.getResponse());
            this.exchange = exchange;
            this.ruleHandle = ruleHandle;
        }

        @Override
        @NonNull
        public Mono<Void> writeWith(@NonNull final Publisher<? extends DataBuffer> body) {
            modifyResponseHeadersAndStatus();
            final Mono<DataBuffer> dataBufferMono = DataBufferUtils.join(body);
            return dataBufferMono.flatMap(dataBuffer -> {
                byte[] bytes = new byte[dataBuffer.readableByteCount()];
                dataBuffer.read(bytes);
                DataBufferUtils.release(dataBuffer);
                return WebFluxResultUtils.result(this.exchange, modifyBody(bytes));
            });
        }

        private void modifyResponseHeadersAndStatus() {
            HttpHeaders httpHeaders = new HttpHeaders();
            // add origin headers
            httpHeaders.addAll(this.getHeaders());

            // add new headers
            if (MapUtils.isNotEmpty(this.ruleHandle.getAddHeaders())) {
                Map<String, String> addHeaderMap = this.ruleHandle.getAddHeaders();
                addHeaderMap.forEach(httpHeaders::add);
            }

            // set new headers
            if (MapUtils.isNotEmpty(this.ruleHandle.getSetHeaders())) {
                Map<String, String> setHeaderMap = this.ruleHandle.getSetHeaders();
                setHeaderMap.forEach(httpHeaders::set);
            }

            // replace headers
            if (MapUtils.isNotEmpty(this.ruleHandle.getReplaceHeaderKeys())) {
                Map<String, String> replaceHeaderMap = this.ruleHandle.getReplaceHeaderKeys();
                replaceHeaderMap.forEach((key, value) -> httpHeaders.replace(key, Collections.singletonList(value)));
            }

            // remove headers
            if (CollectionUtils.isNotEmpty(this.ruleHandle.getRemoveHeaderKeys())) {
                Set<String> removeHeaderList = this.ruleHandle.getRemoveHeaderKeys();
                removeHeaderList.forEach(httpHeaders::remove);
            }

            // reset http status
            if (this.ruleHandle.getStatusCode() > 0) {
                this.setStatusCode(HttpStatus.valueOf(this.ruleHandle.getStatusCode()));
            }

            // reset http headers
            this.getDelegate().getHeaders().clear();
            this.getDelegate().getHeaders().putAll(httpHeaders);
        }

        private byte[] modifyBody(final byte[] responseBody) {
            try {
                String bodyStr = modifyBody(new String(responseBody, StandardCharsets.UTF_8));
                LOG.info("the body string {}", bodyStr);
                return bodyStr.getBytes(StandardCharsets.UTF_8);
            } catch (Exception e) {
                LOG.error("modify response error", e);
                throw new ShenyuException(String.format("response modify failure. %s", e.getLocalizedMessage()));
            }
        }

        private String modifyBody(final String jsonValue) {
            DocumentContext context = JsonPath.parse(jsonValue);
            if (CollectionUtils.isNotEmpty(this.ruleHandle.getAddBodyKeys())) {
                this.ruleHandle.getAddBodyKeys().forEach(info -> context.put(info.getPath(), info.getKey(), info.getValue()));
            }
            if (CollectionUtils.isNotEmpty(this.ruleHandle.getReplaceBodyKeys())) {
                this.ruleHandle.getReplaceBodyKeys().forEach(info -> context.renameKey(info.getPath(), info.getKey(), info.getValue()));
            }
            if (CollectionUtils.isNotEmpty(this.ruleHandle.getRemoveBodyKeys())) {
                this.ruleHandle.getRemoveBodyKeys().forEach(context::delete);
            }
            return context.jsonString();
        }
    }
}
