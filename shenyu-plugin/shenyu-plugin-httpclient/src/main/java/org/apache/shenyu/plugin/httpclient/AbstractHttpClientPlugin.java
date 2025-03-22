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

package org.apache.shenyu.plugin.httpclient;

import com.google.common.collect.Sets;
import io.netty.channel.ConnectTimeoutException;
import io.netty.handler.timeout.ReadTimeoutException;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.enums.HeaderUniqueStrategyEnum;
import org.apache.shenyu.common.enums.RetryEnum;
import org.apache.shenyu.common.enums.UniqueHeaderEnum;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.common.utils.LogUtils;
import org.apache.shenyu.loadbalancer.cache.UpstreamCacheManager;
import org.apache.shenyu.loadbalancer.entity.Upstream;
import org.apache.shenyu.loadbalancer.factory.LoadBalancerFactory;
import org.apache.shenyu.plugin.api.ShenyuPlugin;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.api.result.ShenyuResultEnum;
import org.apache.shenyu.plugin.api.result.ShenyuResultWrap;
import org.apache.shenyu.plugin.api.utils.RequestUrlUtils;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.apache.shenyu.plugin.httpclient.exception.ShenyuTimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;
import reactor.util.retry.RetryBackoffSpec;

import java.net.URI;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.TimeoutException;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * The type abstract http client plugin.
 */
public abstract class AbstractHttpClientPlugin<R> implements ShenyuPlugin {

    protected static final Logger LOG = LoggerFactory.getLogger(AbstractHttpClientPlugin.class);

    @Override
    public final Mono<Void> execute(final ServerWebExchange exchange, final ShenyuPluginChain chain) {
        final ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        Objects.requireNonNull(shenyuContext);
        final URI uri = exchange.getAttribute(Constants.HTTP_URI);
        if (Objects.isNull(uri)) {
            Object error = ShenyuResultWrap.error(exchange, ShenyuResultEnum.CANNOT_FIND_URL);
            return WebFluxResultUtils.result(exchange, error);
        }
        final long timeout = (long) Optional.ofNullable(exchange.getAttribute(Constants.HTTP_TIME_OUT)).orElse(3000L);
        final Duration duration = Duration.ofMillis(timeout);
        final int retryTimes = (int) Optional.ofNullable(exchange.getAttribute(Constants.HTTP_RETRY)).orElse(0);
        final String retryStrategy = (String) Optional.ofNullable(exchange.getAttribute(Constants.RETRY_STRATEGY)).orElseGet(RetryEnum.CURRENT::getName);
        LogUtils.debug(LOG, () -> String.format("The request urlPath is: %s, retryTimes is : %s, retryStrategy is : %s", uri, retryTimes, retryStrategy));
        final Mono<R> response = doRequest(exchange, exchange.getRequest().getMethod().name(), uri, exchange.getRequest().getBody())
                .timeout(duration, Mono.error(() -> new TimeoutException("Response took longer than timeout: " + duration)))
                .doOnError(e -> LOG.error(e.getMessage(), e));
        if (RetryEnum.CURRENT.getName().equals(retryStrategy)) {
            //old version of DividePlugin and SpringCloudPlugin will run on this
            RetryBackoffSpec retryBackoffSpec = Retry.backoff(retryTimes, Duration.ofMillis(20L))
                    .maxBackoff(Duration.ofSeconds(20L))
                    .transientErrors(true)
                    .jitter(0.5d)
                    .filter(t -> t instanceof TimeoutException || t instanceof ConnectTimeoutException
                            || t instanceof ReadTimeoutException || t instanceof IllegalStateException)
                    .onRetryExhaustedThrow((retryBackoffSpecErr, retrySignal) -> {
                        throw new ShenyuTimeoutException("Request timeout, the maximum number of retry times has been exceeded");
                    });
            return response.retryWhen(retryBackoffSpec)
                    .onErrorMap(ShenyuTimeoutException.class, th -> new ResponseStatusException(HttpStatus.REQUEST_TIMEOUT, th.getMessage(), th))
                    .onErrorMap(TimeoutException.class, th -> new ResponseStatusException(HttpStatus.GATEWAY_TIMEOUT, th.getMessage(), th))
                    .flatMap((Function<Object, Mono<? extends Void>>) o -> chain.execute(exchange));
        }
        final Set<URI> exclude = Sets.newHashSet(uri);
        return resend(response, exchange, duration, exclude, retryTimes)
                .onErrorMap(ShenyuException.class, th -> new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                        ShenyuResultEnum.CANNOT_FIND_HEALTHY_UPSTREAM_URL_AFTER_FAILOVER.getMsg(), th))
                .onErrorMap(TimeoutException.class, th -> new ResponseStatusException(HttpStatus.GATEWAY_TIMEOUT, th.getMessage(), th))
                .flatMap((Function<Object, Mono<? extends Void>>) o -> chain.execute(exchange));
    }

    private Mono<R> resend(final Mono<R> clientResponse,
                           final ServerWebExchange exchange,
                           final Duration duration,
                           final Set<URI> exclude,
                           final int retryTimes) {
        Mono<R> result = clientResponse;
        for (int i = 0; i < retryTimes; i++) {
            result = resend(result, exchange, duration, exclude);
        }
        return result;
    }
    
    private Mono<R> resend(final Mono<R> response,
                           final ServerWebExchange exchange,
                           final Duration duration,
                           final Set<URI> exclude) {
        // does it necessary to add backoff interval time ?
        return response.onErrorResume(th -> {
            final String selectorId = exchange.getAttribute(Constants.DIVIDE_SELECTOR_ID);
            final String loadBalance = exchange.getAttribute(Constants.LOAD_BALANCE);
            //always query the latest available list
            final List<Upstream> upstreamList = UpstreamCacheManager.getInstance().findUpstreamListBySelectorId(selectorId)
                    .stream().filter(data -> {
                        final String trimUri = data.getUrl().trim();
                        for (URI needToExclude : exclude) {
                            // exclude already called
                            if ((needToExclude.getHost() + ":" + needToExclude.getPort()).equals(trimUri)) {
                                return false;
                            }
                        }
                        return true;
                    }).collect(Collectors.toList());
            if (CollectionUtils.isEmpty(upstreamList)) {
                // no need to retry anymore
                return Mono.error(new ShenyuException(ShenyuResultEnum.CANNOT_FIND_HEALTHY_UPSTREAM_URL_AFTER_FAILOVER.getMsg()));
            }
            final String ip = Objects.requireNonNull(exchange.getRequest().getRemoteAddress()).getAddress().getHostAddress();
            final Upstream upstream = LoadBalancerFactory.selector(upstreamList, loadBalance, ip);
            if (Objects.isNull(upstream)) {
                // no need to retry anymore
                return Mono.error(new ShenyuException(ShenyuResultEnum.CANNOT_FIND_HEALTHY_UPSTREAM_URL_AFTER_FAILOVER.getMsg()));
            }
            final URI newUri = RequestUrlUtils.buildRequestUri(exchange, upstream.buildDomain());
            // in order not to affect the next retry call, newUri needs to be excluded
            exclude.add(newUri);
            return doRequest(exchange, exchange.getRequest().getMethod().name(), newUri, exchange.getRequest().getBody())
                    .timeout(duration, Mono.error(() -> new TimeoutException("Response took longer than timeout: " + duration)))
                    .doOnError(e -> LOG.error(e.getMessage(), e));
        });
    }

    /**
     * Process the Web request.
     *
     * @param exchange    the current server exchange
     * @param httpMethod  http method, eg.POST
     * @param uri         the request uri
     * @param body        the request body
     * @return {@code Mono<Void>} to indicate when request processing is complete
     */
    protected abstract Mono<R> doRequest(ServerWebExchange exchange, String httpMethod,
                                         URI uri, Flux<DataBuffer> body);

    protected void duplicateHeaders(final ServerWebExchange exchange, final HttpHeaders headers, final UniqueHeaderEnum uniqueHeaderEnum) {
        final String duplicateHeader = exchange.getAttribute(uniqueHeaderEnum.getName());
        if (StringUtils.isEmpty(duplicateHeader)) {
            return;
        }
        List<String> duplicateHeaderList = Arrays.asList(StringUtils.split(duplicateHeader, Constants.SEPARATOR_CHARS));
        if (CollectionUtils.isEmpty(duplicateHeaderList)) {
            return;
        }
        HeaderUniqueStrategyEnum strategy = exchange.getAttributeOrDefault(uniqueHeaderEnum.getStrategy(), HeaderUniqueStrategyEnum.RETAIN_FIRST);
        for (String headerKey : duplicateHeaderList) {
            this.duplicate(headers, headerKey, strategy);
        }
    }
    
    protected void duplicate(final HttpHeaders headers, final String header, final HeaderUniqueStrategyEnum strategy) {
        List<String> headerValues = headers.get(header);
        if (Objects.isNull(headerValues) || headerValues.size() <= 1) {
            return;
        }
        switch (strategy) {
            case RETAIN_FIRST:
                headers.set(header, headerValues.get(0));
                break;
            case RETAIN_LAST:
                headers.set(header, headerValues.get(headerValues.size() - 1));
                break;
            case RETAIN_UNIQUE:
                headers.put(header, new ArrayList<>(new LinkedHashSet<>(headerValues)));
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + strategy);
        }
    }
}
