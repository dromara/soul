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

package org.apache.shenyu.plugin.divide.websocket;

import java.net.URI;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.shenyu.plugin.divide.balance.utils.LoadBalanceUtils;
import org.apache.shenyu.plugin.divide.cache.UpstreamCacheManager;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.DivideUpstream;
import org.apache.shenyu.common.dto.convert.rule.impl.DivideRuleHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.api.result.ShenyuResultEnum;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.api.result.ShenyuResultWrap;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.lang.NonNull;
import org.springframework.util.StringUtils;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import org.springframework.web.reactive.socket.client.WebSocketClient;
import org.springframework.web.reactive.socket.server.WebSocketService;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Mono;

/**
 * The type Web socket plugin.
 *
 * @author xiaoyu(Myth)
 */
@Slf4j
public class WebSocketPlugin extends AbstractShenyuPlugin {

    private static final String SEC_WEB_SOCKET_PROTOCOL = "Sec-WebSocket-Protocol";

    private final WebSocketClient webSocketClient;

    private final WebSocketService webSocketService;

    /**
     * Instantiates a new Web socket plugin.
     *
     * @param webSocketClient  the web socket client
     * @param webSocketService the web socket service
     */
    public WebSocketPlugin(final WebSocketClient webSocketClient, final WebSocketService webSocketService) {
        this.webSocketClient = webSocketClient;
        this.webSocketService = webSocketService;
    }

    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        final List<DivideUpstream> upstreamList = UpstreamCacheManager.getInstance().findUpstreamListBySelectorId(selector.getId());
        final ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        if (CollectionUtils.isEmpty(upstreamList) || Objects.isNull(shenyuContext)) {
            log.error("divide upstream configuration error：{}", rule.toString());
            return chain.execute(exchange);
        }
        final DivideRuleHandle ruleHandle = GsonUtils.getInstance().fromJson(rule.getHandle(), DivideRuleHandle.class);
        final String ip = Objects.requireNonNull(exchange.getRequest().getRemoteAddress()).getAddress().getHostAddress();
        DivideUpstream divideUpstream = LoadBalanceUtils.selector(upstreamList, ruleHandle.getLoadBalance(), ip);
        if (Objects.isNull(divideUpstream)) {
            log.error("websocket has no upstream");
            Object error = ShenyuResultWrap.error(ShenyuResultEnum.CANNOT_FIND_URL.getCode(), ShenyuResultEnum.CANNOT_FIND_URL.getMsg(), null);
            return WebFluxResultUtils.result(exchange, error);
        }
        URI wsRequestUrl = UriComponentsBuilder.fromUri(URI.create(buildWsRealPath(divideUpstream, shenyuContext))).build().toUri();
        log.info("you websocket urlPath is :{}", wsRequestUrl.toASCIIString());
        HttpHeaders headers = exchange.getRequest().getHeaders();
        return this.webSocketService.handleRequest(exchange, new ShenyuWebSocketHandler(
                wsRequestUrl, this.webSocketClient, filterHeaders(headers), buildWsProtocols(headers)));
    }

    private String buildWsRealPath(final DivideUpstream divideUpstream, final ShenyuContext shenyuContext) {
        String protocol = divideUpstream.getProtocol();
        if (StringUtils.isEmpty(protocol)) {
            protocol = "ws://";
        }
        return protocol + divideUpstream.getUpstreamUrl() + shenyuContext.getMethod();
    }

    private List<String> buildWsProtocols(final HttpHeaders headers) {
        List<String> protocols = headers.get(SEC_WEB_SOCKET_PROTOCOL);
        if (CollectionUtils.isNotEmpty(protocols)) {
            protocols = protocols
                    .stream().flatMap(header -> Arrays.stream(StringUtils.commaDelimitedListToStringArray(header)))
                    .map(String::trim).collect(Collectors.toList());
        }
        return protocols;
    }

    private HttpHeaders filterHeaders(final HttpHeaders headers) {
        HttpHeaders filtered = new HttpHeaders();
        headers.entrySet().stream()
                .filter(entry -> !entry.getKey().toLowerCase()
                        .startsWith("sec-websocket"))
                .forEach(header -> filtered.addAll(header.getKey(),
                        header.getValue()));
        return filtered;
    }

    @Override
    public String named() {
        return PluginEnum.DIVIDE.getName();
    }

    /**
     * plugin is execute.
     *
     * @return default false.
     */
    @Override
    public Boolean skip(final ServerWebExchange exchange) {
        final ShenyuContext body = exchange.getAttribute(Constants.CONTEXT);
        return !Objects.equals(Objects.requireNonNull(body).getRpcType(), RpcTypeEnum.WEB_SOCKET.getName());
    }

    @Override
    public int getOrder() {
        return PluginEnum.WEB_SOCKET.getCode();
    }

    private static class ShenyuWebSocketHandler implements WebSocketHandler {

        private final WebSocketClient client;

        private final URI url;

        private final HttpHeaders headers;

        private final List<String> subProtocols;

        /**
         * Instantiates a new Soul web socket handler.
         *
         * @param url       the url
         * @param client    the client
         * @param headers   the headers
         * @param protocols the protocols
         */
        ShenyuWebSocketHandler(final URI url, final WebSocketClient client,
                               final HttpHeaders headers,
                               final List<String> protocols) {
            this.client = client;
            this.url = url;
            this.headers = headers;
            if (protocols != null) {
                this.subProtocols = protocols;
            } else {
                this.subProtocols = Collections.emptyList();
            }
        }

        @NonNull
        @Override
        public List<String> getSubProtocols() {
            return this.subProtocols;
        }

        @NonNull
        @Override
        public Mono<Void> handle(@NonNull final WebSocketSession session) {
            // pass headers along so custom headers can be sent through
            return client.execute(url, this.headers, new WebSocketHandler() {

                @NonNull
                @Override
                public Mono<Void> handle(@NonNull final WebSocketSession webSocketSession) {
                    // Use retain() for Reactor Netty
                    Mono<Void> sessionSend = webSocketSession
                            .send(session.receive().doOnNext(WebSocketMessage::retain));
                    Mono<Void> serverSessionSend = session.send(
                            webSocketSession.receive().doOnNext(WebSocketMessage::retain));
                    return Mono.zip(sessionSend, serverSessionSend).then();
                }

                @NonNull
                @Override
                public List<String> getSubProtocols() {
                    return ShenyuWebSocketHandler.this.subProtocols;
                }
            });
        }

    }

}
