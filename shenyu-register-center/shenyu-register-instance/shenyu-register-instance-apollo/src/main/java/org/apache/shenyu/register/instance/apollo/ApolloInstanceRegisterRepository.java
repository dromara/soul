package org.apache.shenyu.register.instance.apollo;/*
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


import com.ctrip.framework.apollo.ConfigChangeListener;
import com.ctrip.framework.apollo.ConfigService;
import com.ctrip.framework.apollo.core.ConfigConsts;
import com.google.common.collect.Maps;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.register.instance.api.ShenyuInstanceRegisterRepository;
import org.apache.shenyu.register.instance.api.config.RegisterConfig;
import org.apache.shenyu.register.instance.api.entity.InstanceEntity;
import org.apache.shenyu.register.instance.api.path.InstancePathConstants;
import org.apache.shenyu.register.instance.api.watcher.WatcherListener;
import org.apache.shenyu.spi.Join;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * The type Etcd instance register repository.
 */
@Join
public class ApolloInstanceRegisterRepository implements ShenyuInstanceRegisterRepository {

    private static final Logger LOGGER = LoggerFactory.getLogger(ApolloInstanceRegisterRepository.class);

    private ApolloClient apolloClient;

    private final Map<String, ConfigChangeListener> configChangeListenerMap = Maps.newConcurrentMap();

    private String namespace;

    @Override
    public void init(RegisterConfig config) {
        Properties properties = config.getProps();
        String portalUrl = config.getServerLists();
        String appId = properties.getProperty("appId");
        String token = properties.getProperty("token");
        String env = properties.getProperty("env", "DEV");
        String clusterName = properties.getProperty("clusterName", ConfigConsts.CLUSTER_NAME_DEFAULT);
        String namespace = properties.getProperty("namespace", ConfigConsts.NAMESPACE_APPLICATION);
        ApolloConfig apolloConfig = new ApolloConfig();
        apolloConfig.setAppId(appId);
        apolloConfig.setPortalUrl(portalUrl);
        apolloConfig.setToken(token);
        apolloConfig.setEnv(env);
        apolloConfig.setClusterName(clusterName);
        apolloConfig.setNamespace(namespace);
        this.namespace = namespace;
        this.apolloClient = new ApolloClient(apolloConfig);
    }

    @Override
    public void persistInstance(InstanceEntity instance) {
        String instanceNodeName = buildInstanceNodeName(instance);
        String instancePath = InstancePathConstants.buildInstanceParentPath(instance.getAppName());
        String realNode = InstancePathConstants.buildRealNode(instancePath, instanceNodeName);
        String nodeData = GsonUtils.getInstance().toJson(instance);
        apolloClient.createOrUpdateItem(realNode, nodeData, "register instance");
        LOGGER.info("apollo instance register success: {}", nodeData);
    }

    @Override
    public List<InstanceEntity> selectInstancesAndWatcher(String selectKey, WatcherListener watcherListener) {
        final String watchKey = InstancePathConstants.buildInstanceParentPath(selectKey);
        final Function<Map<String, String>, List<InstanceEntity>> getInstanceRegisterFun = childrenList ->
                childrenList.values().stream().map(x -> GsonUtils.getInstance().fromJson(x, InstanceEntity.class)).collect(Collectors.toList());
        Map<String, String> childrenList = new HashMap<>();
        ConfigChangeListener configChangeListener = changeEvent -> {
            Set<String> keys = changeEvent.changedKeys();
            keys.forEach(key -> {
                if (key.startsWith(watchKey)) {
                    switch (changeEvent.getChange(key).getChangeType()) {
                        case ADDED:
                            childrenList.put(key, changeEvent.getChange(key).getNewValue());
                            LOGGER.info("apollo instance register success: {}", changeEvent.getChange(key).getNewValue());
                        case MODIFIED:
                            childrenList.put(key, changeEvent.getChange(key).getNewValue());
                            LOGGER.info("apollo instance register success: {}", changeEvent.getChange(key).getNewValue());
                            break;
                        case DELETED:
                            childrenList.remove(key);
                            LOGGER.info("apollo instance register delete success: {}", changeEvent.getChange(key).getOldValue());
                            break;
                        default:
                            break;
                    }
                    watcherListener.listener(getInstanceRegisterFun.apply(childrenList));
                }
            });
        };
        ConfigService.getConfig(namespace).addChangeListener(configChangeListener);
        configChangeListenerMap.put(watchKey, configChangeListener);
        return getInstanceRegisterFun.apply(childrenList);
    }

    @Override
    public void close() {
        configChangeListenerMap.forEach((key, value) -> ConfigService.getConfig(namespace).removeChangeListener(value));
    }

    private String buildInstanceNodeName(final InstanceEntity instance) {
        String host = instance.getHost();
        int port = instance.getPort();
        return String.join(Constants.COLONS, host, Integer.toString(port));
    }
}
