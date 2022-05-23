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

package org.apache.shenyu.springboot.starter.netty;

import io.netty.channel.ChannelOption;
import io.netty.channel.WriteBufferWaterMark;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.web.embedded.netty.NettyReactiveWebServerFactory;
import org.springframework.boot.web.embedded.netty.NettyServerCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import reactor.netty.http.server.HttpServer;
import reactor.netty.resources.LoopResources;

import java.util.Optional;

/**
 * The type shenyu netty web server factory.
 */
@Configuration
public class ShenyuNettyWebServerConfiguration {
    
    /**
     * Netty tcp config.
     *
     * @return the netty tcp config
     */
    @Bean
    @ConfigurationProperties(prefix = "shenyu.netty.tcp")
    public NettyTcpProperties nettyTcpProperties() {
        return new NettyTcpProperties();
    }
    
    /**
     * Netty reactive web server factory netty reactive web server factory.
     *
     * @param properties the properties
     * @return the netty reactive web server factory
     */
    @Bean
    @ConditionalOnProperty(value = "shenyu.netty.tcp.webServerFactoryEnabled", havingValue = "true", matchIfMissing = true)
    public NettyReactiveWebServerFactory nettyReactiveWebServerFactory(final ObjectProvider<NettyTcpProperties> properties) {
        NettyReactiveWebServerFactory webServerFactory = new NettyReactiveWebServerFactory();
        NettyTcpProperties nettyTcpProperties = Optional.ofNullable(properties.getIfAvailable()).orElse(new NettyTcpProperties());
        webServerFactory.addServerCustomizers(new EventLoopNettyCustomizer(nettyTcpProperties));
        return webServerFactory;
    }

    private static class EventLoopNettyCustomizer implements NettyServerCustomizer {

        private final NettyTcpProperties nettyTcpProperties;
    
        /**
         * Instantiates a new Event loop netty customizer.
         *
         * @param nettyTcpProperties the netty tcp config
         */
        EventLoopNettyCustomizer(final NettyTcpProperties nettyTcpProperties) {
            this.nettyTcpProperties = nettyTcpProperties;
        }

        @Override
        public HttpServer apply(HttpServer httpServer) {
            // TODO moremind: optimize httpServer
            return httpServer.runOn(LoopResources.create("shenyu-netty", nettyTcpProperties.getSelectCount(), nettyTcpProperties.getWorkerCount(), true))
                    .option(ChannelOption.SO_BACKLOG, nettyTcpProperties.getServerSocketChannel().getSoBacklog())
                    .option(ChannelOption.SO_REUSEADDR, nettyTcpProperties.getServerSocketChannel().isSoReuseAddr())
                    .option(ChannelOption.SO_RCVBUF, nettyTcpProperties.getServerSocketChannel().getSoRcvBuf())
                    .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, nettyTcpProperties.getServerSocketChannel().getConnectTimeoutMillis())
                    .option(ChannelOption.WRITE_BUFFER_WATER_MARK, new WriteBufferWaterMark(nettyTcpProperties.getServerSocketChannel().getWriteBufferLowWaterMark(),
                            nettyTcpProperties.getServerSocketChannel().getWriteBufferHighWaterMark()))
                    .option(ChannelOption.WRITE_SPIN_COUNT, nettyTcpProperties.getServerSocketChannel().getWriteSpinCount())
                    .childOption(ChannelOption.AUTO_READ, false)
                    .option(ChannelOption.ALLOCATOR, nettyTcpProperties.getServerSocketChannel().getAllocator());
        }
    }
}
