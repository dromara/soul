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

package org.apache.shenyu.alert.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

/**
 * AlertContent.
 */
public class AlertContentDTO implements Serializable {
    
    /**
     * primary key id.
     */
    private Long id;
    
    /**
     * alert title.
     */
    private String title;
    
    /**
     * Alarm level.
     * 0: high-emergency-critical alarm-red.
     * 1: medium-critical-critical alarm-orange.
     * 2: low-warning-warning alarm-yellow
     */
    private byte level;
    
    /**
     * alert labels.
     */
    private Map<String, String> labels;
    
    /**
     * The actual content of the alarm notification.
     */
    private String content;
    
    /**
     * create time.
     */
    private Date dateCreated;
    
    /**
     * update time.
     */
    private Date dateUpdated;
    
    /**
     * get id.
     *
     * @return id
     */
    public Long getId() {
        return id;
    }
    
    /**
     * set id.
     *
     * @param id id
     */
    public void setId(final Long id) {
        this.id = id;
    }
    
    /**
     * get title.
     * @return title
     */
    public String getTitle() {
        return title;
    }
    
    /**
     * set title.
     * @param title title
     */
    public void setTitle(final String title) {
        this.title = title;
    }
    
    /**
     * get level.
     * @return level
     */
    public byte getLevel() {
        return level;
    }
    
    /**
     * set level.
     * @param level level
     */
    public void setLevel(final byte level) {
        this.level = level;
    }
    
    /**
     * get labels.
     * @return labels
     */
    public Map<String, String> getLabels() {
        return labels;
    }
    
    /**
     * set labels.
     * @param labels labels
     */
    public void setLabels(final Map<String, String> labels) {
        this.labels = labels;
    }
    
    /**
     * get content.
     *
     * @return content
     */
    public String getContent() {
        return content;
    }
    
    /**
     * set content.
     *
     * @param content content
     */
    public void setContent(final String content) {
        this.content = content;
    }
    
    /**
     * get dateCreated.
     *
     * @return dateCreated
     */
    public Date getDateCreated() {
        return dateCreated;
    }
    
    /**
     * set dateCreated.
     *
     * @param dateCreated dateCreated
     */
    public void setDateCreated(final Date dateCreated) {
        this.dateCreated = dateCreated;
    }
    
    /**
     * get dateUpdated.
     *
     * @return dateUpdated
     */
    public Date getDateUpdated() {
        return dateUpdated;
    }
    
    /**
     * set dateUpdated.
     *
     * @param dateUpdated dateUpdated
     */
    public void setDateUpdated(final Date dateUpdated) {
        this.dateUpdated = dateUpdated;
    }
    
}
