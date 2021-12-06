/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.shenyu.admin.aspect;

import org.apache.shenyu.common.exception.ShenyuException;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.junit.MockitoJUnitRunner;

import java.lang.reflect.Method;

import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Test cases for {@link DataPermissionAspect}.
 */
@RunWith(MockitoJUnitRunner.Silent.class)
public class DataPermissionAspectTest {

    @InjectMocks
    private DataPermissionAspect dataPermissionAspect;

    @Test
    public void testAround() {
        ProceedingJoinPoint point = mock(ProceedingJoinPoint.class);
        boolean thrown = false;
        try {
            dataPermissionAspect.around(point);
        } catch (ShenyuException e) {
            thrown = true;
        }
        assertTrue(thrown);

        MethodSignature signature = mock(MethodSignature.class);
        Method method = mock(Method.class);
        when(point.getSignature()).thenReturn(signature);
        when(signature.getMethod()).thenReturn(method);
        when(method.getAnnotation(any())).thenReturn(null);
        dataPermissionAspect.around(point);
        try {
            verify(point).proceed(null);
        } catch (Throwable t) {
            throw new ShenyuException(t);
        }
    }
}
