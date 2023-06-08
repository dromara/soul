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

package org.apache.shenyu.springboot.stater.sync.data.polaris;

import org.apache.shenyu.springboot.starter.sync.data.polaris.PolarisSyncDataConfiguration;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.mockito.Answers.CALLS_REAL_METHODS;

/**
 * The test case for {@link PolarisSyncDataConfigurationTest}.
 */
@ExtendWith(SpringExtension.class)
@SpringBootTest(
        classes = PolarisSyncDataConfiguration.class,
        properties = {
                "shenyu.sync.polaris.address=grpc://127.0.0.1:8093",
                "shenyu.sync.polaris.namespace=default"
        })
@EnableAutoConfiguration
@MockBean(name = "polarisConfigService", value = PolarisMockConfigService.class, answer = CALLS_REAL_METHODS)
public final class PolarisSyncDataConfigurationTest {
}
