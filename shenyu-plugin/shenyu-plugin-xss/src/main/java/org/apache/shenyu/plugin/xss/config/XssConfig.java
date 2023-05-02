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

package org.apache.shenyu.plugin.xss.config;

import java.io.Serializable;

/**
 * The type Xss config.
 */
public class XssConfig implements Serializable {

    private static final long serialVersionUID = 96834909685183123L;

    private String request;

    private String response;

    private String csp;

    private String httpOnly;


    /**
     * get request.
     *
     * @return request
     */
    public String getRequest() {
        return request;
    }

    /**
     * set request.
     *
     * @param request request
     */
    public void setRequest(final String request) {
        this.request = request;
    }

    /**
     * get response.
     *
     * @return response
     */
    public String getResponse() {
        return response;
    }

    /**
     * set response.
     *
     * @param response response
     */
    public void setResponse(final String response) {
        this.response = response;
    }

    /**
     * get csp.
     *
     * @return csp
     */
    public String getCsp() {
        return csp;
    }

    /**
     * set csp.
     *
     * @param csp csp
     */
    public void setCsp(final String csp) {
        this.csp = csp;
    }

    /**
     * get httpOnly.
     *
     * @return httpOnly
     */
    public String getHttpOnly() {
        return httpOnly;
    }

    /**
     * set httpOnly.
     *
     * @param httpOnly httpOnly
     */
    public void setHttpOnly(final String httpOnly) {
        this.httpOnly = httpOnly;
    }

//
//    public Boolean enableHttpOnly() {
//
//    }
}
