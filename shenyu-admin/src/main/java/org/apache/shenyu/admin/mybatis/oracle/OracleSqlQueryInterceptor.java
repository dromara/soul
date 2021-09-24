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

package org.apache.shenyu.admin.mybatis.oracle;

import org.apache.ibatis.cache.CacheKey;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.mapping.SqlSource;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.apache.shenyu.common.utils.ReflectUtils;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern;

/**
 * The limit syntax of oracleSql conflicts with that of mysql,
 * So use the interceptor to process the SQL syntax here.
 */
@Intercepts({
        @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}),
        @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class, CacheKey.class, BoundSql.class}),
        @Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class})
})
public class OracleSqlQueryInterceptor implements Interceptor {

    private static final String RESOURCE_PATTERN = "(\\bresource\\b)";

    @Override
    public Object intercept(final Invocation invocation) throws Throwable {
        Object[] args = invocation.getArgs();
        MappedStatement ms = (MappedStatement) args[0];
        Object parameter = args[1];
        Executor executor = (Executor) invocation.getTarget();
        BoundSql boundSql;
        CacheKey cacheKey;

        if (ms.getSqlCommandType().compareTo(SqlCommandType.SELECT) == 0) {
            RowBounds rowBounds = (RowBounds) args[2];
            ResultHandler<?> resultHandler = (ResultHandler<?>) args[3];

            if (args.length == 4) {
                boundSql = getProcessedBoundSql(ms, ms.getBoundSql(parameter));
                cacheKey = executor.createCacheKey(ms, parameter, rowBounds, boundSql);
            } else {
                cacheKey = (CacheKey) args[4];
                boundSql = getProcessedBoundSql(ms, (BoundSql) args[5]);
            }
            return executor.query(ms, parameter, rowBounds, resultHandler, cacheKey, boundSql);
        } else {
            boundSql = getProcessedBoundSql(ms, ms.getBoundSql(parameter));
            MappedStatement newMs = copyFromMappedStatement(ms, new BoundSqlSqlSource(boundSql));
            return executor.update(newMs, parameter);
        }
    }

    private BoundSql getProcessedBoundSql(final MappedStatement ms, final BoundSql boundSql) {
        BoundSql result;
        List<ParameterMapping> parameterMappings = boundSql.getParameterMappings();
        Configuration configuration = ms.getConfiguration();
        Object parameterObject = boundSql.getParameterObject();
        // Oracle does not support the mysql escape character {`}, so replace it with {"}.
        // Convert SQL statements to lowercase.
        String script = boundSql.getSql().replace("`", "\"").toLowerCase();

        if (Pattern.compile(RESOURCE_PATTERN).matcher(script).find()) {
            script = script.replaceAll(RESOURCE_PATTERN, "\"RESOURCE\"");
            result = new BoundSql(configuration, script, parameterMappings, parameterObject);
            // Resolve MyBatis interceptor plugin foreach parameter invalidation.
            this.copyParam(boundSql, result);
            return result;
        }
        result = new BoundSql(configuration, script, parameterMappings, parameterObject);
        // Resolve MyBatis interceptor plugin foreach parameter invalidation.
        this.copyParam(boundSql, result);
        return result;
    }

    @SuppressWarnings("unchecked")
    private void copyParam(final BoundSql oldSql, final BoundSql newSql) {
        if (ReflectUtils.getFieldValue(oldSql, "metaParameters") != null) {
            MetaObject mo = (MetaObject) ReflectUtils.getFieldValue(oldSql, "metaParameters");
            ReflectUtils.setFieldValue(newSql, "metaParameters", mo);
        }
        if (ReflectUtils.getFieldValue(oldSql, "additionalParameters") != null) {
            Map<String, Object> map = (Map<String, Object>) ReflectUtils.getFieldValue(oldSql, "additionalParameters");
            ReflectUtils.setFieldValue(newSql, "additionalParameters", map);
        }
    }

    @Override
    public Object plugin(final Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(final Properties properties) {
    }

    private MappedStatement copyFromMappedStatement(final MappedStatement ms, final SqlSource newSqlSource) {
        MappedStatement.Builder builder = new MappedStatement.Builder(ms.getConfiguration(), ms.getId(), newSqlSource, ms.getSqlCommandType());
        builder.resource(ms.getResource());
        builder.fetchSize(ms.getFetchSize());
        builder.statementType(ms.getStatementType());
        builder.keyGenerator(ms.getKeyGenerator());
        if (ms.getKeyProperties() != null && ms.getKeyProperties().length > 0) {
            builder.keyProperty(ms.getKeyProperties()[0]);
        }
        builder.timeout(ms.getTimeout());
        builder.parameterMap(ms.getParameterMap());
        builder.resultMaps(ms.getResultMaps());
        builder.resultSetType(ms.getResultSetType());
        builder.cache(ms.getCache());
        builder.flushCacheRequired(ms.isFlushCacheRequired());
        builder.useCache(ms.isUseCache());
        return builder.build();
    }

    public static class BoundSqlSqlSource implements SqlSource {
        private BoundSql boundSql;

        public BoundSqlSqlSource(final BoundSql boundSql) {
            this.boundSql = boundSql;
        }

        /**
         * get boundSql.
         * @param parameterObject the parameterObject.
         * @return boundSql.
         */
        public BoundSql getBoundSql(final Object parameterObject) {
            return boundSql;
        }
    }
}
