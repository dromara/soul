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

package org.apache.shenyu.client.tars;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.shenyu.client.core.disruptor.ShenyuClientRegisterEventPublisher;
import org.apache.shenyu.client.tars.common.annotation.ShenyuTarsClient;
import org.apache.shenyu.client.tars.common.annotation.ShenyuTarsService;
import org.apache.shenyu.client.tars.common.dto.TarsRpcExt;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.IpUtils;
import org.apache.shenyu.register.client.api.ShenyuClientRegisterRepository;
import org.apache.shenyu.register.common.config.ShenyuRegisterCenterConfig;
import org.apache.shenyu.register.common.dto.MetaDataRegisterDTO;
import org.springframework.aop.support.AopUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.core.LocalVariableTableParameterNameDiscoverer;
import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * The Tars ServiceBean PostProcessor.
 */
public class TarsServiceBeanPostProcessor implements BeanPostProcessor {

    private final LocalVariableTableParameterNameDiscoverer localVariableTableParameterNameDiscoverer = new LocalVariableTableParameterNameDiscoverer();

    private ShenyuClientRegisterEventPublisher publisher = ShenyuClientRegisterEventPublisher.getInstance();

    private final ExecutorService executorService;

    private final String contextPath;

    private final String ipAndPort;

    private final String host;

    private final int port;

    public TarsServiceBeanPostProcessor(final ShenyuRegisterCenterConfig config, final ShenyuClientRegisterRepository shenyuClientRegisterRepository) {
        Properties props = config.getProps();
        String contextPath = props.getProperty("contextPath");
        String ip = props.getProperty("host");
        String port = props.getProperty("port");
        if (StringUtils.isEmpty(contextPath) || StringUtils.isEmpty(ip) || StringUtils.isEmpty(port)) {
            throw new RuntimeException("tars client must config the contextPath, ipAndPort");
        }
        this.contextPath = contextPath;
        this.ipAndPort = ip + ":" + port;
        this.host = props.getProperty("host");
        this.port = Integer.parseInt(port);
        executorService = Executors.newSingleThreadExecutor(new ThreadFactoryBuilder().setNameFormat("shenyu-tars-client-thread-pool-%d").build());
        publisher.start(shenyuClientRegisterRepository);
    }

    @Override
    public Object postProcessAfterInitialization(final Object bean, final String beanName) throws BeansException {
        if (bean.getClass().getAnnotation(ShenyuTarsService.class) != null) {
            executorService.execute(() -> handler(bean));
        }
        return bean;
    }

    private void handler(final Object serviceBean) {
        Class<?> clazz = serviceBean.getClass();
        if (AopUtils.isAopProxy(serviceBean)) {
            clazz = AopUtils.getTargetClass(serviceBean);
        }
        Method[] methods = ReflectionUtils.getUniqueDeclaredMethods(clazz);
        String serviceName = serviceBean.getClass().getAnnotation(ShenyuTarsService.class).serviceName();
        for (Method method : methods) {
            ShenyuTarsClient shenyuSofaClient = method.getAnnotation(ShenyuTarsClient.class);
            if (Objects.nonNull(shenyuSofaClient)) {
                publisher.publishEvent(buildMetaDataDTO(serviceName, shenyuSofaClient, method, buildRpcExt(methods)));
            }
        }
    }

    private MetaDataRegisterDTO buildMetaDataDTO(final String serviceName, final ShenyuTarsClient shenyuTarsClient, final Method method, final String rpcExt) {
        String ipAndPort = this.ipAndPort;
        String path = this.contextPath + shenyuTarsClient.path();
        String desc = shenyuTarsClient.desc();
        String host = IpUtils.isCompleteHost(this.host) ? this.host : IpUtils.getHost(this.host);
        String configRuleName = shenyuTarsClient.ruleName();
        String ruleName = ("".equals(configRuleName)) ? path : configRuleName;
        String methodName = method.getName();
        Class<?>[] parameterTypesClazz = method.getParameterTypes();
        String parameterTypes = Arrays.stream(parameterTypesClazz).map(Class::getName)
                .collect(Collectors.joining(","));
        return MetaDataRegisterDTO.builder()
                .appName(ipAndPort)
                .serviceName(serviceName)
                .methodName(methodName)
                .contextPath(this.contextPath)
                .path(path)
                .host(host)
                .port(port)
                .ruleName(ruleName)
                .pathDesc(desc)
                .parameterTypes(parameterTypes)
                .rpcType("tars")
                .rpcExt(rpcExt)
                .enabled(shenyuTarsClient.enabled())
                .wrap(shenyuTarsClient.wrap())
                .build();
    }

    private TarsRpcExt.RpcExt buildRpcExt(final Method method) {
        String[] paramNames = localVariableTableParameterNameDiscoverer.getParameterNames(method);
        List<Pair<String, String>> params = new ArrayList<>();
        if (paramNames != null && paramNames.length > 0) {
            Class<?>[] paramTypes = method.getParameterTypes();
            for (int i = 0; i < paramNames.length; i++) {
                params.add(Pair.of(paramTypes[i].getName(), paramNames[i]));
            }
        }
        return new TarsRpcExt.RpcExt(method.getName(), params, method.getReturnType().getName());
    }

    private String buildRpcExt(final Method[] methods) {
        List<TarsRpcExt.RpcExt> list = new ArrayList<>();
        for (Method method : methods) {
            ShenyuTarsClient shenyuSofaClient = method.getAnnotation(ShenyuTarsClient.class);
            if (Objects.nonNull(shenyuSofaClient)) {
                list.add(buildRpcExt(method));
            }
        }
        TarsRpcExt buildList = new TarsRpcExt(list);
        return GsonUtils.getInstance().toJson(buildList);
    }
}
