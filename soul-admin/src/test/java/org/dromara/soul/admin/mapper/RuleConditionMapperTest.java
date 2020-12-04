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

package org.dromara.soul.admin.mapper;

import org.dromara.soul.admin.AbstractSpringIntegrationTest;
import org.dromara.soul.admin.entity.RuleConditionDO;
import org.dromara.soul.admin.query.RuleConditionQuery;
import org.dromara.soul.common.utils.UUIDUtils;
import org.junit.Before;
import org.junit.Test;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import static org.hamcrest.Matchers.greaterThan;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertThat;

/**
 * Test cases for RuleConditionMapper.
 *
 * @author Andy-86
 */
public class RuleConditionMapperTest extends AbstractSpringIntegrationTest {

    @Resource
    private RuleConditionMapper ruleConditionMapper;

    private RuleConditionDO record = buildRuleConditionDo();

    @Before
    public void before() {
        int count = ruleConditionMapper.insert(record);
        assertEquals(1, count);
    }

    @Test
    public void selectById() {
        RuleConditionDO rule = ruleConditionMapper.selectById(record.getId());
        assertNotNull(rule);
    }

    @Test
    public void selectByQuery() {
        RuleConditionQuery ruleConditionQuery = new RuleConditionQuery(record.getRuleId());
        List<RuleConditionDO> rules = ruleConditionMapper.selectByQuery(ruleConditionQuery);
        assertThat(rules.size(), greaterThan(0));

        List<RuleConditionDO> rulesWithoutRuleId = ruleConditionMapper.selectByQuery(null);
        assertThat(rulesWithoutRuleId.size(), greaterThan(0));
    }

    @Test
    public void insert() {
        RuleConditionDO newRecord = buildRuleConditionDo();
        int count = ruleConditionMapper.insert(newRecord);
        assertEquals(1, count);
    }

    @Test
    public void insertSelective() {
        RuleConditionDO newRecord = buildRuleConditionDo();
        int count = ruleConditionMapper.insertSelective(newRecord);
        assertEquals(1, count);
    }

    @Test
    public void update() {
        record.setParamType("post");
        Timestamp currentTimeStamp = Timestamp.valueOf(LocalDateTime.now());
        record.setDateUpdated(currentTimeStamp);
        int count = ruleConditionMapper.update(record);
        assertEquals(1, count);
    }

    @Test
    public void updateSelective() {
        record.setParamType("query");
        Timestamp currentTimeStamp = Timestamp.valueOf(LocalDateTime.now());
        record.setDateUpdated(currentTimeStamp);
        int count = ruleConditionMapper.updateSelective(record);
        assertEquals(1, count);
    }

    @Test
    public void delete() {
        RuleConditionDO newRecord = buildRuleConditionDo();
        int count = ruleConditionMapper.insert(newRecord);
        assertEquals(1, count);

        int deleteCount = ruleConditionMapper.delete(newRecord.getId());
        assertEquals(1, deleteCount);
    }

    @Test
    public void deleteByQuery() {
        RuleConditionDO newRecord = buildRuleConditionDo();
        int count = ruleConditionMapper.insert(newRecord);
        assertEquals(1, count);

        RuleConditionQuery ruleConditionQuery = new RuleConditionQuery(newRecord.getRuleId());
        int deleteCount = ruleConditionMapper.deleteByQuery(ruleConditionQuery);
        assertEquals(1, deleteCount);
    }

    /**
     * Create a new ruleCondition.
     *
     * @return new ruleCondition
     */
    public RuleConditionDO buildRuleConditionDo() {
        RuleConditionDO rule = new RuleConditionDO();
        String id = UUIDUtils.getInstance().generateShortUuid();
        rule.setId(id);
        String ruleId = UUIDUtils.getInstance().generateShortUuid();
        rule.setRuleId(ruleId);
        rule.setOperator("=");
        rule.setParamName("test_param");
        rule.setParamType("uri");
        rule.setParamValue("http");
        Timestamp currentTimeStamp = Timestamp.valueOf(LocalDateTime.now());
        rule.setDateUpdated(currentTimeStamp);
        rule.setDateCreated(currentTimeStamp);
        return rule;
    }
}
