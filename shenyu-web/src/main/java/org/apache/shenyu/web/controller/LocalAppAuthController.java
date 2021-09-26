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

package org.apache.shenyu.web.controller;

import org.apache.shenyu.common.dto.AppAuthData;
import org.apache.shenyu.common.utils.CollectionUtils;
import org.apache.shenyu.sync.data.api.AuthDataSubscriber;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.List;

/**
 * The type AppAuth controller.
 */
@RestController
@RequestMapping("/shenyu")
public class LocalAppAuthController {

    /**
     * logger.
     */
    private static final Logger LOG = LoggerFactory.getLogger(LocalAppAuthController.class);

    private static final String SUCCESS = "success";

    private final List<AuthDataSubscriber> subscribers;
    
    /**
     * Instantiates a new Local app auth controller.
     *
     * @param subscribers the subscribers
     */
    public LocalAppAuthController(final ObjectProvider<List<AuthDataSubscriber>> subscribers) {
        this.subscribers = subscribers.getIfAvailable(ArrayList::new);
    }
    
    /**
     * Clean AppAuth data by appKey.
     *
     * @param appKey the appKey
     * @return the mono
     */
    @GetMapping("/auth/delete")
    public Mono<String> clean(final String appKey) {
        if (CollectionUtils.isEmpty(subscribers)) {
            return Mono.just(SUCCESS);
        }
        LOG.info("delete apache shenyu local AppAuth data");
        AppAuthData appAuthData = new AppAuthData();
        appAuthData.setAppKey(appKey);
        subscribers.forEach(authDataSubscriber -> authDataSubscriber.unSubscribe(appAuthData));
        return Mono.just(SUCCESS);
    }
    
    /**
     * Save or update app auth data.
     *
     * @param appAuthData the app auth data
     * @return the mono
     */
    @PostMapping("/auth/saveOrUpdate")
    public Mono<String> saveOrUpdate(@RequestBody final AppAuthData appAuthData) {
        if (CollectionUtils.isEmpty(subscribers)) {
            return Mono.just(SUCCESS);
        }
        LOG.info("saveOrUpdate apache shenyu local app auth");
        subscribers.forEach(authDataSubscriber -> authDataSubscriber.onSubscribe(appAuthData));
        return Mono.just(SUCCESS);
    }
}
