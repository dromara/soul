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

package org.apache.shenyu.plugin.apache.dubbo.proxy;

import com.google.common.cache.LoadingCache;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.dubbo.config.ReferenceConfig;
import org.apache.dubbo.rpc.service.GenericService;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.plugin.apache.dubbo.cache.ApacheDubboConfigCache;
import org.apache.shenyu.plugin.dubbo.common.param.DubboParamResolveService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.web.server.ServerWebExchange;

import java.lang.reflect.Field;
import java.util.concurrent.CompletableFuture;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * The Test Case For ApacheDubboProxyService.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public final class ApacheDubboProxyServiceTest {
    private static final String PATH = "/duubo/findAll";

    private static final String METHOD_NAME = "findAll";

    private static final String[] LEFT = new String[]{};

    private static final Object[] RIGHT = new Object[]{};

    private MetaData metaData;

    private SelectorData selectorData;

    private RuleData ruleData;

    private ServerWebExchange exchange;

    @Mock
    private ReferenceConfig<GenericService> referenceConfig;

    @BeforeEach
    public void setup() {
        exchange = MockServerWebExchange.from(MockServerHttpRequest.get("localhost").build());
        metaData = new MetaData();
        metaData.setId("1332017966661636096");
        metaData.setAppName("dubbo");
        metaData.setPath(PATH);
        metaData.setServiceName("org.apache.shenyu.test.dubbo.api.service.DubboTestService");
        metaData.setMethodName(METHOD_NAME);
        metaData.setRpcType(RpcTypeEnum.DUBBO.getName());
        selectorData = new SelectorData();
        selectorData.setId("1895390769043820544");
        selectorData.setPluginId("6");
        selectorData.setHandle("[]");
        ruleData = new RuleData();
        ruleData.setId("1895390769224175616");
        ruleData.setHandle("{}");
    }

    @AfterEach
    public void after() {
        ApacheDubboConfigCache.getInstance().invalidateAll();
    }

    @Test
    @SuppressWarnings(value = "unchecked")
    public void genericInvokerTest() throws IllegalAccessException, NoSuchFieldException {
        GenericService genericService = mock(GenericService.class);
        when(referenceConfig.get()).thenReturn(genericService);
        when(referenceConfig.getInterface()).thenReturn(PATH);
        CompletableFuture<Object> future = new CompletableFuture<>();
        when(genericService.$invoke(METHOD_NAME, LEFT, RIGHT)).thenReturn(future);
        ApacheDubboConfigCache apacheDubboConfigCache = ApacheDubboConfigCache.getInstance();
        Field field = ApacheDubboConfigCache.class.getDeclaredField("cache");
        field.setAccessible(true);
        ((LoadingCache<String, ReferenceConfig<GenericService>>) field.get(apacheDubboConfigCache)).put(PATH, referenceConfig);
        ApacheDubboProxyService apacheDubboProxyService = new ApacheDubboProxyService(new BodyParamResolveServiceImpl());
        apacheDubboProxyService.genericInvoker("", metaData, selectorData, ruleData, exchange);
        future.complete("success");
    }

    static class BodyParamResolveServiceImpl implements DubboParamResolveService {

        @Override
        public Pair<String[], Object[]> buildParameter(final String body, final String parameterTypes) {
            return new ImmutablePair<>(LEFT, RIGHT);
        }
    }
}
