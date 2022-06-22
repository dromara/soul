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

package org.apache.shenyu.admin.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import okhttp3.Response;
import okhttp3.ResponseBody;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.mapper.AppAuthMapper;
import org.apache.shenyu.admin.model.entity.AppAuthDO;
import org.apache.shenyu.admin.utils.HttpUtils;
import org.apache.shenyu.admin.utils.ShenyuSignatureUtils;
import org.apache.shenyu.admin.utils.UploadUtils;
import org.apache.shenyu.common.utils.JsonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

/**
 * Sandbox environment.
 */
@RestController
@RequestMapping("/sandbox")
public class SandboxController {
    private static final Logger LOG = LoggerFactory.getLogger(SandboxController.class);

    private static final HttpUtils HTTP_UTILS = new HttpUtils();

    @Resource
    private AppAuthMapper appAuthMapper;

    //    /**
//     * proxyGateway.
//     *
//     * @param proxyGatewayDTO proxyGatewayDTO
//     * @param request         request
//     * @param response        response
//     * @throws IOException IOException
//     */
//    @PostMapping(path = "/proxyGateway")
//    public void proxyGateway(@RequestBody @Valid final ProxyGatewayDTO proxyGatewayDTO,
//        final HttpServletRequest request,
//        final HttpServletResponse response) throws IOException {
    /**
     * proxyGateway.
     *
     * @param requestUrl requestUrl
     * @param appKey     appKey
     * @param cookie     cookie
     * @param bizParam   bizParam
     * @param httpMethod httpMethod
     * @param request    request
     * @param response   response
     * @throws IOException IOException
     */
    @PostMapping(path = "/proxyGateway")
    public void proxyGateway(
        @RequestParam(required = false) final String requestUrl,
        @RequestParam(required = false) final String appKey,
        @RequestParam(required = false) final String cookie,
        @RequestParam(required = false) final String bizParam,
        @RequestParam(defaultValue = "get") final String httpMethod,
        final HttpServletRequest request,
        final HttpServletResponse response) throws IOException {
//        Assert.isTrue(StringUtils.isNotBlank(proxyGatewayDTO), "requestUrl cannot be empty.");
//        String appKey = proxyGatewayDTO.getAppKey();
//        String requestUrl = proxyGatewayDTO.getRequestUrl();

        // Public request parameters.
        Map<String, String> reqParams = new HashMap<String, String>();
        try {
//            String bizParamStr = StringEscapeUtils.escapeHtml4(proxyGatewayDTO.getBizParam());
            String bizParamStr = StringEscapeUtils.escapeHtml4(bizParam);
            Map<String, String> reqMap = (Map) JsonUtils.toMap(bizParamStr);
            LOG.info("bizParam toMap= {}", JsonUtils.toJson(reqMap));
            if (Objects.nonNull(reqMap)) {
                reqParams.putAll(reqMap);
            }
        } catch (Exception e) {
            LOG.error("proxyGateway JsonUtils.toMap error={}", e);
            return;
        }

        Collection<MultipartFile> uploadFiles = UploadUtils.getUploadFiles(request);
        List<HttpUtils.UploadFile> files = uploadFiles.stream()
            .map(multipartFile -> {
                try {
                    return new HttpUtils.UploadFile(multipartFile.getName(), multipartFile.getOriginalFilename(), multipartFile.getBytes());
                } catch (IOException e) {
                    LOG.error("upload file fail", e);
                    return null;
                }
            })
            .filter(Objects::nonNull)
            .collect(Collectors.toList());

        Map<String, String> header = new HashMap<>();
//        header.put("Cookie", proxyGatewayDTO.getCookie());
        header.put("Cookie", cookie);

        String signContent = null;
        String sign = null;
        if (StringUtils.isNotEmpty(appKey)) {
            String timestamp = String.valueOf(LocalDateTime.now().toInstant(ZoneOffset.of("+8")).toEpochMilli());
            String secureKey = getSecureKey(appKey);
            String[] methodArr = requestUrl.split("/", 2);
            signContent = ShenyuSignatureUtils.getSignContent(secureKey, timestamp, methodArr[1]);
            sign = ShenyuSignatureUtils.generateSign(signContent);

            header.put("timestamp", timestamp);
            header.put("appKey", appKey);
            header.put("sign", sign);
            header.put("version", ShenyuSignatureUtils.VERSION);
        }

//        Response resp = HTTP_UTILS.requestCall(requestUrl, reqParams, header, HttpUtils.HTTPMethod.fromValue(proxyGatewayDTO.getHttpMethod()), files);
        Response resp = HTTP_UTILS.requestCall(requestUrl, reqParams, header, HttpUtils.HTTPMethod.fromValue(httpMethod), files);
        ResponseBody body = resp.body();
        if (Objects.isNull(body)) {
            return;
        }
        response.addHeader("sandbox-params", UriUtils.encode(buildParamQuery(reqParams), StandardCharsets.UTF_8));
        if (StringUtils.isNotEmpty(appKey)) {
            response.addHeader("sandbox-beforesign", UriUtils.encode(signContent, StandardCharsets.UTF_8));
            response.addHeader("sandbox-sign", UriUtils.encode(sign, StandardCharsets.UTF_8));
        }
        IOUtils.copy(body.byteStream(), response.getOutputStream());
        response.flushBuffer();
    }

    private String getSecureKey(final String appKey) {
        AppAuthDO appAuthDO = appAuthMapper.findByAppKey(appKey);
        if (Objects.isNull(appAuthDO) || StringUtils.isEmpty(appAuthDO.getAppSecret())) {
            throw new RuntimeException("security key not found.");
        }
        return appAuthDO.getAppSecret();
    }

    protected String buildParamQuery(final Map<String, String> params) {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            sb.append("&").append(entry.getKey()).append("=").append(entry.getValue());
        }
        return sb.substring(1);
    }

}
