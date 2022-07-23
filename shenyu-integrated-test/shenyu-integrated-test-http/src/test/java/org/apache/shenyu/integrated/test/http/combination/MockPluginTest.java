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

package org.apache.shenyu.integrated.test.http.combination;


import org.apache.shenyu.common.dto.ConditionData;
import org.apache.shenyu.common.enums.OperatorEnum;
import org.apache.shenyu.common.enums.ParamTypeEnum;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.integratedtest.common.AbstractPluginDataInit;
import org.apache.shenyu.integratedtest.common.helper.HttpHelper;
import org.apache.shenyu.web.controller.LocalPluginController;
import org.hamcrest.BaseMatcher;
import org.hamcrest.Description;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.*;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

public class MockPluginTest extends AbstractPluginDataInit {

    @BeforeAll
    public static void setup() throws IOException {
        String pluginResult = initPlugin(PluginEnum.MOCK.getName(), "");
        assertThat(pluginResult, is("success"));
        String selectorAndRulesResult = initSelectorAndRules(PluginEnum.MOCK.getName(), "", buildSelectorConditionList(), buildRuleLocalDataList());
        assertThat(selectorAndRulesResult, is("success"));
    }

    @Test
    public void testFixContentMock() throws IOException {
        final String testPath = "/http/test/fix";
        Map<String, Object> correctResponse = HttpHelper.INSTANCE.getFromGateway(testPath, new HashMap<>(), Map.class);
        assertThat(correctResponse.get("user"), is("test"));
    }

    @Test
    public void testPlaceholderContentMock() throws IOException {
        final String testPath = "/http/test/placeholder";
        Map<String, Object> correctResponse = HttpHelper.INSTANCE.getFromGateway(testPath, new HashMap<>(), Map.class);
        assertThat(correctResponse.get("number"),   new BaseMatcher<Object>() {
            @Override
            public void describeTo(Description description) {

            }

            @Override
            public boolean matches(Object o) {
                if (!(o instanceof Integer)) {
                    return false;
                }
                int result = (int) o;
                return result >= 10 && result <= 20;
            }
        });
    }


    private static List<ConditionData> buildSelectorConditionList() {
        ConditionData conditionData = new ConditionData();
        conditionData.setParamType(ParamTypeEnum.URI.getName());
        conditionData.setOperator(OperatorEnum.MATCH.getAlias());
        conditionData.setParamValue("/http/**");
        return Collections.singletonList(conditionData);
    }

    private static List<LocalPluginController.RuleLocalData> buildRuleLocalDataList() {
        List<LocalPluginController.RuleLocalData> ruleLocalDataList = new ArrayList<>();
        ruleLocalDataList.add(buildRuleLocalData("/http/test/fix",
                "{\"httpStatusCode\":200,\"responseContent\":\"{\\\"user\\\":\\\"test\\\"}\"}"));
        ruleLocalDataList.add(buildRuleLocalData("/http/test/placeholder",
                "{\"httpStatusCode\":200,\"responseContent\":\"{\\\"number\\\":${int|10-20}}\"}"));
        return ruleLocalDataList;
    }

    private static LocalPluginController.RuleLocalData buildRuleLocalData(final String paramValue, final String ruleHandle) {
        ConditionData conditionData = new ConditionData();
        conditionData.setParamType(ParamTypeEnum.URI.getName());
        conditionData.setOperator(OperatorEnum.EQ.getAlias());
        conditionData.setParamValue(paramValue);
        LocalPluginController.RuleLocalData ruleLocalData = new LocalPluginController.RuleLocalData();
        ruleLocalData.setConditionDataList(Collections.singletonList(conditionData));
        ruleLocalData.setRuleHandler(ruleHandle);
        return ruleLocalData;
    }

    @AfterAll
    public static void clean() throws IOException {
        cleanPluginData(PluginEnum.MOCK.getName());
    }

}
