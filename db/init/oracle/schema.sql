-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

create table dashboard_user
(
    id           VARCHAR2(128) not null,
    user_name    VARCHAR2(64) not null,
    password     VARCHAR2(128),
    role         NUMBER(10) not null,
    enabled      NUMBER(3) not null,
    client_id     VARCHAR2(32),
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id),
    constraint unique_user_name unique (user_name)
);
-- Add comments to the columns
comment on column DASHBOARD_USER.id
  is 'primary key id';
comment on column DASHBOARD_USER.user_name
  is 'user name';
comment on column DASHBOARD_USER.password
  is 'user password';
comment on column DASHBOARD_USER.role
  is 'role';
comment on column DASHBOARD_USER.enabled
  is 'delete or not';
comment on column DASHBOARD_USER.date_created
  is 'create time';
comment on column DASHBOARD_USER.date_updated
  is 'update time';

create table plugin
(
    id           VARCHAR2(128) not null,
    name         VARCHAR2(62) not null,
    config       CLOB,
    role         VARCHAR2(64) not null,
    sort         NUMBER(10),
    enabled      NUMBER(3) default '0' not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    plugin_jar   BLOB,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column PLUGIN.id
  is 'primary key id';
comment on column PLUGIN.name
  is 'plugin name';
comment on column PLUGIN.config
  is 'plugin configuration';
comment on column PLUGIN.role
  is 'plugin role';
comment on column PLUGIN.sort
  is 'sort';
comment on column PLUGIN.enabled
  is 'plugin whether to open (0 not open, 1 open)';
comment on column PLUGIN.date_created
  is 'create time';
comment on column PLUGIN.date_updated
  is 'update time';
comment on column PLUGIN.plugin_jar
  is 'plugin jar';


create table plugin_handle
(
    id           VARCHAR2(128) not null,
    plugin_id    VARCHAR2(128) not null,
    field        VARCHAR2(100) not null,
    label        VARCHAR2(100),
    data_type    NUMBER(5) default '1' not null,
    type         NUMBER(5),
    sort         NUMBER(10),
    ext_obj      clob,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id),
    constraint plugin_id_field_type unique (plugin_id,field,type)
);
-- Add comments to the columns
comment on column PLUGIN_HANDLE.plugin_id
  is 'plugin id';
comment on column PLUGIN_HANDLE.field
  is 'field';
comment on column PLUGIN_HANDLE.label
  is 'label';
comment on column PLUGIN_HANDLE.data_type
  is 'data type 1 number 2 string';
comment on column PLUGIN_HANDLE.type
  is 'type, 1 means selector, 2 means rule, 3 means plugin';
comment on column PLUGIN_HANDLE.sort
  is 'sort';
comment on column PLUGIN_HANDLE.ext_obj
  is 'extra configuration (json format data)';
comment on column PLUGIN_HANDLE.date_created
  is 'create time';
comment on column PLUGIN_HANDLE.date_updated
  is 'update time';

create table selector
(
    id           VARCHAR2(128) not null primary key,
    plugin_id    VARCHAR2(128) not null,
    name         VARCHAR2(64) not null,
    match_mode   NUMBER(10) not null,
    type         NUMBER(10) not null,
    sort         NUMBER(10) not null,
    handle       VARCHAR2(1024),
    enabled      NUMBER(3) not null,
    loged        NUMBER(3) not null,
    continued    NUMBER(3) not null,
    match_restful NUMBER(3) not null,
    namespace_id VARCHAR2(50) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null
);
-- Add comments to the columns
comment on column SELECTOR.id
  is 'primary key id varchar';
comment on column SELECTOR.plugin_id
  is 'plugin id';
comment on column SELECTOR.name
  is 'selector name';
comment on column SELECTOR.match_mode
  is 'matching mode (0 and 1 or)';
comment on column SELECTOR.type
  is 'type (0 full flow, 1 custom flow)';
comment on column SELECTOR.sort
  is 'sort';
comment on column SELECTOR.handle
  is 'processing logic (here for different plugins, there will be different fields to identify different processes, all data in JSON format is stored)';
comment on column SELECTOR.enabled
  is 'whether to open (0 not open, 1 open)';
comment on column SELECTOR.loged
  is 'whether to print the log (0 not print, 1 print)';
comment on column SELECTOR.continued
  is 'whether to continue execution';
comment on column SELECTOR.match_restful
  is 'whether to match restful(0 cache, 1 not cache)';
comment on column SELECTOR.namespace_id
  is 'namespace id';
comment on column SELECTOR.date_created
  is 'create time';
comment on column SELECTOR.date_updated
  is 'update time';

create table selector_condition
(
    id           VARCHAR2(128) not null,
    selector_id  VARCHAR2(128) not null,
    param_type   VARCHAR2(64) not null,
    operator     VARCHAR2(64) not null,
    param_name   VARCHAR2(64) not null,
    param_value  VARCHAR2(64) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column SELECTOR_CONDITION.id
  is 'primary key id';
comment on column SELECTOR_CONDITION.selector_id
  is 'selector id';
comment on column SELECTOR_CONDITION.param_type
  is 'parameter type (to query uri, etc.)';
comment on column SELECTOR_CONDITION.operator
  is 'matching character (=> <like matching)';
comment on column SELECTOR_CONDITION.param_name
  is 'parameter name';
comment on column SELECTOR_CONDITION.param_value
  is 'parameter value';
comment on column SELECTOR_CONDITION.date_created
  is 'create time';
comment on column SELECTOR_CONDITION.date_updated
  is 'update time';

create table rule
(
    id            VARCHAR2(128) not null PRIMARY KEY,
    selector_id   VARCHAR2(128) not null,
    match_mode    NUMBER(10) not null,
    name          VARCHAR2(128) not null,
    enabled       NUMBER(3) not null,
    loged         NUMBER(3) not null,
    match_restful NUMBER(3) not null,
    namespace_id VARCHAR2(50) not null,
    sort          NUMBER(10) not null,
    handle        VARCHAR2(1024),
    date_created  timestamp(3) default SYSDATE not null,
    date_updated  timestamp(3) default SYSDATE not null
);
-- Add comments to the columns
comment on column RULE.id
  is 'primary key id';
comment on column RULE.selector_id
  is 'selector id';
comment on column RULE.match_mode
  is 'matching mode (0 and 1 or)';
comment on column RULE.name
  is 'rule name';
comment on column RULE.enabled
  is 'whether to open (0 not open, 1 open)';
comment on column RULE.loged
  is 'whether to log or not (0 not print, 1 print)';
comment on column RULE.match_restful
  is 'whether to match restful(0 cache, 1 not cache)';
comment on column RULE.namespace_id
  is 'namespace id';
comment on column RULE.sort
  is 'sort';
comment on column RULE.handle
  is 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)';
comment on column RULE.date_created
  is 'create time';
comment on column RULE.date_updated
  is 'update time';

create table rule_condition
(
    id           VARCHAR2(128) not null PRIMARY KEY,
    rule_id      VARCHAR2(128) not null,
    param_type   VARCHAR2(64) not null,
    operator     VARCHAR2(64) not null,
    param_name   VARCHAR2(64) not null,
    param_value  VARCHAR2(64) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null
);
-- Add comments to the columns
comment on column RULE_CONDITION.id
  is 'primary key id';
comment on column RULE_CONDITION.rule_id
  is 'rule id';
comment on column RULE_CONDITION.param_type
  is 'parameter type (post query uri, etc.)';
comment on column RULE_CONDITION.operator
  is 'matching character (=> <like match)';
comment on column RULE_CONDITION.param_name
  is 'parameter name';
comment on column RULE_CONDITION.param_value
  is 'parameter value';
comment on column RULE_CONDITION.date_created
  is 'create time';
comment on column RULE_CONDITION.date_updated
  is 'update time';

create table meta_data
(
    id              VARCHAR2(128) not null,
    app_name        VARCHAR2(255) not null,
    path            VARCHAR2(255) not null,
    path_desc       VARCHAR2(255),
    rpc_type        VARCHAR2(64) not null,
    service_name    VARCHAR2(255),
    method_name     VARCHAR2(255),
    parameter_types VARCHAR2(255),
    rpc_ext         VARCHAR2(512),
    namespace_id VARCHAR2(50) not null,
    date_created    timestamp(3) default SYSDATE not null,
    date_updated    timestamp(3) default SYSDATE not null,
    enabled         NUMBER(3) default '0' not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column META_DATA.id
  is 'id';
comment on column META_DATA.app_name
  is 'application name';
comment on column META_DATA.path
  is 'path, cannot be repeated';
comment on column META_DATA.path_desc
  is 'path description';
comment on column META_DATA.rpc_type
  is 'rpc type';
comment on column META_DATA.service_name
  is 'service name';
comment on column META_DATA.method_name
  is 'method name';
comment on column META_DATA.parameter_types
  is 'parameter types are provided with multiple parameter types separated by commas';
comment on column META_DATA.rpc_ext
  is 'rpc extended information, json format';
comment on column META_DATA.namespace_id
  is 'namespace id';
comment on column META_DATA.date_created
  is 'create time';
comment on column META_DATA.date_updated
  is 'update time';
comment on column META_DATA.enabled
  is 'enabled state (0 close, 1 enabled) ';

create table mock_request_record
(
    id VARCHAR2(128) not null PRIMARY KEY,
    api_id VARCHAR2(128) not null,
    host VARCHAR2(32) not null,
    port NUMBER(5) not null,
    url VARCHAR2(1024) not null,
    path_variable VARCHAR2(255) default '' not null,
    query VARCHAR2(1024) default '' not null,
    header VARCHAR2(1024) default '' not null,
    body CLOB,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null
);
-- Add comments to the table
comment on table MOCK_REQUEST_RECORD
  is 'mock request records';
-- Add comments to the columns
comment on column MOCK_REQUEST_RECORD.id
  is 'id';
comment on column MOCK_REQUEST_RECORD.api_id
  is 'the api id';
comment on column MOCK_REQUEST_RECORD.host
  is 'the request host';
comment on column MOCK_REQUEST_RECORD.port
  is 'the request port';
comment on column MOCK_REQUEST_RECORD.url
    is 'the request url';
comment on column MOCK_REQUEST_RECORD.path_variable
  is 'the request param in url';
comment on column MOCK_REQUEST_RECORD.query
  is 'the request param after url';
comment on column MOCK_REQUEST_RECORD.header
  is 'the request param in header';
comment on column MOCK_REQUEST_RECORD.body
  is 'the request body';
comment on column MOCK_REQUEST_RECORD.date_created
  is 'create time';
comment on column MOCK_REQUEST_RECORD.date_updated
  is 'update time';

create table model
(
    id VARCHAR2(128) not null PRIMARY KEY,
    name VARCHAR2(128) not null,
    model_desc VARCHAR2(1024) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null
);
-- Add comments to the table
comment on table MODEL
  is 'model desc table';
-- Add comments to the columns
comment on column MODEL.id
  is 'id';
comment on column MODEL.name
  is 'the model name';
comment on column MODEL.model_desc
  is 'the model description';
comment on column MODEL.date_created
  is 'create time';
comment on column MODEL.date_updated
  is 'update time';
-- todo add some simple model, like java.lang.String long java.lang.Long

create table operation_record_log
(
    id                NUMBER(20) not null PRIMARY KEY,
    color             VARCHAR2(20) not null,
    context           CLOB not null,
    operator          VARCHAR2(200) not null,
    operation_time    timestamp(3) not null,
    operation_type    VARCHAR2(60) DEFAULT 'update' not null
);
-- Add comments to the columns
comment on column OPERATION_RECORD_LOG.id
  is 'id';
comment on column OPERATION_RECORD_LOG.color
  is 'log color';
comment on column OPERATION_RECORD_LOG.context
  is 'log context';
comment on column OPERATION_RECORD_LOG.operator
  is 'operator [user or app]]';
comment on column OPERATION_RECORD_LOG.operation_time
  is 'operation time';
comment on column OPERATION_RECORD_LOG.operation_type
  is 'operation type：create/update/delete/register...';

create sequence operation_record_log_seq
    increment by 1
    START WITH 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

create table api
(
    id VARCHAR2 (128) not null,
    context_path VARCHAR2 (255) not null,
    api_path VARCHAR2 (255) not null,
    http_method NUMBER (10) not null,
    consume VARCHAR2 (255) not null,
    produce VARCHAR2 (255) not null,
    version VARCHAR2 (255) not null,
    rpc_type VARCHAR2 (64) not null,
    state NUMBER (10) not null,
    ext VARCHAR2 (1025) not null,
    api_owner VARCHAR2 (255) not null,
    api_desc VARCHAR2 (1024) not null,
    document CLOB not null,
    document_md5 VARCHAR2 (32) not null,
    api_source NUMBER (10) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table API
  is 'api document';
-- Add comments to the columns
comment on column API.id
  is 'primary key id';
comment on column API.context_path
  is 'the context_path';
comment on column API.api_path
  is 'the api_path';
comment on column API.http_method
  is '0-get,1-head,2-post,3-put,4-patch,5-delete,6-options,7-trace';
comment on column API.consume
  is 'consume content-type';
comment on column API.produce
  is 'produce content-type';
comment on column API.version
  is 'api version,for example V0.01';
comment on column API.rpc_type
  is 'http,dubbo,sofa,tars,websocket,motan,grpc';
comment on column API.state
  is '0-unpublished,1-published,2-offline';
comment on column API.ext
  is 'extended fields';
comment on column API.api_owner
  is 'api_owner';
comment on column API.api_desc
  is 'the api description';
comment on column API.api_source
  is '0-swagger,1-annotation generation,2-create manually,3-import swagger,4-import yapi';
comment on column API.document
  is 'complete documentation of the api, including request parameters and response parameters';
comment on column API.document_md5
  is 'document_md5';
comment on column API.date_created
  is 'create time';
comment on column API.date_updated
  is 'update time';


create table api_rule_relation
(
    id VARCHAR2 (128) not null,
    api_id VARCHAR2 (128) not null,
    rule_id VARCHAR2 (128) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);

-- Add comments to the columns
comment on column API_RULE_RELATION.id
  is 'primary key id';
comment on column API_RULE_RELATION.api_id
  is 'the table api primary key id';
comment on column API_RULE_RELATION.rule_id
  is 'the table rule primary key id';
comment on column API_RULE_RELATION.date_created
  is 'create time';
comment on column API_RULE_RELATION.date_updated
  is 'update time';

create table app_auth
(
    id           VARCHAR2(128) not null,
    app_key      VARCHAR2(32) not null,
    app_secret   VARCHAR2(128) not null,
    user_id      VARCHAR2(128),
    phone        VARCHAR2(255),
    ext_info     VARCHAR2(1024),
    open         NUMBER(3) not null,
    enabled      NUMBER(3) not null,
    namespace_id VARCHAR2(50) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column APP_AUTH.id
  is 'primary key id';
comment on column APP_AUTH.app_key
  is 'application identification key';
comment on column APP_AUTH.app_secret
  is 'encryption algorithm secret';
comment on column APP_AUTH.user_id
  is 'user id';
comment on column APP_AUTH.phone
  is 'phone number when the user applies';
comment on column APP_AUTH.ext_info
  is 'extended parameter json';
comment on column APP_AUTH.open
  is 'open auth path or not (0 not open, 1 open) ';
comment on column APP_AUTH.enabled
  is 'delete or not (0 close, 1 open) ';
comment on column APP_AUTH.namespace_id
  is 'namespace id';
comment on column APP_AUTH.date_created
  is 'create time';
comment on column APP_AUTH.date_updated
  is 'update time';

create table auth_param
(
    id           VARCHAR2(128) not null,
    auth_id      VARCHAR2(128),
    app_name     VARCHAR2(255) not null,
    app_param    VARCHAR2(255),
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column AUTH_PARAM.id
  is 'primary key id';
comment on column AUTH_PARAM.auth_id
  is 'authentication table id';
comment on column AUTH_PARAM.app_name
  is 'business Module';
comment on column AUTH_PARAM.app_param
  is 'service module parameters (parameters that need to be passed by the gateway) json type';
comment on column AUTH_PARAM.date_created
  is 'create time';
comment on column AUTH_PARAM.date_updated
  is 'update time';

create table auth_path
(
    id           VARCHAR2(128) not null,
    auth_id      VARCHAR2(128) not null,
    app_name     VARCHAR2(255) not null,
    path         VARCHAR2(255) not null,
    enabled      NUMBER(3) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column AUTH_PATH.id
  is 'primary key id';
comment on column AUTH_PATH.auth_id
  is 'auth table id';
comment on column AUTH_PATH.app_name
  is 'module';
comment on column AUTH_PATH.path
  is 'path';
comment on column AUTH_PATH.enabled
  is 'whether pass 1 is (0 close, 1 open) ';
comment on column AUTH_PATH.date_created
  is 'create time';
comment on column AUTH_PATH.date_updated
  is 'update time';

create table shenyu_dict
(
    id           VARCHAR2(128) not null,
    type         VARCHAR2(100) not null,
    dict_code    VARCHAR2(100) not null,
    dict_name    VARCHAR2(100) not null,
    dict_value   VARCHAR2(2048),
    "desc"       VARCHAR2(255),
    sort         NUMBER(10) not null,
    enabled      NUMBER(3),
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id),
    constraint dict_type_dict_code_dict_name unique (type,dict_code,dict_name)
);
-- Add comments to the columns
comment on column SHENYU_DICT.id
  is 'primary key id';
comment on column SHENYU_DICT.type
  is 'type';
comment on column SHENYU_DICT.dict_code
  is 'dictionary encoding';
comment on column SHENYU_DICT.dict_name
  is 'dictionary name';
comment on column SHENYU_DICT.dict_value
  is 'dictionary value';
comment on column SHENYU_DICT."desc"
  is 'dictionary description or remarks';
comment on column SHENYU_DICT.sort
  is 'sort';
comment on column SHENYU_DICT.enabled
  is 'whether it is enabled (0 close, 1 open) ';
comment on column SHENYU_DICT.date_created
  is 'create time';
comment on column SHENYU_DICT.date_updated
  is 'update time';

create table role
(
    id           VARCHAR2(128) not null,
    role_name    VARCHAR2(32) not null,
    description  VARCHAR2(255),
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id,role_name)
);
-- Add comments to the table
comment on table ROLE
  is 'role table';
-- Add comments to the columns
comment on column ROLE.id
  is 'primary key id';
comment on column ROLE.role_name
  is 'role name';
comment on column ROLE.description
  is 'role describe';
comment on column ROLE.date_created
  is 'create time';
comment on column ROLE.date_updated
  is 'update time';

create table user_role
(
    id           VARCHAR2(128) not null,
    user_id      VARCHAR2(128) not null,
    role_id      VARCHAR2(128) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table USER_ROLE
  is 'user and role bind table';
-- Add comments to the columns
comment on column USER_ROLE.id
  is 'primary key id';
comment on column USER_ROLE.user_id
  is 'user primary key';
comment on column USER_ROLE.role_id
  is 'role primary key';
comment on column USER_ROLE.date_created
  is 'create time';
comment on column USER_ROLE.date_updated
  is 'update time';

create table param
(
    id           VARCHAR2(128) not null,
    api_id       VARCHAR2(128) not null,
    model_id     VARCHAR2(128) not null,
    type         NUMBER(10) not null,
    name         VARCHAR2(255) not null,
    param_desc   VARCHAR2(1024) not null,
    required     NUMBER(3) not null,
    ext          VARCHAR2(1024) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table PARAM
  is 'param document';
-- Add comments to the columns
comment on column PARAM.id
  is 'primary key id';
comment on column PARAM.api_id
  is 'the api id';
comment on column PARAM.model_id
  is 'the model id, empty if not a model';
comment on column PARAM.type
  is '0-requestPathVariable,1-requestUrlParam,2-requestHeader,3-requestBody,4-responseHeader,5-responseBody';
comment on column PARAM.name
  is 'the param name';
comment on column PARAM.param_desc
  is 'the param description';
comment on column PARAM.required
  is 'whether to require (0 not required, 1 required)';
comment on column PARAM.ext
  is 'extended fields';
comment on column PARAM.date_created
  is 'create time';
comment on column PARAM.date_updated
  is 'update time';

create table permission
(
    id           VARCHAR2(128) not null,
    object_id    VARCHAR2(128) not null,
    resource_id  VARCHAR2(128) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table PERMISSION
  is 'permission table';
-- Add comments to the columns
comment on column PERMISSION.id
  is 'primary key id';
comment on column PERMISSION.object_id
  is 'user primary key id or role primary key id';
comment on column PERMISSION.resource_id
  is 'resource primary key id';
comment on column PERMISSION.date_created
  is 'create time';
comment on column PERMISSION.date_updated
  is 'update time';

create table "resource"
(
    id            VARCHAR2(128) not null,
    parent_id     VARCHAR2(128) null,
    title         VARCHAR2(128) not null,
    name          VARCHAR2(32) null,
    url           VARCHAR2(32) null,
    component     VARCHAR2(32) null,
    resource_type NUMBER(10) not null,
    sort          NUMBER(10) not null,
    icon          VARCHAR2(32) null,
    is_leaf       NUMBER(3) not null,
    is_route      NUMBER(10) not null,
    perms         VARCHAR2(64) null,
    status        NUMBER(10) not null,
    date_created  timestamp(3) default SYSDATE not null,
    date_updated  timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table "resource"
  is 'resource table';
-- Add comments to the columns
comment on column "resource".id
  is 'primary key id';
comment on column "resource".parent_id
  is 'resource parent primary key id';
comment on column "resource".title
  is 'title';
comment on column "resource".name
  is 'route name';
comment on column "resource".url
  is 'route url';
comment on column "resource".component
  is 'component';
comment on column "resource".resource_type
  is 'resource type eg 0:main menu 1:child menu 2:function button';
comment on column "resource".sort
  is 'sort';
comment on column "resource".icon
  is 'icon';
comment on column "resource".is_leaf
  is 'leaf node 0:no 1:yes';
comment on column "resource".is_route
  is 'route 1:yes 0:no';
comment on column "resource".perms
  is 'button permission description sys:user:add(add);sys:user:edit(edit)';
comment on column "resource".status
  is 'status 1:enable 0:disable';
comment on column "resource".date_created
  is 'create time';
comment on column "resource".date_updated
  is 'update time';

create table data_permission
(
    id           VARCHAR2(128) not null,
    user_id      VARCHAR2(128) not null,
    data_id      VARCHAR2(128) not null,
    data_type    NUMBER(10) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table DATA_PERMISSION
  is 'data permission table';
-- Add comments to the columns
comment on column DATA_PERMISSION.id
  is 'primary key id';
comment on column DATA_PERMISSION.user_id
  is 'user primary key id';
comment on column DATA_PERMISSION.data_id
  is 'data(selector,rule) primary key id';
comment on column DATA_PERMISSION.data_type
  is '0 selector type , 1 rule type';
comment on column DATA_PERMISSION.date_created
  is 'create time';
comment on column DATA_PERMISSION.date_updated
  is 'update time';

create table detail
(
    id           VARCHAR2(128) not null,
    field_id     VARCHAR2(128) not null,
    is_example   NUMBER(3) not null,
    field_value  CLOB not null,
    value_desc   VARCHAR2(1024) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table DETAIL
  is 'field value detail table';
-- Add comments to the columns
comment on column DETAIL.id
  is 'primary key id';
comment on column DETAIL.field_id
  is 'the field id';
comment on column DETAIL.is_example
  is 'is example or not (0 not, 1 is)';
comment on column DETAIL.field_value
  is 'the field value';
comment on column DETAIL.value_desc
  is 'field value description';
comment on column DETAIL.date_created
  is 'create time';
comment on column DETAIL.date_updated
  is 'update time';

create table field
(
    id           VARCHAR2(128) not null,
    model_id     VARCHAR2(128) not null,
    self_model_id VARCHAR2(128) not null,
    name         VARCHAR2(128) not null,
    field_desc   VARCHAR2(1024) not null,
    required     NUMBER(3) not null,
    ext          VARCHAR2(1024) not null,
    date_created timestamp(3) default SYSDATE not null,
    date_updated timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the table
comment on table field
  is 'field document table';
-- Add comments to the columns
comment on column FIELD.id
  is 'primary key id';
comment on column FIELD.model_id
  is 'this field belongs to which model';
comment on column FIELD.self_model_id
  is 'which model of this field is';
comment on column FIELD.name
  is 'field name';
comment on column FIELD.field_desc
  is 'field description';
comment on column FIELD.required
  is 'whether to require (0 not required, 1 required)';
comment on column FIELD.ext
  is 'extended fields,can store genericTypes,eg..{"genericTypes":[model_id1,model_id2]}';
comment on column FIELD.date_created
  is 'create time';
comment on column FIELD.date_updated
  is 'update time';

/**default admin user**/
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(dashboard_user(id)) */ INTO dashboard_user (id, user_name, password, role, enabled) VALUES ('1','admin','ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413', '1', '1');

/** insert admin role */
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(user_role(id)) */ INTO user_role (id, user_id, role_id) VALUES ('1351007709096976384', '1', '1346358560427216896');
/** insert permission role for role */
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(role(id)) */ INTO role (id,role_name,description) VALUES ('1346358560427216896', 'super', 'Administrator');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(role(id)) */ INTO role (id,role_name,description) VALUES ('1385482862971723776', 'default', 'Standard');


insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885184', 'degradeRuleGrade', 'DEGRADE_GRADE_RT', 'slow call ratio', '0', 'degrade type-slow call ratio', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885185', 'degradeRuleGrade', 'DEGRADE_GRADE_EXCEPTION_RATIO', 'exception ratio', '1', 'degrade type-abnormal ratio', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885186', 'degradeRuleGrade', 'DEGRADE_GRADE_EXCEPTION_COUNT', 'exception number strategy', '2', 'degrade type-abnormal number strategy', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885187', 'flowRuleGrade', 'FLOW_GRADE_QPS', 'QPS', '1', 'grade type-QPS', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885188', 'flowRuleGrade', 'FLOW_GRADE_THREAD', 'number of concurrent threads', '0', 'degrade type-number of concurrent threads', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885189', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_DEFAULT', 'direct rejection by default', '0', 'control behavior-direct rejection by default', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885190', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_WARM_UP', 'warm up', '1', 'control behavior-warm up', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885191', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_RATE_LIMITER', 'constant speed queuing', '2', 'control behavior-uniform speed queuing', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885192', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_WARM_UP_RATE_LIMITER', 'preheating uniformly queued', '3', 'control behavior-preheating uniformly queued', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885193', 'permission', 'REJECT', 'reject', 'reject', 'reject', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885194', 'permission', 'ALLOW', 'allow', 'allow', 'allow', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885195', 'algorithmName', 'ALGORITHM_SLIDINGWINDOW', 'slidingWindow', 'slidingWindow', 'Sliding window algorithm', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885196', 'algorithmName', 'ALGORITHM_LEAKYBUCKET', 'leakyBucket', 'leakyBucket', 'Leaky bucket algorithm', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885197', 'algorithmName', 'ALGORITHM_CONCURRENT', 'concurrent', 'concurrent', 'Concurrent algorithm', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885198', 'algorithmName', 'ALGORITHM_TOKENBUCKET', 'tokenBucket', 'tokenBucket', 'Token bucket algorithm', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885199', 'loadBalance', 'LOAD_BALANCE', 'roundRobin', 'roundRobin', 'roundRobin', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885200', 'loadBalance', 'LOAD_BALANCE', 'random', 'random', 'random', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885201', 'loadBalance', 'LOAD_BALANCE', 'hash', 'hash', 'hash', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885202', 'status', 'DIVIDE_STATUS', 'close', 'false', 'close', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885203', 'status', 'DIVIDE_STATUS', 'open', 'true', 'open', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885204', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'multiple rule', '1', 'multiple rule', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897201885205', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'single rule', '0', 'single rule', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079488', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'multiple handle', '1', 'multiple handle', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079489', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'single handle', '0', 'single handle', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079490', 'matchMode', 'MATCH_MODE', 'and', '0', 'and', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079491', 'matchMode', 'MATCH_MODE', 'or', '1', 'or', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079492', 'operator', 'OPERATOR', 'match', 'match', 'match', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079493', 'operator', 'OPERATOR', '=', '=', '=', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079494', 'operator', 'OPERATOR', 'regex', 'regex', 'regex', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079495', 'operator', 'OPERATOR', 'contains', 'contains', 'contains', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079496', 'operator', 'OPERATOR', 'TimeBefore', 'TimeBefore', 'TimeBefore', 4, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079497', 'operator', 'OPERATOR', 'TimeAfter', 'TimeAfter', 'TimeAfter', 5, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079498', 'operator', 'OPERATOR', 'exclude', 'exclude', 'exclude', 6, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1618229897206079498', 'operator', 'OPERATOR', 'pathPattern', 'pathPattern', 'pathPattern', 7, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1618229897206079499', 'operator', 'OPERATOR', 'isBlank', 'isBlank', 'isBlank', 8, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079499', 'paramType', 'PARAM_TYPE', 'post', 'post', 'post', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079500', 'paramType', 'PARAM_TYPE', 'uri', 'uri', 'uri', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079501', 'paramType', 'PARAM_TYPE', 'query', 'query', 'query', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079502', 'paramType', 'PARAM_TYPE', 'host', 'host', 'host', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079503', 'paramType', 'PARAM_TYPE', 'ip', 'ip', 'ip', 4, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079504', 'paramType', 'PARAM_TYPE', 'header', 'header', 'header', 5, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079505', 'paramType', 'PARAM_TYPE', 'cookie', 'cookie', 'cookie', 6, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079506', 'paramType', 'PARAM_TYPE', 'req_method', 'req_method', 'req_method', 7, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079507', 'keyResolverName', 'WHOLE_KEY_RESOLVER', 'whole', 'WHOLE_KEY_RESOLVER', 'Rate limit by all request', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079508', 'keyResolverName', 'REMOTE_ADDRESS_KEY_RESOLVER', 'remoteAddress', 'REMOTE_ADDRESS_KEY_RESOLVER', 'Rate limit by remote address', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079509', 'automaticTransitionFromOpenToHalfOpenEnabled', 'AUTOMATIC_HALF_OPEN', 'open', 'true', null, 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079510', 'automaticTransitionFromOpenToHalfOpenEnabled', 'AUTOMATIC_HALF_OPEN', 'close', 'false', null, 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079511', 'paramType', 'PARAM_TYPE', 'domain', 'domain', 'domain', 8, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079512', 'strategyName', 'STRATEGY_NAME', 'rsa', 'rsa', 'rsa strategy', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079513', 'way', 'WAY', 'encrypt', 'encrypt', 'encrypt', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079514', 'way', 'WAY', 'decrypt', 'decrypt', 'decrypt', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079515', 'mode', 'MODE', 'cluster', 'cluster', 'cluster', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079516', 'mode', 'MODE', 'sentinel', 'sentinel', 'sentinel', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079517', 'mode', 'MODE', 'standalone', 'standalone', 'standalone', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079518', 'gray', 'GRAY_STATUS', 'close', 'false', 'close', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079519', 'gray', 'GRAY_STATUS', 'open', 'true', 'open', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079520', 'threadpool', 'THREADPOOL', 'shared', 'shared', null, 4, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079521', 'threadpool', 'THREADPOOL', 'fixed', 'fixed', null, 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079522', 'threadpool', 'THREADPOOL', 'eager', 'eager', null, 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079523', 'threadpool', 'THREADPOOL', 'cached', 'cached', null, 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079524', 'threadpool', 'THREADPOOL', 'limited', 'limited', null, 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079525', 'retryStrategy', 'RETRY_STRATEGY', 'current', 'current', 'current', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079526', 'retryStrategy', 'RETRY_STRATEGY', 'failover', 'failover', 'failover', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079527', 'table', 'INIT_FLAG', 'status', 'false', 'table(resource,permission) init status', 0, 0);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079528', 'compressAlg', 'COMPRESS_ALG', 'none', 'none', null, 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079529', 'compressAlg', 'COMPRESS_ALG', 'LZ4', 'LZ4', null, 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079530', 'cacheType', 'CACHE_TYPE_MEMORY', 'memory', 'memory', 'use memory to cache data', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079531', 'cacheType', 'CACHE_TYPE_REDIS', 'redis', 'redis', 'use redis to cache data', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079532', 'threadpool', 'THREADPOOL', 'default', 'default', null, 5, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079533', 'signRequestBody', 'SIGN_REQUEST_BODY', 'close', 'false', 'close', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1518229897206079534', 'signRequestBody', 'SIGN_REQUEST_BODY', 'open', 'true', 'open', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545811989312315392', 'apidoc', 'API_DOC_GLOBAL_FLAG', 'status', 'true', 'Global switching (on or off) of API documents.', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812101056962560', 'apidocEnv', 'ENV_LABEL_OFFLINE', 'Offline', 'http://127.0.0.1:9195', 'Offline environment', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812228228259840', 'apidocEnv', 'ENV_LABEL_ONLINE', 'Online', 'http://127.0.0.1:9196', 'Online environment', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812228228259841', 'engine', 'engine', 'ReplacingMergeTree', 'ReplacingMergeTree', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812228228259842', 'engine', 'engine', 'MergeTree', 'MergeTree', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1572621976689762310', 'engine', 'engine', 'ReplicatedReplicatedMergeTree', 'ReplicatedReplicatedMergeTree', '', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1572621976689762311', 'engine', 'engine', 'ReplicatedMergeTree', 'ReplicatedMergeTree', '', 3, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ INTO SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812228228259843', 'loadBalance', 'LOAD_BALANCE', 'leastActive', 'leastActive', 'leastActive', 3, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ INTO SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812228228259844', 'loadBalance', 'LOAD_BALANCE', 'p2c', 'p2c', 'p2c', 4, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ INTO SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1545812228228259845', 'loadBalance', 'LOAD_BALANCE', 'shortestResponse', 'shortestResponse', 'shortestResponse', 5, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ INTO SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737478', 'rewriteMetaData', 'REWRITE_META_DATA', 'true', 'true', '', 4, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ INTO SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737479', 'rewriteMetaData', 'REWRITE_META_DATA', 'false', 'false', '', 4, 1);

/*plugin*/
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('1','sign','Authentication',  20, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort,config,enabled) VALUES ('2','waf', 'Authentication', 50,'{"model":"black"}','0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('3','rewrite', 'HttpProcess', 90,'0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config,enabled) VALUES ('4','rateLimiter','FaultTolerance', 60,'{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config,enabled) VALUES ('5','divide', 'Proxy', 200,'{"multiSelectorHandle":"1","multiRuleHandle":"0"}','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config,enabled) VALUES ('6','dubbo','Proxy', 310,'{"register":"zookeeper://localhost:2181","multiSelectorHandle":"1","threadpool":"shared","corethreads":0,"threads":2147483647,"queues":0}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('9','hystrix', 'FaultTolerance', 130,'0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('10','sentinel', 'FaultTolerance', 140,'0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('11','sofa', 'Proxy', 310, '{"protocol":"zookeeper","register":"127.0.0.1:2181","threadpool":"shared"}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('12','resilience4j', 'FaultTolerance', 310,'0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('13', 'tars', 'Proxy', 310,'{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}','0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('14', 'contextPath', 'HttpProcess', 80,'1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('15', 'grpc', 'Proxy', 310,'{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}','0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('16', 'redirect', 'HttpProcess', 110,'0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('17', 'motan', 'Proxy', 310,'{"registerProtocol":"zk",registerAddress":"127.0.0.1:2181","corethreads":0,"threads":2147483647,"queues":0,"threadpool":"shared"}','0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('18', 'loggingConsole', 'Logging', 160, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('19', 'jwt', 'Authentication', 30, '{"secretKey":"key"}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('20', 'request', 'HttpProcess', 120, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('21', 'oauth2', 'Authentication', 40, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('22', 'paramMapping','HttpProcess', 70, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('23', 'modifyResponse', 'HttpProcess', 220, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('24', 'cryptorRequest', 'Cryptor', 100, '1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('25', 'cryptorResponse', 'Cryptor', 410, '1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('26', 'websocket', 'Proxy', 200, '{"multiSelectorHandle":"1"}', '1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('27', 'generalContext', 'Common', 125, '1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('28', 'mqtt', 'Proxy', 125, '{"port": 9500,"bossGroupThreadCount": 1,"maxPayloadSize": 65536,"workerGroupThreadCount": 12,"userName": "shenyu","password": "shenyu","isEncryptPassword": false,"encryptMode": "","leakDetectorLevel": "DISABLED"}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('29', 'loggingRocketMQ', 'Logging', 170,'{"topic":"shenyu-access-logging", "namesrvAddr": "localhost:9876","producerGroup":"shenyu-plugin-logging-rocketmq"}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('30', 'cache', '{"cacheType":"memory"}', 'Cache', 10, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('31', 'mock', 'Mock', 1, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('32', 'loggingElasticSearch', '{"host":"localhost", "port": "9200"}', 'Logging', 190, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('33', 'loggingKafka', '{"topic":"shenyu-access-logging", "namesrvAddr": "localhost:9092"}', 'Logging', 180, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('34', 'loggingAliyunSls', '{"projectName": "shenyu", "logStoreName": "shenyu-logstore", "topic": "shenyu-topic"}', 'Logging', 175, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('35', 'loggingPulsar', '{"topic":"shenyu-access-logging", "serviceUrl": "pulsar://localhost:6650"}', 'Logging', 185, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('36', 'loggingTencentCls', '{"endpoint": "ap-guangzhou.cls.tencentcs.com", "topic": "shenyu-topic"}', 'Logging', 176, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('38', 'loggingClickHouse', '{"host":"127.0.0.1","port":"8123","databse":"shenyu-gateway","username":"foo","password":"bar"}', 'Logging', 195, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('39', 'casdoor', '{"endpoint":"http://localhost:8000"}' ,'Authentication', 40, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, enabled) VALUES ('40', 'keyAuth', 'Authentication', 150, '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('42', 'tcp', 'Proxy', 320, null, '1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('43', 'loggingHuaweiLts', 'Logging', 177, '{"totalSizeInBytes":"104857600","maxBlockMs":"0","ioThreadCount":"1","batchSizeThresholdInBytes":"524288","batchCountThreshold":"4096","lingerMs":"2000","retries":"100","baseRetryBackoffMs":"100","maxRetryBackoffMs":"100","enableLocalTest":"true","setGiveUpExtraLongSingleLog":"false"}','0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('44', 'basicAuth', 'Authentication', 150, '{"defaultHandleJson":"{\"authorization\":\"test:test123\"}"}','0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, role, sort, config, enabled) VALUES ('45', 'loggingRabbitmq', 'Logging', 171, '{"host":"127.0.0.1","port":5672,"password":"admin","username":"admin","exchangeName":"exchange.logging.plugin","queueName":"queue.logging.plugin","routingKey":"topic.logging","virtualHost":"/","exchangeType":"direct","durable":"true","exclusive":"false","autoDelete":"false"}', '0');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('50', 'aiProxy', '{"provider":"OpenAI","baseUrl":"https://api.openai.com/v1/chat/completions","model":"gpt-4o-mini","apiKey":"your_api_key","temperature":"0.5","maxTokens":"1000","stream":"false","prompt":""}', 'Ai', 199, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled) VALUES ('51', 'aiTokenLimiter', NULL, 'Ai', 171, 0);

/*insert plugin_handle data for sentinel*/
insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468118', '6', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468119', '6', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"http://","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468120', '6', 'status', 'status', 3, 1, 8, '{"defaultValue":"true","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468121', '6', 'timestamp', 'startupTime', 1, 1, 7, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468122', '6', 'upstreamHost', 'host', 2, 1, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468123', '6', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468124', '6', 'version', 'version', 2, 1, 4, '{"required":"0","placeholder":"version","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468125', '6', 'warmup', 'warmupTime', 1, 1, 6, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468126', '6', 'weight', 'weight', 1, 1, 5, '{"defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468127', '6', 'threadpool', 'threadpool', 3, 3, 0, '{"required":"0","defaultValue":"cached","placeholder":"threadpool","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468128', '6', 'corethreads', 'corethreads', 1, 3, 0, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468129', '6', 'threads', 'threads', 1, 3, 0, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468130', '6', 'queues', 'queues', 1, 3, 0, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204173923', '6', 'timeout', 'timeout', 3, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204173924', '6', 'retries', 'retries', 3, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204173925', '6', 'loadBalance', 'loadStrategy', 3, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468131', '26', 'host', 'host', 2, 1, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468132', '26', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"ws://","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468133', '26', 'url', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468134', '26', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468135', '26', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468136', '26', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468137', '26', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468138', '26', 'loadBalance', 'loadStrategy', 3, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468139', '26', 'retry', 'retryCount', 1, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468140', '26', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468141', '26', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468142', '17', 'registerProtocol', 'registerProtocol', 2, 3, 0, '{"required":"0","defaultValue":"direct","placeholder":"registerProtocol","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1679002911061737473', '17', 'registerAddress', 'registerAddress', 2, 3, 1, '{"required":"0","defaultValue":"127.0.0.1:2181","placeholder":"registerAddress","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468143', '28', 'port', 'port', 1, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468144', '28', 'bossGroupThreadCount', 'bossGroupThreadCount', 1, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468145', '28', 'maxPayloadSize', 'maxPayloadSize', 1, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468146', '28', 'workerGroupThreadCount', 'workerGroupThreadCount', 1, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468147', '28', 'userName', 'userName', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468148', '28', 'password', 'password', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468149', '28', 'isEncryptPassword', 'isEncryptPassword', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468150', '28', 'encryptMode', 'encryptMode', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468151', '28', 'leakDetectorLevel', 'leakDetectorLevel', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468152', '29', 'topic', 'topic', 2, 3, 1, '{"required":"1","defaultValue":"shenyu-access-logging"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468153', '29', 'namesrvAddr', 'namesrvAddr', 2, 3, 2, '{"required":"1","defaultValue":"localhost:9876"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468154', '29', 'producerGroup', 'producerGroup', 2, 3, 3, '{"required":"1","defaultValue":"shenyu-plugin-logging-rocketmq"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468155', '29', 'accessKey', 'accessKey', 2, 3, 4, '{"required":"0","defaultValue":"","placeholder":"accessKey"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468156', '29', 'secretKey', 'secretKey', 2, 3, 5, '{"required":"0","defaultValue":"","placeholder":"secretKey"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468157', '29', 'sampleRate', 'sampleRate', 2, 3, 6, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468158', '29', 'maxResponseBody', 'maxResponseBody', 1, 3, 7, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468159', '29', 'maxRequestBody', 'maxRequestBody', 1, 3, 8, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468160', '29', 'compressAlg', 'compressAlg', 3, 3, 9, '{"required":"0","defaultValue":"none"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468161', '29', 'topic', 'topic', 2, 1, 1, '{"required":"0","defaultValue":"","placeholder":"optional"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468162', '29', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468163', '30', 'cacheType', 'cacheType', 3, 3, 1, '{"required":"1","defaultValue":"memory","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662400', '30', 'database', 'database', 1, 3, 2, '{"required":"0","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662401', '30', 'master', 'master', 2, 3, 3, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662402', '30', 'mode', 'mode', 2, 3, 4, '{"required":"0","defaultValue":"standalone","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662403', '30', 'url', 'url', 2, 3, 5, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662404', '30', 'password', 'password', 2, 3, 6, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662405', '30', 'maxIdle', 'maxIdle', 1, 3, 7, '{"required":"0","defaultValue":"8","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662406', '30', 'minIdle', 'minIdle', 1, 3, 8, '{"required":"0","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662407', '30', 'maxActive', 'maxActive', 1, 3, 9, '{"required":"0","defaultValue":"8","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662408', '30', 'maxWait', 'maxWait', 3, 3, 10, '{"required":"0","defaultValue":"-1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897218662409', '30', 'timeoutSeconds', 'timeoutSeconds', 1, 2, 0, '{"required":"0","defaultValue":"60","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897206079532', '10', 'flowRuleGrade', 'flowRuleGrade', 3, 2, 8, '{"required":"1","defaultValue":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897206079533', '10', 'flowRuleControlBehavior', 'flowRuleControlBehavior', 3, 2, 5, '{"required":"1","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897206079534', '10', 'flowRuleEnable', 'flowRuleEnable 1 or 0', 1, 2, 7, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897206079535', '10', 'flowRuleCount', 'flowRuleCount', 1, 2, 6, '{"required":"1","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897206079536', '10', 'degradeRuleEnable', 'degradeRuleEnable 1 or 0', 1, 2, 2, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897206079537', '10', 'degradeRuleGrade', 'degradeRuleGrade', 3, 2, 3, '{"required":"1","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273792', '10', 'degradeRuleCount', 'degradeRuleCount', 1, 2, 1, '{"required":"1","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273793', '10', 'degradeRuleTimeWindow', 'degradeRuleTimeWindow', 1, 2, 4, '{"required":"1","defaultValue":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273794', '10', 'degradeRuleMinRequestAmount', 'degradeRuleMinRequestAmount', 1, 2, 3, '{"required":"1","defaultValue":"5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273795', '10', 'degradeRuleStatIntervals', 'degradeRuleStatIntervals', 1, 2, 3, '{"required":"1","defaultValue":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273796', '10', 'degradeRuleSlowRatioThreshold', 'degradeRuleSlowRatioThreshold', 1, 2, 3, '{"required":"1","defaultValue":"0.5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273797', '10', 'fallbackUri', 'fallbackUri', 2, 2, 9, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273798', '2', 'permission', 'permission', 3, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273799', '2', 'statusCode', 'statusCode', 2, 2, 2, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273800', '4', 'replenishRate', 'replenishRate', 2, 2, 2, '{"required":"1","defaultValue":"10","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273801', '4', 'burstCapacity', 'burstCapacity', 2, 2, 3, '{"required":"1","defaultValue":"100","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273802', '3', 'regex', 'regex', 2, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273803', '3', 'replace', 'replace', 2, 2, 2, null);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1697146860569596304', '3', 'percentage', 'percentage', 1, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273804', '16', 'redirectURI', 'redirectURI', 2, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273808', '12', 'timeoutDurationRate', 'timeoutDurationRate ms)', 1, 2, 1, '{"required":"1","defaultValue":"5000","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273809', '12', 'limitRefreshPeriod', 'limitRefreshPeriod ms)', 1, 2, 0, '{"required":"1","defaultValue":"500","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273810', '12', 'limitForPeriod', 'limitForPeriod', 1, 2, 0, '{"required":"1","defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273811', '12', 'circuitEnable', 'circuitEnable', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273812', '12', 'timeoutDuration', 'timeoutDuration ms)', 1, 2, 2, '{"required":"1","defaultValue":"30000","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273813', '12', 'fallbackUri', 'fallbackUri', 2, 2, 2, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273814', '12', 'slidingWindowSize', 'slidingWindowSize', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273815', '12', 'slidingWindowType', 'slidingWindowType', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273816', '12', 'minimumNumberOfCalls', 'minimumNumberOfCalls', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273817', '12', 'waitIntervalFunctionInOpenState', 'waitIntervalInOpen', 1, 2, 2, '{"required":"1","defaultValue":"60000","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273818', '12', 'permittedNumberOfCallsInHalfOpenState', 'bufferSizeInHalfOpen', 1, 2, 2, '{"required":"1","defaultValue":"10","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273819', '12', 'failureRateThreshold', 'failureRateThreshold', 1, 2, 2, '{"required":"1","defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273820', '12', 'automaticTransitionFromOpenToHalfOpenEnabled', 'automaticHalfOpen', 3, 2, 1, '{"required":"1","defaultValue":"true","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273821', '4', 'mode', 'mode', 3, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273822', '4', 'master', 'master', 2, 3, 2, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273823', '4', 'url', 'url', 2, 3, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273824', '4', 'password', 'password', 2, 3, 4, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273825', '11', 'protocol', 'protocol', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273826', '11', 'register', 'register', 2, 3, 2, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273827', '2', 'model', 'model', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273828', '6', 'register', 'register', 2, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273829', '4', 'algorithmName', 'algorithmName', 3, 2, 1, '{"required":"1","defaultValue":"slidingWindow","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273830', '4', 'keyResolverName', 'keyResolverName', 3, 2, 4, '{"required":"1","defaultValue":"WHOLE_KEY_RESOLVER","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273831', '5', 'upstreamHost', 'host', 2, 1, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273832', '5', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"http://","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273833', '5', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273834', '5', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273835', '5', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273836', '5', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273837', '5', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273838', '5', 'loadBalance', 'loadStrategy', 3, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273839', '5', 'retry', 'retryCount', 1, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273840', '5', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273841', '5', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273842', '5', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273843', '5', 'headerMaxSize', 'headerMaxSize', 1, 2, 3, '{"defaultValue":"10240","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273844', '5', 'requestMaxSize', 'requestMaxSize', 1, 2, 4, '{"defaultValue":"102400","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273845', '5', 'retryStrategy', 'retryStrategy', 3, 2, 0, '{"required":"0","defaultValue":"current","placeholder":"retryStrategy","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273846', '13', 'upstreamHost', 'host', 2, 1, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273847', '13', 'protocol', 'protocol', 2, 1, 2, '{"defaultValue":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273848', '13', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273849', '13', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273850', '13', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273851', '13', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273852', '13', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273853', '13', 'loadBalance', 'loadStrategy', 3, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273854', '13', 'retry', 'retryCount', 1, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273855', '13', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273856', '13', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273857', '13', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273858', '13', 'corethreads', 'corethreads', 1, 3, 3, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273859', '13', 'threads', 'threads', 1, 3, 4, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273860', '13', 'queues', 'queues', 1, 3, 5, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897210273861', '13', 'threadpool', 'threadpool', 3, 3, 2, '{"required":"0","defaultValue":"default","placeholder":"threadpool","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468095', '15', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468096', '15', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468097', '15', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468098', '15', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468099', '15', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468100', '15', 'threadpool', 'threadpool', 3, 3, 0, '{"required":"0","defaultValue":"cached","placeholder":"threadpool","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468101', '14', 'contextPath', 'contextPath', 2, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468102', '14', 'addPrefix', 'addPrefix', 2, 2, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468104', '19', 'secretKey', 'secretKey', 2, 3, 0, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468105', '24', 'strategyName', 'strategyName', 3, 2, 1, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468106', '24', 'fieldNames', 'fieldNames', 2, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468107', '24', 'decryptKey', 'decryptKey', 2, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468108', '24', 'encryptKey', 'encryptKey', 2, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468109', '24', 'way', 'way', 3, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1630760188111376384', '24', 'mapType', 'mapType', 3, 2, 3, '{\"required\":\"0\",\"defaultValue\":\"all\",\"rule\":\"\"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468110', '25', 'strategyName', 'strategyName', 3, 2, 2, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468111', '25', 'decryptKey', 'decryptKey', 2, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468112', '25', 'encryptKey', 'encryptKey', 2, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468113', '25', 'fieldNames', 'fieldNames', 2, 2, 4, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468114', '25', 'way', 'way', 3, 2, 3, null);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1630768384280514560', '25', 'mapType', 'mapType', 3, 2, 4, '{\"required\":\"0\",\"defaultValue\":\"all\",\"rule\":\"\"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468115', '6', 'gray', 'gray', 3, 1, 9, '{"required":"0","defaultValue":"false","placeholder":"gray","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468116', '6', 'group', 'group', 2, 1, 3, '{"required":"0","placeholder":"group","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468117', '6', 'loadbalance', 'loadbalance', 3, 2, 0, '{"required":"0","placeholder":"loadbalance","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468164', '11', 'corethreads', 'corethreads', 1, 3, 4, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468165', '11', 'threads', 'threads', 1, 3, 5, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468166', '11', 'queues', 'queues', 1, 3, 6, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468167', '11', 'threadpool', 'threadpool', 3, 3, 3, '{"required":"0","defaultValue":"default","placeholder":"threadpool","rule":""}');


insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1537326008606343168', '31', 'responseContent', 'responseContent', 2, 2, 0, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1537325892176658432', '31', 'httpStatusCode', 'httpStatusCode', 1, 2, 0, '{"required":"0","defaultValue":"200","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468168', '32', 'host', 'host', 2, 3, 1, '{"required":"1","defaultValue":"localhost"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468169', '32', 'port', 'port', 2, 3, 2, '{"required":"1","defaultValue":"9200"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468092', '32', 'username', 'username', 2, 3, 3, '{"required":"0","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468093', '32', 'password', 'password', 2, 3, 4, '{"required":"0","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468094', '32', 'authCache', 'authCache', 2, 3, 5, '{"required":"0","defaultValue":"","placeholder":"true|false"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468170', '32', 'sampleRate', 'sampleRate', 2, 3, 6, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468171', '32', 'maxResponseBody', 'maxResponseBody', 1, 3, 7, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468172', '32', 'maxRequestBody', 'maxRequestBody', 1, 3, 8, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468173', '32', 'compressAlg', 'compressAlg', 3, 3, 9, '{"required":"0","defaultValue":"none"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468174', '32', 'indexName', 'indexName', 2, 3, 10, '{"required":"1","defaultValue":"shenyu-access-logging"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468175', '32', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468176', '1', 'signRequestBody', 'signRequestBody', 3, 2, 9, '{"required":"0","defaultValue":"false","placeholder":"signRequestBody","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468177', '33', 'topic', 'topic', 2, 3, 1, '{"required":"1","defaultValue":"shenyu-access-logging"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468178', '33', 'namesrvAddr', 'namesrvAddr', 2, 3, 2, '{"required":"1","defaultValue":"localhost:9092"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468179', '33', 'sampleRate', 'sampleRate', 2, 3, 4, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468180', '33', 'maxResponseBody', 'maxResponseBody', 1, 3, 5, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468181', '33', 'maxRequestBody', 'maxRequestBody', 1, 3, 6, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468182', '33', 'compressAlg', 'compressAlg', 3, 3, 7, '{"required":"0","defaultValue":"none"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468183', '33', 'topic', 'topic', 2, 1, 1, '{"required":"0","defaultValue":"","placeholder":"optional"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468184', '33', 'securityProtocol', 'securityProtocol', 3, 3, 8, '{"required":"0","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468185', '33', 'saslMechanism', 'saslMechanism', 3, 3, 9, '{"required":"0","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468186', '33', 'userName', 'userName',  2, 3, 10, '{"required":"0","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468187', '33', 'passWord', 'passWord', 2, 3, 11, '{"required":"0","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468188', '34', 'accessId', 'accessId', 2, 3, 0, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468189', '34', 'accessKey', 'accessKey', 2, 3, 1, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468190', '34', 'host', 'host', 2, 3, 2, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468191', '34', 'projectName', 'projectName', 2, 3, 3, '{"required":"0","defaultValue":"shenyu","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468192', '34', 'logStoreName', 'logStoreName', 2, 3, 4, '{"required":"0","defaultValue":"shenyu-logstore","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468193', '34', 'topic', 'topic', 2, 3, 5, '{"required":"0","defaultValue":"shenyu-topic","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468194', '34', 'ttlInDay', 'ttlInDay', 1, 3, 6, '{"required":"0","defaultValue":3,"placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468195', '34', 'shardCount', 'shardCount', 1, 3, 7, '{"required":"0","defaultValue":10,"placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468196', '34', 'sendThreadCount', 'sendThreadCount', 1, 3, 8, '{"required":"0","defaultValue":1,"placeholder":"1-500"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468197', '34', 'ioThreadCount', 'ioThreadCount', 1, 3, 9, '{"required":"0","defaultValue":1,"placeholder":"1-500"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468198', '34', 'sampleRate', 'sampleRate', 2, 3, 10, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468199', '34', 'maxRequestBody', 'maxRequestBody', 1, 3, 11, '{"required":"0","defaultValue":524288,"placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468200', '34', 'maxResponseBody', 'maxResponseBody', 1, 3, 12, '{"required":"0","defaultValue":524288,"placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468201', '34', 'bufferQueueSize', 'bufferQueueSize', 1, 3, 13, '{"required":"0","defaultValue":524288,"placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468202', '35', 'topic', 'topic', 2, 3, 1, '{"required":"1","defaultValue":"shenyu-access-logging"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468203', '35', 'serviceUrl', 'serviceUrl', 2, 3, 2, '{"required":"1","defaultValue":"pulsar://localhost:6650"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468204', '35', 'sampleRate', 'sampleRate', 2, 3, 4, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468205', '35', 'maxResponseBody', 'maxResponseBody', 1, 3, 5, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468206', '35', 'maxRequestBody', 'maxRequestBody', 1, 3, 6, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468207', '35', 'compressAlg', 'compressAlg', 3, 3, 7, '{"required":"0","defaultValue":"none"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468208', '36', 'secretId', 'secretId', 2, 3, 1, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468209', '36', 'secretKey', 'secretKey', 2, 3, 2, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468210', '36', 'endpoint', 'endpoint', 2, 3, 3, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468211', '36', 'topic', 'topic', 2, 3, 4, '{"required":"1","defaultValue":"","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468212', '36', 'sendThreadCount', 'sendThreadCount', 1, 3, 5, '{"required":"0","defaultValue":1,"placeholder":"1-500"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468213', '36', 'totalSizeInBytes', 'totalSizeInBytes', 1, 3, 6, '{"required":"0","defaultValue":104857600}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468214', '36', 'maxSendThreadCount', 'maxSendThreadCount', 1, 3, 7, '{"required":"0","defaultValue":1,"placeholder":"availableProcessors + 1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468215', '36', 'maxBlockSec', 'maxBlockSec', 1, 3, 8, '{"required":"0","defaultValue":60000}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468216', '36', 'maxBatchSize', 'maxBatchSize', 1, 3, 9, '{"required":"0","defaultValue":524288}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468217', '36', 'maxBatchCount', 'maxBatchCount', 1, 3, 10, '{"required":"0","defaultValue":4096}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468218', '36', 'lingerMs', 'lingerMs', 1, 3, 11, '{"required":"0","defaultValue":2000}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468219', '36', 'retries', 'retries', 1, 3, 12, '{"required":"0","defaultValue":10}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468220', '36', 'maxReservedAttempts', 'maxReservedAttempts', 1, 3, 13, '{"required":"0","defaultValue":11}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468221', '36', 'baseRetryBackoffMs', 'baseRetryBackoffMs', 1, 3, 14, '{"required":"0","defaultValue":100}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468222', '36', 'maxRetryBackoffMs', 'maxRetryBackoffMs', 1, 3, 15, '{"required":"0","defaultValue":50000}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468223', '38', 'host', 'host', 2, 3, 1, '{"required":"0","defaultValue":"127.0.0.1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468224', '38', 'port', 'port', 2, 3, 1, '{"required":"0","defaultValue":"8123"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468225', '38', 'database', 'database', 2, 2, 0, '{"required":"0","defaultValue":"shenyu-gateway","placeholder":"database"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468226', '38', 'username', 'username', 2, 2, 0, '{"required":"0","defaultValue":"foo","placeholder":"username"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468227', '38', 'password', 'password', 2, 2, 0, '{"required":"0","defaultValue":"bar","placeholder":"password"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468229', '10', 'flowRuleMaxQueueingTimeMs', 'flowRuleMaxQueueingTimeMs', 1, 2, 6, '{"required":"0","defaultValue":"500"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468230', '10', 'flowRuleWarmUpPeriodSec', 'flowRuleWarmUpPeriodSec', 1, 2, 6, '{"required":"0","defaultValue":"10"}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1518229897214468231', '14', 'addPrefixed', 'addPrefixed', 3, 2, 3, '{"required":"1","defaultValue":"false"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1570590990341775360', '39', 'endpoint', 'casdoor endpoint', 2, 3, 0, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1570591047635968000', '39', 'client_id', 'client_id', 2, 3, 0, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1570591109623586816', '39', 'client_secrect', 'client_secrect', 2, 3, 0, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1570591165374275584', '39', 'certificate', 'certificate', 2, 3, 0, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1570591215131303936', '39', 'organization-name', 'organization-name', 2, 3, 0, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1570591265492312064', '39', 'application-name', 'application-name', 2, 3, 0, '{"required":"1","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468091', '18', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468232', '18', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468233', '18', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468234', '29', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468235', '29', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468236', '29', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468237', '32', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468238', '32', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468239', '32', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468240', '33', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468241', '33', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468242', '33', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468243', '34', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468244', '34', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468245', '34', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468246', '35', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468247', '35', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468248', '35', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468249', '36', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468250', '36', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468251', '36', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468252', '38', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468253', '38', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468254', '38', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468255', '38', 'host', 'host', 2, 3, 3, '{"required":"1","defaultValue":"127.0.0.1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468256', '38', 'port', 'port', 2, 3, 4, '{"required":"1","defaultValue":"8123"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468257', '38', 'database', 'database', 2, 3, 5, '{"required":"0","defaultValue":"shenyu-gateway"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468258', '38', 'username', 'username', 2, 3, 6, '{"required":"1","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468259', '38', 'password', 'password', 2, 3, 7, '{"required":"1","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468260', '38', 'password', 'password', 2, 3, 7, '{"required":"1","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1518229897214468261', '38', 'engine', 'engine', 3, 3, 8, '{"required":"0","defaultValue":"MergeTree"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172862', '38', 'clusterName', 'clusterName', 3, 3, 9, '{"required":"1","defaultValue":"cluster"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204172777', '38', 'ttl', 'ttl', 3, 3, 10,  '{\"required\":\"0\",\"defaultValue\":\"30\"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172863', '43', 'projectId', 'projectId', 2, 3, 0, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172864', '43', 'logGroupId', 'logGroupId', 2, 3, 1, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172865', '43', 'logStreamId', 'logStreamId', 2, 3, 2, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172866', '43', 'accessKeyId', 'AccessKey', 2, 3, 4, '{"required":"1","placeholder":"accessKeyId","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172867', '43','accessKeySecret', 'accessKey', 2, 3, 5, '{"required":"1","placeholder":"accessKeySecret","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172868', '43', 'regionName', 'regionName', 2, 3, 6, '{"required":"1","placeholder":"regionName","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172869', '43', 'totalSizeInBytes', 'totalSizeInBytes', 1, 3, 8, '{"required":"0","defaultValue":"104857600","placeholder":"totalSizeInBytes","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172870', '43', 'maxBlockMs', 'maxBlockMs', 1, 3, 9, '{"required":"0","defaultValue":"0","placeholder":"maxBlockMs","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172871', '43', 'ioThreadCount', 'ioThreadCount', 1, 3, 10, '{"required":"0","defaultValue":"1","placeholder":"ioThreadCount","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172872', '43', 'batchSizeThresholdInBytes', 'batchSizeThresholdInBytes', 1, 3, 11, '{"required":"0","defaultValue":"524288","placeholder":" batchSizeThresholdInBytes","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172873', '43', 'batchCountThreshold', 'batchCountThreshold', 1, 3, 12, '{"required":"0","defaultValue":"4096","placeholder":" batchCountThreshold","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172874', '43', 'lingerMs', 'lingerMs', 1, 3, 12, '{"required":"0","defaultValue":"2000","placeholder":"lingerMs","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172875', '43', 'retries', 'retries', 1, 3, 13, '{"required":"0","defaultValue":"100","placeholder":"retries","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172876', '43', 'baseRetryBackoffMs', 'baseRetryBackoffMs', 1, 3, 14, '{"required":"0","defaultValue":"100","placeholder":"baseRetryBackoffMs","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172877', '43', 'maxRetryBackoffMs', 'maxRetryBackoffMs', 1, 3, 15, '{"required":"0","defaultValue":"100","placeholder":"maxRetryBackoffMs","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172878', '43', 'enableLocalTest', 'enableLocalTest', 2, 3, 15, '{"required":"0","defaultValue":"false","placeholder":"enableLocalTest","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1529402613204172879', '43', 'setGiveUpExtraLongSingleLog', 'setGiveUpExtraLongSingleLog', 2, 3, 16, '{"required":"0","defaultValue":"false","placeholder":"setGiveUpExtraLongSingleLog","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204172880', '43', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204172881', '43', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204172882', '43', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678293333363167232', '42', 'discoveryHandler', 'discoveryHandler', 2, 1, 0, '{"required":"0","defaultValue":"url,protocol,status,weight","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997037438107648', '42', 'bossGroupThreadCount', 'bossGroupThreadCount', 2, 1, 1, '{"required":"0","defaultValue":"1","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997142656417792', '42', 'workerGroupThreadCount', 'workerGroupThreadCount', 2, 1, 2, '{"required":"0","defaultValue":"12","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997399104552960', '42', 'clientMaxIdleTimeMs', 'clientMaxIdleTimeMs', 2, 1, 7, '{"required":"0","defaultValue":"30000","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997479614218240', '42', 'clientPendingAcquireMaxCount', 'clientPendingAcquireMaxCount', 2, 1, 4, '{"required":"0","defaultValue":"5","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678996921914392576', '42', 'loadBalance', 'loadBalance', 3, 1, 3, '{"required":"0","defaultValue":"random","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997769998467072', '42', 'clientMaxLifeTimeMs', 'clientMaxLifeTimeMs', 2, 1, 8, '{"required":"0","defaultValue":"60000","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997277012557824', '42', 'clientMaxConnections', 'clientMaxConnections', 2, 1, 6, '{"required":"0","defaultValue":"20","rule":""}');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ INTO plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
VALUES ('1678997557628272640', '42', 'clientPendingAcquireTimeout', 'clientPendingAcquireTimeout', 2, 1, 5, '{"required":"0","defaultValue":"5","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204172883', '15', 'loadBalance', 'loadBalance', 3, 2, 3, '{"required":"0","defaultValue":"random","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1529402613204172884', '44', 'defaultHandleJson', 'defaultHandleJson', 2, 3, 2, '{"required":"0","defaultValue":"{\"authorization\":\"test:test123\"}","placeholder":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721435546642157568', '45', 'host', 'host', 2, 3, 0, '{"required":"1","defaultValue":"127.0.0.1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721435708743618560', '45', 'port', 'port', 1, 3, 0, '{"required":"1","defaultValue":"15672","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721436368046264320', '45', 'password', 'password', 2, 3, 0, '{"required":"0","defaultValue":"admin","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721436500343001088', '45', 'username', 'username', 2, 3, 0, '{"required":"0","defaultValue":"admin","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721436639635836928', '45', 'exchangeName', 'exchangeName', 2, 3, 0, '{"required":"1","defaultValue":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721436745583955968', '45', 'queueName', 'queueName', 2, 3, 0, '{"required":"1","defaultValue":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721509996347617280', '45', 'routingKey', 'routingKey', 2, 3, 0, '{"required":"1","defaultValue":"","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721725585461706752', '45', 'virtualHost', 'virtualHost', 2, 3, 0, '{"required":"1","defaultValue":"/","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1721725662875975680', '45', 'exchangeType', 'exchangeType', 2, 3, 0, '{"required":"1","defaultValue":"direct","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804180904927232', '45', 'durable', 'durable', 2, 3, 0, '{"required":"1","defaultValue":"true","placeholder":"true / false","rule":"/^(true|false)$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804370575548416', '45', 'exclusive', 'exclusive', 2, 3, 0, '{"required":"1","defaultValue":"false","placeholder":"true / false","rule":"/^(true|false)$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804461256400896', '45', 'autoDelete', 'autoDelete', 2, 3, 0, '{"required":"1","defaultValue":"false","placeholder":"true / false","rule":"/^(true|false)$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507008', '45', 'args', 'args', 2, 3, 0, '{"required":"0","defaultValue":"","placeholder":"","rule":"/^\\s*(\\{.*\\}|\\[.*\\])\\s*$/"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507009', '33', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507010', '45', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507011', '45', 'sampleRate', 'sampleRate', 2, 3, 4, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507012', '43', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507013', '43', 'sampleRate', 'sampleRate', 2, 3, 17, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507014', '36', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507015', '36', 'sampleRate', 'sampleRate', 2, 3, 16, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507016', '34', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507017', '35', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507018', '38', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507019', '38', 'sampleRate', 'sampleRate', 2, 3, 11, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507021', '14', 'rewriteContextPath', 'rewriteContextPath', 2, 2, 2, '{"required":"0","defaultValue":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507022', '14', 'percentage', 'percentage', 1, 2, 3, '{"required":"1","defaultValue":"100"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507023', '3', 'rewriteMetaData', 'rewriteMetaData', 3, 2, 3, '{"required":"1","defaultValue":"false"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507024', '8', 'registerType', 'registerType', 2, 3, 1, NULL);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507025', '8', 'serverLists', 'serverLists', 2, 3, 2, NULL);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507026', '8', 'props', 'props', 4, 3, 3, NULL);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507027', '20', 'preserveHost', 'preserveHost', 3, 2, 0, '{"required":"0","defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507028', '20', 'requestHeaderUniqueStrategy', 'requestHeaderUniqueStrategy', 2, 2, 1, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507029', '20', 'requestUniqueHeaders', 'requestUniqueHeaders', 2, 2, 2, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507030', '20', 'respHeaderUniqueStrategy', 'respHeaderUniqueStrategy', 2, 2, 3, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507031', '20', 'respUniqueHeaders', 'respUniqueHeaders', 2, 2, 4, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507032', '19', 'handleType', 'handleType', 2, 3, 1, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507033', '50', 'provider', 'provider', 3, 3, 1, '{"required":"1","defaultValue":"OpenAI","placeholder":"provider","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507034', '50', 'baseUrl', 'baseUrl', 2, 3, 2, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507036', '50', 'model', 'model', 2, 3, 3, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507035', '50', 'apiKey', 'apiKey', 2, 3, 4, '{"required":"1","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507037', '50', 'temperature', 'temperature', 2, 3, 5, '{"required":"0","rule":"", "placeholder":"optional,0,0.01~1"}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507038', '50', 'maxTokens', 'maxTokens', 2, 3, 6, '{"required":"0","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507039', '50', 'stream', 'stream', 3, 3, 7, '{"defaultValue":"false","rule":""}');

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(plugin_id, field, type)) */ into plugin_handle (ID, PLUGIN_ID, FIELD, LABEL, DATA_TYPE, TYPE, SORT, EXT_OBJ)
values ('1722804548510507040', '50', 'prompt', 'prompt', 2, 3, 8, '{"required":"0","rule":""}');


insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784272', 'securityProtocol', 'SECURITY_PROTOCOL', 'PLAINTEXT', 'PLAINTEXT', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784273', 'securityProtocol', 'SECURITY_PROTOCOL', 'SSL', 'SSL', '', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784274', 'securityProtocol', 'SECURITY_PROTOCOL', 'SASL_PLAINTEXT', 'SASL_PLAINTEXT', '', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784275', 'securityProtocol', 'SECURITY_PROTOCOL', 'SASL_SSL', 'SASL_SSL', '', 4, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784276', 'saslMechanism', 'SASL_MECHANISM', 'default', '', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784277', 'saslMechanism', 'SASL_MECHANISM', 'GSSAPI', 'GSSAPI', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784278', 'saslMechanism', 'SASL_MECHANISM', 'PLAIN', 'PLAIN', '', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784279', 'saslMechanism', 'SASL_MECHANISM', 'OAUTHBEARER', 'OAUTHBEARER', '', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784280', 'saslMechanism', 'SASL_MECHANISM', 'SCRAM-SHA-256', 'SCRAM-SHA-256', '', 4, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784281', 'saslMechanism', 'SASL_MECHANISM', 'SCRAM-SHA-512', 'SCRAM-SHA-512', '', 5, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784282', 'addPrefixed', 'ADD_PREFIXED', 'open', 'true', '', 0, 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1529402613195784283', 'addPrefixed', 'ADD_PREFIXED', 'close', 'false', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1572621145865248768', 'keyword', 'MASK_KEYWORD', 'keyword', 'keyword', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1572621497251454976', 'maskType', 'MASKTYPE_ENCRYPT', 'encrypt', 'dataMaskByMD5', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1572621587282190336', 'maskType', 'MASKTYPE_REPLACE', 'replace', 'dataMaskByCharReplace', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1572621912915369984', 'maskStatus', 'MASK_STATUS_FALSE', 'notmask', 'false', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1572621976689762304', 'maskStatus', 'MASK_STATUS_TRUE', 'mask', 'true', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1630761573833920512', 'mapType', 'mapType', 'all', 'all', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1630761984393367552', 'mapType', 'mapType', 'field', 'field', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
values ('1679002911061737472', 'discoveryMode', 'DISCOVERY_MODE', 'zookeeper', '{"baseSleepTimeMilliseconds":"1000","maxRetries":"3","maxSleepTimeMilliseconds":"1000","connectionTimeoutMilliseconds":"1000","sessionTimeoutMilliseconds":"1000","namespace":"","digest":null}', 'discoery mode to link zookeeper', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737473', 'discoveryMode', 'DISCOVERY_MODE', 'etcd', '{"etcdTimeout": "3000", "etcdTTL": "5"}', 'discoery mode to link etcd', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737474', 'discoveryMode', 'DISCOVERY_MODE', 'nacos', '{"groupName": "SHENYU_GROUP", "nacosNameSpace": "", "username": "", "password": "", "accessKey": "", "secretKey": ""}', 'discoery mode to link nacos', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737475', 'discoveryMode', 'DISCOVERY_MODE', 'eureka', '{"eurekaClientRefreshInterval": "10", "eurekaClientRegistryFetchIntervalSeconds": "10"}', 'discoery mode to link eureka', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737480', 'preserveHost', 'PRESERVE_HOST', 'true', 'true', '', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES('1679002911061737481', 'preserveHost', 'PRESERVE_HOST', 'false', 'false', '', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737482', 'provider', 'PROVIDER_TYPE_OPENAI', 'OpenAI', 'OpenAI', 'OpenAI', 0, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737483', 'provider', 'PROVIDER_TYPE_DEEPSEEK', 'DeepSeek', 'DeepSeek', 'DeepSeek', 1, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737484', 'provider', 'PROVIDER_TYPE_MOONSHOT', 'Moonshot', 'Moonshot', 'Moonshot', 2, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737485', 'provider', 'PROVIDER_TYPE_OPENAPI', 'OpenAPI', 'OpenAPI', 'OpenAPI', 3, 1);

insert /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(type, dict_code, dict_name)) */ into SHENYU_DICT (ID, TYPE, DICT_CODE, DICT_NAME, DICT_VALUE, "desc", SORT, ENABLED)
VALUES ('1679002911061737486', 'provider', 'PROVIDER_TYPE_ALIYUN', 'ALiYun', 'ALiYun', 'ALiYun', 4, 1);


/** insert resource for resource */
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"   (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346775491550474240','','SHENYU.MENU.PLUGIN.LIST','plug','/plug','PluginList','0','0','dashboard','0','0','','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1357956838021890048','','SHENYU.MENU.CONFIG.MANAGMENT','config','/config','config','0','1','api','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346777449787125760','1357956838021890048','SHENYU.MENU.SYSTEM.MANAGMENT.PLUGIN','plugin','/config/plugin','plugin','1','2','book','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347034027070337024','1346777449787125760','SHENYU.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:plugin:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347039054925148160','1346777449787125760','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:plugin:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347041326749691904','1346777449787125760','SHENYU.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:plugin:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347046566244003840','1346777449787125760','SHENYU.BUTTON.SYSTEM.SYNCHRONIZE','','','','2','3','','1','0','system:plugin:modify','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347047143350874112','1346777449787125760','SHENYU.BUTTON.SYSTEM.ENABLE','','','','2','4','','1','0','system:plugin:disable','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347047203220369408','1346777449787125760','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','5','','1','0','system:plugin:edit','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346777623011880960','1357956838021890048','SHENYU.PLUGIN.PLUGINHANDLE','pluginhandle','/config/pluginhandle','pluginhandle','1','3','down-square','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347047555588042752','1346777623011880960','SHENYU.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:pluginHandler:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347047640145211392','1346777623011880960','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:pluginHandler:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347047695002513408','1346777623011880960','SHENYU.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:pluginHandler:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347047747305484288','1346777623011880960','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','3','','1','0','system:pluginHandler:edit','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346777766301888512','1357956838021890048','SHENYU.MENU.SYSTEM.MANAGMENT.AUTHEN','auth','/config/auth','auth','1','4','audit','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048004105940992','1346777766301888512','SHENYU.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:authen:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048101875167232','1346777766301888512','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:authen:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048145877610496','1346777766301888512','SHENYU.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:authen:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048240677269503','1346777766301888512','SHENYU.PLUGIN.BATCH.OPENED','','','','2','3','','1','0','system:authen:open','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048240677269504','1346777766301888512','SHENYU.BUTTON.SYSTEM.ENABLE','','','','2','3','','1','0','system:authen:disable','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048316216684544','1346777766301888512','SHENYU.BUTTON.SYSTEM.SYNCHRONIZE','','','','2','4','','1','0','system:authen:modify','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048776029843456','1346777766301888512','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','5','','1','0','system:authen:edit','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1350804501819195392','1346777766301888512','SHENYU.BUTTON.SYSTEM.EDITRESOURCEDETAILS','','','','2','6','','1','0','system:authen:editResourceDetails','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346777907096285184','1357956838021890048','SHENYU.MENU.SYSTEM.MANAGMENT.METADATA','metadata','/config/metadata','metadata','1','5','snippets','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347048968414179328','1346777907096285184','SHENYU.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:meta:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049029323862016','1346777907096285184','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:meta:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049092552994816','1346777907096285184','SHENYU.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:meta:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049251395481600','1346777907096285184','SHENYU.BUTTON.SYSTEM.ENABLE','','','','2','3','','1','0','system:meta:disable','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049317178945536','1346777907096285184','SHENYU.BUTTON.SYSTEM.SYNCHRONIZE','','','','2','4','','1','0','system:meta:modify','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049370014593024','1346777907096285184','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','5','','1','0','system:meta:edit','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346778036402483200','1357956838021890048','SHENYU.MENU.SYSTEM.MANAGMENT.DICTIONARY','dict','/config/dict','dict','1','6','ordered-list','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049542417264640','1346778036402483200','SHENYU.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:dict:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049598155370496','1346778036402483200','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:dict:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049659023110144','1346778036402483200','SHENYU.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:dict:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049731047698432','1346778036402483200','SHENYU.BUTTON.SYSTEM.ENABLE','','','','2','3','','1','0','system:dict:disable','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347049794008395776','1346778036402483200','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','4','','1','0','system:dict:edit','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346776175553376256','','SHENYU.MENU.SYSTEM.MANAGMENT','system','/system','system','0','2','setting','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1346777157943259136','1346776175553376256','SHENYU.MENU.SYSTEM.MANAGMENT.USER','manage','/system/manage','manage','1','1','user','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347032308726902784','1346777157943259136','SHENYU.BUTTON.SYSTEM.ADD','','','','2','0','','1','0','system:manager:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347032395901317120','1346777157943259136','SHENYU.BUTTON.SYSTEM.LIST','','','','2','1','','1','0','system:manager:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347032453707214848','1346777157943259136','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','2','','1','0','system:manager:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1347032509051056128','1346777157943259136','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','3','','1','0','system:manager:edit','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1386680049203195904','1346777157943259136','SHENYU.BUTTON.DATA.PERMISSION.CONFIG', '', '', '', 2, 0, '', 1, 0, 'system:manager:configureDataPermission', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1386680049203195915','1346777157943259136','SHENYU.COMMON.EXPORT', '', '', '', 2, 0, '', 1, 0, 'system:manager:exportConfig', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1386680049203195916','1346777157943259136','SHENYU.COMMON.IMPORT', '', '', '', 2, 0, '', 1, 0, 'system:manager:importConfig', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1350106119681622016','1346776175553376256','SHENYU.MENU.SYSTEM.MANAGMENT.ROLE','role','/system/role','role','1','0','usergroup-add','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1350107709494804480','1350106119681622016','SHENYU.BUTTON.SYSTEM.ADD','','','','2','0','','1','0','system:role:add','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1350107842236137472','1350106119681622016','SHENYU.BUTTON.SYSTEM.LIST','','','','2','1','','1','0','system:role:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1350112406754766848','1350106119681622016','SHENYU.BUTTON.SYSTEM.DELETE','','','','2','2','','1','0','system:role:delete','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1350112481253994496','1350106119681622016','SHENYU.BUTTON.SYSTEM.EDIT','','','','2','3','','1','0','system:role:edit','1');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1355163372527050752','1346776175553376256','SHENYU.MENU.SYSTEM.MANAGMENT.RESOURCE','resource','/system/resource','resource','1','2','menu','0','0','','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1355165158419750912','1355163372527050752','SHENYU.BUTTON.RESOURCE.MENU.ADD','','','','2','1','','1','0','system:resource:addMenu','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1355165353534578688','1355163372527050752','SHENYU.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:resource:list','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1355165475785957376','1355163372527050752','SHENYU.BUTTON.RESOURCE.MENU.DELETE','','','','2','2','','1','0','system:resource:deleteMenu','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1355165608565039104','1355163372527050752','SHENYU.BUTTON.RESOURCE.MENU.EDIT','','','','2','3','','1','0','system:resource:editMenu','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1357977745889132544','1355163372527050752','SHENYU.BUTTON.RESOURCE.BUTTON.ADD','','','','2','4','','1','0','system:resource:addButton','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1357977912126177280','1355163372527050752','SHENYU.SYSTEM.EDITOR','','','','2','5','','1','0','system:resource:editButton','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1357977971827900416','1355163372527050752','SHENYU.SYSTEM.DELETEDATA','','','','2','6','','1','0','system:resource:deleteButton','1');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1534577121923309568', '', 'SHENYU.MENU.DOCUMENT', '', '/document', '', 0, 3, 'file-text', 0, 0, '', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1534585430311051264', '1534577121923309568', 'SHENYU.MENU.DOCUMENT.APIDOC', '', '/document/apidoc', '', 1, 0, 'api', 0, 0, '', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES('1534585531108564992', '1534585430311051264', 'send', '', '', '', 2, 0, '', 1, 0, 'document:apirun:send', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1572525965625266176', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.RESOURCE', '', '', '', 2, 6, '', 1, 0, 'system:plugin:resource', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1697141926247763968','1346776175553376256','SHENYU.MENU.SYSTEM.MANAGMENT.ALERT','','/system/alert','',1,3,'alert',0,0,'',1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1697146375729025024', '1697141926247763968', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, 'unordered-list', 1, 0, 'system:alert:list', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1697145808210333696','1697141926247763968','SHENYU.BUTTON.SYSTEM.ADD','','','',2,0,'plus',1,0,'system:alert:add',1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1697146617513873408','1697141926247763968','SHENYU.BUTTON.SYSTEM.DELETE','','','',2,0,'delete',1,0,'system:alert:delete',1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1697146860540235776','1697141926247763968','SHENYU.BUTTON.SYSTEM.EDIT','','','',2,0,'edit',1,0,'system:alert:edit',1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1844015648095666176', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.SCALE', '', '/system/scale', '', 1, 4, 'sliders', 0, 0, '', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1844025735425183744', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, 'unordered-list', 1, 0, 'system:scale:list', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1844025850382667776', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 0, 'plus', 1, 0, 'system:scale:add', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1844025989214130176', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 0, 'delete', 1, 0, 'system:scale:delete', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1844026099075534848', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 0, 'edit', 1, 0, 'system:scale:edit', 1);


/* default permission */
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708572688384', '1346358560427216896', '1346775491550474240');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1357956838021890049', '1346358560427216896', '1357956838021890048');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708597854208', '1346358560427216896', '1346777449787125760');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708702711808', '1346358560427216896', '1347034027070337024');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708706906112', '1346358560427216896', '1347039054925148160');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708711100416', '1346358560427216896', '1347041326749691904');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708715294720', '1346358560427216896', '1347046566244003840');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708719489024', '1346358560427216896', '1347047143350874112');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708723683328', '1346358560427216896', '1347047203220369408');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708606242816', '1346358560427216896', '1346777623011880960');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708727877632', '1346358560427216896', '1347047555588042752');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708732071936', '1346358560427216896', '1347047640145211392');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708732071937', '1346358560427216896', '1347047695002513408');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708736266240', '1346358560427216896', '1347047747305484288');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708610437120', '1346358560427216896', '1346777766301888512');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708740460544', '1346358560427216896', '1347048004105940992');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708744654848', '1346358560427216896', '1347048101875167232');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708744654849', '1346358560427216896', '1347048145877610496');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708748849151', '1346358560427216896', '1347048240677269503');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708748849152', '1346358560427216896', '1347048240677269504');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708753043456', '1346358560427216896', '1347048316216684544');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708757237760', '1346358560427216896', '1347048776029843456');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007709088587777', '1346358560427216896', '1350804501819195392');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708614631424', '1346358560427216896', '1346777907096285184');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708757237761', '1346358560427216896', '1347048968414179328');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708761432064', '1346358560427216896', '1347049029323862016');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708765626368', '1346358560427216896', '1347049092552994816');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708769820672', '1346358560427216896', '1347049251395481600');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708774014976', '1346358560427216896', '1347049317178945536');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708774014977', '1346358560427216896', '1347049370014593024');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708623020032', '1346358560427216896', '1346778036402483200');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708778209280', '1346358560427216896', '1347049542417264640');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708782403584', '1346358560427216896', '1347049598155370496');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708786597888', '1346358560427216896', '1347049659023110144');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708790792192', '1346358560427216896', '1347049731047698432');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708794986496', '1346358560427216896', '1347049794008395776');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708585271296', '1346358560427216896', '1346776175553376256');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708593659904', '1346358560427216896', '1346777157943259136');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708685934593', '1346358560427216896', '1347032308726902784');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708690128896', '1346358560427216896', '1347032395901317120');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708694323200', '1346358560427216896', '1347032453707214848');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007708698517504', '1346358560427216896', '1347032509051056128');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1386680049203195905', '1346358560427216896', '1386680049203195904');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1386680049203195906', '1346358560427216896', '1386680049203195915');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1386680049203195907', '1346358560427216896', '1386680049203195916');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007709080199168', '1346358560427216896', '1350106119681622016');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007709080199169', '1346358560427216896', '1350107709494804480');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007709084393472', '1346358560427216896', '1350107842236137472');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007709084393473', '1346358560427216896', '1350112406754766848');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1351007709088587776', '1346358560427216896', '1350112481253994496');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1355167519859040256', '1346358560427216896', '1355163372527050752');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1355167519859040257', '1346358560427216896', '1355165158419750912');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1355167519859040258', '1346358560427216896', '1355165353534578688');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1355167519859040259', '1346358560427216896', '1355165475785957376');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1355167519859040260', '1346358560427216896', '1355165608565039104');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1357977745893326848', '1346358560427216896', '1357977745889132544');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1357977912126177281', '1346358560427216896', '1357977912126177280');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1357977971827900417', '1346358560427216896', '1357977971827900416');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1534577122279825408', '1346358560427216896', '1534577121923309568');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1534585430587875328', '1346358560427216896', '1534585430311051264');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1534585531389583360', '1346358560427216896', '1534585531108564992');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1572525965658820608', '1346358560427216896', '1572525965625266176');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697141926281318400', '1346358560427216896', '1697141926247763968');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697145808239693824', '1346358560427216896', '1697145808210333696');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697146375754190848', '1346358560427216896', '1697146375729025024');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697146617543233536', '1346358560427216896', '1697146617513873408');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697146860569595904', '1346358560427216896', '1697146860540235776');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697141926281381720', '1346358560427216896', '1844015648095666176');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697145808239621836', '1346358560427216896', '1844025735425183744');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697146375754129471', '1346358560427216896', '1844025850382667776');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697146617543248162', '1346358560427216896', '1844025989214130176');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1697146860569542740', '1346358560427216896', '1844026099075534848');

create table tag
(
    id            VARCHAR2(128) not null,
    name          VARCHAR2(255) not null,
    tag_desc      VARCHAR2(255) not null,
    parent_tag_id VARCHAR2(128) not null,
    ext           VARCHAR2(1024) not null,
    date_created  timestamp(3) default SYSDATE not null,
    date_updated  timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment
on column TAG.id
  is 'primary key id';
comment
on column TAG.name
  is 'tag name';
comment
on column TAG.tag_desc
  is 'tag desc';
comment
on column TAG.parent_tag_id
  is 'parent tag id';
comment
on column TAG.ext
  is 'extension info';
comment
on column TAG.date_created
  is 'create time';
comment
on column TAG.date_updated
  is 'update time';


create table tag_relation
(
    id                VARCHAR2(128) not null,
    api_id            VARCHAR2(128) not null,
    tag_id            VARCHAR2(128) not null,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column TAG_RELATION.id
  is 'primary key id';
comment on column TAG_RELATION.api_id
  is 'api_id';
comment on column TAG_RELATION.tag_id
  is 'parent tag id';
comment on column TAG_RELATION.date_created
  is 'create time';
comment on column TAG_RELATION.date_updated
  is 'update time';


create table discovery
(
    id                VARCHAR2(128) not null,
    name            VARCHAR2(255) not null,
    level            VARCHAR2(64) not null,
    plugin_name      VARCHAR2(255),
    namespace_id VARCHAR2(50) not null,
    type            VARCHAR2(64) not null,
    server_list      VARCHAR2(255),
    props            CLOB,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column DISCOVERY.id
  is 'primary key id';
comment on column DISCOVERY.name
  is 'the discovery name';
comment on column DISCOVERY.level
  is '0 selector,1 plugin  2 global';
comment on column DISCOVERY.plugin_name
  is 'the plugin name';
comment on column DISCOVERY.namespace_id
  is 'namespace id';
comment on column DISCOVERY.type
  is 'local,zookeeper,etcd,consul,nacos';
comment on column DISCOVERY.server_list
  is 'register server url (,)';
comment on column DISCOVERY.props
  is 'the discovery pops (json)';
comment on column DISCOVERY.date_created
  is 'create time';
comment on column DISCOVERY.date_updated
  is 'update time';


create table discovery_handler
(
    id                VARCHAR2(128) not null,
    discovery_id            VARCHAR2(128) not null,
    handler            VARCHAR2(255) not null,
    listener_node      VARCHAR2(255),
    props            CLOB,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column DISCOVERY_HANDLER.id
  is 'primary key id';
comment on column DISCOVERY_HANDLER.discovery_id
  is 'the discovery id';
comment on column DISCOVERY_HANDLER.handler
  is 'the handler';
comment on column DISCOVERY_HANDLER.listener_node
  is 'register server listener to node';
comment on column DISCOVERY_HANDLER.props
  is 'the discovery pops (json)';
comment on column DISCOVERY_HANDLER.date_created
  is 'create time';
comment on column DISCOVERY_HANDLER.date_updated
  is 'update time';


create table discovery_rel
(
    id                VARCHAR2(128) not null,
    plugin_name      VARCHAR2(255) not null,
    discovery_handler_id            VARCHAR2(128) not null,
    selector_id      VARCHAR2(128),
    proxy_selector_id      VARCHAR2(128),
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column DISCOVERY_REL.id
  is 'primary key id';
comment on column DISCOVERY_REL.plugin_name
  is 'the plugin name';
comment on column DISCOVERY_REL.discovery_handler_id
  is 'the discovery handler id';
comment on column DISCOVERY_REL.selector_id
  is 'the selector id';
comment on column DISCOVERY_REL.proxy_selector_id
  is 'the proxy selector id';
comment on column DISCOVERY_REL.date_created
  is 'create time';
comment on column DISCOVERY_REL.date_updated
  is 'update time';


create table discovery_upstream
(
    id                VARCHAR2(128) not null,
    discovery_handler_id   VARCHAR2(128) not null,
    namespace_id VARCHAR2(50) not null,
    protocol            VARCHAR2(64),
    url      VARCHAR2(64) not null,
    status      NUMBER(10) not null,
    weight      NUMBER(10)  not null,
    props       CLOB,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
CREATE UNIQUE INDEX discovery_upstream_idx ON discovery_upstream (discovery_handler_id, url);

-- Add comments to the columns
comment on column DISCOVERY_UPSTREAM.id
  is 'primary key id';
comment on column DISCOVERY_UPSTREAM.discovery_handler_id
  is 'the discovery handler id';
comment on column DISCOVERY_UPSTREAM.namespace_id
  is 'namespace id';
comment on column DISCOVERY_UPSTREAM.protocol
  is 'for http, https, tcp, ws';
comment on column DISCOVERY_UPSTREAM.url
  is 'ip:port';
comment on column DISCOVERY_UPSTREAM.status
  is 'type (0, healthy, 1 unhealthy)';
comment on column DISCOVERY_UPSTREAM.weight
  is 'the weight for lists';
comment on column DISCOVERY_UPSTREAM.props
  is 'the discovery pops (json)';
comment on column DISCOVERY_UPSTREAM.date_created
  is 'create time';
comment on column DISCOVERY_UPSTREAM.date_updated
  is 'update time';


create table proxy_selector
(
    id                VARCHAR2(128) not null,
    name   VARCHAR2(255) not null,
    plugin_name            VARCHAR2(255) not null,
    type      VARCHAR2(64) not null,
    forward_port      NUMBER(10) not null,
    props       CLOB,
    namespace_id VARCHAR2(50) not null,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
-- Add comments to the columns
comment on column PROXY_SELECTOR.id
  is 'primary key id';
comment on column PROXY_SELECTOR.name
  is 'the proxy name';
comment on column PROXY_SELECTOR.plugin_name
  is 'the plugin name';
comment on column PROXY_SELECTOR.type
  is 'proxy type for tcp, upd, ws';
comment on column PROXY_SELECTOR.forward_port
  is 'the proxy forward port';
comment on column PROXY_SELECTOR.props
  is 'the discovery pops (json)';
comment on column PROXY_SELECTOR.namespace_id
  is 'namespace id';
comment on column PROXY_SELECTOR.date_created
  is 'create time';
comment on column PROXY_SELECTOR.date_updated
  is 'update time';

create table alert_template
(
    id            varchar(128) not null,
    name          varchar(255) not null,
    strategy_name varchar(255) not null,
    content       varchar(1000) not null,
    date_created  timestamp(3) default SYSDATE not null,
    date_updated  timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
)
;
-- Add comments to the columns
comment
on column ALTER_TEMPLATE.id
  is 'primary key id';
comment
on column ALTER_TEMPLATE.name
  is 'alert template name';
comment
on column ALTER_TEMPLATE.strategy_name
  is 'alert template strategy name';
comment
on column ALTER_TEMPLATE.content
  is 'alert template content';
comment
on column ALTER_TEMPLATE.date_created
  is 'create time';
comment
on column ALTER_TEMPLATE.date_updated
  is 'update time';

-- ----------------------------
-- Table structure for alert_receiver
-- ----------------------------
create table alert_receiver
(
    id                   varchar(128)   not null,
    name                 varchar(255)   not null,
    enable               NUMBER(10)     not null,
    type                 NUMBER(10)     not null,
    phone                varchar(255),
    email                varchar(255),
    hook_url             varchar(255),
    wechat_id            varchar(255),
    access_token         varchar(255),
    tg_bot_token         varchar(255),
    tg_user_id           varchar(255),
    slack_web_hook_url   varchar(255),
    corp_id              varchar(255),
    agent_id             varchar(255),
    app_secret           varchar(255),
    discord_channel_id   varchar(255),
    discord_bot_token    varchar(255),
    smn_ak               varchar(255),
    smn_sk               varchar(255),
    smn_project_id       varchar(255),
    smn_region           varchar(255),
    smn_topic_urn        varchar(255),
    match_all            NUMBER(10),
    labels               varchar(255),
    levels               varchar(255),
    namespace_id         varchar(50)    not null,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
)
;
-- Add comments to the columns
comment
on column alert_receiver.id
  is 'primary key id';
comment
on column alert_receiver.name
  is 'alert receiver name';
comment
on column alert_receiver.enable
  is 'enable or not';
comment
on column alert_receiver.type
  is 'notice type 0-SMS 1-Email 2-webhook 3-WeChat Official Account 4-Enterprise WeChat Robot 5-DingTalk Robot 6-FeiShu Robot 7-Telegram Bot 8-SlackWebHook 9-Discord Bot 10-Enterprise WeChat';
comment
on column alert_receiver.match_all
  is 'enable or not';
comment
on column alert_receiver.labels
  is 'alarm labels';
comment
on column alert_receiver.levels
  is 'alarm levels';
comment
on column lert_receiver.namespace_id
  is 'namespace id';
comment
on column alert_receiver.date_created
  is 'create time';
comment
on column alert_receiver.date_updated
  is 'update time';


-- ----------------------------
-- Table structure for SHENYU_LOCK
-- ----------------------------
CREATE TABLE SHENYU_LOCK  (
   LOCK_KEY CHAR(36),
   REGION VARCHAR(100),
   CLIENT_ID CHAR(36),
   CREATED_DATE TIMESTAMP NOT NULL,
   constraint SHENYU_LOCK_PK primary key (LOCK_KEY, REGION)
);
-- Add comments to the columns
comment on column SHENYU_LOCK.LOCK_KEY
  is 'LOCK_KEY';
comment on column SHENYU_LOCK.REGION
  is 'REGION';
comment on column SHENYU_LOCK.CLIENT_ID
  is 'CLIENT_ID';
comment on column SHENYU_LOCK.CREATED_DATE
  is 'CREATED_DATE';

-- ----------------------------
-- Table structure for cluster_master
-- ----------------------------
create table cluster_master
(
    id                   varchar(128)   not null,
    master_host          varchar(255)   not null,
    master_port          varchar(255)   not null,
    context_path          varchar(255)   not null,
    date_created      timestamp(3) default SYSDATE not null,
    date_updated      timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
)
;
-- Add comments to the columns
comment
on column alert_receiver.id
  is 'primary key id';
comment
on column alert_receiver.master_host
  is 'master host';
comment
on column alert_receiver.master_port
  is 'master port';
comment
on column alert_receiver.context_path
  is 'master context_path';
comment
on column alert_receiver.date_created
  is 'create time';
comment
on column alert_receiver.date_updated
  is 'update time';




INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1792749362445840474', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.NAMESPACE', 'namespace', '/config/namespace', 'namespace', 1, 0, 'appstore', 0, 0, '', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1792749362445840475', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 0, '', 1, 0, 'system:namespace:add', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1792749362445840476', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 1, '', 1, 0, 'system:namespace:list', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1792749362445840477', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 2, '', 1, 0, 'system:namespace:delete', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) VALUES ('1792749362445840478', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 3, '', 1, 0, 'system:namespace:edit', 1);


INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343252', '1346358560427216896', '1792749362445840474');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343253', '1346358560427216896', '1792749362445840475');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343254', '1346358560427216896', '1792749362445840476');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343255', '1346358560427216896', '1792749362445840477');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343256', '1346358560427216896', '1792749362445840478');

CREATE TABLE namespace (
                           id VARCHAR2(128) NOT NULL,
                           namespace_id VARCHAR2(50) NOT NULL,
                           name VARCHAR2(255) NOT NULL,
                           description VARCHAR2(255),
                           date_created      timestamp(3) default SYSDATE not null,
                           date_updated      timestamp(3) default SYSDATE not null,
                           CONSTRAINT pk_namespace PRIMARY KEY (id)
);


COMMENT ON COLUMN namespace.id IS 'namespace primary key';
COMMENT ON COLUMN namespace.namespace_id IS 'namespace id';
COMMENT ON COLUMN namespace.name IS 'namespace name';
COMMENT ON COLUMN namespace.description IS 'namespace desc';
COMMENT ON COLUMN namespace.date_created IS 'create time';
COMMENT ON COLUMN namespace.date_updated IS 'update time';

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace(id)) */ INTO `namespace` (`id`, `namespace_id`, `name`, `description`) VALUES ('1', '649330b6-c2d7-4edc-be8e-8a54df9eb385', 'default', 'default-namespace');


CREATE TABLE namespace_plugin_rel (
                               id VARCHAR2(128) COLLATE utf8mb4_unicode_ci NOT NULL,
                               namespace_id VARCHAR2(50) COLLATE utf8mb4_unicode_ci NOT NULL,
                               plugin_id VARCHAR2(128) COLLATE utf8mb4_unicode_ci NOT NULL,
                               config CLOB COLLATE utf8mb4_unicode_ci,
                               sort NUMBER(11),
                               enabled NUMBER(4,0) NOT NULL DEFAULT 0 CHECK (enabled IN (0, 1)),
                               date_created      timestamp(3) default SYSDATE not null,
                               date_updated      timestamp(3) default SYSDATE not null,
                               CONSTRAINT pk_namespace_plugin_rel PRIMARY KEY (id)
);

COMMENT ON COLUMN namespace_plugin_rel.id IS 'Primary key ID';
COMMENT ON COLUMN namespace_plugin_rel.namespace_id IS 'Namespace ID';
COMMENT ON COLUMN namespace_plugin_rel.plugin_id IS 'Plugin ID';
COMMENT ON COLUMN namespace_plugin_rel.config IS 'Plugin configuration';
COMMENT ON COLUMN namespace_plugin_rel.sort IS 'Sort order';
COMMENT ON COLUMN namespace_plugin_rel.enabled IS 'Whether the plugin is enabled (0 = not open, 1 = open)';
COMMENT ON COLUMN namespace_plugin_rel.date_created IS 'Creation time';
COMMENT ON COLUMN namespace_plugin_rel.date_updated IS 'Update time';

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822145','649330b6-c2d7-4edc-be8e-8a54df9eb385','1', NULL, 20, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822146','649330b6-c2d7-4edc-be8e-8a54df9eb385','10', NULL, 140, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822147','649330b6-c2d7-4edc-be8e-8a54df9eb385','11', '{"protocol":"zookeeper","register":"127.0.0.1:2181","threadpool":"shared"}', 310, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822148','649330b6-c2d7-4edc-be8e-8a54df9eb385','12', NULL, 310, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822149','649330b6-c2d7-4edc-be8e-8a54df9eb385','13', '{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}', 310, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822150','649330b6-c2d7-4edc-be8e-8a54df9eb385','14', NULL, 80, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822151','649330b6-c2d7-4edc-be8e-8a54df9eb385','15', '{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}', 310, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822152','649330b6-c2d7-4edc-be8e-8a54df9eb385','16', NULL, 110, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822153','649330b6-c2d7-4edc-be8e-8a54df9eb385','17', '{"registerProtocol":"direct","registerAddress":"127.0.0.1:2181","corethreads":0,"threads":2147483647,"queues":0,"threadpool":"shared"}', 310, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822154','649330b6-c2d7-4edc-be8e-8a54df9eb385','18', NULL, 160, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822155','649330b6-c2d7-4edc-be8e-8a54df9eb385','19', '{"secretKey":"key"}', 30, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822156','649330b6-c2d7-4edc-be8e-8a54df9eb385','2', '{"model":"black"}', 50, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822157','649330b6-c2d7-4edc-be8e-8a54df9eb385','20', NULL, 120, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822158','649330b6-c2d7-4edc-be8e-8a54df9eb385','21', NULL, 40, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822159','649330b6-c2d7-4edc-be8e-8a54df9eb385','22', NULL, 70, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822160','649330b6-c2d7-4edc-be8e-8a54df9eb385','23', NULL, 220, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822161','649330b6-c2d7-4edc-be8e-8a54df9eb385','24', NULL, 100, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822162','649330b6-c2d7-4edc-be8e-8a54df9eb385','25', NULL, 410, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822163','649330b6-c2d7-4edc-be8e-8a54df9eb385','26', '{"multiSelectorHandle":"1"}', 200, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822164','649330b6-c2d7-4edc-be8e-8a54df9eb385','27', NULL, 125, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822165','649330b6-c2d7-4edc-be8e-8a54df9eb385','28', '{"port": 9500,"bossGroupThreadCount": 1,"maxPayloadSize": 65536,"workerGroupThreadCount": 12,"userName": "shenyu","password": "shenyu","isEncryptPassword": false,"encryptMode": "","leakDetectorLevel": "DISABLED"}', 125, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822166','649330b6-c2d7-4edc-be8e-8a54df9eb385','29', '{"topic":"shenyu-access-logging", "namesrvAddr": "localhost:9876","producerGroup":"shenyu-plugin-logging-rocketmq"}', 170, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822167','649330b6-c2d7-4edc-be8e-8a54df9eb385','3', NULL, 90, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822168','649330b6-c2d7-4edc-be8e-8a54df9eb385','30', '{"cacheType":"memory"}', 10, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822169','649330b6-c2d7-4edc-be8e-8a54df9eb385','31', NULL, 1, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822170','649330b6-c2d7-4edc-be8e-8a54df9eb385','32', '{"host":"localhost", "port": "9200"}', 190, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822171','649330b6-c2d7-4edc-be8e-8a54df9eb385','33', '{"host":"localhost", "port": "9092"}', 180, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822172','649330b6-c2d7-4edc-be8e-8a54df9eb385','34', '{"projectName": "shenyu", "logStoreName": "shenyu-logstore", "topic": "shenyu-topic"}', 175, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822173','649330b6-c2d7-4edc-be8e-8a54df9eb385','35', '{"topic":"shenyu-access-logging", "serviceUrl": "pulsar://localhost:6650"}', 185, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822174','649330b6-c2d7-4edc-be8e-8a54df9eb385','36', '{"endpoint": "ap-guangzhou.cls.tencentcs.com", "topic": "shenyu-topic"}', 176, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822175','649330b6-c2d7-4edc-be8e-8a54df9eb385','38', '{"host":"127.0.0.1","port":"8123","databse":"shenyu-gateway","username":"foo","password":"bar"}', 195, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822176','649330b6-c2d7-4edc-be8e-8a54df9eb385','39', '{"endpoint":"http://localhost:8000"}', 40, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822177','649330b6-c2d7-4edc-be8e-8a54df9eb385','4', '{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}', 60, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822178','649330b6-c2d7-4edc-be8e-8a54df9eb385','40', NULL, 150, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822179','649330b6-c2d7-4edc-be8e-8a54df9eb385','42', NULL, 320, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822180','649330b6-c2d7-4edc-be8e-8a54df9eb385','43', '{"totalSizeInBytes":"104857600","maxBlockMs":"0","ioThreadCount":"1","batchSizeThresholdInBytes":"524288","batchCountThreshold":"4096","lingerMs":"2000","retries":"100","baseRetryBackoffMs":"100","maxRetryBackoffMs":"100","enableLocalTest":"true","setGiveUpExtraLongSingleLog":"false"}', 177, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822181','649330b6-c2d7-4edc-be8e-8a54df9eb385','44', '{"defaultHandleJson":"{\"authorization\":\"test:test123\"}"}', 150, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822182','649330b6-c2d7-4edc-be8e-8a54df9eb385','45', '{"host":"127.0.0.1","port":5672,"password":"admin","username":"admin","exchangeName":"exchange.logging.plugin","queueName":"queue.logging.plugin","routingKey":"topic.logging","virtualHost":"/","exchangeType":"direct","durable":"true","exclusive":"false","autoDelete":"false"}', 171, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822183','649330b6-c2d7-4edc-be8e-8a54df9eb385','5', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', 200, 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822184','649330b6-c2d7-4edc-be8e-8a54df9eb385','6', '{"register":"zookeeper://localhost:2181","multiSelectorHandle":"1","threadpool":"shared","corethreads":0,"threads":2147483647,"queues":0}', 310, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822186','649330b6-c2d7-4edc-be8e-8a54df9eb385','9', NULL, 130, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822187','649330b6-c2d7-4edc-be8e-8a54df9eb385','50', '{"provider":"OpenAI","baseUrl":"https://api.openai.com/v1/chat/completions","model":"gpt-4o-mini","apiKey":"your_api_key","temperature":"0.5","maxTokens":"1000","stream":"false","prompt":""}', 199, 0);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id,namespace_id,plugin_id, config, sort, enabled) VALUES ('1801816010882822188','649330b6-c2d7-4edc-be8e-8a54df9eb385','51', NULL, 171, 0);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840479', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.NAMESPACEPLUGIN', 'namespacePlugin', '/config/namespacePlugin', 'namespacePlugin', 1, 2, 'build', 0, 0, '', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840480', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:namespacePlugin:list', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840481', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:namespacePlugin:delete', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840482', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:namespacePlugin:add', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840483', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', '', '', '', 2, 3, '', 1, 0, 'system:namespacePlugin:modify', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840484', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.ENABLE', '', '', '', 2, 4, '', 1, 0, 'system:namespacePlugin:disable', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840485', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 5, '', 1, 0, 'system:namespacePlugin:edit', 1);
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX("resource" (id)) */ INTO "resource"  (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status)VALUES ('1792749362445840486', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.RESOURCE', '', '', '', 2, 6, '', 1, 0, 'system:namespacePlugin:resource', 1);


INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343260', '1346358560427216896', '1792749362445840479');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343261', '1346358560427216896', '1792749362445840480');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343262', '1346358560427216896', '1792749362445840481');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343263', '1346358560427216896', '1792749362445840482');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343264', '1346358560427216896', '1792749362445840483');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343265', '1346358560427216896', '1792749362445840484');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343266', '1346358560427216896', '1792749362445840485');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (permission(id)) */ INTO permission (id, object_id, resource_id) VALUES ('1792779493541343267', '1346358560427216896', '1792749362445840486');


-- ----------------------------
-- Table structure for scale
-- ----------------------------
create table scale_policy
(
    id             varchar(128) not null,
    sort           number not null,
    status         number not null,
    num            number,
    begin_time     timestamp(3),
    end_time       timestamp(3),
    date_created   timestamp(3) default SYSDATE not null,
    date_updated   timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
comment on column SCALE_POLICY.id
    is 'primary key id';
comment on column SCALE_POLICY.sort
    is 'sort';
comment on column SCALE_POLICY.status
    is 'status 1:enable 0:disable';
comment on column SCALE_POLICY.num
    is 'number of bootstrap';
comment on column SCALE_POLICY.begin_time
    is 'begin time';
comment on column SCALE_POLICY.end_time
    is 'end time';
comment on column SCALE_POLICY.date_created
    is 'create time';
comment on column SCALE_POLICY.date_updated
    is 'update time';

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (scale_policy(id)) */ INTO scale_policy (id, sort, status, num, begin_time, end_time, date_created, date_updated) VALUES ('1', 3, 0, 10, NULL, NULL, '2024-07-31 20:00:00.000', '2024-07-31 20:00:00.000');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (scale_policy(id)) */ INTO scale_policy (id, sort, status, num, begin_time, end_time, date_created, date_updated) VALUES ('2', 2, 0, 10, '2024-07-31 20:00:00.000', '2024-08-01 20:00:00.000', '2024-07-31 20:00:00.000', '2024-07-31 20:00:00.000');
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX (scale_policy(id)) */ INTO scale_policy (id, sort, status, num, begin_time, end_time, date_created, date_updated) VALUES ('3', 1, 0, NULL, NULL, NULL, '2024-07-31 20:00:00.000', '2024-07-31 20:00:00.000');

create table scale_rule
(
    id             varchar(128) not null,
    metric_name    varchar(128) not null,
    type           number not null,
    sort           number not null,
    status         number not null,
    minimum        varchar(128),
    maximum        varchar(128),
    date_created   timestamp(3) default SYSDATE not null,
    date_updated   timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
comment on column SCALE_RULE.id
    is 'primary key id';
comment on column SCALE_RULE.metric_name
    is 'metric name';
comment on column SCALE_RULE.type
    is 'type 0:shenyu 1:k8s 2:others';
comment on column SCALE_RULE.sort
    is 'sort';
comment on column SCALE_RULE.status
    is 'status 1:enable 0:disable';
comment on column SCALE_RULE.minimum
    is 'minimum of metric';
comment on column SCALE_RULE.maximum
    is 'maximum of metric';
comment on column SCALE_RULE.date_created
    is 'create time';
comment on column SCALE_RULE.date_updated
    is 'update time';

create table scale_history
(
    id             varchar(128) not null,
    config_id      number not null,
    num            number not null,
    action         number not null,
    msg            clob,
    date_created   timestamp(3) default SYSDATE not null,
    date_updated   timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
comment on column SCALE_HISTORY.id
    is 'primary key id';
comment on column SCALE_HISTORY.config_id
    is '0:manual 1:period 2:dynamic';
comment on column SCALE_HISTORY.num
    is 'number of bootstrap';
comment on column SCALE_HISTORY.action
    is 'status 1:enable 0:disable';
comment on column SCALE_HISTORY.msg
    is 'message';
comment on column SCALE_HISTORY.date_created
    is 'create time';
comment on column SCALE_HISTORY.date_updated
    is 'update time';


create table namespace_user_rel
(
    id             varchar(128) not null,
    namespace_id   varchar(50) NOT NULL,
    user_id        varchar(128) NOT NULL,
    date_created   timestamp(3) default SYSDATE not null,
    date_updated   timestamp(3) default SYSDATE not null,
    PRIMARY KEY (id)
);
comment on column NAMESPACE_USER_REL.id
    is 'primary key id';
comment on column NAMESPACE_USER_REL.namespace_id
    is 'namespace_id';
comment on column NAMESPACE_USER_REL.user_id
    is 'user_id';
comment on column NAMESPACE_USER_REL.date_created
    is 'create time';
comment on column NAMESPACE_USER_REL.date_updated
    is 'update time';


INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534849', '1346775491550474240', 'aiProxy', 'aiProxy', '/plug/aiProxy', 'aiProxy', 1, 0, 'pic-center', 0, 0, '', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534850', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:add', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534851', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:query', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534852', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:edit', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534853', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:delete', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534854', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:add', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534855', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:query', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534856', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:edit', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534857', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:delete', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534858', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxy:modify', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542741', '1346358560427216896', '1844026099075534849');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542742', '1346358560427216896', '1844026099075534850');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542743', '1346358560427216896', '1844026099075534851');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542744', '1346358560427216896', '1844026099075534852');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542745', '1346358560427216896', '1844026099075534853');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542746', '1346358560427216896', '1844026099075534854');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542747', '1346358560427216896', '1844026099075534855');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542748', '1346358560427216896', '1844026099075534856');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542749', '1346358560427216896', '1844026099075534857');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542750', '1346358560427216896', '1844026099075534858');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507041', '50', 'provider', 'provider', 3, 1, 0, '{"required":"1","defaultValue":"OpenAI","placeholder":"provider","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507042', '50', 'baseUrl', 'baseUrl', 2, 1, 1, '{"required":"1","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507043', '50', 'model', 'model', 2, 1, 2, '{"required":"1","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507044', '50', 'apiKey', 'apiKey', 2, 1, 3, '{"required":"1","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507045', '50', 'temperature', 'temperature', 2, 1, 4, '{"required":"0","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507046', '50', 'maxTokens', 'maxTokens', 2, 1, 5, '{"required":"0","rule":"", "placeholder":"optional,0,0.01~1"}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507047', '50', 'stream', 'stream', 3, 1, 6, '{"defaultValue":"false","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1722804548510507048', '50', 'prompt', 'prompt', 2, 1, 7, '{"required":"0","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642741', '1346358560427216896', '1844026099075554850', to_timestamp('2023-08-31 06:59:01', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 06:59:01', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642742', '1346358560427216896', '1844026099075554851', to_timestamp('2023-08-31 07:22:07', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:22:07', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642743', '1346358560427216896', '1844026099075554852', to_timestamp('2023-08-31 07:14:26', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:14:26', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642744', '1346358560427216896', '1844026099075554853', to_timestamp('2023-08-31 07:22:07', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:22:07', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642745', '1346358560427216896', '1844026099075554854', to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642746', '1346358560427216896', '1844026099075554855', to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642747', '1346358560427216896', '1844026099075554856', to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642748', '1346358560427216896', '1844026099075554857', to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642749', '1346358560427216896', '1844026099075554858', to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id, date_created, date_updated) 
VALUES ('1697146860569642750', '1346358560427216896', '1844026099075554859', to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-08-31 07:18:37', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin(id)) */ INTO plugin (id, name, config, role, sort, enabled, date_created, date_updated, plugin_jar) 
VALUES ('52', 'aiPrompt', null, 'Ai', 170, 0, to_timestamp('2023-12-20 18:02:53', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2023-12-20 18:02:53', 'YYYY-MM-DD HH24:MI:SS'), null);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507140', '52', 'prepend', 'prepend', 2, 3, 1, '{"required":"0","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507141', '52', 'preRole', 'preRole', 3, 3, 2, '{"required":"0","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507142', '52', 'append', 'append', 2, 3, 3, '{"required":"0","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507143', '52', 'postRole', 'postRole', 3, 3, 4, '{"required":"0","rule":""}', to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'), to_timestamp('2024-01-02 17:20:50.233', 'YYYY-MM-DD HH24:MI:SS.FF3'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554850', '1346775491550474240', 'aiPrompt', 'aiPrompt', '/plug/aiPrompt', 'aiPrompt', 1, 0, 'pic-center', 0, 0, '', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554851', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:add', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554852', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:query', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554853', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:edit', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554854', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:delete', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554855', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:add', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554856', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:query', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554857', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:edit', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554858', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:delete', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated) 
VALUES ('1844026099075554859', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPrompt:modify', 1, to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:58', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, desc, sort, enabled, date_created, date_updated) 
VALUES ('1679002911061737580', 'preRole', 'ROLE_TYPE_SYSTEM', 'SYSTEM', 'system', 'system', 0, 1, to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, desc, sort, enabled, date_created, date_updated) 
VALUES ('1679002911061737581', 'preRole', 'ROLE_TYPE_USER', 'USER', 'user', 'user', 1, 1, to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, desc, sort, enabled, date_created, date_updated) 
VALUES ('1679002911061737582', 'postRole', 'ROLE_TYPE_SYSTEM', 'SYSTEM', 'system', 'system', 0, 1, to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, desc, sort, enabled, date_created, date_updated) 
VALUES ('1679002911061737583', 'postRole', 'ROLE_TYPE_USER', 'USER', 'user', 'user', 1, 1, to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2024-02-07 14:31:49', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(namespace_plugin_rel(id)) */ INTO namespace_plugin_rel (id, namespace_id, plugin_id, config, sort, enabled, date_created, date_updated) 
VALUES ('1801816010882822189', '649330b6-c2d7-4edc-be8e-8a54df9eb385', '52', NULL, 171, 0, to_timestamp('2022-05-25 18:02:53', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2022-05-25 18:02:53', 'YYYY-MM-DD HH24:MI:SS'));

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534859', '1346775491550474240', 'aiTokenLimiter', 'aiTokenLimiter', '/plug/aiTokenLimiter', 'aiTokenLimiter', 1, 0, 'pic-center', 0, 0, '', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534860', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:add', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534861', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:query', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534862', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:edit', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534863', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:delete', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534864', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:add', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534865', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:query', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534866', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:edit', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534867', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:delete', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(resource(id)) */ INTO resource (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status) 
VALUES ('1844026099075534868', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiter:modify', 1);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542751', '1346358560427216896', '1844026099075534859');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542752', '1346358560427216896', '1844026099075534860');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542753', '1346358560427216896', '1844026099075534861');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542754', '1346358560427216896', '1844026099075534862');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542755', '1346358560427216896', '1844026099075534863');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542756', '1346358560427216896', '1844026099075534864');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542757', '1346358560427216896', '1844026099075534865');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542758', '1346358560427216896', '1844026099075534866');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542759', '1346358560427216896', '1844026099075534867');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(permission(id)) */ INTO permission (id, object_id, resource_id) 
VALUES ('1697146860569542760', '1346358560427216896', '1844026099075534868');

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507049', '51', 'database', 'database', 1, 3, 2, '{"required":"0","defaultValue":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507050', '51', 'master', 'master', 2, 3, 3, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507051', '51', 'mode', 'mode', 2, 3, 4, '{"required":"0","defaultValue":"standalone","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507052', '51', 'url', 'url', 2, 3, 5, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507053', '51', 'password', 'password', 2, 3, 6, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507054', '51', 'maxIdle', 'maxIdle', 1, 3, 7, '{"required":"0","defaultValue":"8","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507055', '51', 'minIdle', 'minIdle', 1, 3, 8, '{"required":"0","defaultValue":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507056', '51', 'maxActive', 'maxActive', 1, 3, 9, '{"required":"0","defaultValue":"8","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507057', '51', 'maxWait', 'maxWait', 3, 3, 10, '{"required":"0","defaultValue":"-1","rule":""}', sysdate, sysdate);


INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507049', '51', 'database', 'database', 1, 3, 2, '{"required":"0","defaultValue":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507050', '51', 'master', 'master', 2, 3, 3, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507051', '51', 'mode', 'mode', 2, 3, 4, '{"required":"0","defaultValue":"standalone","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507052', '51', 'url', 'url', 2, 3, 5, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507053', '51', 'password', 'password', 2, 3, 6, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507054', '51', 'maxIdle', 'maxIdle', 1, 3, 7, '{"required":"0","defaultValue":"8","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507055', '51', 'minIdle', 'minIdle', 1, 3, 8, '{"required":"0","defaultValue":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507056', '51', 'maxActive', 'maxActive', 1, 3, 9, '{"required":"0","defaultValue":"8","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated) 
VALUES ('1722804548510507057', '51', 'maxWait', 'maxWait', 3, 3, 10, '{"required":"0","defaultValue":"-1","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
VALUES ('1679002911061737490', 'aiTokenLimitType', 'DEFAULT_KEY_RESOLVER', 'default', 'default', 'Rate limit by default', 0, 1, sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
VALUES ('1679002911061737491', 'aiTokenLimitType', 'IP_KEY_RESOLVER', 'ip', 'ip', 'Rate limit by request ip', 1, 1, sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
VALUES ('1679002911061737492', 'aiTokenLimitType', 'URI_KEY_RESOLVER', 'uri', 'uri', 'Rate limit by request uri', 2, 1, sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
VALUES ('1679002911061737493', 'aiTokenLimitType', 'HEADER_KEY_RESOLVER', 'header', 'header', 'Rate limit by request header', 3, 1, sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
VALUES ('1679002911061737494', 'aiTokenLimitType', 'PARAMETER_KEY_RESOLVER', 'parameter', 'parameter', 'Rate limit by request parameter', 4, 1, sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(shenyu_dict(id)) */ INTO shenyu_dict (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
VALUES ('1679002911061737495', 'aiTokenLimitType', 'COOKIE_KEY_RESOLVER', 'cookie', 'cookie', 'Rate limit by request cookie', 5, 1, sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1899702350766538752', '51', 'aiTokenLimitType', 'aiTokenLimitType', 3, 2, 0, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1899702411294539776', '51', 'timeWindowSeconds', 'timeWindowSeconds', 1, 2, 1, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1899702472330051584', '51', 'keyName', 'keyName', 2, 2, 2, '{"required":"0","rule":""}', sysdate, sysdate);

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(plugin_handle(id)) */ INTO plugin_handle (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
VALUES ('1899702529972371456', '51', 'tokenLimit', 'tokenLimit', 1, 2, 3, '{"required":"0","rule":""}', sysdate, sysdate);
