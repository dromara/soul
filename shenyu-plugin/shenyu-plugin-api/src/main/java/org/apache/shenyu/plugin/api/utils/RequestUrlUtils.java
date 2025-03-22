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

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Objects;

/**
 * RequestUrlUtils.
 */
public final class RequestUrlUtils {

    private RequestUrlUtils() {
    }

    /**
     * Build the final request uri.
     *
     * @param exchange the exchange
     * @param domain   the domain
     * @return request uri
     */
    public static URI buildRequestUri(final ServerWebExchange exchange, final String domain) {
        String path = domain;
        final String rewriteUri = exchange.getAttribute(Constants.REWRITE_URI);
        if (StringUtils.isNoneBlank(rewriteUri)) {
            path = path + rewriteUri;
        } else {
            ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
            Objects.requireNonNull(shenyuContext);
            String realUrl = shenyuContext.getRealUrl();
            if (StringUtils.isNoneBlank(realUrl)) {
                path = path + realUrl;
            }
        }
        URI uri = exchange.getRequest().getURI();
        if (StringUtils.isNotEmpty(uri.getRawQuery()) && uri.getRawQuery().contains("%")
                || StringUtils.isNotEmpty(uri.getRawPath()) && uri.getRawPath().contains("%")) {
            path = path + "?" + RequestQueryCodecUtil.getCodecQuery(exchange);
            return UriComponentsBuilder.fromUriString(path).build(true).toUri();
        } else {
            if (StringUtils.isNotEmpty(uri.getQuery())) {
                path = path + "?" + uri.getQuery();
            }
            Objects.requireNonNull(path);
            return UriComponentsBuilder.fromUriString(path).build(false).toUri();
        }
    }
    
    /**
     * Get the rewritten raw path.
     *
     * @param exchange the exchange
     * @return the rewritten raw path
     */
    public static String getRewrittenRawPath(final ServerWebExchange exchange) {
        // match the new selector/rule of RewritePlugin
        ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        if (Objects.nonNull(shenyuContext)) {
            final String rewriteContextPath = exchange.getAttribute(Constants.REWRITE_CONTEXT_PATH);
            final String rewriteUri = exchange.getAttribute(Constants.REWRITE_URI);
            if (StringUtils.isNotBlank(rewriteContextPath) && StringUtils.isNotBlank(rewriteUri)) {
                return rewriteContextPath + rewriteUri;
            } else if (StringUtils.isNotBlank(rewriteContextPath)) {
                return rewriteContextPath + shenyuContext.getRealUrl();
            }
            final String contextPath = exchange.getAttribute(Constants.CONTEXT_PATH);
            if (StringUtils.isNotBlank(contextPath)) {
                return contextPath + shenyuContext.getRealUrl();
            }
        }
        return exchange.getRequest().getURI().getRawPath();
    }
}
