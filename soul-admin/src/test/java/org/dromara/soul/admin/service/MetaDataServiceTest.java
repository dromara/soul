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

package org.dromara.soul.admin.service;

import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;
import org.dromara.soul.admin.dto.MetaDataDTO;
import org.dromara.soul.admin.entity.MetaDataDO;
import org.dromara.soul.admin.mapper.MetaDataMapper;
import org.dromara.soul.admin.page.CommonPager;
import org.dromara.soul.admin.page.PageParameter;
import org.dromara.soul.admin.query.MetaDataQuery;
import org.dromara.soul.admin.service.impl.MetaDataServiceImpl;
import org.dromara.soul.admin.vo.MetaDataVO;
import org.dromara.soul.common.constant.AdminConstants;
import org.dromara.soul.common.dto.MetaData;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.context.ApplicationEventPublisher;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Test cases for MetaDataService.
 *
 * @author James Fang (funpad)
 */
@RunWith(MockitoJUnitRunner.class)
public class MetaDataServiceTest {

    @InjectMocks
    private MetaDataServiceImpl metaDataService;

    @Mock
    private MetaDataMapper metaDataMapper;

    @Spy
    private ApplicationEventPublisher eventPublisher;

    @Mock
    private MetaDataDTO metaDataDTO;

    @Mock
    private MetaDataQuery metaDataQuery;

    /**
     * Test case for createOrUpdate.<br>
     * Note that the following methods have dependencies before and after.
     */
    @Test
    public void testCreateOrUpdate() {
        testCreateOrUpdateForParamsError();
        testCreateOrUpdateForPathExist();
        testCreateOrUpdateForInsert();
        testCreateOrUpdateForUpdate();
    }

    /**
     * Test case for delete.<br>
     * Note that there is no test case where ids is null,
     * because the source code needs to be updated first.
     */
    @Test
    public void testDelete() {
        testDeleteForEmptyIds();
        testDeleteForNotEmptyIds();
    }

    /**
     * Test case for enabled.
     */
    @Test
    public void testEnabled() {
        // Given
        List<String> ids = Lists.newArrayList("id1", "id2", "id3");
        when(metaDataMapper.selectById(anyString()))
                .thenReturn(new MetaDataDO())
                .thenReturn(null)
                .thenReturn(new MetaDataDO());
        // When
        String msg = metaDataService.enabled(ids, true);
        // Then
        assertEquals(AdminConstants.ID_NOT_EXIST, msg);

        // When
        msg = metaDataService.enabled(ids, false);
        // Then
        assertEquals(StringUtils.EMPTY, msg);
    }

    /**
     * Test case for syncData.
     */
    @Test
    public void testSyncDate() {
        // Given
        ArrayList<MetaDataDO> all = Lists.newArrayList(new MetaDataDO());
        when(metaDataMapper.findAll())
                .thenReturn(null)
                .thenReturn(Lists.newArrayList())
                .thenReturn(all);
        doNothing().when(eventPublisher).publishEvent(any());
        // When
        for (int i = 0; i < 3; i++) {
            metaDataService.syncData();
        }
        // Then
        verify(eventPublisher, times(1)).publishEvent(any());
    }

    /**
     * Test case for findById.
     */
    @Test
    public void testFindById() {
        // Given
        when(metaDataMapper.selectById(anyString())).thenReturn(null);
        // When
        MetaDataVO dataVo = metaDataService.findById(anyString());
        // Then
        Assert.assertEquals(new MetaDataVO(), dataVo);

        // Given
        final String appName = "appName";
        MetaDataDO metaDataDO = new MetaDataDO();
        metaDataDO.setAppName(appName);
        when(metaDataMapper.selectById(anyString())).thenReturn(metaDataDO);
        // When
        dataVo = metaDataService.findById(anyString());
        // Then
        Assert.assertEquals(appName, dataVo.getAppName());
    }

    /**
     * Test case for listByPage.
     */
    @Test
    public void testListByPage() {
        // Given
        when(metaDataQuery.getPageParameter()).thenReturn(new PageParameter(1, 10, 5));
        when(metaDataMapper.countByQuery(any())).thenReturn(3);
        ArrayList<MetaDataDO> metaDataDOList = getMetaDataDOList();
        when(metaDataMapper.selectByQuery(any())).thenReturn(metaDataDOList);
        // When
        CommonPager<MetaDataVO> pager = metaDataService.listByPage(metaDataQuery);
        // Then
        Assert.assertEquals("The dataList should be contain " + metaDataDOList.size() + " element.",
                metaDataDOList.size(), pager.getDataList().size());
    }

    /**
     * Test case for findAll.
     */
    @Test
    public void testFindAll() {
        // Given
        ArrayList<MetaDataDO> metaDataDOList = getMetaDataDOList();
        when(metaDataMapper.selectAll()).thenReturn(metaDataDOList);
        // When
        List<MetaDataVO> all = metaDataService.findAll();
        // Then
        Assert.assertEquals("The list should be contain " + metaDataDOList.size() + " element.",
                metaDataDOList.size(), all.size());
    }

    /**
     * Test case for findAllGroup.
     */
    @Test
    public void testFindAllGroup() {
        // Given
        when(metaDataMapper.selectAll()).thenReturn(getMetaDataDOList());
        // When
        Map<String, List<MetaDataVO>> allGroup = metaDataService.findAllGroup();
        // then
        Assert.assertEquals("There should be 2 groups.", 2, allGroup.keySet().size());
    }

    /**
     * Test case for listAll.
     */
    @Test
    public void testListAll() {
        // Given
        ArrayList<MetaDataDO> metaDataDOList = getMetaDataDOList();
        metaDataDOList.add(null);
        when(metaDataMapper.selectAll()).thenReturn(metaDataDOList);
        // When
        List<MetaData> all = metaDataService.listAll();
        // then
        Assert.assertEquals("The List should be contain " + (metaDataDOList.size() - 1) + " element.",
                metaDataDOList.size() - 1, all.size());
    }

    /**
     * Cases where the params error.
     */
    private void testCreateOrUpdateForParamsError() {
        // Given
        when(metaDataDTO.getAppName())
                .thenReturn(null)
                .thenReturn(StringUtils.EMPTY)
                .thenReturn("AppName");
        when(metaDataDTO.getPath())
                .thenReturn(null)
                .thenReturn(StringUtils.EMPTY)
                .thenReturn("path");
        when(metaDataDTO.getRpcType())
                .thenReturn(null)
                .thenReturn(StringUtils.EMPTY)
                .thenReturn("rpcType");
        when(metaDataDTO.getServiceName())
                .thenReturn(null)
                .thenReturn(StringUtils.EMPTY)
                .thenReturn("serviceName");
        when(metaDataDTO.getMethodName())
                .thenReturn(null)
                .thenReturn(StringUtils.EMPTY)
                .thenReturn("methodName");

        for (int i = 0; i < 2 * 5; i++) {
            // When
            String msg = metaDataService.createOrUpdate(metaDataDTO);
            // Then
            assertEquals(AdminConstants.PARAMS_ERROR, msg);
        }
    }

    /**
     * Cases where check passed or the data path already exists.<br>
     * The stub declared in createOrUpdateCase1 will not be repeated.
     */
    private void testCreateOrUpdateForPathExist() {
        // Given
        MetaDataDO metaDataDO = new MetaDataDO();
        metaDataDO.setId("id1");
        when(metaDataDTO.getId())
                .thenReturn(null)
                .thenReturn("id1");
        when(metaDataMapper.findByPath(anyString()))
                .thenReturn(null)
                .thenReturn(metaDataDO);

        for (int i = 0; i < 2; i++) {
            // When
            String msg = metaDataService.createOrUpdate(metaDataDTO);
            // Then
            assertEquals(StringUtils.EMPTY, msg);
        }

        // Given
        when(metaDataDTO.getId()).thenReturn("id2");
        // When
        String msg = metaDataService.createOrUpdate(metaDataDTO);
        // Then
        assertEquals(AdminConstants.DATA_PATH_IS_EXIST, msg);
    }

    /**
     * Cases where check passed and insert operation.<br>
     * The stub declared in createOrUpdateCase1 will not be repeated.
     */
    private void testCreateOrUpdateForInsert() {
        // Given
        when(metaDataDTO.getId()).thenReturn(null);
        when(metaDataMapper.findByPath(anyString())).thenReturn(null);
        when(metaDataMapper.insert(any())).thenReturn(1);
        // When
        String msg = metaDataService.createOrUpdate(metaDataDTO);
        // Then
        assertEquals(StringUtils.EMPTY, msg);
    }

    /**
     * Cases where check passed and update operation.<br>
     * The stub declared in createOrUpdateCase1 and createOrUpdateCase3 will not be repeated.
     */
    private void testCreateOrUpdateForUpdate() {
        // Given
        MetaDataDO metaDataDO = new MetaDataDO();
        when(metaDataDTO.getId()).thenReturn("id");
        when(metaDataMapper.selectById("id")).thenReturn(null).thenReturn(metaDataDO);
        when(metaDataMapper.update(any())).thenReturn(1);
        // When
        String msg = metaDataService.createOrUpdate(metaDataDTO);
        // Then
        assertEquals(StringUtils.EMPTY, msg);
    }

    private void assertEquals(final String expected, final String actual) {
        Assert.assertEquals("The msg should be '" + expected + "'.",
                expected, actual);
    }

    /**
     * Cases where get an empty id list.
     */
    private void testDeleteForEmptyIds() {
        // Given
        List<String> ids = Lists.newArrayList();
        // When
        int count = metaDataService.delete(ids);
        // Then
        Assert.assertEquals("The count of delete should be 0.",
                0, count);
    }

    /**
     * Cases where get a not empty id list.
     */
    private void testDeleteForNotEmptyIds() {
        // Given
        List<String> ids = Lists.newArrayList("id1", "id2", "id3");
        when(metaDataMapper.selectById("id1")).thenReturn(new MetaDataDO());
        when(metaDataMapper.selectById("id3")).thenReturn(new MetaDataDO());
        when(metaDataMapper.delete("id1")).thenReturn(1);
        when(metaDataMapper.delete("id3")).thenReturn(1);
        // When
        int count = metaDataService.delete(ids);
        // Then
        Assert.assertEquals("The count of delete should be 2.",
                2, count);
    }

    private ArrayList<MetaDataDO> getMetaDataDOList() {
        final MetaDataDO metaDataDO1 = new MetaDataDO();
        final MetaDataDO metaDataDO2 = new MetaDataDO();
        final MetaDataDO metaDataDO3 = new MetaDataDO();

        metaDataDO1.setId("id1");
        metaDataDO1.setAppName("appName1");
        metaDataDO2.setId("id2");
        metaDataDO2.setAppName("appName2");
        metaDataDO3.setId("id3");
        metaDataDO3.setAppName("appName2");
        return Lists.newArrayList(metaDataDO1, metaDataDO2, metaDataDO3);
    }
}
