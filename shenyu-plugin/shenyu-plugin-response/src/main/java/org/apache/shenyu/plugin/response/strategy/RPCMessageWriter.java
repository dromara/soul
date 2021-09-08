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

package org.apache.shenyu.plugin.response.strategy;

import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.result.ShenyuResultEnum;
import org.apache.shenyu.plugin.api.result.ShenyuResultWrap;
import org.apache.shenyu.plugin.api.utils.WebFluxResultUtils;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Objects;

/**
 * The type Rpc message writer.
 */
public class RPCMessageWriter implements MessageWriter {

    @Override
    public Mono<Void> writeWith(final ServerWebExchange exchange, final ShenyuPluginChain chain) {
        return chain.execute(exchange).then(Mono.defer(() -> {
            Object result = exchange.getAttribute(Constants.RPC_RESULT);
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
}
