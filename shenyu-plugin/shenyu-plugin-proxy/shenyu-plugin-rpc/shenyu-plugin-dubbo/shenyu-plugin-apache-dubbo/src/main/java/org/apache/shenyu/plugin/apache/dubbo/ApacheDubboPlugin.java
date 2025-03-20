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

package org.apache.shenyu.plugin.apache.dubbo;

import org.apache.dubbo.common.constants.CommonConstants;
import org.apache.dubbo.rpc.RpcContext;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.impl.DubboRuleHandle;
import org.apache.shenyu.plugin.apache.dubbo.handler.ApacheDubboPluginDataHandler;
import org.apache.shenyu.plugin.apache.dubbo.proxy.ApacheDubboProxyService;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.dubbo.common.AbstractDubboPlugin;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.Objects;

/**
 * The type Apache dubbo plugin.
 */
public class ApacheDubboPlugin extends AbstractDubboPlugin {

    private final ApacheDubboProxyService dubboProxyService;

    /**
     * Instantiates a new Dubbo plugin.
     *
     * @param dubboProxyService the dubbo proxy service
     */
    public ApacheDubboPlugin(final ApacheDubboProxyService dubboProxyService) {
        this.dubboProxyService = dubboProxyService;
    }

    /**
     * do dubbo invoker.
     *
     * @param exchange exchange the current server exchange {@linkplain ServerWebExchange}
     * @param chain    chain the current chain  {@linkplain ServerWebExchange}
     * @param metaData the medata
     * @param param    the param
     * @return {@code Mono<Void>} to indicate when request handling is complete
     */
    @Override
    protected Mono<Void> doDubboInvoker(final ServerWebExchange exchange,
                                        final ShenyuPluginChain chain,
                                        final SelectorData selector,
                                        final RuleData rule,
                                        final MetaData metaData,
                                        final String param) {
        DubboRuleHandle dubboRuleHandle = ApacheDubboPluginDataHandler.RULE_CACHED_HANDLE.get().obtainHandle(rule.getId());
        if (dubboRuleHandle.getTimeout() > 0) {
            RpcContext.getClientAttachment().setAttachment(CommonConstants.TIMEOUT_KEY, dubboRuleHandle.getTimeout());
        }
        RpcContext.getClientAttachment().setAttachment(Constants.DUBBO_SELECTOR_ID, selector.getId());
        RpcContext.getClientAttachment().setAttachment(Constants.DUBBO_RULE_ID, rule.getId());
        RpcContext.getClientAttachment().setAttachment(Constants.DUBBO_REMOTE_ADDRESS, Objects.requireNonNull(exchange.getRequest().getRemoteAddress()).getAddress().getHostAddress());
        final Mono<Object> result = dubboProxyService.genericInvoker(param, metaData, selector, rule, exchange);
        return result.then(chain.execute(exchange));
    }

    @Override
    protected void transmitRpcContext(final Map<String, String> rpcContext) {
        RpcContext.getClientAttachment().setAttachments(rpcContext);
    }
}
