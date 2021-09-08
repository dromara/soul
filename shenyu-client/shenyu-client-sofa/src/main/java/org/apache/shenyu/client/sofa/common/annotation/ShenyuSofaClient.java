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

package org.apache.shenyu.client.sofa.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * The interface shenyu client.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.METHOD})
@Inherited
public @interface ShenyuSofaClient {
    /**
     * Path string.
     *
     * @return the string
     */
    String path();

    /**
     * Rule name string.
     *
     * @return the string
     */
    String ruleName() default "";

    /**
     * Desc string.
     *
     * @return String string
     */
    String desc() default "";

    /**
     * Enabled boolean.
     *
     * @return the boolean
     */
    boolean enabled() default true;

    /**
     * wrap the rpc response.
     *
     * @return the boolean
     */
    boolean wrap() default true;

    /**
     * LoadBalance string.
     *
     * @return the boolean
     */
    String loadBalance() default "hash";

    /**
     * Timeout long.
     *
     * @return the timeout
     */
    int timeout() default -1;

    /**
     * Retries int.
     *
     * @return the retries
     */
    int retries() default 3;
}
