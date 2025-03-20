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

package org.apache.shenyu.plugin.dubbo.common.handler;

import com.google.common.collect.Maps;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.plugin.base.handler.MetaDataHandler;

import java.util.Objects;
import java.util.concurrent.ConcurrentMap;

/**
 * The common dubbo meta data handler.
 */
public abstract class AbstractDubboMetaDataHandler implements MetaDataHandler {

    private static final ConcurrentMap<String, MetaData> META_DATA = Maps.newConcurrentMap();

    @Override
    public void handle(final MetaData metaData) {
        MetaData exist = META_DATA.get(metaData.getPath());
        if (Objects.isNull(exist) || !isInitialized(metaData)) {
            // The first initialization
            initReference(metaData);
        } else {
            // There are updates, which only support the update of four properties of serviceName rpcExt parameterTypes methodName,
            // because these four properties will affect the call of Dubbo;
            if (!Objects.equals(metaData.getServiceName(), exist.getServiceName())
                    || !Objects.equals(metaData.getRpcExt(), exist.getRpcExt())
                    || !Objects.equals(metaData.getParameterTypes(), exist.getParameterTypes())
                    || !Objects.equals(metaData.getMethodName(), exist.getMethodName())) {
                updateReference(metaData);
            }
        }
        META_DATA.put(metaData.getPath(), metaData);
    }

    protected abstract boolean isInitialized(MetaData metaData);

    protected abstract void initReference(MetaData metaData);

    protected abstract void updateReference(MetaData metaData);

    @Override
    public void remove(final MetaData metaData) {
        invalidateReference(metaData);
        META_DATA.remove(metaData.getPath());
    }

    protected abstract void invalidateReference(MetaData path);

    @Override
    public String rpcType() {
        return RpcTypeEnum.DUBBO.getName();
    }
}
