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

package org.apache.shenyu.client.sofa;

import com.alipay.sofa.runtime.service.component.Service;
import com.alipay.sofa.runtime.spring.factory.ServiceFactoryBean;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.client.core.disruptor.ShenyuClientRegisterEventPublisher;
import org.apache.shenyu.client.sofa.common.annotation.ShenyuSofaClient;
import org.apache.shenyu.client.sofa.common.dto.SofaRpcExt;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.IpUtils;
import org.apache.shenyu.register.client.api.ShenyuClientRegisterRepository;
import org.apache.shenyu.register.common.config.ShenyuRegisterCenterConfig;
import org.apache.shenyu.register.common.dto.MetaDataRegisterDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.support.AopUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * The Sofa ServiceBean PostProcessor.
 */
public class SofaServiceBeanPostProcessor implements BeanPostProcessor {

    private static final Logger LOG = LoggerFactory.getLogger(SofaServiceBeanPostProcessor.class);

    private ShenyuClientRegisterEventPublisher publisher = ShenyuClientRegisterEventPublisher.getInstance();

    private final ExecutorService executorService;

    private final String contextPath;

    private final String appName;

    private final String host;

    private final String port;

    public SofaServiceBeanPostProcessor(final ShenyuRegisterCenterConfig config, final ShenyuClientRegisterRepository shenyuClientRegisterRepository) {
        Properties props = config.getProps();
        String contextPath = props.getProperty("contextPath");
        String appName = props.getProperty("appName");
        if (StringUtils.isEmpty(contextPath)) {
            throw new RuntimeException("sofa client must config the contextPath");
        }
        this.contextPath = contextPath;
        this.appName = appName;
        this.host = props.getProperty("host");
        this.port = props.getProperty("port");
        executorService = Executors.newSingleThreadExecutor(new ThreadFactoryBuilder().setNameFormat("shenyu-sofa-client-thread-pool-%d").build());
        publisher.start(shenyuClientRegisterRepository);
    }

    @Override
    public Object postProcessAfterInitialization(final Object bean, final String beanName) throws BeansException {
        if (bean instanceof ServiceFactoryBean) {
            executorService.execute(() -> handler((ServiceFactoryBean) bean));
        }
        return bean;
    }

    private void handler(final ServiceFactoryBean serviceBean) {
        Class<?> clazz;
        Object targetProxy;
        try {
            targetProxy = ((Service) Objects.requireNonNull(serviceBean.getObject())).getTarget();
            clazz = targetProxy.getClass();
        } catch (Exception e) {
            LOG.error("failed to get sofa target class", e);
            return;
        }
        if (AopUtils.isAopProxy(targetProxy)) {
            clazz = AopUtils.getTargetClass(targetProxy);
        }
        Method[] methods = ReflectionUtils.getUniqueDeclaredMethods(clazz);
        for (Method method : methods) {
            ShenyuSofaClient shenyuSofaClient = method.getAnnotation(ShenyuSofaClient.class);
            if (Objects.nonNull(shenyuSofaClient)) {
                publisher.publishEvent(buildMetaDataDTO(serviceBean, shenyuSofaClient, method));
            }
        }
    }

    private MetaDataRegisterDTO buildMetaDataDTO(final ServiceFactoryBean serviceBean, final ShenyuSofaClient shenyuSofaClient, final Method method) {
        String appName = this.appName;
        String path = contextPath + shenyuSofaClient.path();
        String desc = shenyuSofaClient.desc();
        String serviceName = serviceBean.getInterfaceClass().getName();
        String host = IpUtils.isCompleteHost(this.host) ? this.host : IpUtils.getHost(this.host);
        int port = StringUtils.isBlank(this.port) ? -1 : Integer.parseInt(this.port);
        String configRuleName = shenyuSofaClient.ruleName();
        String ruleName = ("".equals(configRuleName)) ? path : configRuleName;
        String methodName = method.getName();
        Class<?>[] parameterTypesClazz = method.getParameterTypes();
        String parameterTypes = Arrays.stream(parameterTypesClazz).map(Class::getName)
                .collect(Collectors.joining(","));
        return MetaDataRegisterDTO.builder()
                .appName(appName)
                .serviceName(serviceName)
                .methodName(methodName)
                .contextPath(contextPath)
                .host(host)
                .port(port)
                .path(path)
                .ruleName(ruleName)
                .pathDesc(desc)
                .parameterTypes(parameterTypes)
                .rpcType("sofa")
                .rpcExt(buildRpcExt(shenyuSofaClient))
                .enabled(shenyuSofaClient.enabled())
                .wrap(shenyuSofaClient.wrap())
                .build();
    }

    private String buildRpcExt(final ShenyuSofaClient shenyuSofaClient) {
        SofaRpcExt build = SofaRpcExt.builder()
                .loadbalance(shenyuSofaClient.loadBalance())
                .retries(shenyuSofaClient.retries())
                .timeout(shenyuSofaClient.timeout())
                .build();
        return GsonUtils.getInstance().toJson(build);
    }
}
