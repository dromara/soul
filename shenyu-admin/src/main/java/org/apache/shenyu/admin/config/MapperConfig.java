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

package org.apache.shenyu.admin.config;

import org.apache.shenyu.admin.mybatis.oracle.OracleSqlQueryInterceptor;
import org.apache.shenyu.admin.mybatis.pg.interceptor.PostgreSqlQueryInterceptor;
import org.apache.shenyu.admin.mybatis.pg.interceptor.PostgreSqlUpdateInterceptor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


/**
 *  for MyBatis Configure management.
 */
@Configuration
public class MapperConfig {

    /**
     * Add the plugin to the MyBatis plugin interceptor chain.
     *
     * @return {@linkplain PostgreSqlQueryInterceptor}
     */
    @Bean
    @ConditionalOnProperty(name = "shenyu.database.dialect", havingValue = "postgresql")
    public PostgreSqlQueryInterceptor postgreSqlQueryInterceptor() {
        return new PostgreSqlQueryInterceptor();
    }

    /**
     * Add the plugin to the MyBatis plugin interceptor chain.
     *
     * @return {@linkplain OracleSqlQueryInterceptor}
     */
    @Bean
    @ConditionalOnProperty(name = "shenyu.database.dialect", havingValue = "oracle")
    public OracleSqlQueryInterceptor oracleSqlQueryInterceptor() {
        return new OracleSqlQueryInterceptor();
    }

    /**
     * Add the plugin to the MyBatis plugin interceptor chain.
     *
     * @return {@linkplain PostgreSqlUpdateInterceptor}
     */
    @Bean
    @ConditionalOnProperty(name = "shenyu.database.dialect", havingValue = "postgresql")
    public PostgreSqlUpdateInterceptor postgreSqlUpdateInterceptor() {
        return new PostgreSqlUpdateInterceptor();
    }
}
