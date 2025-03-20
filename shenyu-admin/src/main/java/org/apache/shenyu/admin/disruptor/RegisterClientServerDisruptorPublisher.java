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

package org.apache.shenyu.admin.disruptor;

import org.apache.shenyu.admin.disruptor.executor.RegisterServerConsumerExecutor.RegisterServerExecutorFactory;
import org.apache.shenyu.admin.disruptor.subscriber.ApiDocExecutorSubscriber;
import org.apache.shenyu.admin.disruptor.subscriber.DiscoveryConfigRegisterExecutorSubscriber;
import org.apache.shenyu.admin.disruptor.subscriber.InstanceInfoRegisterExecutorSubscriber;
import org.apache.shenyu.admin.disruptor.subscriber.MetadataExecutorSubscriber;
import org.apache.shenyu.admin.disruptor.subscriber.URIRegisterExecutorSubscriber;
import org.apache.shenyu.admin.register.ShenyuClientServerRegisterPublisher;
import org.apache.shenyu.admin.service.DiscoveryService;
import org.apache.shenyu.admin.service.InstanceInfoService;
import org.apache.shenyu.admin.service.register.ShenyuClientRegisterService;
import org.apache.shenyu.disruptor.DisruptorProviderManage;
import org.apache.shenyu.disruptor.provider.DisruptorProvider;
import org.apache.shenyu.register.common.type.DataTypeParent;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * The type Disruptor publisher.
 */
public class RegisterClientServerDisruptorPublisher implements ShenyuClientServerRegisterPublisher {
    
    private static final RegisterClientServerDisruptorPublisher INSTANCE = new RegisterClientServerDisruptorPublisher();
    
    private DisruptorProviderManage<Collection<DataTypeParent>> providerManage;
    
    /**
     * Gets instance.
     *
     * @return the instance
     */
    public static RegisterClientServerDisruptorPublisher getInstance() {
        return INSTANCE;
    }
    
    /**
     * start.
     *
     * @param shenyuClientRegisterService the shenyu client register service
     * @param discoveryService the discovery service
     * @param instanceInfoService the instance info service
     */
    public void start(final Map<String, ShenyuClientRegisterService> shenyuClientRegisterService, final DiscoveryService discoveryService, final InstanceInfoService instanceInfoService) {
        RegisterServerExecutorFactory factory = new RegisterServerExecutorFactory();
        factory.addSubscribers(new URIRegisterExecutorSubscriber(shenyuClientRegisterService));
        factory.addSubscribers(new MetadataExecutorSubscriber(shenyuClientRegisterService));
        factory.addSubscribers(new ApiDocExecutorSubscriber(shenyuClientRegisterService));
        factory.addSubscribers(new DiscoveryConfigRegisterExecutorSubscriber(discoveryService));
        factory.addSubscribers(new InstanceInfoRegisterExecutorSubscriber(instanceInfoService));
        providerManage = new DisruptorProviderManage<>(factory);
        providerManage.startup();
    }
    
    @Override
    public void publish(final DataTypeParent data) {
        DisruptorProvider<Collection<DataTypeParent>> provider = providerManage.getProvider();
        provider.onData(Collections.singleton(data));
    }
    
    @Override
    public void publish(final Collection<? extends DataTypeParent> dataList) {
        DisruptorProvider<Collection<DataTypeParent>> provider = providerManage.getProvider();
        provider.onData(dataList.stream().map(DataTypeParent.class::cast).collect(Collectors.toList()));
        
    }
    
    @Override
    public void close() {
        providerManage.getProvider().shutdown();
    }
}
