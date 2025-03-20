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

package org.apache.shenyu.web.loader;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.net.URL;
import java.util.Optional;

/**
 * The type Shenyu plugin path builder.
 */
public final class ShenyuPluginPathBuilder {

    private static final String PLUGIN_PATH = "plugin-ext";
    
    private static final String DEFAULT_EXT_PLUGIN_PATH = "ext-lib/";

    private ShenyuPluginPathBuilder() {
    }

    /**
     * Gets plugin file.
     *
     * @param path the path
     * @return the plugin jar file.
     */
    public static File getPluginFile(final String path) {
        String pluginPath = getPluginPath(path);
        return new File(pluginPath);
    }
    
    /**
     * Gets plugin path.
     *
     * @param path the path
     * @return the plugin path
     */
    public static String getPluginPath(final String path) {
        if (StringUtils.isNotEmpty(path)) {
            return path;
        }
        String pluginPath = System.getProperty(PLUGIN_PATH);
        if (StringUtils.isNotEmpty(pluginPath)) {
            return pluginPath;
        }
        URL resource = ShenyuPluginPathBuilder.class.getResource(DEFAULT_EXT_PLUGIN_PATH);
        return Optional.ofNullable(resource).map(URL::getPath).orElse(DEFAULT_EXT_PLUGIN_PATH);
    }
}
