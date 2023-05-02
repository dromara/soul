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

package org.apache.shenyu.plugin.xss;

import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.XssHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.utils.Singleton;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.xss.config.XssConfig;
import org.apache.shenyu.plugin.xss.handler.XssPluginDataHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.util.HtmlUtils;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * XSS plugin avoids common XSS attacks.
 */
public class XssPlugin extends AbstractShenyuPlugin {

    private static final Logger LOG = LoggerFactory.getLogger(XssPlugin.class);


    @Override
    protected Mono<Void> doExecute(final ServerWebExchange exchange, final ShenyuPluginChain chain, final SelectorData selector, final RuleData rule) {
        LOG.info("Xss plugin doExecute start.");

        final XssConfig xssConfig = Singleton.INST.get(XssConfig.class);
        XssHandle xssHandle = XssPluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));

        // Parameter attack
        if (Objects.isNull(xssHandle)) {
            LOG.error("xss handler can not configuration,skip.");
            return chain.execute(exchange);
        }
        final HttpHeaders headers = exchange.getResponse().getHeaders();


//        ServerHttpRequest request = exchange.getRequest();
//        ServerWebExchange modifiedExchange = exchange.mutate()
//                .request(originalRequest -> originalRequest.uri(
//                                UriComponentsBuilder.fromUri(exchange.getRequest()
//                                                .getURI())
//                                        .replaceQueryParams(parameterToHtml(request, xssHandle))
//                                        .build()
//                                        .encode()
//                                        .toUri()
//                        )
//                ).build();

        // Parameter attack


        // CSP https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
        if (!headers.containsKey("Content-Security-Policy")) {
            headers.add("Content-Security-Policy", "script-src 'self'");
        }
        // CSP


        // Cookie Http only
        ServerHttpResponse response = exchange.getResponse();
        List<String> cookies = headers.get(HttpHeaders.SET_COOKIE);

        if (cookies != null) {
            final String cookieStr = String.join(",", cookies);
            if (!cookieStr.contains("HttpOnly")) {
                List<String> newCookies = new ArrayList<>(cookies.size());
                for (String cookie : cookies) {
                    if (cookie.contains("JSESSIONID")) {
                        newCookies.add(cookie + "; HttpOnly");
                    } else {
                        newCookies.add(cookie);
                    }
                }
                headers.put(HttpHeaders.SET_COOKIE, newCookies);
            }
        }
        // Cookie Http only


        LOG.info("Xss plugin doExecute end.");
        return chain.execute(exchange);
    }

    private MultiValueMap<String, String> parameterToHtml(final ServerHttpRequest request, final XssHandle xssHandle) {
        MultiValueMap<String, String> queryParams = new LinkedMultiValueMap<>(request.getQueryParams());

        queryParams.forEach((k, v) -> {
            final List<String> newValues = new ArrayList<>();
            for (final String value : v) {
                newValues.add(HtmlUtils.htmlEscape(value));
            }
            queryParams.replace(k, newValues);
        });
        return queryParams;
    }


    @Override
    public int getOrder() {
        return PluginEnum.XSS.getCode();
    }

    @Override
    public String named() {
        return PluginEnum.XSS.getName();
    }

}
