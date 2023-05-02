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

package org.apache.shenyu.plugin.xss.handler;

import org.apache.shenyu.common.dto.PluginData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.convert.rule.XssHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.Singleton;
import org.apache.shenyu.plugin.base.cache.CommonHandleCache;
import org.apache.shenyu.plugin.base.handler.PluginDataHandler;
import org.apache.shenyu.plugin.base.utils.BeanHolder;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.xss.config.XssConfig;

import java.util.Optional;
import java.util.function.Supplier;

/**
 * The type Xss plugin data handler.
 */
public class XssPluginDataHandler implements PluginDataHandler {

    public static final Supplier<CommonHandleCache<String, XssHandle>> CACHED_HANDLE = new BeanHolder<>(CommonHandleCache::new);

    @Override
    public void handlerPlugin(final PluginData pluginData) {
        XssConfig XssConfig = GsonUtils.getInstance().fromJson(pluginData.getConfig(), XssConfig.class);
        Singleton.INST.single(XssConfig.class, XssConfig);
    }

    @Override
    public void handlerRule(final RuleData ruleData) {
        Optional.ofNullable(ruleData.getHandle()).ifPresent(s -> {
            final XssHandle XssHandle = GsonUtils.getInstance().fromJson(s, XssHandle.class);
            CACHED_HANDLE.get().cachedHandle(CacheKeyUtils.INST.getKey(ruleData), XssHandle);
        });
    }

    @Override
    public void removeRule(final RuleData ruleData) {
        Optional.ofNullable(ruleData.getHandle()).ifPresent(s -> CACHED_HANDLE.get().removeHandle(CacheKeyUtils.INST.getKey(ruleData)));
    }

    @Override
    public String pluginNamed() {
        return PluginEnum.XSS.getName();
    }
}
