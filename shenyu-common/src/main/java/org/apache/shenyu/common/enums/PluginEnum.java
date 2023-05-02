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
 
package org.apache.shenyu.common.enums;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * PluginEnum.
 */
public enum PluginEnum {

    /**
     * Global plugin enum.
     */
    GLOBAL(-1, 0, "global"),
    /**
     * Mqtt plugin enum.
     */
    MQTT(0, 0, "mqtt"),

    /**
     * the mock plugin enum.
     */
    MOCK(8, 0, "mock"),
    
    /**
     * the cache plugin enum.
     */
    CACHE(10, 0, "cache"),
    
    /**
     * Monitor plugin enum.
     */
    METRICS(15, 0, "metrics"),
    
    /**
     * Sign plugin enum.
     */
    SIGN(20, 0, "sign"),
    
    /**
     * Jwt plugin enum.
     */
    JWT(30, 0, "jwt"),
    
    /**
     * OAuth2 plugin enum.
     */
    OAUTH2(40, 0, "oauth2"),

    /**
     * Casdoor plugin enum.
     */
    CASDOOR(40, 0, "casdoor"),

    /**
     * Waf plugin enum.
     */
    WAF(50, 0, "waf"),

    /**
     * Xss plugin enum.
     */
    XSS(55, 0, "xss"),

    /**
     * Rate limiter plugin enum.
     */
    RATE_LIMITER(60, 0, "rateLimiter"),
    
    /**
     * Param mapping plugin enum.
     */
    PARAM_MAPPING(70, 0, "paramMapping"),
    
    /**
     * Context path plugin enum.
     */
    CONTEXT_PATH(80, 0, "contextPath"),
    
    /**
     * Rewrite plugin enum.
     */
    REWRITE(90, 0, "rewrite"),
    
    /**
     * Cryptor request plugin enum.
     */
    CRYPTOR_REQUEST(100, 0, "cryptorRequest"),
    
    /**
     * Redirect plugin enum.
     */
    REDIRECT(110, 0, "redirect"),
    
    /**
     * Request plugin enum.
     */
    REQUEST(120, 0, "request"),


    
    /**
     * GeneralContext plugin enum.
     */
    GENERAL_CONTEXT(125, 0, "generalContext"),
    
    /**
     * Hystrix plugin enum.
     */
    HYSTRIX(130, 0, "hystrix"),
    
    /**
     * Sentinel plugin enum.
     */
    SENTINEL(140, 0, "sentinel"),
    
    /**
     * Resilence4J plugin enum.
     */
    RESILIENCE4J(150, 0, "resilience4j"),
    
    /**
     * Logging console plugin enum.
     */
    LOGGING_CONSOLE(160, 0, "loggingConsole"),
    
    /**
     * Logging RocketMQ plugin enum.
     */
    LOGGING_ROCKETMQ(170, 0, "loggingRocketMQ"),

    /**
     * Logging AliYun sls enums.
     */
    LOGGING_ALIYUN_SLS(175, 0, "loggingAliyunSls"),

    /**
     * Logging Tencent cls enums.
     */
    LOGGING_TENCENT_CLS(176, 0, "loggingTencentCls"),

    /**
     * Logging Kafka plugin enum.
     */
    LOGGING_KAFKA(180, 0, "loggingKafka"),

    /**
     * Logging Pulsar plugin enum.
     */
    LOGGING_PULSAR(185, 0, "loggingPulsar"),

    /**
     * Logging ElasticSearch plugin enum.
     */
    LOGGING_ELASTIC_SEARCH(190, 0, "loggingElasticSearch"),

    /**
     * Logging ClickHouse plugin enum.
     */
    LOGGING_CLICK_HOUSE(195, 0, "loggingClickHouse"),
    
    /**
     * Divide plugin enum.
     */
    DIVIDE(200, 0, "divide"),
    
    /**
     * springCloud plugin enum.
     */
    SPRING_CLOUD(200, 0, "springCloud"),
    
    /**
     * webSocket plugin enum.
     */
    WEB_SOCKET(200, 0, "websocket"),
    
    /**
     * Uri plugin enum.
     */
    URI(205, 0, "uri"),
    
    /**
     * Web client plugin enum.
     */
    WEB_CLIENT(210, 0, "webClient"),
    
    /**
     * Netty http client plugin enum.
     */
    NETTY_HTTP_CLIENT(210, 0, "nettyHttpClient"),
    
    /**
     * ModifyResponse plugin enum.
     */
    MODIFY_RESPONSE(220, 0, "modifyResponse"),
    
    /**
     * Param transform plugin enum.
     */
    RPC_PARAM_TRANSFORM(300, 0, "paramTransform"),
    
    /**
     * Dubbo plugin enum.
     */
    DUBBO(310, 0, "dubbo"),
    
    /**
     * Sofa plugin enum.
     */
    SOFA(310, 0, "sofa"),
    
    /**
     * Tars plugin enum.
     */
    TARS(310, 0, "tars"),
    
    /**
     * GPRC plugin enum.
     */
    GRPC(310, 0, "grpc"),
    
    /**
     * Motan plugin enum.
     */
    MOTAN(310, 0, "motan"),

    /**
     * Motan plugin enum.
     */
    BRPC(310, 0, "brpc"),

    /**
     * Cryptor response plugin enum.
     */
    CRYPTOR_RESPONSE(410, 0, "cryptorResponse"),
    
    /**
     * Response plugin enum.
     */
    RESPONSE(420, 0, "response"),

    /**
     * Key-auth plugin enum.
     */
    KEY_AUTH(430, 0, "keyAuth");
    
    /**
     * When the application starts, the plugin is cached and we can obtained by name.
     * When there are duplicate plugin names, it can be detected and resolved at compile time.
     */
    private static final Map<String, PluginEnum> PLUGIN_ENUM_MAP = Arrays.stream(PluginEnum.values()).collect(Collectors.toMap(plugin -> plugin.name, plugin -> plugin));
    
    private final int code;
    
    private final int role;
    
    private final String name;
    
    /**
     * all args constructor.
     *
     * @param code code
     * @param role role
     * @param name name
     */
    PluginEnum(final int code, final int role, final String name) {
        this.code = code;
        this.role = role;
        this.name = name;
    }
    
    /**
     * get code.
     *
     * @return code code
     */
    public int getCode() {
        return code;
    }
    
    /**
     * get role.
     *
     * @return role role
     */
    public int getRole() {
        return role;
    }
    
    /**
     * get name.
     *
     * @return name name
     */
    public String getName() {
        return name;
    }
    
    /**
     * get plugin enum by name.
     *
     * @param name plugin name.
     * @return plugin enum.
     */
    public static PluginEnum getPluginEnumByName(final String name) {
        return PLUGIN_ENUM_MAP.getOrDefault(name, PluginEnum.GLOBAL);
    }
    
    /**
     * get upstream plugin names.
     *
     * @return List string
     */
    public static List<String> getUpstreamNames() {
        return Arrays.asList(DIVIDE.name, GRPC.name, TARS.name, SPRING_CLOUD.name, DUBBO.name);
    }
}
