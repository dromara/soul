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

package org.apache.shenyu.plugin.tars.util;

import org.apache.shenyu.common.dto.MetaData;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;

/**
 * Test case for {@link PrxInfoUtil}.
 */
@RunWith(MockitoJUnitRunner.class)
public class PrxInfoUtilTest {

    @Test
    public void testGetParamClass() throws Exception {
        assertEquals(int.class, PrxInfoUtil.getParamClass("int"));
        assertEquals(long.class, PrxInfoUtil.getParamClass("long"));
        assertEquals(short.class, PrxInfoUtil.getParamClass("short"));
        assertEquals(byte.class, PrxInfoUtil.getParamClass("byte"));
        assertEquals(boolean.class, PrxInfoUtil.getParamClass("boolean"));
        assertEquals(char.class, PrxInfoUtil.getParamClass("char"));
        assertEquals(float.class, PrxInfoUtil.getParamClass("float"));
        assertEquals(Integer.class, PrxInfoUtil.getParamClass("java.lang.Integer"));
    }

    @Test(expected = ClassNotFoundException.class)
    public void testGetParamClassThrowsClassNotFoundException() throws Exception {
        PrxInfoUtil.getParamClass("className");
    }

    @Test
    public void testGetPrxName() {
        final MetaData metaData = new MetaData("id", "appName", "contextPath", "/path",
                "rpcType", "serviceName", "methodName", "parameterTypes",
                "rpcExt", false, true);
        final String result = PrxInfoUtil.getPrxName(metaData);
        assertEquals("pathmethodNamePrx", result);
    }

    @Test
    public void testGetMethodName() {
        assertEquals("promise_methodName", PrxInfoUtil.getMethodName("methodName"));
    }

    @Test
    public void testGetObjectName() {
        final String result = PrxInfoUtil.getObjectName("127.0.0.1:8080", "serviceName");
        assertEquals("serviceName@tcp -h 127.0.0.1 -p 8080", result);
    }

    @Test
    public void testGetParamArray() {
        assertArrayEquals(new Object[]{11, Double.valueOf("1.321321312"), Long.valueOf("131231312"), Short.valueOf("11"), Byte.valueOf("0"), false, 'a', 1.321321312F},
                PrxInfoUtil.getParamArray(new Class<?>[]{int.class, double.class, long.class, short.class, byte.class, boolean.class, char.class, float.class},
                        new String[]{"int", "double", "long", "short", "byte", "boolean", "char", "float"},
                        "{\"int\":11,\"double\":1.321321312,\"long\":131231312,\"short\":11,\"byte\":0,\"boolean\":false,\"char\":'a',\"float\":1.321321312}"));
    }
}
