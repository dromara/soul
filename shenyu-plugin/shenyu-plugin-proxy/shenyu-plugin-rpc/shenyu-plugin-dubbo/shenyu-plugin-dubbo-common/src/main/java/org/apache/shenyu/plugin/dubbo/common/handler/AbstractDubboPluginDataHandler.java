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

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.dto.PluginData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.plugin.DubboRegisterConfig;
import org.apache.shenyu.common.dto.convert.rule.impl.DubboRuleHandle;
import org.apache.shenyu.common.dto.convert.selector.DubboUpstream;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.Singleton;
import org.apache.shenyu.loadbalancer.cache.UpstreamCacheManager;
import org.apache.shenyu.loadbalancer.entity.Upstream;
import org.apache.shenyu.plugin.base.cache.CommonHandleCache;
import org.apache.shenyu.plugin.base.handler.PluginDataHandler;
import org.apache.shenyu.plugin.base.utils.BeanHolder;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.function.Supplier;
import java.util.stream.Collectors;

/**
 * The common dubbo plugin data handler.
 */
public abstract class AbstractDubboPluginDataHandler implements PluginDataHandler {

    public static final Supplier<CommonHandleCache<String, DubboRuleHandle>> RULE_CACHED_HANDLE = new BeanHolder<>(CommonHandleCache::new);

    public static final Supplier<CommonHandleCache<String, List<DubboUpstream>>> SELECTOR_CACHED_HANDLE = new BeanHolder<>(CommonHandleCache::new);

    protected abstract void initConfigCache(DubboRegisterConfig dubboRegisterConfig);

    protected abstract void invalidateReferenceBySelector(SelectorData selectorData);

    protected abstract void invalidateReferenceByRule(RuleData ruleData);

    @Override
    public void handlerPlugin(final PluginData pluginData) {
        if (Objects.nonNull(pluginData) && Boolean.TRUE.equals(pluginData.getEnabled())) {
            DubboRegisterConfig dubboRegisterConfig = GsonUtils.getInstance().fromJson(pluginData.getConfig(), DubboRegisterConfig.class);
            DubboRegisterConfig exist = Singleton.INST.get(DubboRegisterConfig.class);
            if (Objects.isNull(dubboRegisterConfig)) {
                return;
            }
            if (Objects.isNull(exist) || !dubboRegisterConfig.equals(exist)) {
                // If it is null, initialize it
                this.initConfigCache(dubboRegisterConfig);
            }
            Singleton.INST.single(DubboRegisterConfig.class, dubboRegisterConfig);
        }
    }

    @Override
    public void handlerSelector(final SelectorData selectorData) {
        // remove old upstream reference
        this.invalidateReferenceBySelector(selectorData);
        if (!selectorData.getContinued()) {
            RULE_CACHED_HANDLE.get().cachedHandle(CacheKeyUtils.INST.getKey(selectorData.getId(), Constants.DEFAULT_RULE), DubboRuleHandle.newInstance());
        }
        List<DubboUpstream> dubboUpstreams = GsonUtils.getInstance().fromList(selectorData.getHandle(), DubboUpstream.class);
        if (CollectionUtils.isEmpty(dubboUpstreams)) {
            return;
        }
        List<DubboUpstream> graySelectorHandle = new ArrayList<>();
        for (DubboUpstream each : dubboUpstreams) {
            if (StringUtils.isNotBlank(each.getUpstreamUrl()) && Objects.nonNull(each.isGray()) && Boolean.TRUE.equals(each.isGray())) {
                graySelectorHandle.add(each);
            }
        }
        if (CollectionUtils.isNotEmpty(graySelectorHandle)) {
            SELECTOR_CACHED_HANDLE.get().cachedHandle(selectorData.getId(), graySelectorHandle);
            UpstreamCacheManager.getInstance().submit(selectorData.getId(), convertUpstreamList(graySelectorHandle));
        } else {
            // if update gray selector is empty, remove cache
            removeSelector(selectorData);
        }
    }

    @Override
    public void removeSelector(final SelectorData selectorData) {
        SELECTOR_CACHED_HANDLE.get().removeHandle(selectorData.getId());
        UpstreamCacheManager.getInstance().removeByKey(selectorData.getId());
        RULE_CACHED_HANDLE.get().removeHandle(CacheKeyUtils.INST.getKey(selectorData.getId(), Constants.DEFAULT_RULE));
        // remove old upstream reference
        this.invalidateReferenceBySelector(selectorData);
    }

    @Override
    public void handlerRule(final RuleData ruleData) {
        RULE_CACHED_HANDLE.get().cachedHandle(ruleData.getId(), GsonUtils.getInstance().fromJson(ruleData.getHandle(), DubboRuleHandle.class));
        // remove old upstream reference
        this.invalidateReferenceByRule(ruleData);
    }

    @Override
    public void removeRule(final RuleData ruleData) {
        RULE_CACHED_HANDLE.get().removeHandle(ruleData.getId());
        // remove old upstream reference
        this.invalidateReferenceByRule(ruleData);
    }

    @Override
    public String pluginNamed() {
        return PluginEnum.DUBBO.getName();
    }

    private List<Upstream> convertUpstreamList(final List<DubboUpstream> handleList) {
        return handleList.stream().map(u -> Upstream.builder()
                .protocol(u.getProtocol())
                .url(u.getUpstreamUrl())
                .weight(u.getWeight())
                .status(u.isStatus())
                .timestamp(u.getTimestamp())
                .warmup(u.getWarmup())
                .group(u.getGroup())
                .version(u.getVersion())
                .build()).collect(Collectors.toList());
    }
}
