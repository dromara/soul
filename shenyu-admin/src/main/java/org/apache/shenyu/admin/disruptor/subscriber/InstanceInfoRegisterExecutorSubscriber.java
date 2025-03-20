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

package org.apache.shenyu.admin.disruptor.subscriber;

import org.apache.shenyu.admin.service.InstanceInfoService;
import org.apache.shenyu.common.concurrent.ShenyuThreadFactory;
import org.apache.shenyu.register.common.dto.InstanceInfoRegisterDTO;
import org.apache.shenyu.register.common.subsriber.ExecutorTypeSubscriber;
import org.apache.shenyu.register.common.type.DataType;

import java.util.Collection;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class InstanceInfoRegisterExecutorSubscriber implements ExecutorTypeSubscriber<InstanceInfoRegisterDTO> {

    private final InstanceInfoService instanceInfoService;

    private final ScheduledExecutorService executorService;

    /**
     * Instantiates a new Instance info register executor subscriber.
     *
     * @param instanceInfoService the instance info service
     */
    public InstanceInfoRegisterExecutorSubscriber(final InstanceInfoService instanceInfoService) {
        this.instanceInfoService = instanceInfoService;
        executorService = new ScheduledThreadPoolExecutor(10, ShenyuThreadFactory.create("scheduled-eureka-watcher", true));
    }

    @Override
    public void executor(final Collection<InstanceInfoRegisterDTO> instanceInfoRegisterDTOS) {
        executorService.schedule(() -> instanceInfoRegisterDTOS.forEach(instanceInfoService::registerInstanceInfo), 2, TimeUnit.SECONDS);
    }

    @Override
    public DataType getType() {
        return DataType.INSTANCE_INFO;
    }

}
