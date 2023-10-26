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

package org.apache.shenyu.plugin.api.context;

import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.plugin.api.ExtendDataBase;

/**
 * The interface shenyu context decorator.
 */
public interface ShenyuContextDecorator extends ExtendDataBase {
    
    /**
     * Decorator shenyu context.
     *
     * @param shenyuContext the shenyu context
     * @param metaData the meta data
     * @return the shenyu context
     */
    ShenyuContext decorator(ShenyuContext shenyuContext, MetaData metaData);
    
    /**
     * Rpc type string.
     *
     * @return the string
     */
    default String rpcType() {
        return "http";
    }
}
