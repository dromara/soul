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

package org.apache.shenyu.plugin.tars.subscriber;

import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;

/**
 * Test case for {@link TarsMetaDataSubscriber}.
 */
@RunWith(MockitoJUnitRunner.class)
public class TarsMetaDataSubscriberTest {

    private TarsMetaDataSubscriber tarsMetaDataSubscriber;

    private MetaData metaData;

    @Before
    public void setUp() {
        metaData = new MetaData("id", "127.0.0.1:8080", "contextPath",
                "path", RpcTypeEnum.TARS.getName(), "serviceName", "method1",
                "parameterTypes", "{\"methodInfo\":[{\"methodName\":\"method1\",\"params\":[{\"left\":\"int\",\"right\":\"param1\"},"
                + "{\"left\":\"java.lang.Integer\",\"right\":\"param2\"}],\"returnType\":\"java.lang.String\"}]}", false, true);
        tarsMetaDataSubscriber = new TarsMetaDataSubscriber();
    }

    @Test
    public void testOnSubscribe() {
        tarsMetaDataSubscriber.onSubscribe(metaData);
        // test for cache;
        tarsMetaDataSubscriber.onSubscribe(metaData);
    }

    @Test
    public void testUnSubscribe() {
        tarsMetaDataSubscriber.unSubscribe(metaData);
    }
}
