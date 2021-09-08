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

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.exception.ExceptionHandlers;
import org.apache.shenyu.admin.model.dto.BatchCommonDTO;
import org.apache.shenyu.admin.model.dto.MetaDataDTO;
import org.apache.shenyu.admin.model.page.CommonPager;
import org.apache.shenyu.admin.model.page.PageParameter;
import org.apache.shenyu.admin.model.query.MetaDataQuery;
import org.apache.shenyu.admin.service.MetaDataService;
import org.apache.shenyu.admin.utils.ShenyuResultMessage;
import org.apache.shenyu.admin.model.vo.MetaDataVO;
import org.apache.shenyu.common.constant.AdminConstants;
import org.apache.shenyu.common.utils.DateUtils;
import org.apache.shenyu.common.utils.GsonUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Arrays;

import static org.hamcrest.core.Is.is;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Test cases for MetaDataController.
 */
@RunWith(MockitoJUnitRunner.class)
public final class MetaDataControllerTest {

    private MockMvc mockMvc;

    @InjectMocks
    private MetaDataController metaDataController;

    @Mock
    private MetaDataService metaDataService;

    private final MetaDataVO metaDataVO = new MetaDataVO("appName", "appPath", "desc", "rpcType", "serviceName", "methodName", "types", "rpcExt",
            "1", DateUtils.localDateTimeToString(LocalDateTime.now()), DateUtils.localDateTimeToString(LocalDateTime.now()),
            true, true);

    @Before
    public void setUp() {
        this.mockMvc = MockMvcBuilders.standaloneSetup(metaDataController)
                .setControllerAdvice(new ExceptionHandlers())
                .build();
    }

    @Test
    public void testQueryList() throws Exception {
        final PageParameter pageParameter = new PageParameter();
        List<MetaDataVO> metaDataVOS = new ArrayList<>();
        metaDataVOS.add(metaDataVO);
        final CommonPager<MetaDataVO> commonPager = new CommonPager<>();
        commonPager.setPage(pageParameter);
        commonPager.setDataList(metaDataVOS);
        final MetaDataQuery metaDataQuery = new MetaDataQuery("appName", pageParameter);
        given(this.metaDataService.listByPage(metaDataQuery)).willReturn(commonPager);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/meta-data/queryList")
                        .param("appName", "appName")
                        .param("currentPage", pageParameter.getCurrentPage() + "")
                        .param("pageSize", pageParameter.getPageSize() + ""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.QUERY_SUCCESS)))
                .andExpect(jsonPath("$.data.dataList[0].appName", is(metaDataVO.getAppName())))
                .andReturn();
    }

    @Test
    public void testFindAll() throws Exception {
        List<MetaDataVO> metaDataVOS = new ArrayList<>();
        metaDataVOS.add(metaDataVO);
        given(this.metaDataService.findAll()).willReturn(metaDataVOS);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/meta-data/findAll"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.QUERY_SUCCESS)))
                .andExpect(jsonPath("$.data[0].appName", is(metaDataVO.getAppName())))
                .andReturn();
    }

    @Test
    public void testFindAllGroup() throws Exception {
        final Map<String, List<MetaDataVO>> result = new HashMap<>();
        String groupName = "groupName-1";
        List<MetaDataVO> metaDataVOS = new ArrayList<>();
        metaDataVOS.add(metaDataVO);
        result.put(groupName, metaDataVOS);
        given(this.metaDataService.findAllGroup()).willReturn(result);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/meta-data/findAllGroup"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.QUERY_SUCCESS)))
                .andExpect(jsonPath("$.data." + groupName + "[0].appName", is(metaDataVO.getAppName())))
                .andReturn();
    }

    @Test
    public void testEditor() throws Exception {
        given(this.metaDataService.findById("1")).willReturn(metaDataVO);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/meta-data/{id}", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.DETAIL_SUCCESS)))
                .andExpect(jsonPath("$.data.appName", is(metaDataVO.getAppName())))
                .andReturn();
    }

    @Test
    public void testCreateOrUpdate() throws Exception {
        final MetaDataDTO metaDataDTO = new MetaDataDTO();
        metaDataDTO.setId("0001");
        metaDataDTO.setAppName("aname-01");
        metaDataDTO.setContextPath("path");
        metaDataDTO.setEnabled(false);
        given(this.metaDataService.createOrUpdate(metaDataDTO)).willReturn(StringUtils.EMPTY);
        this.mockMvc.perform(MockMvcRequestBuilders.post("/meta-data/createOrUpdate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(GsonUtils.getInstance().toJson(metaDataDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.CREATE_SUCCESS)))
                .andReturn();
    }

    @Test
    public void testCreateOrUpdateWithError() throws Exception {
        final MetaDataDTO metaDataDTO = new MetaDataDTO();
        metaDataDTO.setId("0001");
        metaDataDTO.setAppName("aname-01");
        metaDataDTO.setContextPath("path");
        metaDataDTO.setEnabled(false);
        given(this.metaDataService.createOrUpdate(metaDataDTO)).willReturn(AdminConstants.PARAMS_ERROR);
        this.mockMvc.perform(MockMvcRequestBuilders.post("/meta-data/createOrUpdate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(GsonUtils.getInstance().toJson(metaDataDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(AdminConstants.PARAMS_ERROR)))
                .andReturn();
    }

    @Test
    public void testBatchDeleted() throws Exception {
        final List<String> ids = new ArrayList<>(2);
        ids.add("1");
        ids.add("2");
        given(this.metaDataService.delete(ids)).willReturn(2);
        this.mockMvc.perform(MockMvcRequestBuilders.post("/meta-data/batchDeleted")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(GsonUtils.getInstance().toJson(ids)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.DELETE_SUCCESS)))
                .andExpect(jsonPath("$.data", is(2)))
                .andReturn();
    }

    @Test
    public void testBatchEnabled() throws Exception {
        final BatchCommonDTO batchCommonDTO = new BatchCommonDTO();
        batchCommonDTO.setIds(Arrays.asList("1", "2"));
        batchCommonDTO.setEnabled(true);
        given(this.metaDataService.enabled(batchCommonDTO.getIds(), batchCommonDTO.getEnabled())).willReturn(StringUtils.EMPTY);
        this.mockMvc.perform(MockMvcRequestBuilders.post("/meta-data/batchEnabled")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(GsonUtils.getInstance().toJson(batchCommonDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(ShenyuResultMessage.ENABLE_SUCCESS)))
                .andReturn();
    }

    @Test
    public void testBatchEnabledWithError() throws Exception {
        final BatchCommonDTO batchCommonDTO = new BatchCommonDTO();
        batchCommonDTO.setIds(Arrays.asList("1", "2"));
        batchCommonDTO.setEnabled(true);
        given(this.metaDataService.enabled(batchCommonDTO.getIds(), batchCommonDTO.getEnabled())).willReturn(AdminConstants.ID_NOT_EXIST);
        this.mockMvc.perform(MockMvcRequestBuilders.post("/meta-data/batchEnabled")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(GsonUtils.getInstance().toJson(batchCommonDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", is(AdminConstants.ID_NOT_EXIST)))
                .andReturn();
    }

    @Test
    public void testSyncData() throws Exception {
        this.mockMvc.perform(MockMvcRequestBuilders.post("/meta-data/syncData"))
                .andExpect(status().isOk())
                .andReturn();
    }
}
