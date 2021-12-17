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

package org.apache.shenyu.plugin.base.condition.data;

import org.apache.shenyu.common.dto.ConditionData;
import org.apache.shenyu.spi.SPI;
import org.springframework.web.server.ServerWebExchange;

/**
 * The interface Parameter data.
 */
@SPI
public interface ParameterData {

    /**
     * Builder string.
     *
     * @param paramName the param name
     * @param exchange  the exchange
     * @return the string
     */
    default String builder(final String paramName, final ServerWebExchange exchange) {
        return "";
    }


    /**
     * Judge type for contains,
     * different Param Type have own comparison method.
     *
     * @param conditionData the rule conditionData
     * @param realData      the request's realData
     * @return {@link Boolean}
     */
    default Boolean containsJudge(final ConditionData conditionData, final String realData) {
        return conditionData.getParamValue().trim().contains(realData);
    }
}
