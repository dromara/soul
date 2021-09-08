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

package org.apache.shenyu.common.dto;

import org.apache.commons.lang3.StringUtils;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;

/**
 * Test case for MetaData.
 */
public class MetaDataTest {

    private static final String CONTEXT_PATH = "/shenyu";

    private static final String PATH = CONTEXT_PATH + "/context/path";

    @Test
    public void testUpdateContextPath() {
        MetaData metaData = new MetaData("id", "appName", "contextPath", "path", "rpcType",
                "serviceName", "methodName", "parameterTypes", "rpcExt", true, true);
        metaData.setPath(PATH);
        metaData.updateContextPath();
        assertEquals(metaData.getContextPath(), CONTEXT_PATH);
    }

    /**
     * just improve code coverage.
     */
    @Test
    public void testGetterSetter() {
        MetaData metaData = MetaData.builder().id("id").appName("appName").contextPath("contextPath")
                .path(PATH).rpcType("rpcType").serviceName("serviceName").methodName("methodName")
                .parameterTypes("parameterTypes").rpcExt("rpcExt").enabled(true).build();
        metaData.setId("id");
        assertTrue(StringUtils.equals(metaData.getId(), "id"));
        metaData.setAppName("appName");
        assertTrue(StringUtils.equals(metaData.getAppName(), "appName"));
        metaData.setContextPath("contextPath");
        assertTrue(StringUtils.equals(metaData.getContextPath(), "contextPath"));
        metaData.setPath(PATH);
        assertTrue(StringUtils.equals(metaData.getPath(), PATH));
        metaData.setRpcType("rpcType");
        assertTrue(StringUtils.equals(metaData.getRpcType(), "rpcType"));
        metaData.setServiceName("serviceName");
        assertTrue(StringUtils.equals(metaData.getServiceName(), "serviceName"));
        metaData.setMethodName("methodName");
        assertTrue(StringUtils.equals(metaData.getMethodName(), "methodName"));
        metaData.setParameterTypes("parameterTypes");
        assertTrue(StringUtils.equals(metaData.getParameterTypes(), "parameterTypes"));
        metaData.setRpcExt("rpcExt");
        assertTrue(StringUtils.equals(metaData.getRpcExt(), "rpcExt"));
        metaData.setEnabled(true);
        assertEquals(metaData.getEnabled(), true);
        assertNotNull(metaData.toString());
    }

}
