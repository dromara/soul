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

package org.apache.shenyu.plugin.base.cache;

import com.google.common.collect.Maps;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.map.LRUMap;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.cache.MemorySafeLRUMap;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentSkipListSet;


/**
 * The match data cache.
 */
public final class MatchDataCache {

    private static final MatchDataCache INSTANCE = new MatchDataCache();

    /**
     * pluginName -> LRUMap.
     */
    private static final ConcurrentMap<String, MemorySafeLRUMap<String, List<SelectorData>>> SELECTOR_DATA_MAP = Maps.newConcurrentMap();

    /**
     * pluginName -> LRUMap.
     */
    private static final ConcurrentMap<String, MemorySafeLRUMap<String, List<RuleData>>> RULE_DATA_MAP = Maps.newConcurrentMap();

    /**
     * selectorId -> path.
     */
    private static final ConcurrentMap<String, Set<String>> SELECTOR_MAPPING = Maps.newConcurrentMap();

    /**
     * ruleId -> path.
     */
    private static final ConcurrentMap<String, Set<String>> RULE_MAPPING = Maps.newConcurrentMap();

    private MatchDataCache() {
    }

    /**
     * Gets instance.
     *
     * @return the instance
     */
    public static MatchDataCache getInstance() {
        return INSTANCE;
    }

    /**
     * Remove selector data.
     *
     * @param selectorData the selector data
     */
    public void removeSelectorData(final SelectorData selectorData) {
        final LRUMap<String, List<SelectorData>> lruMap = SELECTOR_DATA_MAP.get(selectorData.getPluginName());
        final String selectorDataId = selectorData.getId();
        if (Objects.nonNull(lruMap)) {
            // If the selector has been deleted or changed, need to delete the cache.
            Set<String> paths = SELECTOR_MAPPING.get(selectorDataId);
            if (CollectionUtils.isNotEmpty(paths)) {
                SELECTOR_MAPPING.remove(selectorDataId);
                paths.forEach(path -> {
                    final List<SelectorData> selectorDataList = lruMap.get(path);
                    Optional.ofNullable(selectorDataList).ifPresent(list -> list.removeIf(e -> e.getId().equals(selectorDataId)));
                    if (CollectionUtils.isEmpty(selectorDataList)) {
                        lruMap.remove(path);
                    }
                });
            }
            cleanSelectorNullList(lruMap);
        }
    }

    /**
     * clean selector Null list.
     *
     * @param lruMap the lruMap
     */
    private void cleanSelectorNullList(LRUMap<String, List<SelectorData>> lruMap) {
        List<String> removeNuLLList = new ArrayList<>();
        lruMap.forEach((key, value) -> {
            if (CollectionUtils.isEmpty(value)) {
                removeNuLLList.add(key);
            }
        });
        removeNuLLList.forEach(lruMap::remove);
    }

    /**
     * clean rule Null list.
     *
     * @param lruMap the lruMap
     */
    private void cleanRuleNullList(LRUMap<String, List<RuleData>> lruMap) {
        List<String> removeNuLLList = new ArrayList<>();
        lruMap.forEach((key, value) -> {
            if (CollectionUtils.isEmpty(value)) {
                removeNuLLList.add(key);
            }
        });
        removeNuLLList.forEach(lruMap::remove);
    }

    /**
     * Remove rule data.
     *
     * @param ruleData the rule data
     */
    public void removeRuleData(final RuleData ruleData) {
        final LRUMap<String, List<RuleData>> lruMap = RULE_DATA_MAP.get(ruleData.getPluginName());
        final String ruleDataId = ruleData.getId();
        if (Objects.nonNull(lruMap)) {
            // If the rule has been deleted or changed, need to delete the cache.
            Set<String> paths = RULE_MAPPING.get(ruleDataId);
            if (CollectionUtils.isNotEmpty(paths)) {
                RULE_MAPPING.remove(ruleDataId);
                paths.forEach(path -> {
                    final List<RuleData> ruleDataList = lruMap.get(path);
                    Optional.ofNullable(ruleDataList).ifPresent(list -> list.removeIf(e -> e.getId().equals(ruleDataId)));
                    if (CollectionUtils.isEmpty(ruleDataList)) {
                        lruMap.remove(path);
                    }
                });
            }
            cleanRuleNullList(lruMap);
        }
    }

    /**
     * Remove selector data by plugin name.
     *
     * @param pluginName the plugin name
     */
    public void removeSelectorDataByPluginName(final String pluginName) {
        SELECTOR_DATA_MAP.remove(pluginName);
        SELECTOR_MAPPING.clear();
    }

    /**
     * Remove rule data by selector id.
     *
     * @param selectorId the selector id
     */
    public void removeRuleDataBySelectorId(final String selectorId) {
        RULE_DATA_MAP.remove(selectorId);
        RULE_MAPPING.clear();
    }

    /**
     * Clean selector data.
     */
    public void cleanSelectorData() {
        SELECTOR_DATA_MAP.clear();
        SELECTOR_MAPPING.clear();
    }

    /**
     * Clean rule data.
     */
    public void cleanRuleData() {
        RULE_DATA_MAP.clear();
        RULE_MAPPING.clear();
    }

    /**
     * Cache selector data.
     *
     * @param path         the path
     * @param selectorData the selector data
     * @param maxMemory    the max memory
     */
    public void cacheSelectorData(final String path, final SelectorData selectorData, final Integer maxMemory) {
        final LRUMap<String, List<SelectorData>> lruMap = SELECTOR_DATA_MAP.computeIfAbsent(selectorData.getPluginName(),
                map -> new MemorySafeLRUMap<>(maxMemory, 1 << 16));
        List<SelectorData> selectorDataList = lruMap.computeIfAbsent(path, list -> Collections.synchronizedList(new ArrayList<>()));
        if (StringUtils.isNoneBlank(selectorData.getId())) {
            selectorDataList.add(selectorData);
            SELECTOR_MAPPING.computeIfAbsent(selectorData.getId(), set -> new ConcurrentSkipListSet<>()).add(path);
        }
    }

    /**
     * Cache rule data.
     *
     * @param path      the path
     * @param ruleData  the rule data
     * @param maxMemory the max memory
     */
    public void cacheRuleData(final String path, final RuleData ruleData, final Integer maxMemory) {
        final LRUMap<String, List<RuleData>> lruMap = RULE_DATA_MAP.computeIfAbsent(ruleData.getPluginName(),
                map -> new MemorySafeLRUMap<>(maxMemory, 1 << 16));
        List<RuleData> ruleDataList = lruMap.computeIfAbsent(path, list -> Collections.synchronizedList(new ArrayList<>()));
        if (StringUtils.isNoneBlank(ruleData.getId())) {
            ruleDataList.add(ruleData);
            RULE_MAPPING.computeIfAbsent(ruleData.getId(), set -> new ConcurrentSkipListSet<>()).add(path);
        }
    }

    /**
     * Obtain selector data.
     *
     * @param pluginName the pluginName
     * @param path       the path
     * @return the selector data
     */
    public List<SelectorData> obtainSelectorData(final String pluginName, final String path) {
        List<SelectorData> selectorDataList = null;
        final LRUMap<String, List<SelectorData>> lruMap = SELECTOR_DATA_MAP.get(pluginName);
        if (Objects.nonNull(lruMap)) {
            selectorDataList = lruMap.get(path);
        }
        return selectorDataList;
    }

    /**
     * Obtain rule data.
     *
     * @param pluginName the pluginName
     * @param path       the path
     * @return the rule data
     */
    public List<RuleData> obtainRuleData(final String pluginName, final String path) {
        List<RuleData> ruleDataList = null;
        final LRUMap<String, List<RuleData>> lruMap = RULE_DATA_MAP.get(pluginName);
        if (Objects.nonNull(lruMap)) {
            ruleDataList = lruMap.get(path);
        }
        return ruleDataList;
    }
}
