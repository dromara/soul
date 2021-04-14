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

package org.dromara.soul.common.dto.convert.rule.impl;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.dromara.soul.common.constant.Constants;
import org.dromara.soul.common.dto.convert.rule.RuleHandle;

/**
 * The type Spring cloud rule handle.
 *
 * @author xiaoyu(Myth)
 */
@ToString
@Getter
@Setter
@NoArgsConstructor
public class SpringCloudRuleHandle implements RuleHandle {

    private static final long serialVersionUID = 269429745060607954L;

    /**
     * this remote uri path.
     */
    private String path;

    /**
     * timeout is required.
     */
    private long timeout = Constants.TIME_OUT;

    @Override
    public RuleHandle createDefault(final String path) {
        this.path = path;
        return this;
    }
}
