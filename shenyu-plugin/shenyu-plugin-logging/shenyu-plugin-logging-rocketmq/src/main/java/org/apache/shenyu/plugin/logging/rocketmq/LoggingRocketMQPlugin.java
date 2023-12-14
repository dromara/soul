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

package org.apache.shenyu.plugin.logging.rocketmq;

import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.plugin.logging.common.AbstractLoggingPlugin;
import org.apache.shenyu.plugin.logging.common.collector.LogCollector;
import org.apache.shenyu.plugin.logging.common.entity.ShenyuRequestLog;
import org.apache.shenyu.plugin.logging.rocketmq.collector.RocketMQLogCollector;
import org.apache.shenyu.plugin.logging.rocketmq.handler.LoggingRocketMQPluginDataHandler;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.web.server.ServerWebExchange;

import java.util.Optional;

/**
 * Integrated rocketmq collect log.
 */
public class LoggingRocketMQPlugin extends AbstractLoggingPlugin<ShenyuRequestLog> {

    @Override
    protected LogCollector<ShenyuRequestLog> logCollector() {
        return RocketMQLogCollector.getInstance();
    }

    /**
     * pluginEnum.
     *
     * @return plugin
     */
    @Override
    public PluginEnum pluginEnum() {
        return PluginEnum.LOGGING_ROCKETMQ;
    }

    /**
     * log collect extension.
     * base on ShenyuRequestLog to extend log
     *
     * @param exchange exchange
     * @param selector selector
     * @param rule     rule
     * @return base ShenyuRequestLog
     */
    @Override
    protected ShenyuRequestLog doLogExecute(final ServerWebExchange exchange, final SelectorData selector, final RuleData rule) {
        return new ShenyuRequestLog();
    }

    @Override
    protected boolean isSampled(final String selectorID, final ServerHttpRequest request) {
        return Optional.ofNullable(LoggingRocketMQPluginDataHandler.getSelectApiSamplerMap().get(selectorID))
                .map(sampler -> sampler.isSampled(request))
                .orElse(true);
    }
}
