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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Optional;

/**
 * The type Shenyu plugin path builder.
 */
public final class ShenyuPluginPathBuilder {
    
    private static final Logger LOG = LoggerFactory.getLogger(ShenyuPluginPathBuilder.class);
    
    private static final String PLUGIN_PATH = "plugin-ext";
    
    private static final String DEFAULT_EXT_PLUGIN_PATH = "/ext-lib/";
    
    private static final String FILE_PRE = "file:";
    
    /**
     * Gets plugin path.
     *
     * @param path the path
     * @return the plugin path
     */
    public static File getPluginPath(final String path) {
        if (StringUtils.isNotEmpty(path)) {
            return new File(path);
        }
        String pluginPath = System.getProperty(PLUGIN_PATH);
        if (StringUtils.isNotEmpty(pluginPath)) {
            return new File(pluginPath);
        }
        return buildPluginJarPath();
    }
    
    private static File buildPluginJarPath() {
        URL url = ShenyuPluginPathBuilder.class.getResource(DEFAULT_EXT_PLUGIN_PATH);
        return Optional.ofNullable(url).map(u -> new File(u.getFile())).orElse(new File(DEFAULT_EXT_PLUGIN_PATH));
    }
    
    private static File getFileInResource(final String url, final String classResourcePath) {
        int prefixLength = FILE_PRE.length();
        String classLocation = url.substring(prefixLength, url.length() - classResourcePath.length());
        return new File(classLocation);
    }
    
    private static File getFileInJar(final String url, final int fileInJarIndex) {
        String realUrl = url.substring(url.indexOf(FILE_PRE), fileInJarIndex);
        try {
            File jarFile = new File(new URL(realUrl).toURI());
            return jarFile.exists() ? jarFile.getParentFile() : null;
        } catch (final MalformedURLException | URISyntaxException ex) {
            LOG.error(String.format("Can not locate shenyu plugin jar file by url %s", url), ex);
            return null;
        }
    }
}
