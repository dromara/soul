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

package org.dromara.soul.plugin.motan.proxy;

import com.weibo.api.motan.config.RefererConfig;
import com.weibo.api.motan.proxy.CommonHandler;
import com.weibo.api.motan.rpc.ResponseFuture;
import lombok.SneakyThrows;
import org.apache.commons.lang3.StringUtils;
import org.dromara.soul.common.constant.Constants;
import org.dromara.soul.common.dto.MetaData;
import org.dromara.soul.common.enums.ResultEnum;
import org.dromara.soul.common.exception.SoulException;
import org.dromara.soul.common.utils.GsonUtils;
import org.dromara.soul.plugin.motan.cache.ApplicationConfigCache;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;

/**
 * Motan proxy service.
 *
 * @author tydhot
 */
public class MotanProxyService {

    /**
     * Generic invoker object.
     *
     * @param body the body
     * @param metaData the meta data
     * @param exchange the exchange
     * @return the object
     * @throws SoulException the soul exception
     */
    @SneakyThrows
    public Mono<Object> genericInvoker(final String body, final MetaData metaData, final ServerWebExchange exchange) throws SoulException {
        RefererConfig<CommonHandler> reference = ApplicationConfigCache.getInstance().get(metaData.getPath());
        if (Objects.isNull(reference) || StringUtils.isEmpty(reference.getServiceInterface())) {
            ApplicationConfigCache.getInstance().invalidate(metaData.getPath());
            reference = ApplicationConfigCache.getInstance().initRef(metaData);
        }
        CommonHandler commonHandler = reference.getRef();
        ApplicationConfigCache.MotanParamInfo motanParamInfo = ApplicationConfigCache.PARAM_MAP.get(metaData.getMethodName());
        Object[] params;
        if (motanParamInfo == null) {
            params = new Object[0];
        } else {
            int num = motanParamInfo.getParamTypes().length;
            params = new Object[num];
            for (int i = 0; i < num; i++) {
                Map<String, Object> bodyMap = GsonUtils.getInstance().convertToMap(body);
                params[i] = bodyMap.get(motanParamInfo.getParamNames()[i]).toString();
            }
        }
        ResponseFuture responseFuture = (ResponseFuture) commonHandler.asyncCall(metaData.getMethodName(),
                params, Object.class);
        CompletableFuture<Object> future = CompletableFuture.supplyAsync(() -> responseFuture.getValue());
        return Mono.fromFuture(future.thenApply(ret -> {
            if (Objects.isNull(ret)) {
                ret = Constants.MOTAN_RPC_RESULT_EMPTY;
            }
            exchange.getAttributes().put(Constants.MOTAN_RPC_RESULT, ret);
            exchange.getAttributes().put(Constants.CLIENT_RESPONSE_RESULT_TYPE, ResultEnum.SUCCESS.getName());
            return ret;
        })).onErrorMap(SoulException::new);
    }

//    private GenericMessage buildGenericMessage(String name, Map<String, Object> map) {
//        GenericMessage message = new GenericMessage();
//        message.setName(name);
//        for (Map.Entry<String, Object> e : map.entrySet()) {
//            int nameIndex = CommonSerializer.getHash(e.getKey());
//            message.putFields(nameIndex,e.getValue());
//        }
//        return message;
//    }
}
