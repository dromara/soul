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

package org.apache.shenyu.agent.bootstrap.loader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.security.CodeSource;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

/**
 * AgentClassLoader.
 */
public class AgentClassLoader extends ClassLoader {

    private static final Logger LOGGER = LoggerFactory.getLogger(AgentClassLoader.class);

    static {
        /*
         * Try to solve the classloader dead lock.
         */
        registerAsParallelCapable();
    }

    private static File agentFile;

    private final JarFile jarFile;

    private final String jarName;

    public AgentClassLoader(final Class agentClass, final ClassLoader agentParent, final String jarName) throws IOException, URISyntaxException {
        super(agentParent);
        this.jarName = jarName;
        agentFile = getJarFile(agentClass);
        jarFile = new JarFile(agentFile, false);
    }

    @Override
    protected Class<?> findClass(final String name) throws ClassNotFoundException {
        String path = name.replace('.', '/').concat(".class");
        JarEntry jarEntry = findJarEntry(path);
        if (jarEntry != null) {
            try {
                URL classFileUrl = new URL("jar:file:" + agentFile.getAbsolutePath() + "!/" + path);
                byte[] data;
                try (BufferedInputStream is = new BufferedInputStream(
                        classFileUrl.openStream()); ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                    int ch;
                    while ((ch = is.read()) != -1) {
                        baos.write(ch);
                    }
                    data = baos.toByteArray();
                }
                return defineClass(name, data, 0, data.length);
            } catch (IOException e) {
                LOGGER.error("find class fail.", e);
            }
        }
        // find class from agent initializer jar
        return super.findClass(name);

    }

    private JarEntry findJarEntry(final String patch) {

        return jarFile.getJarEntry(patch);
    }

    private File getJarFile(final Class agentClass) {
        CodeSource codeSource = agentClass.getProtectionDomain().getCodeSource();

        if (codeSource == null) {
            throw new IllegalStateException("could not get agent jar location");
        }
        String file = codeSource.getLocation().getFile();
        String target = file.substring(0, file.indexOf("class"));

        File javaagentFile = new File(target, jarName.concat(".jar"));

        if (!javaagentFile.isFile()) {
            throw new IllegalStateException(
                    "agent jar location doesn't appear to be a file: " + javaagentFile.getAbsolutePath());
        }

        return javaagentFile;
    }
}
