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

package org.apache.shenyu.examples.springmvc.controller;

import java.util.Objects;
import javax.servlet.http.HttpServletRequest;

import org.apache.shenyu.client.apidocs.annotations.ApiDoc;
import org.apache.shenyu.client.apidocs.annotations.ApiModule;
import org.apache.shenyu.client.springmvc.annotation.ShenyuSpringMvcClient;
import org.apache.shenyu.examples.springmvc.dto.OAuth2DTO;
import org.apache.shenyu.examples.springmvc.dto.OrderDTO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * TestController.
 */
@RestController
@RequestMapping("/order")
@ShenyuSpringMvcClient("/order")
@ApiModule(value = "order")
public class OrderController {

    /**
     * Save order dto.
     *
     * @param orderDTO the order dto
     * @return the order dto
     */
    @PostMapping("/save")
    @ShenyuSpringMvcClient("/save")
    @ApiDoc(desc = "save")
    public OrderDTO save(@RequestBody final OrderDTO orderDTO) {
        orderDTO.setName("hello world save order");
        return orderDTO;
    }

    /**
     * Find by id order dto.
     *
     * @param id the id
     * @return the order dto
     */
    @GetMapping("/findById")
    @ShenyuSpringMvcClient("/findById")
    @ApiDoc(desc = "findById")
    public OrderDTO findById(@RequestParam("id") final String id) {
        return build(id, "hello world findById");
    }

    /**
     * Gets path variable.
     *
     * @param id   the id
     * @param name the name
     * @return the path variable
     */
    @GetMapping("/path/{id}/{name}")
    @ShenyuSpringMvcClient("/path/**")
    @ApiDoc(desc = "path/{id}/{name}")
    public OrderDTO getPathVariable(@PathVariable("id") final String id, @PathVariable("name") final String name) {
        return build(id, "hello world restful: " + name);
    }

    /**
     * Test rest ful order dto.
     *
     * @param id the id
     * @return the order dto
     */
    @GetMapping("/path/{id}/name")
    @ShenyuSpringMvcClient("/path/**/name")
    @ApiDoc(desc = "path/{id}/name")
    public OrderDTO testRestFul(@PathVariable("id") final String id) {
        return build(id, "hello world restful inline " + id);
    }

    /**
     * Test oauth2 request.
     * @param request request with the oauth2 headers
     * @return the oauth2 dto
     */
    @GetMapping("/oauth2/test")
    @ShenyuSpringMvcClient("/oauth2/test")
    @ApiDoc(desc = "oauth2/test")
    public OAuth2DTO testRestFul(final HttpServletRequest request) {
        final String token = request.getHeader("Authorization");
        final OAuth2DTO oAuth2DTO = new OAuth2DTO();
        oAuth2DTO.setToken(Objects.isNull(token) ? "no authorization" : token);
        return oAuth2DTO;
    }

    private OrderDTO build(final String id, final String name) {
        final OrderDTO orderDTO = new OrderDTO();
        orderDTO.setId(id);
        orderDTO.setName(name);
        return orderDTO;
    }

}
