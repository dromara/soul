/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * Contributor license agreements.See the NOTICE file distributed with
 * This work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * he License.You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.apache.shenyu.plugin.motan.response;

import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.plugin.api.ShenyuPlugin;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.api.result.ShenyuResultEnum;
import org.apache.shenyu.plugin.api.result.ShenyuResultWrap;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Objects;

/**
 * this is motan response plugin.
 */
public class MotanResponsePlugin implements ShenyuPlugin {

    /**
     * Process the Web request and (optionally) delegate to the next
     * {@code WebFilter} through the given {@link ShenyuPluginChain}.
     *
     * @param exchange the current server exchange
     * @param chain    provides a way to delegate to the next filter
     * @return {@code Mono<Void>} to indicate when request processing is complete
     */
    @Override
    public Mono<Void> execute(final ServerWebExchange exchange, final ShenyuPluginChain chain) {
        return chain.execute(exchange).then(Mono.defer(() -> {
            final Object result = exchange.getAttribute(Constants.MOTAN_RPC_RESULT);
            if (Objects.isNull(result)) {
                Object error = ShenyuResultWrap.error(ShenyuResultEnum.SERVICE_RESULT_ERROR.getCode(), ShenyuResultEnum.SERVICE_RESULT_ERROR.getMsg(), null);
                return WebFluxResultUtils.result(exchange, error);
            }
            boolean wrap = true;
            MetaData metaData = exchange.getAttribute(Constants.META_DATA);
            if (metaData != null) {
                wrap = metaData.getWrap() == null || metaData.getWrap();
            }
            Object success = ShenyuResultWrap.success(ShenyuResultEnum.SUCCESS.getCode(), ShenyuResultEnum.SUCCESS.getMsg(), JsonUtils.removeClass(result), wrap);
            return WebFluxResultUtils.result(exchange, success);
        }));
    }

    @Override
    public boolean skip(final ServerWebExchange exchange) {
        final ShenyuContext shenyuContext = exchange.getAttribute(Constants.CONTEXT);
        assert shenyuContext != null;
        return !Objects.equals(shenyuContext.getRpcType(), RpcTypeEnum.MOTAN.getName());
    }

    @Override
    public int getOrder() {
        return PluginEnum.RESPONSE.getCode();
    }

    /**
     * acquire plugin name.
     *
     * @return plugin name.
     */
    @Override
    public String named() {
        return PluginEnum.RESPONSE.getName();
    }
}
