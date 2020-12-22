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

package org.dromara.soul.client.apache.dubbo.validation;

import org.apache.dubbo.common.URL;
import org.apache.dubbo.validation.Validator;
import org.dromara.soul.client.apache.dubbo.validation.mock.MockValidationParameter;
import org.dromara.soul.client.apache.dubbo.validation.service.TestService;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import javax.validation.ValidationException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

/**
 * ApacheDubboClientValidatorTest.
 *
 * @author KevinClair
 */
public final class ApacheDubboClientValidatorTest {

    private static final String MOCK_SERVICE_URL = "mock://localhost:28000/org.dromara.soul.client.apache.dubbo.validation.mock.MockValidatorTarget";

    private ApacheDubboClientValidator apacheDubboClientValidatorUnderTest;

    /**
     * test method {@link ApacheDubboClientValidator#validate(java.lang.String, java.lang.Class[], java.lang.Object[])}.
     */
    @Test
    public void validate() {
        URL url = URL.valueOf("dubbo://127.0.0.1:20880/org.dromara.soul"
                + ".client.apache.dubbo.validation.service.TestService"
                + "?accepts=500&anyhost=true&application=soul-proxy"
                + "&bind.ip=127.0.0.1&bind.port=20880&deprecated=false"
                + "&dubbo=2.0.2&dynamic=true&generic=false"
                + "&interface=org.dromara.soul.client.apache.dubbo.validation.service.TestService"
                + "&keep.alive=true&methods=test&pid=67352&qos.enable=false&release=2.7.0"
                + "&side=provider&threadpool=fixed&threads=500&timeout=20000"
                + "&timestamp=1608119259859&validation=soulValidation");
        Validator apacheDubboClientValidator = new ApacheDubboClientValidation().getValidator(url);
        try {
            apacheDubboClientValidator.validate("test",
                    new Class[]{TestService.TestObject.class},
                    new Object[]{TestService.TestObject.builder().age(null).build()});
        } catch (Exception e) {
            assertEquals("age cannot be null.", e.getMessage());
        }
    }

    @Before
    public void setUp() {
        URL url = URL.valueOf(MOCK_SERVICE_URL);
        apacheDubboClientValidatorUnderTest = new ApacheDubboClientValidator(url);
    }

    @Test(expected = NoSuchMethodException.class)
    public void testValidateWithNonExistMethod() throws Exception {
        apacheDubboClientValidatorUnderTest
                .validate("nonExistingMethod", new Class<?>[]{String.class}, new Object[]{"arg1"});
    }

    @Test
    public void testValidateWithExistMethod() throws Exception {
        final URL url = URL.valueOf(MOCK_SERVICE_URL + "?soulValidation=org.hibernate.validator.HibernateValidator");
        ApacheDubboClientValidator apacheDubboClientValidator = new ApacheDubboClientValidator(url);
        apacheDubboClientValidator
                .validate("method1", new Class<?>[]{String.class}, new Object[]{"anything"});
        apacheDubboClientValidator
                .validate("method1", new Class<?>[]{String.class}, new Object[]{"anything"});
    }

    @Test
    public void testValidateWhenMeetsConstraintThenValidationFailed() {
        try {
            apacheDubboClientValidatorUnderTest
                    .validate("method2", new Class<?>[]{MockValidationParameter.class}, new Object[]{new MockValidationParameter("NotBeNull")});
        } catch (Exception e) {
            Assert.assertTrue(e instanceof ValidationException);
        }
    }

    @Test
    public void testValidateWithArrayArg() throws Exception {
        apacheDubboClientValidatorUnderTest
                .validate("method3", new Class<?>[]{MockValidationParameter[].class}, new Object[]{new MockValidationParameter[]{new MockValidationParameter("parameter")}});
    }

    @Test
    public void testItWithCollectionArg() throws Exception {
        apacheDubboClientValidatorUnderTest
                .validate("method4", new Class<?>[]{List.class}, new Object[]{Collections.singletonList("parameter")});
    }

    @Test
    public void testItWithMapArg() throws Exception {
        final Map<String, String> map = new HashMap<>();
        map.put("key", "value");
        apacheDubboClientValidatorUnderTest.validate("method5", new Class<?>[]{Map.class}, new Object[]{map});
    }
}
