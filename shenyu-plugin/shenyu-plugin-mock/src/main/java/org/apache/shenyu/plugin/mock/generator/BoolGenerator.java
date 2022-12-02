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

package org.apache.shenyu.plugin.mock.generator;

import org.apache.shenyu.plugin.mock.util.MockUtil;
import org.apache.shenyu.spi.Join;

import java.util.List;

/**
 * Boolean Generator.
 */
@Join
public class BoolGenerator implements Generator<Boolean> {

    @Override
    public String getName() {
        return "bool";
    }

    @Override
    public Boolean doGenerate(final List<String> params, final String rule) {
        return MockUtil.bool();
    }

    @Override
    public int getParamSize() {
        return 0;
    }

    @Override
    public boolean match(final String rule) {
        return rule.matches("^bool$");
    }
}
