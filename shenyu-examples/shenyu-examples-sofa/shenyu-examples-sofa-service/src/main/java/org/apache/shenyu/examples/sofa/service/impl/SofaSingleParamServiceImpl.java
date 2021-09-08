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

package org.apache.shenyu.examples.sofa.service.impl;

import org.apache.shenyu.client.sofa.common.annotation.ShenyuSofaClient;
import org.apache.shenyu.examples.sofa.api.entity.SofaSimpleTypeBean;
import org.apache.shenyu.examples.sofa.api.service.SofaSingleParamService;
import org.springframework.stereotype.Service;

import java.util.Random;

/**
 * Sofa single param service.
 */
@Service("sofaSingleParamService")
public class SofaSingleParamServiceImpl implements SofaSingleParamService {

    @Override
    @ShenyuSofaClient(path = "/findById", desc = "Find by Id", wrap = false)
    public SofaSimpleTypeBean findById(final String id) {
        SofaSimpleTypeBean sofaSimpleTypeBean = new SofaSimpleTypeBean();
        sofaSimpleTypeBean.setId(id);
        sofaSimpleTypeBean.setName("hello world shenyu Sofa, findById");
        return sofaSimpleTypeBean;
    }

    @Override
    @ShenyuSofaClient(path = "/findAll", desc = "Get all data")
    public SofaSimpleTypeBean findAll() {
        SofaSimpleTypeBean sofaSimpleTypeBean = new SofaSimpleTypeBean();
        sofaSimpleTypeBean.setName("hello world shenyu Sofa , findAll");
        sofaSimpleTypeBean.setId(String.valueOf(new Random().nextInt()));
        return sofaSimpleTypeBean;
    }

    @Override
    @ShenyuSofaClient(path = "/insert", desc = "Insert a row of data")
    public SofaSimpleTypeBean insert(final SofaSimpleTypeBean sofaSimpleTypeBean) {
        sofaSimpleTypeBean.setName("hello world shenyu Sofa: " + sofaSimpleTypeBean.getName());
        return sofaSimpleTypeBean;
    }
}
