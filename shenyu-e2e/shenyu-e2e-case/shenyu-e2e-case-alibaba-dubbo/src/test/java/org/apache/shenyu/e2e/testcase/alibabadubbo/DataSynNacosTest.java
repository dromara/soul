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

package org.apache.shenyu.e2e.testcase.alibabadubbo;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.apache.shenyu.e2e.client.admin.AdminClient;
import org.apache.shenyu.e2e.client.gateway.GatewayClient;
import org.apache.shenyu.e2e.engine.annotation.ShenYuTest;
import org.apache.shenyu.e2e.engine.annotation.ShenYuTest.Parameter;
import org.apache.shenyu.e2e.engine.config.ShenYuEngineConfigure;
import org.apache.shenyu.e2e.model.data.MetaData;
import org.apache.shenyu.e2e.model.data.RuleCacheData;
import org.apache.shenyu.e2e.model.data.SelectorCacheData;
import org.apache.shenyu.e2e.model.response.MetaDataDTO;
import org.apache.shenyu.e2e.model.response.RuleDTO;
import org.apache.shenyu.e2e.model.response.SelectorDTO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.List;

/**
 * Testing the correctness of Nacos data synchronization method.
 */
@ShenYuTest(
        mode = ShenYuEngineConfigure.Mode.DOCKER,
        services = {
                @ShenYuTest.ServiceConfigure(
                        serviceName = "admin",
                        port = 9095,
                        baseUrl = "http://{hostname:localhost}:9095",
                        parameters = {
                                @Parameter(key = "username", value = "admin"),
                                @Parameter(key = "password", value = "123456"),
                                @Parameter(key = "dataSyn", value = "nacos")
                        }
                ),
                @ShenYuTest.ServiceConfigure(
                        serviceName = "gateway",
                        port = 9195,
                        baseUrl = "http://{hostname:localhost}:9195",
                        type = ShenYuEngineConfigure.ServiceType.SHENYU_GATEWAY,
                        parameters = {
                                @Parameter(key = "dataSyn", value = "nacos")
                        }
                )
        },
        dockerComposeFile = "classpath:./docker-compose.mysql.yml"
)
public class DataSynNacosTest {

    @Test
    void testDataSyn(final AdminClient adminClient, final GatewayClient gatewayClient) throws InterruptedException, JsonProcessingException {
        adminClient.login();
        Thread.sleep(30000);
        List<SelectorDTO> selectorDTOList = adminClient.listAllSelectors();
        List<SelectorCacheData> selectorCacheList = gatewayClient.getSelectorCache();
        Assertions.assertEquals(selectorDTOList.size(), selectorCacheList.size());
        List<MetaData> metaDataCacheList = gatewayClient.getMetaDataCache();
        List<MetaDataDTO> metaDataDTOList = adminClient.listAllMetaData();
        Assertions.assertEquals(metaDataDTOList.size(), metaDataCacheList.size());
        List<RuleCacheData> ruleCacheList = gatewayClient.getRuleCache();
        List<RuleDTO> ruleDTOList = adminClient.listAllRules();
        Assertions.assertEquals(ruleDTOList.size(), ruleCacheList.size());
    }
}
