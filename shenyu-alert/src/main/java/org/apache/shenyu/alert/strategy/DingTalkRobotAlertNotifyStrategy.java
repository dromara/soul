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

package org.apache.shenyu.alert.strategy;

import org.apache.shenyu.alert.exception.AlertNoticeException;
import org.apache.shenyu.common.dto.AlarmContent;
import org.apache.shenyu.alert.model.AlertReceiverDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Objects;

/**
 * Send alarm information through DingTalk robot.
 */
@Service
final class DingTalkRobotAlertNotifyStrategy extends AbstractAlertNotifyHandler {
    
    private static final String DING_TALK_WEB_HOOK_URL = "https://oapi.dingtalk.com/robot/send?access_token=";
    
    private static final Logger log = LoggerFactory.getLogger(DingTalkRobotAlertNotifyStrategy.class);
    
    @Override
    public void send(final AlertReceiverDTO receiver, final AlarmContent alert) {
        try {
            DingTalkWebHookDto dingTalkWebHookDto = new DingTalkWebHookDto();
            MarkdownDTO markdownDTO = new MarkdownDTO();
            markdownDTO.setText(renderContent(alert));
            markdownDTO.setTitle(alert.getTitle());
            dingTalkWebHookDto.setMarkdown(markdownDTO);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<DingTalkWebHookDto> httpEntity = new HttpEntity<>(dingTalkWebHookDto, headers);
            String webHookUrl = DING_TALK_WEB_HOOK_URL + receiver.getAccessToken();
            ResponseEntity<CommonRobotNotifyResp> responseEntity = getRestTemplate().postForEntity(webHookUrl,
                    httpEntity, CommonRobotNotifyResp.class);
            if (responseEntity.getStatusCode() == HttpStatus.OK) {
                Objects.requireNonNull(responseEntity.getBody());
                if (responseEntity.getBody().getErrCode() == 0) {
                    log.debug("Send dingTalk webHook: {} Success", webHookUrl);
                } else {
                    log.warn("Send dingTalk webHook: {} Failed: {}", webHookUrl, responseEntity.getBody().getErrMsg());
                    throw new AlertNoticeException(responseEntity.getBody().getErrMsg());
                }
            } else {
                log.warn("Send dingTalk webHook: {} Failed: {}", webHookUrl, responseEntity.getBody());
                throw new AlertNoticeException("Http StatusCode " + responseEntity.getStatusCode());
            }
        } catch (Exception e) {
            throw new AlertNoticeException("[DingTalk Notify Error] " + e.getMessage());
        }
    }
    
    @Override
    public byte type() {
        return 5;
    }
    
    @Override
    protected String templateName() {
        return "alertNotifyDingTalkRobot";
    }
    
    /**
     * DingDing body.
     */
    private static class DingTalkWebHookDto {
        private static final String MARKDOWN = "markdown";
        
        /**
         * message type.
         */
        private String msgtype = MARKDOWN;
        
        /**
         * markdown.
         */
        private MarkdownDTO markdown;
        
        /**
         * get message type.
         *
         * @return type
         */
        public String getMsgtype() {
            return msgtype;
        }
        
        /**
         * set message type.
         *
         * @param msgtype message type
         */
        public void setMsgtype(final String msgtype) {
            this.msgtype = msgtype;
        }
        
        /**
         * get markdown.
         *
         * @return markdown
         */
        public MarkdownDTO getMarkdown() {
            return markdown;
        }
        
        /**
         * set markdown.
         *
         * @param markdown markdown.
         */
        public void setMarkdown(final MarkdownDTO markdown) {
            this.markdown = markdown;
        }
    }
    
    private static class MarkdownDTO {
        
        /**
         * test.
         */
        private String text;
        
        /**
         * title.
         */
        private String title;
        
        /**
         * get text.
         *
         * @return text
         */
        public String getText() {
            return text;
        }
        
        /**
         * set text.
         *
         * @param text text
         */
        public void setText(final String text) {
            this.text = text;
        }
        
        /**
         * get title.
         *
         * @return title
         */
        public String getTitle() {
            return title;
        }
        
        /**
         * set title.
         *
         * @param title title
         */
        public void setTitle(final String title) {
            this.title = title;
        }
    }
    
}
