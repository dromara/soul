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

package org.apache.shenyu.e2e.testcase.logging.kafka;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Lists;
import io.restassured.http.Method;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.shenyu.e2e.engine.scenario.ShenYuScenarioProvider;
import org.apache.shenyu.e2e.engine.scenario.specification.ScenarioSpec;
import org.apache.shenyu.e2e.engine.scenario.specification.ShenYuBeforeEachSpec;
import org.apache.shenyu.e2e.engine.scenario.specification.ShenYuCaseSpec;
import org.apache.shenyu.e2e.engine.scenario.specification.ShenYuScenarioSpec;
import org.apache.shenyu.e2e.model.MatchMode;
import org.apache.shenyu.e2e.model.Plugin;
import org.apache.shenyu.e2e.model.data.Condition;
import org.junit.jupiter.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.apache.shenyu.e2e.engine.scenario.function.HttpCheckers.exists;
import static org.apache.shenyu.e2e.template.ResourceDataTemplate.newConditions;
import static org.apache.shenyu.e2e.template.ResourceDataTemplate.newRuleBuilder;
import static org.apache.shenyu.e2e.template.ResourceDataTemplate.newSelectorBuilder;

public class DividePluginCases implements ShenYuScenarioProvider {

    private static final String TOPIC = "shenyu-access-logging";

    private static final String TEST = "/http/order/findById?id=123";
    
    private static final ObjectMapper MAPPER = new ObjectMapper();

    private static final Logger LOG = LoggerFactory.getLogger(DividePluginCases.class);

    @Override
    public List<ScenarioSpec> get() {
        return Lists.newArrayList(
                testDivideHello(),
                testKafkaHello()
        );
    }

    private ShenYuScenarioSpec testDivideHello() {
        return ShenYuScenarioSpec.builder()
                .name("http client hello1")
                .beforeEachSpec(ShenYuBeforeEachSpec.builder()
                        .checker(exists(TEST))
                        .build())
                .caseSpec(ShenYuCaseSpec.builder()
                        .addExists(TEST)
                        .build())
                .build();
    }

    private ShenYuScenarioSpec testKafkaHello() {
        return ShenYuScenarioSpec.builder()
                .name("testKafkaHello")
                .beforeEachSpec(
                        ShenYuBeforeEachSpec.builder()
                                .addSelectorAndRule(
                                        newSelectorBuilder("selector", Plugin.LOGGING_KAFKA)
                                                .name("2")
                                                .matchMode(MatchMode.OR)
                                                .conditionList(newConditions(Condition.ParamType.URI, Condition.Operator.STARTS_WITH, "/http"))
                                                .build(),
                                        newRuleBuilder("rule")
                                                .name("2")
                                                .matchMode(MatchMode.OR)
                                                .conditionList(newConditions(Condition.ParamType.URI, Condition.Operator.STARTS_WITH, "/http"))
                                                .build()
                                )
                                .checker(exists(TEST))
                                .build()
                )
                .caseSpec(
                        ShenYuCaseSpec.builder()
                                .add(request -> {
                                    AtomicBoolean isLog = new AtomicBoolean(false);
                                    try {
                                        // Send request first
                                        request.request(Method.GET, "/http/order/findById?id=23");
                                        
                                        Properties properties = new Properties();
                                        properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
                                        properties.put(ConsumerConfig.GROUP_ID_CONFIG, "shenyu-consumer-group");
                                        properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
                                        properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
                                        // 启用自动提交
                                        properties.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "true");
                                        // 自动提交间隔
                                        properties.put(ConsumerConfig.AUTO_COMMIT_INTERVAL_MS_CONFIG, "1000");
                                        
                                        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties)) {
                                            consumer.subscribe(Arrays.asList(TOPIC));
                                            
                                            // Set a reasonable timeout period, e.g. 30 seconds
                                            Instant start = Instant.now();
                                            while (Duration.between(start, Instant.now()).getSeconds() < 60) {
                                                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
                                                LOG.info("records.count:{}", records.count());
                                                
                                                for (var record : records) {
                                                    String message = record.value();
                                                    LOG.info("kafka message:{}", message);
                                                    if (message.contains("/http/order/findById")) {
                                                        isLog.set(true);
                                                        
                                                        // 如果使用手动提交，在处理完消息后提交
                                                        // consumer.commitSync();  // 同步提交
                                                        // 或者
                                                        // consumer.commitAsync(); // 异步提交
                                                        
                                                        return;
                                                    }
                                                }
                                                
                                                // 也可以在每次轮询后批量提交
                                                // if (!records.isEmpty() && !properties.getProperty(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "true").equals("true")) {
                                                //     consumer.commitSync();  // 或 consumer.commitAsync();
                                                // }
                                            }
                                            // If expected message not found within timeout period
                                            LOG.error("Timeout waiting for kafka message");
                                            Assertions.fail("Did not receive expected message within timeout period");
                                        }
                                    } catch (Exception e) {
                                        LOG.error("Error during kafka message consumption", e);
                                        throw new RuntimeException("Failed to consume kafka message", e);
                                    }
                                }).build()
                ).build();
    }
}
