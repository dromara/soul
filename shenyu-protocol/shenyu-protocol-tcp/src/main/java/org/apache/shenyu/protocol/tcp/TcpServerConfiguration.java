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

package org.apache.shenyu.protocol.tcp;

import java.util.Properties;

/**
 * tcp server configuration.
 */
public class TcpServerConfiguration {

    private String pluginSelectorName;

    private int port = 9500;


    private Properties props = new Properties();

    /**
     * getPluginSelectorName.
     *
     * @return pluginSelectorName
     */
    public String getPluginSelectorName() {
        return pluginSelectorName;
    }

    /**
     * setPluginSelectorName.
     *
     * @param pluginSelectorName pluginSelectorName
     */
    public void setPluginSelectorName(final String pluginSelectorName) {
        this.pluginSelectorName = pluginSelectorName;
    }

    /**
     * get port.
     *
     * @return port
     */
    public int getPort() {
        return port;
    }

    /**
     * set port.
     *
     * @param port port
     */
    public void setPort(final int port) {
        this.port = port;
    }

    /**
     * getProps.
     *
     * @return props
     */
    public Properties getProps() {
        return props;
    }

    /**
     * setProps.
     *
     * @param props props
     */
    public void setProps(final Properties props) {
        this.props = props;
    }

}
