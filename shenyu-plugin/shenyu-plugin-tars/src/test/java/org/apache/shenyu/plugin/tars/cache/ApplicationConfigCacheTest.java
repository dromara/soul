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

package org.apache.shenyu.plugin.tars.cache;

import com.qq.tars.protocol.annotation.Servant;
import org.assertj.core.util.Lists;
import org.apache.shenyu.common.concurrent.ShenyuThreadFactory;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.plugin.tars.proxy.TarsInvokePrxList;
import org.apache.shenyu.plugin.tars.util.PrxInfoUtil;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

/**
 * Test case for {@link ApplicationConfigCache}.
 */
@RunWith(MockitoJUnitRunner.class)
public final class ApplicationConfigCacheTest {

    private ApplicationConfigCache applicationConfigCacheUnderTest;

    @Before
    public void setUp() {
        applicationConfigCacheUnderTest = ApplicationConfigCache.getInstance();
    }

    @Test(expected = NullPointerException.class)
    public void testGet() throws ClassNotFoundException {
        final String rpcExt = "{\"methodInfo\":[{\"methodName\":\"method1\",\"params\":"
                + "[{\"left\":\"int\",\"right\":\"param1\"},{\"left\":\"java.lang.Integer\","
                + "\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}";

        final MetaData metaData = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path5", RpcTypeEnum.TARS.getName(), "serviceName5", "method1",
                "parameterTypes", rpcExt, false, true);
        applicationConfigCacheUnderTest.initPrx(metaData);
        final TarsInvokePrxList result = applicationConfigCacheUnderTest.get("path5");
        assertNotNull(result);
        assertEquals("promise_method1", result.getMethod().getName());
        assertEquals(2, result.getParamTypes().length);
        assertEquals(2, result.getParamNames().length);
        Class<?> prxClazz = Class.forName(PrxInfoUtil.getPrxName(metaData));
        assertTrue(Arrays.stream(prxClazz.getAnnotations()).anyMatch(annotation -> annotation instanceof Servant));
    }

    @Test(expected = NullPointerException.class)
    public void testConcurrentInitPrx() throws InterruptedException {
        final String rpcExt1 = "{\"methodInfo\":[{\"methodName\":\"method1\",\"params\":"
                + "[{\"left\":\"int\",\"right\":\"param1\"},{\"left\":\"java.lang.Integer\","
                + "\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}";
        final String rpcExt2 = "{\"methodInfo\":[{\"methodName\":\"method2\",\"params\":"
                + "[{\"left\":\"int\",\"right\":\"param1\"},{\"left\":\"java.lang.Integer\","
                + "\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}";
        final String rpcExt3 = "{\"methodInfo\":[{\"methodName\":\"method3\",\"params\":"
                + "[{\"left\":\"int\",\"right\":\"param1\"},{\"left\":\"java.lang.Integer\","
                + "\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}";
        final String rpcExt4 = "{\"methodInfo\":[{\"methodName\":\"method4\",\"params\":"
                + "[{\"left\":\"int\",\"right\":\"param1\"},{\"left\":\"java.lang.Integer\","
                + "\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}";

        final MetaData metaData1 = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path1", RpcTypeEnum.TARS.getName(), "serviceName1", "method1",
                "parameterTypes", rpcExt1, false, true);
        final MetaData metaData2 = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path2", RpcTypeEnum.TARS.getName(), "serviceName2", "method2",
                "parameterTypes", rpcExt2, false, true);
        final MetaData metaData3 = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path3", RpcTypeEnum.TARS.getName(), "serviceName3", "method3",
                "parameterTypes", rpcExt3, false, true);
        final MetaData metaData4 = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path4", RpcTypeEnum.TARS.getName(), "serviceName4", "method4",
                "parameterTypes", rpcExt4, false, true);
        List<MetaData> metaDataList = Lists.list(metaData1, metaData2, metaData3, metaData4);
        ExecutorService executorService = Executors.newFixedThreadPool(4,
                ShenyuThreadFactory.create("ApplicationConfigCache-tars-initPrx", false));
        CountDownLatch countDownLatch = new CountDownLatch(4);
        metaDataList.forEach(metaData -> executorService.execute(() -> {
            applicationConfigCacheUnderTest.initPrx(metaData);
            countDownLatch.countDown();
        }));
        countDownLatch.await();
        assertEquals("promise_method1", applicationConfigCacheUnderTest.get("path1").getMethod().getName());
        assertEquals("promise_method2", applicationConfigCacheUnderTest.get("path2").getMethod().getName());
        assertEquals("promise_method3", applicationConfigCacheUnderTest.get("path3").getMethod().getName());
        assertEquals("promise_method4", applicationConfigCacheUnderTest.get("path4").getMethod().getName());
    }

    @Test(expected = NullPointerException.class)
    public void testInitPrx() {
        final MetaData metaData = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path6", RpcTypeEnum.TARS.getName(), "serviceName6", "method1",
                "parameterTypes", "{\"methodInfo\":[{\"methodName\":\"method1\",\"params\":[{\"left\":\"int\",\"right\":\"param1\"},"
                + "{\"left\":\"java.lang.Integer\",\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}", false, true);
        applicationConfigCacheUnderTest.initPrx(metaData);
        final TarsInvokePrxList result = applicationConfigCacheUnderTest.get("path6");
        assertEquals("promise_method1", result.getMethod().getName());
    }

    @Test
    public void testGetClassMethodKey() {
        assertEquals("className_methodName", ApplicationConfigCache.getClassMethodKey("className", "methodName"));
    }

    @Test
    public void testGetInstance() {
        final ApplicationConfigCache result = ApplicationConfigCache.getInstance();
        assertNotNull(result);
    }
}
