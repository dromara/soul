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

package org.apache.shenyu.common.dto.convert.rule;

import java.util.Objects;

/**
 * this is Ai Prompt plugin selector handle.
 */
public class AiPromptHandle {

    /**
     * prepend.
     */
    private String prepend;
    
    /**
     * preRole.
     */
    private String preRole;
    
    /**
     * append.
     */
    private String append;
    
    /**
     * postRole.
     */
    private String postRole;
    
    /**
     * get prepend.
     *
     * @return prepend
     */
    public String getPrepend() {
        return prepend;
    }
    
    /**
     * set prepend.
     *
     * @param prepend prepend
     */
    public void setPrepend(final String prepend) {
        this.prepend = prepend;
    }
    
    /**
     * get preRole.
     *
     * @return preRole
     */
    public String getPreRole() {
        return preRole;
    }
    
    /**
     * set preRole.
     *
     * @param preRole preRole
     */
    public void setPreRole(final String preRole) {
        this.preRole = preRole;
    }
    
    /**
     * get append.
     *
     * @return append
     */
    public String getAppend() {
        return append;
    }
    
    /**
     * set append.
     *
     * @param append append
     */
    public void setAppend(final String append) {
        this.append = append;
    }
    
    /**
     * get postRole.
     *
     * @return postRole
     */
    public String getPostRole() {
        return postRole;
    }
    
    /**
     * set postRole.
     *
     * @param postRole postRole
     */
    public void setPostRole(final String postRole) {
        this.postRole = postRole;
    }
    
    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (Objects.isNull(o) || getClass() != o.getClass()) {
            return false;
        }
        AiPromptHandle that = (AiPromptHandle) o;
        return Objects.equals(prepend, that.prepend) && Objects.equals(preRole, that.preRole)
                && Objects.equals(append, that.append) && Objects.equals(postRole, that.postRole);
    }

    @Override
    public int hashCode() {
        return Objects.hash(prepend, preRole, append, postRole);
    }

    @Override
    public String toString() {
        return "AiPromptConfig{" + "prepend='" + prepend + '\'' + ", preRole='" + preRole + '\'' + ", append='" + append + '\''
                + ", postRole='" + postRole + '\'' + '}';
    }
}
