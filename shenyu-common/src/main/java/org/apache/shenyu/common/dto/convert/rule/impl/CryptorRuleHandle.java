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

package org.apache.shenyu.common.dto.convert.rule.impl;

import org.apache.shenyu.common.dto.convert.rule.RuleHandle;

/**
 * Cryptor response rule handle.
 */
public class CryptorRuleHandle implements RuleHandle {

    private String strategyName;

    private String decryptKey;

    private String encryptKey;

    private String fieldNames;

    private String way;

    /**
     * get strategyName.
     * @return strategyName
     */
    public String getStrategyName() {
        return strategyName;
    }

    /**
     * set strategyName.
     * @param strategyName strategyName
     */
    public void setStrategyName(final String strategyName) {
        this.strategyName = strategyName;
    }

    /**
     * get decryptKey.
     * @return decryptKey
     */
    public String getDecryptKey() {
        return decryptKey;
    }

    /**
     * set decryptKey.
     * @param decryptKey decryptKey
     */
    public void setDecryptKey(final String decryptKey) {
        this.decryptKey = decryptKey;
    }

    /**
     * get encryptKey.
     * @return encryptKey
     */
    public String getEncryptKey() {
        return encryptKey;
    }

    /**
     * set encryptKey.
     * @param encryptKey encryptKey
     */
    public void setEncryptKey(final String encryptKey) {
        this.encryptKey = encryptKey;
    }

    /**
     * get fieldNames.
     * @return fieldNames
     */
    public String getFieldNames() {
        return fieldNames;
    }

    /**
     * set fieldNames.
     * @param fieldNames fieldNames
     */
    public void setFieldNames(final String fieldNames) {
        this.fieldNames = fieldNames;
    }

    /**
     * set way.
     * @return way
     */
    public String getWay() {
        return way;
    }

    /**
     * set way.
     * @param way way
     */
    public void setWay(final String way) {
        this.way = way;
    }

    @Override
    public String toString() {
        return "CryptorResponseRuleHandle{"
                + "strategyName='" + strategyName + '\''
                + ", decryptKey='" + decryptKey + '\''
                + ", encryptKey='" + encryptKey + '\''
                + ", fieldNames='" + fieldNames + '\''
                + ", way='" + way + '\''
                + '}';
    }

    @Override
    public RuleHandle createDefault(final String path, final String rpcExt) {
        return this;
    }

}
