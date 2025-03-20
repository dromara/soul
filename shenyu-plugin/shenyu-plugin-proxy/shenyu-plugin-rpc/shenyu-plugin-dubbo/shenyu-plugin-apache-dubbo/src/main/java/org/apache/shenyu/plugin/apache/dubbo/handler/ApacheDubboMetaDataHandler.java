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

package org.apache.shenyu.plugin.apache.dubbo.handler;

import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.plugin.apache.dubbo.cache.ApacheDubboConfigCache;
import org.apache.shenyu.plugin.dubbo.common.handler.AbstractDubboMetaDataHandler;

import java.util.Objects;

/**
 * The type Apache dubbo meta data subscriber.
 */
public class ApacheDubboMetaDataHandler extends AbstractDubboMetaDataHandler {

    @Override
    protected boolean isInitialized(final MetaData metaData) {
        return Objects.nonNull(ApacheDubboConfigCache.getInstance().get(metaData.getPath()));
    }

    @Override
    protected void initReference(final MetaData metaData) {
        ApacheDubboConfigCache.getInstance().initRef(metaData);
    }

    @Override
    protected void updateReference(final MetaData metaData) {
        ApacheDubboConfigCache.getInstance().build(metaData, "");
        // remove old upstream reference
        ApacheDubboConfigCache.getInstance().invalidateWithMetadataId(metaData.getId());
    }

    @Override
    protected void invalidateReference(final MetaData metaData) {
        ApacheDubboConfigCache.getInstance().invalidate(metaData.getPath());
        // remove old upstream reference
        ApacheDubboConfigCache.getInstance().invalidateWithMetadataId(metaData.getId());
    }
}
