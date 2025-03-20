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

package org.apache.shenyu.springboot.starter.plugin.ai.prompt;

import org.apache.shenyu.plugin.ai.prompt.AiPromptPlugin;
import org.apache.shenyu.plugin.ai.prompt.handler.AiPromptPluginDataHandler;
import org.apache.shenyu.plugin.api.ShenyuPlugin;
import org.apache.shenyu.plugin.base.handler.PluginDataHandler;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.codec.ServerCodecConfigurer;

/**
 * The type ai prompt plugin configuration.
 */
@Configuration
@ConditionalOnProperty(value = {"shenyu.plugins.ai.prompt.enabled"}, havingValue = "true", matchIfMissing = true)
public class AiPromptPluginConfiguration {
    
    /**
     * Ai proxy plugin.
     *
     * @param configurer the configurer
     * @return the shenyu plugin
     */
    @Bean
    public ShenyuPlugin aiPromptPlugin(final ServerCodecConfigurer configurer) {
        return new AiPromptPlugin(configurer.getReaders());
    }
    
    /**
     * Ai prompt plugin handler.
     *
     * @return the shenyu plugin handler
     */
    @Bean
    public PluginDataHandler aiPromptPluginDataHandler() {
        return new AiPromptPluginDataHandler();
    }
    
}
