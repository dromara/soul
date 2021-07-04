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

package org.apache.shenyu.plugin.springcloud.cache;

import lombok.extern.slf4j.Slf4j;
import org.apache.shenyu.common.dto.convert.selector.SpringCloudSelectorHandle;
import org.apache.shenyu.plugin.base.cache.RuleHandleCache;

/**
 * The spring cloud selector handle cache.
 */
@Slf4j
public final class SpringCloudSelectorHandleCache extends RuleHandleCache<String, SpringCloudSelectorHandle> {

    private SpringCloudSelectorHandleCache() {
    }

    /**
     * Gets instance.
     *
     * @return the instance
     */
    public static SpringCloudSelectorHandleCache getInstance() {
        return SpringCloudSelectorHandleCacheInstance.INSTANCE;
    }

    /**
     * The type selector handle cache instance.
     */
    static class SpringCloudSelectorHandleCacheInstance {
        /**
         * The Instance.
         */
        static final SpringCloudSelectorHandleCache INSTANCE = new SpringCloudSelectorHandleCache();
    }
}
