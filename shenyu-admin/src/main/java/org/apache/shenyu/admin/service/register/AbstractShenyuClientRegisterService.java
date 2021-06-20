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

package org.apache.shenyu.admin.service.register;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.model.dto.RuleConditionDTO;
import org.apache.shenyu.admin.model.dto.RuleDTO;
import org.apache.shenyu.admin.model.dto.SelectorConditionDTO;
import org.apache.shenyu.admin.model.dto.SelectorDTO;
import org.apache.shenyu.admin.model.entity.MetaDataDO;
import org.apache.shenyu.common.dto.convert.DivideUpstream;
import org.apache.shenyu.common.dto.convert.rule.RuleHandle;
import org.apache.shenyu.common.dto.convert.rule.RuleHandleFactory;
import org.apache.shenyu.common.enums.MatchModeEnum;
import org.apache.shenyu.common.enums.OperatorEnum;
import org.apache.shenyu.common.enums.ParamTypeEnum;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.enums.SelectorTypeEnum;
import org.apache.shenyu.register.common.dto.MetaDataRegisterDTO;

import java.util.Collections;
import java.util.List;

/**
 * Abstract strategy.
 */
public abstract class AbstractShenyuClientRegisterService implements ShenyuClientRegisterServiceFactory {

    protected static final String CONTEXT_PATH_NAME_PREFIX = "/context-path";

    /**
     * save or update meta data.
     *
     * @param exist       has been exist meta data {@link MetaDataDO}
     * @param metaDataDTO meta data dto {@link MetaDataRegisterDTO}
     */
    protected abstract void saveOrUpdateMetaData(MetaDataDO exist, MetaDataRegisterDTO metaDataDTO);

    /**
     * handler selector.
     *
     * @param metaDataDTO meta data register dto {@link MetaDataRegisterDTO}
     * @return primary key of selector
     */
    protected abstract String handlerSelector(MetaDataRegisterDTO metaDataDTO);

    /**
     * handler rule.
     *
     * @param selectorId  the primary key of selector
     * @param metaDataDTO meta data dto {@link MetaDataRegisterDTO}
     * @param exist       has been exist meta data {@link MetaDataDO}
     */
    protected abstract void handlerRule(String selectorId, MetaDataRegisterDTO metaDataDTO, MetaDataDO exist);

    /**
     * get plugin's id from plugin's name.
     *
     * @param pluginName plugin's name
     * @return plugin's id
     */
    protected abstract String getPluginId(String pluginName);

    @Override
    public String registerURI(final String contextPath, final List<String> uriList) {
        return null;
    }

    protected SelectorDTO registerRpcSelector(final String contextPath, final String rpcType) {
        SelectorDTO selectorDTO = buildDefaultSelectorDTO(contextPath);
        selectorDTO.setPluginId(getPluginId(rpcType));
        selectorDTO.setSelectorConditions(buildDefaultSelectorConditionDTO(contextPath));
        return selectorDTO;
    }

    protected RuleDTO registerRpcRule(final String selectorId, final String path, final String pluginName, final String ruleName) {
        RuleHandle ruleHandle = pluginName.equals(PluginEnum.CONTEXT_PATH.getName())
                ? RuleHandleFactory.ruleHandle(pluginName, buildContextPath(path)) : RuleHandleFactory.ruleHandle(pluginName, path);
        RuleDTO ruleDTO = RuleDTO.builder()
                .selectorId(selectorId)
                .name(ruleName)
                .matchMode(MatchModeEnum.AND.getCode())
                .enabled(Boolean.TRUE)
                .loged(Boolean.TRUE)
                .sort(1)
                .handle(ruleHandle.toJson())
                .build();
        RuleConditionDTO ruleConditionDTO = RuleConditionDTO.builder()
                .paramType(ParamTypeEnum.URI.getName())
                .paramName("/")
                .paramValue(path)
                .build();
        if (path.indexOf("*") > 1) {
            ruleConditionDTO.setOperator(OperatorEnum.MATCH.getAlias());
        } else {
            ruleConditionDTO.setOperator(OperatorEnum.EQ.getAlias());
        }
        ruleDTO.setRuleConditions(Collections.singletonList(ruleConditionDTO));
        return ruleDTO;
    }

    protected List<SelectorConditionDTO> buildDefaultSelectorConditionDTO(final String contextPath) {
        SelectorConditionDTO selectorConditionDTO = new SelectorConditionDTO();
        selectorConditionDTO.setParamType(ParamTypeEnum.URI.getName());
        selectorConditionDTO.setParamName("/");
        selectorConditionDTO.setOperator(OperatorEnum.MATCH.getAlias());
        selectorConditionDTO.setParamValue(contextPath + "/**");
        return Collections.singletonList(selectorConditionDTO);
    }

    protected String buildContextPath(final String path) {
        String split = "/";
        String[] splitList = StringUtils.split(path, split);
        if (splitList.length != 0) {
            return split.concat(splitList[0]);
        }
        return split;
    }

    protected SelectorDTO buildDefaultSelectorDTO(final String name) {
        return SelectorDTO.builder()
                .name(name)
                .type(SelectorTypeEnum.CUSTOM_FLOW.getCode())
                .matchMode(MatchModeEnum.AND.getCode())
                .enabled(Boolean.TRUE)
                .loged(Boolean.TRUE)
                .continued(Boolean.TRUE)
                .sort(1)
                .build();
    }

    protected DivideUpstream buildDivideUpstream(final String uri) {
        return DivideUpstream.builder().upstreamHost("localhost").protocol("http://").upstreamUrl(uri).weight(50).build();
    }
}
