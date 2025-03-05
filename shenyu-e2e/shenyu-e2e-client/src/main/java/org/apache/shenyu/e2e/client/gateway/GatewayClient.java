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

package org.apache.shenyu.e2e.client.gateway;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.shenyu.e2e.annotation.ShenYuGatewayClient;
import org.apache.shenyu.e2e.client.BaseClient;
import org.apache.shenyu.e2e.common.RequestLogConsumer;
import org.apache.shenyu.e2e.model.data.MetaData;
import org.apache.shenyu.e2e.model.data.RuleCacheData;
import org.apache.shenyu.e2e.model.data.SelectorCacheData;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.function.Supplier;

import static io.restassured.RestAssured.given;

/**
 * A client to connect to ShenYu bootstrap(Gateway) server over HTTP.
 */
@ShenYuGatewayClient
public class GatewayClient extends BaseClient {

    private static final Logger log = LoggerFactory.getLogger(GatewayClient.class);
    
    private static final RestTemplate TEMPLATE = new RestTemplate();

    private static final ObjectMapper MAPPER = new ObjectMapper();

    private static final ArrayBlockingQueue<String> BLOCKING_QUEUE = new ArrayBlockingQueue<>(1);

    private final String scenarioId;

    private final String baseUrl;
    
    private final String serviceName;
    
    private final Properties properties;

    public GatewayClient(final String scenarioId, final String serviceName, final String baseUrl, final Properties properties) {
        super(serviceName);
        this.scenarioId = scenarioId;
        this.serviceName = serviceName;
        this.baseUrl = baseUrl;
        this.properties = properties;
    }

    /**
     * get baseUrl.
     *
     * @return baseUrl
     */
    public String getBaseUrl() {
        return baseUrl;
    }
    
    /**
     * get http request specification.
     * @return Supplier
     */
    public Supplier<RequestSpecification> getHttpRequesterSupplier() {
        return () -> given().baseUri(getBaseUrl())
                .filter((req, resp, ctx) -> {
                    if (log.isDebugEnabled()) {
                        RequestLogConsumer.print(log, req);
                    } else {
                        log.info("Request: {} {}", req.getMethod(), req.getURI());
                    }
                    return ctx.next(req, resp);
                })
                .filter((req, resp, ctx) -> {
                    MDC.put("endpoint", req.getMethod() + " " + req.getURI());
                    
                    Response response = ctx.next(req, resp);
                    if (log.isDebugEnabled()) {
                        log.debug("request {} {}:\n{}", req.getMethod(), req.getURI(), response.asPrettyString());
                    }
                    return response;
                })
                .when();
    }

    /**
     * get websocket client.
     * @return Supplier
     */
    public Supplier<WebSocketClient> getWebSocketClientSupplier() {
        return () -> {
            try {
                return new WebSocketClient(new URI(getBaseUrl().replaceAll("http", "ws"))) {
                    @Override
                    public void onOpen(final ServerHandshake handshakeData) {
                        log.info("Open websocket connection successfully");
                    }

                    @Override
                    public void onMessage(final String message) {
                        BLOCKING_QUEUE.add(message);
                        log.info("Receive Message: {}", message);
                    }

                    @Override
                    public void onClose(final int code, final String reason, final boolean remote) {
                    }

                    @Override
                    public void onError(final Exception ex) {
                        log.error(ex.getMessage());
                    }
                };
            } catch (URISyntaxException e) {
                throw new RuntimeException("Invalid WebSocket URI", e);
            }
        };

    }
    
    /**
     * get meta data cache.
     * @return List List
     * @throws JsonProcessingException JsonProcessingException
     */
    public List<MetaData> getMetaDataCache() throws JsonProcessingException {
        ResponseEntity<List> response = TEMPLATE.exchange(baseUrl + "/actuator/metadata", HttpMethod.GET, null, List.class);
        List body = response.getBody();
        Map<String, MetaData> s = (Map<String, MetaData>) body.get(0);
        List<MetaData> metaDataList = new ArrayList<>();
        for (Map.Entry entry : s.entrySet()) {
            String json = MAPPER.writeValueAsString(entry.getValue());
            MetaData metaData = MAPPER.readValue(json, MetaData.class);
            metaDataList.add(metaData);
        }
        return metaDataList;
    }
    
    /**
     * get selector cache.
     * @return List List
     * @throws JsonProcessingException JsonProcessingException
     */
    public List<SelectorCacheData> getSelectorCache() throws JsonProcessingException {
        ResponseEntity<List> response = TEMPLATE.exchange(baseUrl + "/actuator/selectorData", HttpMethod.GET, null, List.class);
        List body = response.getBody();
        Map<String, SelectorCacheData> s = (Map<String, SelectorCacheData>) body.get(0);
        List<SelectorCacheData> selectorDataList = new ArrayList<>();
        for (Map.Entry entry : s.entrySet()) {
            List list = (List) entry.getValue();
            if (CollectionUtils.isEmpty(list)) {
                continue;
            }
            String json = MAPPER.writeValueAsString(list.get(0));
            SelectorCacheData selectorData = MAPPER.readValue(json, SelectorCacheData.class);
            selectorDataList.add(selectorData);
        }
        return selectorDataList;
    }
    
    /**
     * get rule cache.
     * @return List list
     * @throws JsonProcessingException JsonProcessingException
     */
    public List<RuleCacheData> getRuleCache() throws JsonProcessingException {
        ResponseEntity<List> response = TEMPLATE.exchange(baseUrl + "/actuator/ruleData", HttpMethod.GET, null, List.class);
        List body = response.getBody();
        Map<String, RuleCacheData> s = (Map<String, RuleCacheData>) body.get(0);
        List<RuleCacheData> ruleDataList = new ArrayList<>();
        for (Map.Entry entry : s.entrySet()) {
            List list = (List) entry.getValue();
            for (int i = 0; i < list.size(); i++) {
                String json = MAPPER.writeValueAsString(list.get(i));
                RuleCacheData ruleData = MAPPER.readValue(json, RuleCacheData.class);
                ruleDataList.add(ruleData);
            }
        }
        return ruleDataList;
    }

    /**
     * get enable plugins.
     * @return Map Map
     */
    public Map<String, Integer> getPlugins() {
        ResponseEntity<List> response = TEMPLATE.exchange(baseUrl + "/actuator/plugins", HttpMethod.GET, null, List.class);
        List body = response.getBody();
        return (Map<String, Integer>) body.get(0);
    }

    /**
     * get the return message from the server.
     * @return String String
     */
    public String getWebSocketMessage() {
        try {
            return BLOCKING_QUEUE.poll(10, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
