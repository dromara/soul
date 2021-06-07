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

package org.apache.shenyu.plugin.grpc.loadbalance.picker;

import io.grpc.Status;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
public class EmptyPickerTest {

    @Test
    public void testPickSubchannel() {
        Status status = mock(Status.class);
        when(status.isOk()).thenReturn(true);
        EmptyPicker picker = new EmptyPicker(status);
        Assert.assertNotNull(picker.pickSubchannel(null));
    }

    @Test
    public void testIsEquivalentTo() {
        EmptyPicker picker = new EmptyPicker(mock(Status.class));
        Assert.assertTrue(picker.isEquivalentTo(picker));
    }

    @Test
    public void testGetSubchannelsInfo() {
        EmptyPicker picker = new EmptyPicker(mock(Status.class));
        Assert.assertNotNull(picker.getSubchannelsInfo());
    }
}
