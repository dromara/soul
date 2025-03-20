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

package org.apache.shenyu.plugin.sync.data.websocket.client;

import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.constant.InstanceTypeConstants;
import org.apache.shenyu.common.constant.RunningModeConstants;
import org.apache.shenyu.common.dto.WebsocketData;
import org.apache.shenyu.common.enums.ConfigGroupEnum;
import org.apache.shenyu.common.enums.DataEventTypeEnum;
import org.apache.shenyu.common.enums.RunningModeEnum;
import org.apache.shenyu.common.timer.AbstractRoundTask;
import org.apache.shenyu.common.timer.Timer;
import org.apache.shenyu.common.timer.TimerTask;
import org.apache.shenyu.common.timer.WheelTimerFactory;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.common.utils.SystemInfoUtils;
import org.apache.shenyu.plugin.sync.data.websocket.handler.WebsocketDataHandler;
import org.apache.shenyu.sync.data.api.AuthDataSubscriber;
import org.apache.shenyu.sync.data.api.DiscoveryUpstreamDataSubscriber;
import org.apache.shenyu.sync.data.api.MetaDataSubscriber;
import org.apache.shenyu.sync.data.api.PluginDataSubscriber;
import org.apache.shenyu.sync.data.api.ProxySelectorDataSubscriber;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * The type shenyu websocket client.
 */
public final class ShenyuWebsocketClient extends WebSocketClient {
    
    /**
     * logger.
     */
    private static final Logger LOG = LoggerFactory.getLogger(ShenyuWebsocketClient.class);
    
    private volatile boolean alreadySync = Boolean.FALSE;
    
    private final WebsocketDataHandler websocketDataHandler;
    
    private final Timer timer;
    
    private TimerTask timerTask;
    
    private String runningMode;
    
    private String masterUrl;
    
    private volatile boolean isConnectedToMaster;
    
    private final String namespaceId;
    
    /**
     * Instantiates a new shenyu websocket client.
     *
     * @param serverUri the server uri
     * @param pluginDataSubscriber the plugin data subscriber
     * @param metaDataSubscribers the meta data subscribers
     * @param authDataSubscribers the auth data subscribers
     * @param proxySelectorDataSubscribers proxySelectorDataSubscribers,
     * @param discoveryUpstreamDataSubscribers discoveryUpstreamDataSubscribers,
     */
    public ShenyuWebsocketClient(final URI serverUri, final PluginDataSubscriber pluginDataSubscriber,
                                 final List<MetaDataSubscriber> metaDataSubscribers,
                                 final List<AuthDataSubscriber> authDataSubscribers,
                                 final List<ProxySelectorDataSubscriber> proxySelectorDataSubscribers,
                                 final List<DiscoveryUpstreamDataSubscriber> discoveryUpstreamDataSubscribers,
                                 final String namespaceId
    ) {
        super(serverUri);
        this.namespaceId = namespaceId;
        this.addHeader("namespaceId", namespaceId);
        this.websocketDataHandler = new WebsocketDataHandler(pluginDataSubscriber, metaDataSubscribers, authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers);
        this.timer = WheelTimerFactory.getSharedTimer();
        this.connection();
    }
    
    /**
     * Instantiates a new shenyu websocket client.
     *
     * @param serverUri the server uri
     * @param headers the headers
     * @param pluginDataSubscriber the plugin data subscriber
     * @param metaDataSubscribers the meta data subscribers
     * @param authDataSubscribers the auth data subscribers
     * @param proxySelectorDataSubscribers proxySelectorDataSubscribers,
     * @param discoveryUpstreamDataSubscribers discoveryUpstreamDataSubscribers,
     */
    public ShenyuWebsocketClient(final URI serverUri, final Map<String, String> headers,
                                 final PluginDataSubscriber pluginDataSubscriber,
                                 final List<MetaDataSubscriber> metaDataSubscribers,
                                 final List<AuthDataSubscriber> authDataSubscribers,
                                 final List<ProxySelectorDataSubscriber> proxySelectorDataSubscribers,
                                 final List<DiscoveryUpstreamDataSubscriber> discoveryUpstreamDataSubscribers,
                                 final String namespaceId) {
        super(serverUri, headers);
        this.namespaceId = namespaceId;
        LOG.info("shenyu bootstrap websocket namespaceId: {}", namespaceId);
        this.addHeader(Constants.SHENYU_NAMESPACE_ID, namespaceId);
        this.websocketDataHandler = new WebsocketDataHandler(pluginDataSubscriber, metaDataSubscribers, authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers);
        this.timer = WheelTimerFactory.getSharedTimer();
        this.connection();
    }
    
    private void connection() {
        this.connectBlocking();
        this.timer.add(timerTask = new AbstractRoundTask(null, TimeUnit.SECONDS.toMillis(10)) {
            @Override
            public void doRun(final String key, final TimerTask timerTask) {
                healthCheck();
            }
        });
    }
    
    @Override
    public boolean connectBlocking() {
        boolean success = false;
        try {
            success = super.connectBlocking();
        } catch (Exception exception) {
            LOG.error("websocket connection server[{}] is error.....[{}]", this.getURI().toString(), exception.getMessage());
        }
        if (success) {
            LOG.info("websocket connection server[{}] is successful.....", this.getURI().toString());
        } else {
            LOG.warn("websocket connection server[{}] is error.....", this.getURI().toString());
        }
        return success;
    }
    
    @Override
    public void onOpen(final ServerHandshake serverHandshake) {
        LOG.info("websocket connection server[{}] is opened, sending sync msg", this.getURI().toString());
        send(DataEventTypeEnum.RUNNING_MODE.name());
        if (!alreadySync) {
            send(DataEventTypeEnum.MYSELF.name());
            alreadySync = true;
        }
    }
    
    @Override
    public void onMessage(final String result) {
        if (LOG.isDebugEnabled()) {
            LOG.debug("onMessage server[{}] result({})", this.getURI().toString(), result);
        }
        
        Map<String, Object> jsonToMap = JsonUtils.jsonToMap(result);
        Object eventType = jsonToMap.get(RunningModeConstants.EVENT_TYPE);
        if (Objects.equals(DataEventTypeEnum.RUNNING_MODE.name(), eventType)) {
            LOG.info("server[{}] handle running mode result({})", this.getURI().toString(), result);
            this.runningMode = String.valueOf(jsonToMap.get(RunningModeConstants.RUNNING_MODE));
            if (Objects.equals(RunningModeEnum.STANDALONE.name(), runningMode)) {
                return;
            }
            this.masterUrl = String.valueOf(jsonToMap.get(RunningModeConstants.MASTER_URL));
            this.isConnectedToMaster = Boolean.TRUE.equals(jsonToMap.get(RunningModeConstants.IS_MASTER));
        } else {
            handleResult(result);
        }
    }
    
    @Override
    public void onClose(final int i, final String s, final boolean b) {
        this.close();
    }
    
    @Override
    public void onError(final Exception e) {
        LOG.error("websocket server[{}] is error.....", getURI(), e);
    }
    
    @Override
    public void close() {
        alreadySync = false;
        if (this.isOpen()) {
            super.close();
        }
    }
    
    /**
     * Now close.
     * now close. will cancel the task execution.
     */
    public void nowClose() {
        this.close();
        if (Objects.nonNull(timerTask)) {
            timerTask.cancel();
        }
    }
    
    private void healthCheck() {
        try {
            if (!this.isOpen()) {
                this.reconnectBlocking();
            } else {
                this.sendPing();
                send(getInstanceInfo());
                LOG.debug("websocket send to [{}] ping message successful", this.getURI());
            }
        } catch (Exception e) {
            LOG.error("websocket connect is error :{}", e.getMessage());
        }
    }
    
    private String getInstanceInfo() {
        // Combine instance and host information
        Map<String, Object> combinedInfo = Map.of(
                InstanceTypeConstants.BOOTSTRAP_INSTANCE_INFO, SystemInfoUtils.getSystemInfo()
        );
        
        return GsonUtils.getInstance().toJson(combinedInfo);
    }
    
    /**
     * handle admin message.
     *
     * @param result result
     */
    private void handleResult(final String result) {
        LOG.info("server [{}] handleResult({})", this.getURI().toString(), result);
        WebsocketData<?> websocketData = GsonUtils.getInstance().fromJson(result, WebsocketData.class);
        ConfigGroupEnum groupEnum = ConfigGroupEnum.acquireByName(websocketData.getGroupType());
        String eventType = websocketData.getEventType();
        String json = GsonUtils.getInstance().toJson(websocketData.getData());
        websocketDataHandler.executor(groupEnum, json, eventType);
    }
    
    /**
     * Gets the master url.
     *
     * @return the master url
     */
    public String getMasterUrl() {
        return masterUrl;
    }
    
    /**
     * Gets the running mode.
     *
     * @return the running mode
     */
    public String getRunningMode() {
        return runningMode;
    }
    
    /**
     * whether connect to master.
     *
     * @return whether connect to master
     */
    public boolean isConnectedToMaster() {
        return isConnectedToMaster;
    }
    
}
