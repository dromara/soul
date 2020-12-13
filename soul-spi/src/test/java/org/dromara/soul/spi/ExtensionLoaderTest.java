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

package org.dromara.soul.spi;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.dromara.soul.spi.fixture.HasDefaultSPI;
import org.dromara.soul.spi.fixture.JdbcSPI;
import org.dromara.soul.spi.fixture.MysqlSPI;
import org.dromara.soul.spi.fixture.NoClassMatchSPI;
import org.dromara.soul.spi.fixture.NoJoinSPI;
import org.dromara.soul.spi.fixture.NopSPI;
import org.dromara.soul.spi.fixture.NotMatchSPI;
import org.dromara.soul.spi.fixture.SubHasDefaultSPI;
import org.hamcrest.CoreMatchers;
import org.junit.Test;

public final class ExtensionLoaderTest {

    @Test
    public void testSPI() {
        JdbcSPI jdbcSPI = ExtensionLoader.getExtensionLoader(JdbcSPI.class).getJoin("mysql");
        assertThat(jdbcSPI.getClass().getName(), is(MysqlSPI.class.getName()));
    }

    /**
     * test SPI has default value case.
     */
    @Test
    public void testSPIGetDefaultJoin() {
        HasDefaultSPI spi = ExtensionLoader.getExtensionLoader(HasDefaultSPI.class).getDefaultJoin();
        assert spi != null;
        assertThat(spi.getClass().getName(), is(SubHasDefaultSPI.class.getName()));
    }

    /**
     * test SPI no default value case.
     */
    @Test
    public void testSPINoDefaultJoin() {
        JdbcSPI jdbcSPI = ExtensionLoader.getExtensionLoader(JdbcSPI.class).getDefaultJoin();
        assertNull(jdbcSPI);
    }

    /**
     * test ExtensionLoader.getJoin() blank name param case.
     */
    @Test
    public void testSPIGetJoinNameIsBlank() {
        try {
            ExtensionLoader.getExtensionLoader(JdbcSPI.class).getJoin("");
            fail();
        } catch (NullPointerException expected) {
            assertThat(expected.getMessage(),
                    CoreMatchers.containsString("get join name is null"));
        }
    }

    /**
     * test ExtensionLoader.getExtensionLoader() null param case.
     */
    @Test
    public void testGetExtensionLoaderIsNull() {
        try {
            ExtensionLoader.getExtensionLoader(null);
            fail();
        } catch (NullPointerException expected) {
            assertThat(expected.getMessage(),
                    CoreMatchers.containsString("extension clazz is null"));
        }
    }

    /**
     * test ExtensionLoader.getExtensionLoader() param is not interface case.
     */
    @Test
    public void testGetExtensionLoaderNotInterface() {
        try {
            ExtensionLoader.getExtensionLoader(ExtensionLoaderTest.class);
            fail();
        } catch (IllegalArgumentException expected) {
            assertThat(expected.getMessage(),
                    CoreMatchers.containsString("extension clazz (class org.dromara.soul.spi.ExtensionLoaderTest) is not interface!"));
        }
    }

    /**
     * test ExtensionLoader.getExtensionLoader() param is not have SPI annotation case.
     */
    @Test
    public void testGetExtensionLoaderNotSpiAnnotation() {
        try {
            ExtensionLoader.getExtensionLoader(NopSPI.class);
            fail();
        } catch (IllegalArgumentException expected) {
            assertThat(expected.getMessage(),
                    CoreMatchers.containsString("extension clazz (interface org.dromara.soul.spi.fixture.NopSPI) without @interface org.dromara.soul.spi.SPI Annotation"));
        }
    }

    /**
     * test ExtensionLoader.getJoin() param nonentity SPI name case.
     */
    @Test
    public void testGetExtensionLoaderNonentitySPIName() {
        try {
            ExtensionLoader.getExtensionLoader(JdbcSPI.class).getJoin("nonentitySPIName");
            fail();
        } catch (IllegalArgumentException expected) {
            assertThat(expected.getMessage(), CoreMatchers.containsString("name is error"));
        }
    }

    /**
     * test ExtensionLoader.getJoin() param name not interface subType case.
     */
    @Test
    public void testGetExtensionLoaderSPISubTypeNotMatchInterface() {
        try {
            ExtensionLoader.getExtensionLoader(NotMatchSPI.class).getJoin("subNoJoinSPI");
            fail();
        } catch (IllegalStateException expected) {
            assertThat(expected.getMessage(), CoreMatchers.containsString(
                    "load extension resources error,class org.dromara.soul.spi.fixture.SubNoJoinSPI subtype is not of interface org.dromara.soul.spi.fixture.NotMatchSPI"));
        }
    }

    /**
     * test ExtensionLoader.getJoin() param name no class match case.
     */
    @Test
    public void testGetExtensionLoaderNoClassMatchSPI() {
        try {
            ExtensionLoader.getExtensionLoader(NoClassMatchSPI.class).getJoin("subNoClassMatchSPI");
            fail();
        } catch (IllegalStateException expected) {
            assertThat(expected.getMessage(), CoreMatchers.containsString("load extension resources error"));
        }
    }

    /**
     * test ExtensionLoader.getJoin() param no join case.
     */
    @Test
    public void testGetExtensionLoaderNoJoinSPI() {
        try {
            ExtensionLoader.getExtensionLoader(NoJoinSPI.class).getJoin("subNoJoinSPI");
            fail();
        } catch (IllegalStateException expected) {
            assertThat(expected.getMessage(), CoreMatchers.containsString("load extension resources error,class org.dromara.soul.spi.fixture.SubNoJoinSPI with Join annotation"));
        }
    }

    /**
     * test ExtensionLoader.getJoin() param SPI class can not instantiated case.
     */
    @Test
    public void testGetExtensionLoaderCanNotInstantiatedSPI() {
        try {
            ExtensionLoader.getExtensionLoader(JdbcSPI.class).getJoin("canNotInstantiated");
            fail();
        } catch (IllegalStateException expected) {
            assertThat(expected.getMessage(), CoreMatchers.containsString(
                    "Extension instance(name: canNotInstantiated, class: class org.dromara.soul.spi.fixture.CanNotInstantiatedSPI)  "
                            + "could not be instantiated: Class org.dromara.soul.spi.ExtensionLoader "
                            + "can not access a member of class org.dromara.soul.spi.fixture.CanNotInstantiatedSPI with modifiers \"private\""));
        }
    }

    /**
     * test loadClass duplicate class case.
     */
    @Test
    public void testLoadClassDuplicateKey() throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Method loadClassMethod = getLoadClassMethod();
        ExtensionLoader extensionLoader = ExtensionLoader.getExtensionLoader(JdbcSPI.class);
        Map<String, Class<?>> classes = new HashMap<>();
        loadClassMethod.invoke(extensionLoader, classes, "mysql", "org.dromara.soul.spi.fixture.MysqlSPI");
        try {
            loadClassMethod.invoke(extensionLoader, classes, "mysql", "org.dromara.soul.spi.fixture.OracleSPI");
            fail();
        } catch (InvocationTargetException expect) {
            assertThat(expect.getTargetException().getMessage(), CoreMatchers.containsString(
                    "load extension resources error,Duplicate class org.dromara.soul.spi.fixture.JdbcSPI name mysql on "
                            + "org.dromara.soul.spi.fixture.MysqlSPI ororg.dromara.soul.spi.fixture.OracleSPI"));
        }
    }

    /**
     * test loadResources url IO Exception case.
     */
    @Test
    public void loadResourcesIOException()
            throws NoSuchMethodException, MalformedURLException, IllegalAccessException {
        Method loadResourcesMethod = getLoadResources();
        ExtensionLoader extensionLoader = ExtensionLoader.getExtensionLoader(JdbcSPI.class);
        try {
            loadResourcesMethod.invoke(extensionLoader, new HashMap<>(),
                    new URL("file:/org.dromara.soul.spi.fixture.NoExistSPI"));
            fail();
        } catch (InvocationTargetException expect) {
            assertThat(expect.getTargetException().getMessage(), CoreMatchers.containsString("load extension resources error"));
        }
    }

    /**
     * get private loadClass method.
     */
    private Method getLoadClassMethod() throws NoSuchMethodException {
        Method method = ExtensionLoader.class.getDeclaredMethod("loadClass", Map.class, String.class, String.class);
        method.setAccessible(true);
        return method;
    }

    /**
     * get private loadResources method.
     */
    private Method getLoadResources() throws NoSuchMethodException {
        Method method = ExtensionLoader.class.getDeclaredMethod("loadResources", Map.class, URL.class);
        method.setAccessible(true);
        return method;
    }
}
