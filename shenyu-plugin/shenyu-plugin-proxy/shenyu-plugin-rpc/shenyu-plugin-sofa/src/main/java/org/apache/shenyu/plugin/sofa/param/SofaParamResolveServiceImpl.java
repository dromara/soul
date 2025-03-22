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

package org.apache.shenyu.plugin.sofa.param;

import com.alipay.hessian.generic.model.GenericCollection;
import com.alipay.hessian.generic.model.GenericMap;
import com.alipay.hessian.generic.model.GenericObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.ParamCheckUtils;
import org.springframework.lang.NonNull;
import org.springframework.util.Assert;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * The type Default generic param resolve service.
 */
public class SofaParamResolveServiceImpl implements SofaParamResolveService {

    @Override
    @NonNull
    public Pair<String[], Object[]> buildParameter(final String body, final String parameterTypes) {
        final String[] parameterTypeStrings = StringUtils.split(parameterTypes, ",");
        List<String> parameterTypeArr = new ArrayList<>(parameterTypeStrings.length);
        List<Object> values = new ArrayList<>();
        final List<Object> params = new ArrayList<>(GsonUtils.getInstance().toObjectMap(body).values());
        for (int paramIndex = 0; paramIndex < parameterTypeStrings.length; paramIndex++) {
            ParamCheckUtils.checkParamsLength(params.size(), parameterTypeStrings.length);
            final String[] parameter = StringUtils.split(parameterTypeStrings[paramIndex], "#");
            parameterTypeArr.add(parameter[0]);
            values.add(convertToParameterValue(params.get(paramIndex), parameter));
        }
        return new ImmutablePair<>(parameterTypeArr.toArray(new String[0]), values.toArray());
    }

    /**
     * convert to parameter value.
     *
     * @param value         value support [json object string, json array string,string]
     * @param parameterType parameter type support [javaPackage.ClassName#GenericType1#GenericType2], split is ,
     * @return GenericObject, GenericMap, List, string, array...
     * @see com.alipay.hessian.generic.model
     */
    @SuppressWarnings("all")
    private Object convertToParameterValue(final Object value, final String[] parameterType) {
        if (isSingleType(parameterType)) {
            return value;
        }
        if (value instanceof JsonObject && parameterType[0].contains("Map")) {
            final Map<String, Object> mapValue = GsonUtils.getInstance().convertToMap(value.toString());
            if (parameterType.length == 1) {
                // no generic info
                return mapValue;
            }
            Assert.state(parameterType.length == 3, "parameterType length must be 3.");
            // generic map
            final GenericMap genericMap = new GenericMap(parameterType[2]);
            mapValue.replaceAll((k, v) -> convertToGenericObject(parameterType[2], mapValue.get(k)));
            genericMap.setMap(mapValue);
            return genericMap;
        }
        if (value instanceof JsonObject) {
            return convertToGenericObject(parameterType[0], value);
        }
        if (value instanceof JsonArray) {
            if (parameterType.length == 1) {
                // no generic info
                return GsonUtils.getInstance().fromList(value.toString(), Object.class);
            }
            // generic collection
            final GenericCollection genericCollection = new GenericCollection(parameterType[1]);
            genericCollection.setCollection(convertToGenericObjects(parameterType[1], (Iterable<Object>) value));
            return genericCollection;
        }
        return value;
    }

    /**
     * convert json object to {@link GenericObject}.
     *
     * @param paramType  param type string
     * @param paramValue param value (if is object, auto to convert string)
     * @return {@link GenericObject},if is single customize type return  paramValue
     * @see GenericObject
     * @see #isSingleType(String)
     */
    private static Object convertToGenericObject(final String paramType, final Object paramValue) {
        if (isSingleType(paramType)) {
            return paramValue;
        }
        final Map<String, Object> mapValue = GsonUtils.getInstance().convertToMap(paramValue.toString());
        GenericObject genericObject = new GenericObject(paramType);
        mapValue.forEach(genericObject::putField);
        return genericObject;
    }

    /**
     * Convert to GenericObject.
     *
     * @param type   generic type.
     * @param params actual parameters.
     * @return list of GenericObject.
     */
    private static List<Object> convertToGenericObjects(final String type, final Iterable<Object> params) {
        List<Object> list = new ArrayList<>();
        for (Object param : params) {
            list.add(convertToGenericObject(type, param));
        }
        return list;
    }

    /**
     * only one parameter which is customized type.
     *
     * @param parameter parameter array.
     * @return only one parameter and it's customized type return true otherwise return false.
     */
    private static boolean isSingleType(final String[] parameter) {
        return parameter.length == 1 && isSingleType(parameter[0]);
    }

    /**
     * is single type.<br>
     * single type is package[java.xxx or [Ljava.xxx]
     *
     * @param parameterType parameter type.
     * @return type is single type
     */
    private static boolean isSingleType(final String parameterType) {
        return parameterType.startsWith("java");
    }

}
