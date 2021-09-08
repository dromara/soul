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

package org.apache.shenyu.examples.tars.servant.testapp.impl;

import com.qq.tars.spring.annotation.TarsServant;
import org.apache.shenyu.client.tars.common.annotation.ShenyuTarsClient;
import org.apache.shenyu.client.tars.common.annotation.ShenyuTarsService;
import org.apache.shenyu.examples.tars.servant.testapp.HelloServant;

@TarsServant("HelloObj")
@ShenyuTarsService(serviceName = "ShenyuExampleServer.ShenyuExampleApp.HelloObj")
public class HelloServantImpl implements HelloServant {
    @Override
    @ShenyuTarsClient(path = "/hello", desc = "hello")
    public String hello(int no, String name) {
        return String.format("hello no=%s, name=%s, time=%s", no, name, System.currentTimeMillis());
    }

    @Override
    @ShenyuTarsClient(path = "/helloInt", desc = "helloInt")
    public int helloInt(int no, String name) {
        return 1;
    }

    @Override
    @ShenyuTarsClient(path = "/helloIntUnWrap", desc = "helloIntUnWrap", wrap = false)
    public int helloIntUnWrap(int no, String name) {
        return 1;
    }
}
