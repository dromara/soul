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

package org.apache.shenyu.plugin.cache.redis;

import com.google.common.base.Splitter;
import com.google.common.collect.Lists;
import org.apache.commons.pool2.impl.GenericObjectPoolConfig;
import org.apache.shenyu.common.enums.RedisModeEnum;
import org.springframework.data.redis.connection.RedisClusterConfiguration;
import org.springframework.data.redis.connection.RedisNode;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisSentinelConfiguration;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceClientConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettucePoolingClientConfiguration;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * RedisConnectionFactory.
 */
public class RedisConnectionFactory {

    private final LettuceConnectionFactory lettuceConnectionFactory;

    public RedisConnectionFactory(final RedisConfigProperties redisConfigProperties) {
        lettuceConnectionFactory = createLettuceConnectionFactory(redisConfigProperties);
        lettuceConnectionFactory.afterPropertiesSet();
    }

    /**
     * Get Lettuce connection factory.
     * @return the factory
     */
    public LettuceConnectionFactory getLettuceConnectionFactory() {
        return this.lettuceConnectionFactory;
    }

    private LettuceConnectionFactory createLettuceConnectionFactory(final RedisConfigProperties redisConfigProperties) {
        LettuceClientConfiguration lettuceClientConfiguration = getLettuceClientConfiguration(redisConfigProperties);
        if (RedisModeEnum.SENTINEL.getName().equals(redisConfigProperties.getMode())) {
            return new LettuceConnectionFactory(redisSentinelConfiguration(redisConfigProperties), lettuceClientConfiguration);
        }
        if (RedisModeEnum.CLUSTER.getName().equals(redisConfigProperties.getMode())) {
            return new LettuceConnectionFactory(redisClusterConfiguration(redisConfigProperties), lettuceClientConfiguration);
        }
        return new LettuceConnectionFactory(redisStandaloneConfiguration(redisConfigProperties), lettuceClientConfiguration);
    }

    private LettuceClientConfiguration getLettuceClientConfiguration(final RedisConfigProperties redisConfigProperties) {
        return LettucePoolingClientConfiguration.builder().poolConfig(getPoolConfig(redisConfigProperties)).build();
    }

    private GenericObjectPoolConfig<?> getPoolConfig(final RedisConfigProperties redisConfigProperties) {
        GenericObjectPoolConfig<?> config = new GenericObjectPoolConfig<>();
        config.setMaxTotal(redisConfigProperties.getMaxActive());
        config.setMaxIdle(redisConfigProperties.getMaxIdle());
        config.setMinIdle(redisConfigProperties.getMinIdle());
        if (Objects.nonNull(redisConfigProperties.getMaxWait())) {
            config.setMaxWait(Duration.ofMillis(redisConfigProperties.getMaxWait().toMillis()));
        }
        return config;
    }

    /**
     * Redis standalone configuration redis standalone configuration.
     *
     * @param redisConfigProperties the rate limiter config
     * @return the redis standalone configuration
     */
    protected final RedisStandaloneConfiguration redisStandaloneConfiguration(final RedisConfigProperties redisConfigProperties) {
        RedisStandaloneConfiguration config = new RedisStandaloneConfiguration();
        String[] parts = StringUtils.split(redisConfigProperties.getUrl(), ":");
        Objects.requireNonNull(parts);
        config.setHostName(parts[0]);
        config.setPort(Integer.parseInt(parts[1]));
        if (Objects.nonNull(redisConfigProperties.getPassword())) {
            config.setPassword(RedisPassword.of(redisConfigProperties.getPassword()));
        }
        config.setDatabase(redisConfigProperties.getDatabase());
        return config;
    }

    private RedisClusterConfiguration redisClusterConfiguration(final RedisConfigProperties redisConfigProperties) {
        RedisClusterConfiguration config = new RedisClusterConfiguration();
        config.setClusterNodes(createRedisNode(redisConfigProperties.getUrl()));
        if (Objects.nonNull(redisConfigProperties.getPassword())) {
            config.setPassword(RedisPassword.of(redisConfigProperties.getPassword()));
        }
        return config;
    }

    private RedisSentinelConfiguration redisSentinelConfiguration(final RedisConfigProperties redisConfigProperties) {
        RedisSentinelConfiguration config = new RedisSentinelConfiguration();
        config.master(redisConfigProperties.getMaster());
        config.setSentinels(createRedisNode(redisConfigProperties.getUrl()));
        if (Objects.nonNull(redisConfigProperties.getPassword())) {
            config.setPassword(RedisPassword.of(redisConfigProperties.getPassword()));
        }
        config.setDatabase(redisConfigProperties.getDatabase());
        return config;
    }

    private List<RedisNode> createRedisNode(final String url) {
        List<RedisNode> redisNodes = new ArrayList<>();
        List<String> nodes = Lists.newArrayList(Splitter.on(";").split(url));
        for (String node : nodes) {
            String[] parts = StringUtils.split(node, ":");
            Assert.state(Objects.requireNonNull(parts).length == 2, "Must be defined as 'host:port'");
            redisNodes.add(new RedisNode(parts[0], Integer.parseInt(parts[1])));
        }
        return redisNodes;
    }
}
