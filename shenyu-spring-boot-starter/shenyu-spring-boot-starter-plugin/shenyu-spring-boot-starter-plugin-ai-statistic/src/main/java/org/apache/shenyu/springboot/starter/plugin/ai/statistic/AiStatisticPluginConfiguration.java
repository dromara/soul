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

package org.apache.shenyu.springboot.starter.plugin.ai.statistic;

import org.apache.shenyu.plugin.ai.statistic.AiStatisticPlugin;
import org.apache.shenyu.plugin.api.ShenyuPlugin;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * The type ai statistic plugin configuration.
 */
@Configuration
@ConditionalOnProperty(value = {"shenyu.plugins.ai.statistic.enabled"}, havingValue = "true", matchIfMissing = true)
public class AiStatisticPluginConfiguration {
    
    /**
     * Ai statistic plugin.
     *
     * @return the shenyu plugin
     */
    @Bean
    public ShenyuPlugin aiStatisticPlugin() {
        return new AiStatisticPlugin();
    }
    
    
}
