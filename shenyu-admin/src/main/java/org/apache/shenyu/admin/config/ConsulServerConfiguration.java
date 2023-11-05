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

package org.apache.shenyu.admin.config;

import com.ecwid.consul.v1.ConsulClient;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.register.common.config.ShenyuRegisterCenterConfig;
import org.apache.shenyu.register.client.server.consul.ShenyuConsulConfigWatch;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
(prefix = "shenyu.register", name = "registerType", havingValue = "consul")
public class ConsulServerConfiguration {
    /**
     * Register consul client, distinguished from sync consul client.

     * @param config the shenyu register center config
     * @return the consulClient
     */
    @Bean(name = "registerConsulClient")
    public ConsulClient consulClient(final ShenyuRegisterCenterConfig config) {
        final String serverList = config.getServerLists();
        if (StringUtils.isBlank(serverList)) {
            throw new ShenyuException("serverList can not be null.");
        }
        final String[] addresses = serverList.split(":");
        if (addresses.length != 2) {
            throw new ShenyuException("serverList formatter is not incorrect.");
        }
        return new ConsulClient(addresses[0], Integer.parseInt(addresses[1]));
    }

    /**
     * Register shenyuConsulConfigWatch for ConsulClientServerRegisterRepository to monitor metadata.
     *
     * @param config the shenyu register center config
     * @param publisher the application event publisher
     * @return the consul config watch
     */
    @Bean
    public ShenyuConsulConfigWatch shenyuConsulConfigWatch(final ShenyuRegisterCenterConfig config, final ApplicationEventPublisher publisher) {
        return new ShenyuConsulConfigWatch(config, publisher);
    }
}
