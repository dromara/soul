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

package org.apache.shenyu.e2e.testcase.logging.rocketmq;

import com.google.common.collect.Lists;
import org.apache.shenyu.e2e.client.WaitDataSync;
import org.apache.shenyu.e2e.client.admin.AdminClient;
import org.apache.shenyu.e2e.client.gateway.GatewayClient;
import org.apache.shenyu.e2e.constant.Constants;
import org.apache.shenyu.e2e.engine.annotation.ShenYuScenario;
import org.apache.shenyu.e2e.engine.annotation.ShenYuTest;
import org.apache.shenyu.e2e.engine.scenario.specification.AfterEachSpec;
import org.apache.shenyu.e2e.engine.scenario.specification.BeforeEachSpec;
import org.apache.shenyu.e2e.engine.scenario.specification.CaseSpec;
import org.apache.shenyu.e2e.enums.ServiceTypeEnum;
import org.apache.shenyu.e2e.model.ResourcesData;
import org.apache.shenyu.e2e.model.data.BindingData;
import org.apache.shenyu.e2e.model.response.SelectorDTO;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import static org.apache.shenyu.e2e.constant.Constants.SYS_DEFAULT_NAMESPACE_NAMESPACE_ID;

@ShenYuTest(environments = {
        @ShenYuTest.Environment(
                serviceName = "shenyu-e2e-admin",
                service = @ShenYuTest.ServiceConfigure(moduleName = "shenyu-e2e",
                        baseUrl = "http://localhost:31095",
                        type = ServiceTypeEnum.SHENYU_ADMIN,
                        parameters = {
                                @ShenYuTest.Parameter(key = "username", value = "admin"),
                                @ShenYuTest.Parameter(key = "password", value = "123456")
                        }
                )
        ),
        @ShenYuTest.Environment(
                serviceName = "shenyu-e2e-gateway",
                service = @ShenYuTest.ServiceConfigure(moduleName = "shenyu-e2e",
                        baseUrl = "http://localhost:31195",
                        type = ServiceTypeEnum.SHENYU_GATEWAY
                )
        )
})
public class DividePluginTest {

    private static final Logger LOG = LoggerFactory.getLogger(DividePluginTest.class);

    private List<String> selectorIds = Lists.newArrayList();

    @BeforeEach
    void before(final AdminClient client, final GatewayClient gateway, final BeforeEachSpec spec) {
        spec.getChecker().check(gateway);

        ResourcesData resources = spec.getResources();
        for (ResourcesData.Resource res : resources.getResources()) {
            SelectorDTO dto = client.create(res.getSelector());
            selectorIds.add(dto.getId());
            res.getRules().forEach(rule -> {
                rule.setSelectorId(dto.getId());
                client.create(rule);
            });
            BindingData bindingData = res.getBindingData();
            if (Objects.nonNull(bindingData)) {
                bindingData.setSelectorId(dto.getId());
                bindingData.setNamespaceId(SYS_DEFAULT_NAMESPACE_NAMESPACE_ID);
                client.bindingData(bindingData);
            }
        }

        spec.getWaiting().waitFor(gateway);
    }

    @AfterEach
    void after(final AdminClient client, final GatewayClient gateway, final AfterEachSpec spec) {
        spec.getDeleter().delete(client, selectorIds);
        spec.deleteWaiting().waitFor(gateway);
        selectorIds = Lists.newArrayList();
    }

    @BeforeAll
    void setup(final AdminClient adminClient, final GatewayClient gatewayClient) throws Exception {
        adminClient.login();
        
        WaitDataSync.waitAdmin2GatewayDataSyncEquals(adminClient::listAllSelectors, gatewayClient::getSelectorCache, adminClient);
        WaitDataSync.waitAdmin2GatewayDataSyncEquals(adminClient::listAllMetaData, gatewayClient::getMetaDataCache, adminClient);
        WaitDataSync.waitAdmin2GatewayDataSyncEquals(adminClient::listAllRules, gatewayClient::getRuleCache, adminClient);
        
        LOG.info("start loggingRocketMQ plugin");
        Map<String, String> reqBody = new HashMap<>();
        reqBody.put("pluginId", "29");
        reqBody.put("name", "loggingRocketMQ");
        reqBody.put("enabled", "true");
        reqBody.put("role", "Logging");
        reqBody.put("sort", "170");
        reqBody.put("namespaceId", Constants.SYS_DEFAULT_NAMESPACE_NAMESPACE_ID);
        reqBody.put("config", "{\"topic\":\"shenyu-access-logging\", \"namesrvAddr\": \"rocketmq-dialevoneid:9876\",\"producerGroup\":\"shenyu-plugin-logging-rocketmq\"}");
        adminClient.changePluginStatus("1801816010882822166", reqBody);
        Map<String, Integer> plugins = gatewayClient.getPlugins();
        LOG.info("shenyu e2e plugin list ={}", plugins);
        WaitDataSync.waitGatewayPluginUse(gatewayClient, "org.apache.shenyu.plugin.logging.rocketmq.LoggingRocketMQPlugin");
        
    }

    @ShenYuScenario(provider = DividePluginCases.class)
    void testDivide(final GatewayClient gateway, final CaseSpec spec) {
        spec.getVerifiers().forEach(verifier -> verifier.verify(gateway.getHttpRequesterSupplier().get()));
    }
}
