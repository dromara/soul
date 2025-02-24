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

package org.apache.shenyu.plugin.param.mapping.strategy;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.shenyu.common.dto.convert.rule.impl.ParamMappingRuleHandle;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.base.support.CachedBodyOutputMessage;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * Param mapping strategy.
 */
public interface Operator {

    /**
     * Process.
     *
     * @param exchange           exchange
     * @param shenyuPluginChain  chain
     * @param paramMappingRuleHandle handle
     * @return mono
     */
    Mono<Void> apply(ServerWebExchange exchange, ShenyuPluginChain shenyuPluginChain, ParamMappingRuleHandle paramMappingRuleHandle);

    /**
     * Clean buffer.
     *
     * @param outputMessage output
     * @param throwable     throwable
     * @return mono
     */
    default Mono<Void> release(final CachedBodyOutputMessage outputMessage, final Throwable throwable) {
        if (Boolean.TRUE.equals(outputMessage.getCache())) {
            return outputMessage.getBody().map(DataBufferUtils::release).then(Mono.error(throwable));
        }
        return Mono.error(throwable);
    }

    /**
     * Operation.
     *
     * @param jsonValue          json
     * @param paramMappingRuleHandle handle
     * @return string
     */
    default String operation(final String jsonValue, final ParamMappingRuleHandle paramMappingRuleHandle) {
        DocumentContext context = JsonPath.parse(jsonValue);
        operation(context, paramMappingRuleHandle);
        if (!CollectionUtils.isEmpty(paramMappingRuleHandle.getReplaceParameterKeys())) {
            paramMappingRuleHandle.getReplaceParameterKeys().forEach(info -> context.put(info.getPath(), info.getKey(), info.getValue()));
        }
        if (!CollectionUtils.isEmpty(paramMappingRuleHandle.getRemoveParameterKeys())) {
            paramMappingRuleHandle.getRemoveParameterKeys().forEach(context::delete);
        }
        return context.jsonString();
    }

    /**
     * Operation.
     *
     * @param context            context
     * @param paramMappingRuleHandle handle
     */
    default void operation(final DocumentContext context, final ParamMappingRuleHandle paramMappingRuleHandle) {
        if (!CollectionUtils.isEmpty(paramMappingRuleHandle.getAddParameterKeys())) {
            paramMappingRuleHandle.getAddParameterKeys().forEach(info -> context.put(info.getPath(), info.getKey(), info.getValue()));
        }
    }
}
