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

package org.apache.shenyu.plugin.tars;

import org.apache.shenyu.common.concurrent.ShenyuThreadFactory;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.api.context.ShenyuContext;
import org.apache.shenyu.plugin.api.result.DefaultShenyuResult;
import org.apache.shenyu.plugin.api.result.ShenyuResult;
import org.apache.shenyu.plugin.api.utils.SpringBeanUtils;
import org.apache.shenyu.plugin.tars.cache.ApplicationConfigCache;
import org.apache.shenyu.plugin.tars.proxy.TarsInvokePrxList;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Test case for {@link TarsPlugin}.
 */
@RunWith(MockitoJUnitRunner.Silent.class)
public class TarsPluginTest {

    @Mock
    private ShenyuPluginChain chain;

    private MetaData metaData;

    private ServerWebExchange exchange;

    private TarsPlugin tarsPluginUnderTest;

    @Before
    public void setUp() {
        ConfigurableApplicationContext applicationContext = mock(ConfigurableApplicationContext.class);
        when(applicationContext.getBean(ShenyuResult.class)).thenReturn(new DefaultShenyuResult());
        SpringBeanUtils springBeanUtils = SpringBeanUtils.getInstance();
        springBeanUtils.setApplicationContext(applicationContext);
        metaData = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path", RpcTypeEnum.TARS.getName(), "serviceName", "method1",
                "parameterTypes", "{\"methodInfo\":[{\"methodName\":\"method1\",\"params\":"
                + "[{\"left\":\"java.lang.String\",\"right\":\"param1\"},{\"left\":\"java.lang.String\","
                + "\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}", false, true);
        ApplicationConfigCache.getInstance().initPrx(metaData);
        exchange = MockServerWebExchange.from(MockServerHttpRequest.get("localhost").build());
        tarsPluginUnderTest = new TarsPlugin();
    }

    @Test
    public void testTarsPluginWithEmptyBody() {
        ShenyuContext context = mock(ShenyuContext.class);
        exchange.getAttributes().put(Constants.CONTEXT, context);
        exchange.getAttributes().put(Constants.META_DATA, metaData);
        when(chain.execute(exchange)).thenReturn(Mono.empty());
        RuleData data = mock(RuleData.class);
        SelectorData selectorData = mock(SelectorData.class);
        StepVerifier.create(tarsPluginUnderTest.doExecute(exchange, chain, selectorData, data)).expectSubscription().verifyComplete();
    }

    @Test
    public void testTarsPluginWithEmptyMetaData() {
        ShenyuContext context = mock(ShenyuContext.class);
        exchange.getAttributes().put(Constants.CONTEXT, context);
        metaData.setServiceName("");
        exchange.getAttributes().put(Constants.META_DATA, metaData);
        when(chain.execute(exchange)).thenReturn(Mono.empty());
        RuleData data = mock(RuleData.class);
        SelectorData selectorData = mock(SelectorData.class);
        StepVerifier.create(tarsPluginUnderTest.doExecute(exchange, chain, selectorData, data)).expectSubscription().verifyComplete();
    }

    @Test(expected = IllegalArgumentException.class)
    public void testTarsPluginWithArgumentTypeMissMatch() {
        ShenyuContext context = mock(ShenyuContext.class);
        exchange.getAttributes().put(Constants.CONTEXT, context);
        exchange.getAttributes().put(Constants.META_DATA, metaData);
        exchange.getAttributes().put(Constants.PARAM_TRANSFORM, "{\"param1\":1,\"param2\":2}");
        when(chain.execute(exchange)).thenReturn(Mono.empty());
        RuleData data = mock(RuleData.class);
        SelectorData selectorData = mock(SelectorData.class);
        StepVerifier.create(tarsPluginUnderTest.doExecute(exchange, chain, selectorData, data)).expectSubscription().verifyComplete();
    }

    @Test(expected = IllegalArgumentException.class)
    public void testTarsPluginNormal() throws InvocationTargetException, IllegalAccessException {
        ShenyuContext context = mock(ShenyuContext.class);
        exchange.getAttributes().put(Constants.CONTEXT, context);
        exchange.getAttributes().put(Constants.META_DATA, metaData);
        exchange.getAttributes().put(Constants.PARAM_TRANSFORM, "{\"param1\":\"1\",\"param2\":\"1\"}");
        when(chain.execute(exchange)).thenReturn(Mono.empty());
        RuleData data = mock(RuleData.class);
        SelectorData selectorData = mock(SelectorData.class);
        TarsInvokePrxList tarsInvokePrxList = ApplicationConfigCache.getInstance().get(metaData.getPath());
        Method method = mock(Method.class);
        ExecutorService executorService = Executors.newFixedThreadPool(1,
                ShenyuThreadFactory.create("long-polling", true));
        CompletableFuture<String> stringCompletableFuture = CompletableFuture.supplyAsync(() -> "", executorService);
        when(method.invoke(any(), any())).thenReturn(stringCompletableFuture);
        tarsInvokePrxList.setMethod(method);
        StepVerifier.create(tarsPluginUnderTest.doExecute(exchange, chain, selectorData, data)).expectSubscription().verifyComplete();
    }

    @Test
    public void testGetOrder() {
        int result = tarsPluginUnderTest.getOrder();
        assertEquals(PluginEnum.TARS.getCode(), result);
    }

    @Test
    public void testNamed() {
        String result = tarsPluginUnderTest.named();
        assertEquals(PluginEnum.TARS.getName(), result);
    }

    @Test
    public void testSkip() {
        ShenyuContext context = mock(ShenyuContext.class);
        when(context.getRpcType()).thenReturn(RpcTypeEnum.TARS.getName());
        exchange.getAttributes().put(Constants.CONTEXT, context);
        boolean result = tarsPluginUnderTest.skip(exchange);
        assertFalse(result);
    }
}
