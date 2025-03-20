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

package org.apache.shenyu.plugin.apache.dubbo.proxy;

import java.util.Objects;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;
import java.util.List;
import java.util.Collections;
import java.util.Optional;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.dubbo.common.constants.CommonConstants;
import org.apache.dubbo.config.ReferenceConfig;
import org.apache.dubbo.rpc.RpcContext;
import org.apache.dubbo.rpc.service.GenericException;
import org.apache.dubbo.rpc.service.GenericService;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.selector.DubboUpstream;
import org.apache.shenyu.common.enums.LoadBalanceEnum;
import org.apache.shenyu.common.enums.ResultEnum;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.common.utils.ParamCheckUtils;
import org.apache.shenyu.loadbalancer.entity.Upstream;
import org.apache.shenyu.loadbalancer.factory.LoadBalancerFactory;
import org.apache.shenyu.plugin.apache.dubbo.cache.ApacheDubboConfigCache;
import org.apache.shenyu.plugin.dubbo.common.param.DubboParamResolveService;
import org.springframework.util.ObjectUtils;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * dubbo proxy service is  use GenericService.
 */
public class ApacheDubboProxyService {

    private final DubboParamResolveService dubboParamResolveService;

    /**
     * Instantiates a new Dubbo proxy service.
     *
     * @param dubboParamResolveService the generic param resolve service
     */
    public ApacheDubboProxyService(final DubboParamResolveService dubboParamResolveService) {
        this.dubboParamResolveService = dubboParamResolveService;
    }

    /**
     * Generic invoker object.
     *
     * @param body          the body
     * @param metaData      the meta data
     * @param selectorData  the selector data
     * @param ruleData      the rule data
     * @param exchange      the webExchange
     * @return the object
     * @throws ShenyuException the shenyu exception
     */
    public Mono<Object> genericInvoker(final String body, final MetaData metaData, final SelectorData selectorData, final RuleData ruleData, final ServerWebExchange exchange) throws ShenyuException {
        ReferenceConfig<GenericService> reference = this.getReferenceConfig(selectorData, ruleData, metaData, exchange);
        GenericService genericService = reference.get();

        Pair<String[], Object[]> pair;
        if (StringUtils.isBlank(metaData.getParameterTypes()) || ParamCheckUtils.bodyIsEmpty(body)) {
            pair = new ImmutablePair<>(new String[]{}, new Object[]{});
        } else if (CommonConstants.GENERIC_SERIALIZATION_PROTOBUF.equals(reference.getGeneric())) {
            pair = new ImmutablePair<>(new String[]{metaData.getParameterTypes()}, new Object[]{JsonUtils.toJson(JsonUtils.jsonToMap(body))});
        } else {
            pair = dubboParamResolveService.buildParameter(body, metaData.getParameterTypes());
        }
        return Mono.fromFuture(invokeAsync(genericService, metaData.getMethodName(), pair.getLeft(), pair.getRight()).thenApply(ret -> {
            Object result = ret;
            if (Objects.isNull(result)) {
                result = Constants.DUBBO_RPC_RESULT_EMPTY;
            }
            exchange.getAttributes().put(Constants.RPC_RESULT, result);
            exchange.getAttributes().put(Constants.CLIENT_RESPONSE_RESULT_TYPE, ResultEnum.SUCCESS.getName());
            return result;
        })).onErrorMap(exception -> exception instanceof GenericException ? new ShenyuException(((GenericException) exception).getExceptionMessage()) : new ShenyuException(exception));
    }
    
    @SuppressWarnings("unchecked")
    private CompletableFuture<Object> invokeAsync(final GenericService genericService, final String method, final String[] parameterTypes, final Object[] args) throws GenericException {
        //Compatible with asynchronous calls of lower Dubbo versions
        genericService.$invoke(method, parameterTypes, args);
        Object resultFromFuture = RpcContext.getContext().getFuture();
        return resultFromFuture instanceof CompletableFuture ? (CompletableFuture<Object>) resultFromFuture : CompletableFuture.completedFuture(resultFromFuture);
    }

    /**
     * get dubbo reference config.
     *
     * @param selectorData  the selector data
     * @param ruleData      the rule data
     * @param metaData      the meta data
     * @param exchange      the webExchange
     * @return dubbo reference config
     */
    private ReferenceConfig<GenericService> getReferenceConfig(final SelectorData selectorData, final RuleData ruleData, final MetaData metaData, final ServerWebExchange exchange) {
        String referenceKey = metaData.getPath();
        String namespace = "";
        if (CollectionUtils.isNotEmpty(exchange.getRequest().getHeaders().get(Constants.NAMESPACE))) {
            namespace = exchange.getRequest().getHeaders().get(Constants.NAMESPACE).get(0);
        }

        List<DubboUpstream> dubboUpstreams = GsonUtils.getInstance().fromList(selectorData.getHandle(), DubboUpstream.class);
        dubboUpstreams = CollectionUtils.isEmpty(dubboUpstreams) ? null
                : dubboUpstreams.stream().filter(u -> u.isStatus() && StringUtils.isNotBlank(u.getRegistry())).collect(Collectors.toList());
        // if dubboUpstreams is empty, use default plugin config
        if (CollectionUtils.isEmpty(dubboUpstreams)) {
            referenceKey = StringUtils.isNotBlank(namespace) ? namespace + ":" + referenceKey : referenceKey;
            ReferenceConfig<GenericService> reference = ApacheDubboConfigCache.getInstance().get(referenceKey);
            if (StringUtils.isEmpty(reference.getInterface())) {
                ApacheDubboConfigCache.getInstance().invalidate(referenceKey);
                reference = ApacheDubboConfigCache.getInstance().initRefN(metaData, namespace);
            }
            return reference;
        }

        List<Upstream> upstreams = this.convertUpstreamList(dubboUpstreams);
        String ip = Objects.requireNonNull(exchange.getRequest().getRemoteAddress()).getAddress().getHostAddress();
        Upstream upstream = LoadBalancerFactory.selector(upstreams, LoadBalanceEnum.RANDOM.getName(), ip);
        DubboUpstream dubboUpstream = null;
        for (DubboUpstream upstreamItem : dubboUpstreams) {
            if (Objects.equals(upstreamItem.getRegistry(), upstreamItem.getRegistry())
                    && Objects.equals(upstreamItem.getProtocol(), upstream.getProtocol())
                    && Objects.equals(upstreamItem.getVersion(), upstream.getVersion())
                    && Objects.equals(upstreamItem.getGroup(), upstream.getGroup())) {
                dubboUpstream = upstreamItem;
                break;
            }
        }

        referenceKey = ApacheDubboConfigCache.getInstance().generateUpstreamCacheKey(selectorData.getId(), ruleData.getId(), metaData.getId(), namespace, dubboUpstream);
        ReferenceConfig<GenericService> reference = ApacheDubboConfigCache.getInstance().get(referenceKey);
        if (StringUtils.isEmpty(reference.getInterface())) {
            ApacheDubboConfigCache.getInstance().invalidate(referenceKey);
            reference = ApacheDubboConfigCache.getInstance().initRefN(selectorData.getId(), ruleData, metaData, namespace, dubboUpstream);
        }
        return reference;
    }

    /**
     * convert get DubboUpstream to Upstream.
     *
     * @param upstreamList  the dubbo upstream list
     * @return upstream list
     */
    private List<Upstream> convertUpstreamList(final List<DubboUpstream> upstreamList) {
        if (ObjectUtils.isEmpty(upstreamList)) {
            return Collections.emptyList();
        }
        return upstreamList.stream().map(u -> {
            return Upstream.builder()
                    .protocol(u.getProtocol())
                    .url(u.getRegistry())
                    .version(u.getVersion())
                    .group(u.getGroup())
                    .weight(u.getWeight())
                    .status(u.isStatus())
                    .timestamp(Optional.of(u.getTimestamp()).orElse(System.currentTimeMillis()))
                    .build();
        }).collect(Collectors.toList());
    }
}
