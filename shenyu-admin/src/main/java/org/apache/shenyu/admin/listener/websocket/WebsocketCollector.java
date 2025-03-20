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

package org.apache.shenyu.admin.listener.websocket;

import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.config.properties.ClusterProperties;
import org.apache.shenyu.admin.mode.cluster.service.ClusterSelectMasterService;
import org.apache.shenyu.admin.register.ShenyuClientServerRegisterPublisher;
import org.apache.shenyu.admin.service.SyncDataService;
import org.apache.shenyu.admin.spring.SpringBeanUtils;
import org.apache.shenyu.admin.utils.ThreadLocalUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.constant.InstanceTypeConstants;
import org.apache.shenyu.common.constant.RunningModeConstants;
import org.apache.shenyu.common.enums.DataEventTypeEnum;
import org.apache.shenyu.common.enums.RunningModeEnum;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.register.common.dto.InstanceInfoRegisterDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * The type Websocket data changed listener.
 *
 * @since 2.0.0
 */
@ServerEndpoint(value = "/websocket", configurator = WebsocketConfigurator.class)
public class WebsocketCollector {
    
    private static final Logger LOG = LoggerFactory.getLogger(WebsocketCollector.class);
    
    private static final Set<Session> SESSION_SET = new CopyOnWriteArraySet<>();
    
    private static final Map<String, Set<Session>> NAMESPACE_SESSION_MAP = Maps.newConcurrentMap();
    
    private static final String SESSION_KEY = "sessionKey";
    
    private ShenyuClientServerRegisterPublisher publisher;
    
    public ShenyuClientServerRegisterPublisher getPublisher() {
        return publisher;
    }
    
    public void setPublisher(final ShenyuClientServerRegisterPublisher publisher) {
        this.publisher = publisher;
    }
    
    /**
     * On open.
     *
     * @param session the session
     */
    @OnOpen
    public void onOpen(final Session session) {
        String clientIp = getClientIp(session);
        LOG.info("websocket on client[{}] open successful, maxTextMessageBufferSize: {}",
                clientIp, session.getMaxTextMessageBufferSize());
        SESSION_SET.add(session);
        
        String namespaceId = getNamespaceId(session);
        if (StringUtils.isBlank(namespaceId)) {
            throw new ShenyuException("websocket on client open failed, namespaceId is null");
        }
        LOG.info("websocket on client[{}] open successful, namespaceId: {}", clientIp, namespaceId);
        NAMESPACE_SESSION_MAP.computeIfAbsent(namespaceId, k -> Sets.newConcurrentHashSet()).add(session);
    }
    
    private static String getClientIp(final Session session) {
        if (!session.isOpen()) {
            return StringUtils.EMPTY;
        }
        Map<String, Object> userProperties = session.getUserProperties();
        if (MapUtils.isEmpty(userProperties)) {
            return StringUtils.EMPTY;
        }
        
        return Optional.ofNullable(userProperties.get(WebsocketListener.CLIENT_IP_NAME))
                .map(Object::toString)
                .orElse(StringUtils.EMPTY);
    }
    
    private static String getNamespaceId(final Session session) {
        if (!session.isOpen()) {
            LOG.warn("websocket session is closed, can not get namespaceId");
            return null;
        }
        Map<String, Object> userProperties = session.getUserProperties();
        if (MapUtils.isEmpty(userProperties)) {
            LOG.warn("websocket session userProperties is empty, can not get namespaceId");
            return null;
        }
        
        return Optional.ofNullable(userProperties.get(Constants.SHENYU_NAMESPACE_ID))
                .map(Object::toString)
                .orElse(null);
    }
    
    /**
     * On message.
     *
     * @param message the message
     * @param session the session
     */
    @OnMessage
    public void onMessage(final String message, final Session session) {
        if (!Objects.equals(message, DataEventTypeEnum.MYSELF.name())
                && !Objects.equals(message, DataEventTypeEnum.RUNNING_MODE.name())
                && !message.contains("bootstrapInstanceInfo")) {
            return;
        }
        if (message.contains(InstanceTypeConstants.BOOTSTRAP_INSTANCE_INFO)) {
            if (LOG.isDebugEnabled()) {
                LOG.debug("bootstrap report instance info: {}", message);
            }
            String sessionId = session.getId();
            String namespaceId = getNamespaceId(session);
            Map<String, Object> infoMap = GsonUtils.getInstance().convertToMap(message);
            Object o = infoMap.get(InstanceTypeConstants.BOOTSTRAP_INSTANCE_INFO);
            InstanceInfoRegisterDTO instanceInfoRegisterDTO = InstanceInfoRegisterDTO.builder()
                    .sessionId(sessionId)
                    .instanceIp(getClientIp(session))
                    .instanceType(InstanceTypeConstants.BOOTSTRAP_INSTANCE_TYPE)
                    .instanceInfo(GsonUtils.getInstance().toJson(o))
                    .namespaceId(namespaceId)
                    .build();
            SpringBeanUtils.getInstance().getBean(ShenyuClientServerRegisterPublisher.class).publish(instanceInfoRegisterDTO);
            return;
        }
        
        if (Objects.equals(message, DataEventTypeEnum.RUNNING_MODE.name())) {
            if (LOG.isDebugEnabled()) {
                LOG.debug("websocket fetching running mode info...");
            }
            // check if this node is master
            boolean isMaster = true;
            String runningMode = RunningModeEnum.STANDALONE.name();
            String masterUrl = StringUtils.EMPTY;
            ClusterProperties clusterProperties = SpringBeanUtils.getInstance().getBean(ClusterProperties.class);
            if (clusterProperties.isEnabled()) {
                ClusterSelectMasterService clusterSelectMasterService = SpringBeanUtils.getInstance().getBean(ClusterSelectMasterService.class);
                runningMode = RunningModeEnum.CLUSTER.name();
                isMaster = clusterSelectMasterService.isMaster();
                masterUrl = clusterSelectMasterService.getMasterUrl();
            }
            Map<String, Object> map = Maps.newHashMap();
            map.put(RunningModeConstants.EVENT_TYPE, DataEventTypeEnum.RUNNING_MODE.name());
            map.put(RunningModeConstants.IS_MASTER, isMaster);
            map.put(RunningModeConstants.RUNNING_MODE, runningMode);
            map.put(RunningModeConstants.MASTER_URL, masterUrl
                    .replace("http", "ws")
                    .replace("https", "ws")
                    .concat("/websocket"));
            if (isMaster) {
                ThreadLocalUtils.put(SESSION_KEY, session);
            }
            
            sendMessageBySession(session, JsonUtils.toJson(map));
            return;
        }
        
        if (Objects.equals(message, DataEventTypeEnum.MYSELF.name())) {
            try {
                ThreadLocalUtils.put(SESSION_KEY, session);
                String namespaceId = getNamespaceId(session);
                SpringBeanUtils.getInstance().getBean(SyncDataService.class).syncAllByNamespaceId(DataEventTypeEnum.MYSELF, namespaceId);
            } finally {
                ThreadLocalUtils.clear();
            }
        }
        
    }
    
    /**
     * On close.
     *
     * @param session the session
     */
    @OnClose
    public void onClose(final Session session) {
        clearSession(session);
        LOG.warn("websocket close on client[{}]", getClientIp(session));
    }
    
    /**
     * On error.
     *
     * @param session the session
     * @param error the error
     */
    @OnError
    public void onError(final Session session, final Throwable error) {
        clearSession(session);
        LOG.error("websocket collection on client[{}] error: ", getClientIp(session), error);
    }
    
    /**
     * Send.
     *
     * @param message the message
     * @param type the type
     */
    public static void send(final String message, final DataEventTypeEnum type) {
        if (StringUtils.isBlank(message)) {
            return;
        }
        
        if (DataEventTypeEnum.MYSELF == type) {
            Session session = (Session) ThreadLocalUtils.get(SESSION_KEY);
            if (Objects.nonNull(session)) {
                if (session.isOpen()) {
                    sendMessageBySession(session, message);
                } else {
                    SESSION_SET.remove(session);
                }
            }
        } else {
            SESSION_SET.forEach(session -> sendMessageBySession(session, message));
        }
        
    }
    
    /**
     * Send.
     *
     * @param namespaceId the namespaceId
     * @param message the message
     * @param type the type
     */
    public static void send(final String namespaceId, final String message, final DataEventTypeEnum type) {
        if (StringUtils.isBlank(message)) {
            return;
        }
        if (StringUtils.isBlank(namespaceId)) {
            throw new ShenyuException("namespaceId can not be null");
        }
        LOG.info("websocket send message to namespaceId: {}, message: {}", namespaceId, message);
        if (DataEventTypeEnum.MYSELF == type) {
            Session session = (Session) ThreadLocalUtils.get(SESSION_KEY);
            if (Objects.nonNull(session)) {
                if (session.isOpen()) {
                    sendMessageBySession(session, message);
                } else {
                    NAMESPACE_SESSION_MAP.getOrDefault(namespaceId, Sets.newConcurrentHashSet()).remove(session);
                }
            }
        } else {
            NAMESPACE_SESSION_MAP.getOrDefault(namespaceId, Sets.newConcurrentHashSet())
                    .forEach(session -> sendMessageBySession(session, message));
        }
        
    }
    
    private static synchronized void sendMessageBySession(final Session session, final String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            LOG.error("websocket send result is exception: ", e);
        }
    }
    
    private void clearSession(final Session session) {
        SESSION_SET.remove(session);
        String namespaceId = getNamespaceId(session);
        if (StringUtils.isNotBlank(namespaceId)) {
            NAMESPACE_SESSION_MAP.getOrDefault(namespaceId, Sets.newConcurrentHashSet()).remove(session);
        }
        ThreadLocalUtils.clear();
    }
}
