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

package org.apache.shenyu.plugin.sign.provider;

import com.google.common.collect.ImmutableMap;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.plugin.sign.api.SignParameters;
import org.junit.jupiter.api.Test;

import java.net.URI;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

public class DefaultSignProviderTest {

    private final DefaultSignProvider signProvider = new DefaultSignProvider();

    @Test
    void testGenerateSign() {
        SignParameters signParameters = new SignParameters("108C27175A2C43C1BC29B1E483D57E3D",
                "1673093719090", "C25A751BBCE25392DF61B352A2440FF9",
                URI.create("http://localhost:9195/http/test/path/456?name=Lee&data=3"));
        String actual = signProvider.generateSign("061521A73DD94A3FA873C25D050685BB", signParameters);

        assertThat(actual, is("C25A751BBCE25392DF61B352A2440FF9"));
    }

    @Test
    void testGenerateSignWithBody() {

        SignParameters signParameters = new SignParameters("108C27175A2C43C1BC29B1E483D57E3D",
                "1673096293857", "038AA4A8C09C01885054708BA6226E67",
                URI.create("http://localhost:9195/http/test/payment?userName=Lee&userId=3"));
        ImmutableMap<String, String> requestBody = ImmutableMap.of("userName", "Lee", "userId", "3");
        String actual = signProvider.generateSign("061521A73DD94A3FA873C25D050685BB", signParameters, JsonUtils.toJson(requestBody));
        assertThat(actual, is("038AA4A8C09C01885054708BA6226E67"));
    }
}
