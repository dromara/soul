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


/* DROP TABLESPACE */
DROP TABLESPACE shenyu_data INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
/* DROP USER  */
DROP USER shenyu cascade;


/* create tablespace   */
create tablespace shenyu_data
logging
datafile 'D:\oracle\shenyu_data.dbf'
size 50m
autoextend on
next 50m maxsize 20480m
extent management local;

/* create user xxx by xx  */
create user shenyu identified by shenyu
default tablespace shenyu_data;

/* grant */
grant connect,resource,dba to shenyu;

create table SHENYU.APP_AUTH
(
    id           VARCHAR2(128) not null,
    app_key      VARCHAR2(32) not null,
    app_secret   VARCHAR2(128) not null,
    user_id      VARCHAR2(128),
    phone        VARCHAR2(255),
    ext_info     VARCHAR2(1024),
    open         NUMBER(3) not null,
    enabled      NUMBER(3) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.APP_AUTH.id
  is 'primary key id';
comment on column SHENYU.APP_AUTH.app_key
  is 'application identification key';
comment on column SHENYU.APP_AUTH.app_secret
  is 'encryption algorithm secret';
comment on column SHENYU.APP_AUTH.user_id
  is 'user id';
comment on column SHENYU.APP_AUTH.phone
  is 'phone number when the user applies';
comment on column SHENYU.APP_AUTH.ext_info
  is 'extended parameter json';
comment on column SHENYU.APP_AUTH.open
  is 'open auth path or not';
comment on column SHENYU.APP_AUTH.enabled
  is 'delete or not';
comment on column SHENYU.APP_AUTH.date_created
  is 'create time';
comment on column SHENYU.APP_AUTH.date_updated
  is 'update time';
alter table SHENYU.APP_AUTH
    add constraint PRIMARY primary key (ID)
    using index
    tablespace USERS
    pctfree 10
    initrans 2
    maxtrans 255;


create table SHENYU.AUTH_PARAM
(
    id           VARCHAR2(128) not null,
    auth_id      VARCHAR2(128),
    app_name     VARCHAR2(255) not null,
    app_param    VARCHAR2(255),
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.AUTH_PARAM.id
  is 'primary key id';
comment on column SHENYU.AUTH_PARAM.auth_id
  is 'authentication table id';
comment on column SHENYU.AUTH_PARAM.app_name
  is 'business Module';
comment on column SHENYU.AUTH_PARAM.app_param
  is 'service module parameters (parameters that need to be passed by the gateway) json type';
comment on column SHENYU.AUTH_PARAM.date_created
  is 'create time';
comment on column SHENYU.AUTH_PARAM.date_updated
  is 'update time';
alter table SHENYU.AUTH_PARAM
    add constraint PRIMARY_16 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.AUTH_PATH
(
    id           VARCHAR2(128) not null,
    auth_id      VARCHAR2(128) not null,
    app_name     VARCHAR2(255) not null,
    path         VARCHAR2(255) not null,
    enabled      NUMBER(3) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.AUTH_PATH.id
  is 'primary key id';
comment on column SHENYU.AUTH_PATH.auth_id
  is 'auth table id';
comment on column SHENYU.AUTH_PATH.app_name
  is 'module';
comment on column SHENYU.AUTH_PATH.path
  is 'path';
comment on column SHENYU.AUTH_PATH.enabled
  is 'whether pass 1 is';
comment on column SHENYU.AUTH_PATH.date_created
  is 'create time';
comment on column SHENYU.AUTH_PATH.date_updated
  is 'update time';
alter table SHENYU.AUTH_PATH
    add constraint PRIMARY_2 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.DASHBOARD_USER
(
    id           VARCHAR2(128) not null,
    user_name    VARCHAR2(64) not null,
    password     VARCHAR2(128),
    role         NUMBER(10) not null,
    enabled      NUMBER(3) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.DASHBOARD_USER.id
  is 'primary key id';
comment on column SHENYU.DASHBOARD_USER.user_name
  is 'user name';
comment on column SHENYU.DASHBOARD_USER.password
  is 'user password';
comment on column SHENYU.DASHBOARD_USER.role
  is 'role';
comment on column SHENYU.DASHBOARD_USER.enabled
  is 'delete or not';
comment on column SHENYU.DASHBOARD_USER.date_created
  is 'create time';
comment on column SHENYU.DASHBOARD_USER.date_updated
  is 'update time';
alter table SHENYU.DASHBOARD_USER
    add constraint PRIMARY_3 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table SHENYU.DASHBOARD_USER
    add constraint UNIQUE_USER_NAME unique (USER_NAME)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.DATA_PERMISSION
(
    id           VARCHAR2(128) not null,
    user_id      VARCHAR2(128) not null,
    data_id      VARCHAR2(128) not null,
    data_type    NUMBER(10) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.DATA_PERMISSION.id
  is 'primary key id';
comment on column SHENYU.DATA_PERMISSION.user_id
  is 'user primary key id';
comment on column SHENYU.DATA_PERMISSION.data_id
  is 'data(selector,rule) primary key id';
comment on column SHENYU.DATA_PERMISSION.data_type
  is '0 selector type , 1 rule type';
comment on column SHENYU.DATA_PERMISSION.date_created
  is 'create time';
comment on column SHENYU.DATA_PERMISSION.date_updated
  is 'update time';
alter table SHENYU.DATA_PERMISSION
    add constraint PRIMARY_4 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.META_DATA
(
    id              VARCHAR2(128) not null,
    app_name        VARCHAR2(255) not null,
    path            VARCHAR2(255) not null,
    path_desc       VARCHAR2(255) not null,
    rpc_type        VARCHAR2(64) not null,
    service_name    VARCHAR2(255),
    method_name     VARCHAR2(255),
    parameter_types VARCHAR2(255),
    rpc_ext         VARCHAR2(512),
    date_created    DATE default SYSDATE not null,
    date_updated    DATE default SYSDATE not null,
    enabled         NUMBER(3) default '0' not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.META_DATA.id
  is 'id';
comment on column SHENYU.META_DATA.app_name
  is 'application name';
comment on column SHENYU.META_DATA.path
  is 'path, cannot be repeated';
comment on column SHENYU.META_DATA.path_desc
  is 'path description';
comment on column SHENYU.META_DATA.rpc_type
  is 'rpc type';
comment on column SHENYU.META_DATA.service_name
  is 'service name';
comment on column SHENYU.META_DATA.method_name
  is 'method name';
comment on column SHENYU.META_DATA.parameter_types
  is 'parameter types are provided with multiple parameter types separated by commas';
comment on column SHENYU.META_DATA.rpc_ext
  is 'rpc extended information, json format';
comment on column SHENYU.META_DATA.date_created
  is 'create time';
comment on column SHENYU.META_DATA.date_updated
  is 'update time';
comment on column SHENYU.META_DATA.enabled
  is 'enabled state';
alter table SHENYU.META_DATA
    add constraint PRIMARY_5 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.PERMISSION
(
    id           VARCHAR2(128) not null,
    object_id    VARCHAR2(128) not null,
    resource_id  VARCHAR2(128) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.PERMISSION.id
  is 'primary key id';
comment on column SHENYU.PERMISSION.object_id
  is 'user primary key id or role primary key id';
comment on column SHENYU.PERMISSION.resource_id
  is 'resource primary key id';
comment on column SHENYU.PERMISSION.date_created
  is 'create time';
comment on column SHENYU.PERMISSION.date_updated
  is 'update time';
alter table SHENYU.PERMISSION
    add constraint PRIMARY_6 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

create table SHENYU.PLUGIN
(
    id           VARCHAR2(128) not null,
    name         VARCHAR2(62) not null,
    config       CLOB,
    role         VARCHAR2(64) not null,
    sort         NUMBER(10),
    enabled      NUMBER(3) default '0' not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.PLUGIN.id
  is 'primary key id';
comment on column SHENYU.PLUGIN.name
  is 'plugin name';
comment on column SHENYU.PLUGIN.config
  is 'plugin configuration';
comment on column SHENYU.PLUGIN.role
  is 'plug-in role';
comment on column SHENYU.PLUGIN.sort
  is 'sort';
comment on column SHENYU.PLUGIN.enabled
  is 'whether to open (0, not open, 1 open)';
comment on column SHENYU.PLUGIN.date_created
  is 'create time';
comment on column SHENYU.PLUGIN.date_updated
  is 'update time';
alter table SHENYU.PLUGIN
    add constraint PRIMARY_7 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.PLUGIN_HANDLE
(
    id           VARCHAR2(128) not null,
    plugin_id    VARCHAR2(128) not null,
    field        VARCHAR2(100) not null,
    label        VARCHAR2(100),
    data_type    NUMBER(5) default '1' not null,
    type         NUMBER(5),
    sort         NUMBER(10),
    ext_obj      VARCHAR2(1024),
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.PLUGIN_HANDLE.plugin_id
  is 'plugin id';
comment on column SHENYU.PLUGIN_HANDLE.field
  is 'field';
comment on column SHENYU.PLUGIN_HANDLE.label
  is 'label';
comment on column SHENYU.PLUGIN_HANDLE.data_type
  is 'data type 1 number 2 string';
comment on column SHENYU.PLUGIN_HANDLE.type
  is 'type, 1 means selector, 2 means rule, 3 means plugin';
comment on column SHENYU.PLUGIN_HANDLE.sort
  is 'sort';
comment on column SHENYU.PLUGIN_HANDLE.ext_obj
  is 'extra configuration (json format data)';
comment on column SHENYU.PLUGIN_HANDLE.date_created
  is 'create time';
comment on column SHENYU.PLUGIN_HANDLE.date_updated
  is 'update time';
alter table SHENYU.PLUGIN_HANDLE
    add constraint PRIMARY_8 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table SHENYU.PLUGIN_HANDLE
    add constraint PLUGIN_ID_FIELD_TYPE unique (PLUGIN_ID, FIELD, TYPE)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU."RESOURCE"
(
    id            VARCHAR2(128) not null,
    parent_id     VARCHAR2(128),
    title         VARCHAR2(128),
    name          VARCHAR2(32),
    url           VARCHAR2(32),
    component     VARCHAR2(32),
    resource_type NUMBER(10) not null,
    sort          NUMBER(10) not null,
    icon          VARCHAR2(32),
    is_leaf       NUMBER(3) not null,
    is_route      NUMBER(10) not null,
    perms         VARCHAR2(64),
    status        NUMBER(10) not null,
    date_created  DATE default SYSDATE not null,
    date_updated  DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU."RESOURCE".id
  is 'primary key id';
comment on column SHENYU."RESOURCE".parent_id
  is 'resource parent primary key id';
comment on column SHENYU."RESOURCE".title
  is 'title';
comment on column SHENYU."RESOURCE".name
  is 'route name';
comment on column SHENYU."RESOURCE".url
  is 'route url';
comment on column SHENYU."RESOURCE".component
  is 'component';
comment on column SHENYU."RESOURCE".resource_type
  is 'resource type eg 0:main menu 1:child menu 2:function button';
comment on column SHENYU."RESOURCE".sort
  is 'sort';
comment on column SHENYU."RESOURCE".icon
  is 'icon';
comment on column SHENYU."RESOURCE".is_leaf
  is 'leaf node 0:no 1:yes';
comment on column SHENYU."RESOURCE".is_route
  is 'route 1:yes 0:no';
comment on column SHENYU."RESOURCE".perms
  is 'button permission description sys:user:add(add)/sys:user:edit(edit)';
comment on column SHENYU."RESOURCE".status
  is 'status 1:enable 0:disable';
comment on column SHENYU."RESOURCE".date_created
  is 'create time';
comment on column SHENYU."RESOURCE".date_updated
  is 'update time';
alter table SHENYU."RESOURCE"
    add constraint PRIMARY_9 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.ROLE
(
    id           VARCHAR2(128) not null,
    role_name    VARCHAR2(32) not null,
    description  VARCHAR2(255),
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.ROLE.id
  is 'primary key id';
comment on column SHENYU.ROLE.role_name
  is 'role name';
comment on column SHENYU.ROLE.description
  is 'role describe';
comment on column SHENYU.ROLE.date_created
  is 'create time';
comment on column SHENYU.ROLE.date_updated
  is 'update time';
alter table SHENYU.ROLE
    add constraint PRIMARY_10 primary key (ID, ROLE_NAME)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.RULE
(
    id           VARCHAR2(128) not null,
    selector_id  VARCHAR2(128) not null,
    match_mode   NUMBER(10) not null,
    name         VARCHAR2(128) not null,
    enabled      NUMBER(3) not null,
    loged        NUMBER(3) not null,
    sort         NUMBER(10) not null,
    handle       VARCHAR2(1024),
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.RULE.id
  is 'primary key id';
comment on column SHENYU.RULE.selector_id
  is 'selector id';
comment on column SHENYU.RULE.match_mode
  is 'matching mode (0 and 1 or)';
comment on column SHENYU.RULE.name
  is 'rule name';
comment on column SHENYU.RULE.enabled
  is 'whether to open';
comment on column SHENYU.RULE.loged
  is 'whether to log or not';
comment on column SHENYU.RULE.sort
  is 'sort';
comment on column SHENYU.RULE.handle
  is 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)';
comment on column SHENYU.RULE.date_created
  is 'create time';
comment on column SHENYU.RULE.date_updated
  is 'update time';
alter table SHENYU.RULE
    add constraint PRIMARY_11 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table SHENYU.RULE
    add constraint UNIQUE_NAME unique (NAME)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.RULE_CONDITION
(
    id           VARCHAR2(128) not null,
    rule_id      VARCHAR2(128) not null,
    param_type   VARCHAR2(64) not null,
    operator     VARCHAR2(64) not null,
    param_name   VARCHAR2(64) not null,
    param_value  VARCHAR2(64) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.RULE_CONDITION.id
  is 'primary key id';
comment on column SHENYU.RULE_CONDITION.rule_id
  is 'rule id';
comment on column SHENYU.RULE_CONDITION.param_type
  is 'parameter type (post query uri, etc.)';
comment on column SHENYU.RULE_CONDITION.operator
  is 'matching character (=> <like match)';
comment on column SHENYU.RULE_CONDITION.param_name
  is 'parameter name';
comment on column SHENYU.RULE_CONDITION.param_value
  is 'parameter value';
comment on column SHENYU.RULE_CONDITION.date_created
  is 'create time';
comment on column SHENYU.RULE_CONDITION.date_updated
  is 'update time';
alter table SHENYU.RULE_CONDITION
    add constraint PRIMARY_12 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.SELECTOR
(
    id           VARCHAR2(128) not null,
    plugin_id    VARCHAR2(128) not null,
    name         VARCHAR2(64) not null,
    match_mode   NUMBER(10) not null,
    type         NUMBER(10) not null,
    sort         NUMBER(10) not null,
    handle       VARCHAR2(1024),
    enabled      NUMBER(3) not null,
    loged        NUMBER(3) not null,
    continued    NUMBER(3) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.SELECTOR.id
  is 'primary key id varchar';
comment on column SHENYU.SELECTOR.plugin_id
  is 'plugin id';
comment on column SHENYU.SELECTOR.name
  is 'selector name';
comment on column SHENYU.SELECTOR.match_mode
  is 'matching mode (0 and 1 or)';
comment on column SHENYU.SELECTOR.type
  is 'type (0, full flow, 1 custom flow)';
comment on column SHENYU.SELECTOR.sort
  is 'sort';
comment on column SHENYU.SELECTOR.handle
  is 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)';
comment on column SHENYU.SELECTOR.enabled
  is 'whether to open';
comment on column SHENYU.SELECTOR.loged
  is 'whether to print the log';
comment on column SHENYU.SELECTOR.continued
  is 'whether to continue execution';
comment on column SHENYU.SELECTOR.date_created
  is 'create time';
comment on column SHENYU.SELECTOR.date_updated
  is 'update time';
alter table SHENYU.SELECTOR
    add constraint PRIMARY_13 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table SHENYU.SELECTOR
    add constraint UNIQUE_NAME_16 unique (NAME)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.SELECTOR_CONDITION
(
    id           VARCHAR2(128) not null,
    selector_id  VARCHAR2(128) not null,
    param_type   VARCHAR2(64) not null,
    operator     VARCHAR2(64) not null,
    param_name   VARCHAR2(64) not null,
    param_value  VARCHAR2(64) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.SELECTOR_CONDITION.id
  is 'primary key id';
comment on column SHENYU.SELECTOR_CONDITION.selector_id
  is 'selector id';
comment on column SHENYU.SELECTOR_CONDITION.param_type
  is 'parameter type (to query uri, etc.)';
comment on column SHENYU.SELECTOR_CONDITION.operator
  is 'matching character (=> <like matching)';
comment on column SHENYU.SELECTOR_CONDITION.param_name
  is 'parameter name';
comment on column SHENYU.SELECTOR_CONDITION.param_value
  is 'parameter value';
comment on column SHENYU.SELECTOR_CONDITION.date_created
  is 'create time';
comment on column SHENYU.SELECTOR_CONDITION.date_updated
  is 'update time';
alter table SHENYU.SELECTOR_CONDITION
    add constraint PRIMARY_14 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.SHENYU_DICT
(
    id           VARCHAR2(128) not null,
    type         VARCHAR2(100) not null,
    dict_code    VARCHAR2(100) not null,
    dict_name    VARCHAR2(100) not null,
    dict_value   VARCHAR2(100),
    "desc"        VARCHAR2(255),
    sort         NUMBER(10) not null,
    enabled      NUMBER(3),
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.SHENYU_DICT.id
  is 'primary key id';
comment on column SHENYU.SHENYU_DICT.type
  is 'type';
comment on column SHENYU.SHENYU_DICT.dict_code
  is 'dictionary encoding';
comment on column SHENYU.SHENYU_DICT.dict_name
  is 'dictionary name';
comment on column SHENYU.SHENYU_DICT.dict_value
  is 'dictionary value';
comment on column SHENYU.SHENYU_DICT."desc"
  is 'dictionary description or remarks';
comment on column SHENYU.SHENYU_DICT.sort
  is 'sort';
comment on column SHENYU.SHENYU_DICT.enabled
  is 'whether it is enabled';
comment on column SHENYU.SHENYU_DICT.date_created
  is 'create time';
comment on column SHENYU.SHENYU_DICT.date_updated
  is 'update time';
alter table SHENYU.SHENYU_DICT
    add constraint PRIMARY_15 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


create table SHENYU.USER_ROLE
(
    id           VARCHAR2(128) not null,
    user_id      VARCHAR2(128) not null,
    role_id      VARCHAR2(128) not null,
    date_created DATE default SYSDATE not null,
    date_updated DATE default SYSDATE not null
)
    tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column SHENYU.USER_ROLE.id
  is 'primary key id';
comment on column SHENYU.USER_ROLE.user_id
  is 'user primary key';
comment on column SHENYU.USER_ROLE.role_id
  is 'role primary key';
comment on column SHENYU.USER_ROLE.date_created
  is 'create time';
comment on column SHENYU.USER_ROLE.date_updated
  is 'update time';
alter table SHENYU.USER_ROLE
    add constraint PRIMARY_1 primary key (ID)
    using index
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;


insert into shenyu.DASHBOARD_USER (id, user_name, password, role, enabled, date_created, date_updated)
values ('1', 'admin', 'bbiB8zbUo3z3oA0VqEB/IA==', 1, 1, to_date('30-12-1899 01:00:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('27-08-2021', 'dd-mm-yyyy'));
commit;

insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708572688384', '1346358560427216896', '1346775491550474240', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708585271296', '1346358560427216896', '1346776175553376256', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708593659904', '1346358560427216896', '1346777157943259136', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708597854208', '1346358560427216896', '1346777449787125760', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708606242816', '1346358560427216896', '1346777623011880960', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708610437120', '1346358560427216896', '1346777766301888512', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708614631424', '1346358560427216896', '1346777907096285184', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708623020032', '1346358560427216896', '1346778036402483200', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708627214336', '1346358560427216896', '1347026381504262144', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708631408640', '1346358560427216896', '1347026805170909184', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708639797248', '1346358560427216896', '1347027413357572096', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708643991552', '1346358560427216896', '1347027482244820992', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708648185856', '1346358560427216896', '1347027526339538944', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708652380160', '1346358560427216896', '1347027566034432000', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708656574464', '1346358560427216896', '1347027647999520768', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708660768768', '1346358560427216896', '1347027717792739328', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708669157376', '1346358560427216896', '1347027769747582976', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708673351680', '1346358560427216896', '1347027830602739712', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708677545984', '1346358560427216896', '1347027918121086976', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708681740288', '1346358560427216896', '1347027995199811584', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708685934592', '1346358560427216896', '1347028169120821248', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708685934593', '1346358560427216896', '1347032308726902784', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708690128896', '1346358560427216896', '1347032395901317120', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708694323200', '1346358560427216896', '1347032453707214848', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708698517504', '1346358560427216896', '1347032509051056128', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708702711808', '1346358560427216896', '1347034027070337024', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708706906112', '1346358560427216896', '1347039054925148160', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708711100416', '1346358560427216896', '1347041326749691904', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708715294720', '1346358560427216896', '1347046566244003840', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708719489024', '1346358560427216896', '1347047143350874112', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708723683328', '1346358560427216896', '1347047203220369408', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708727877632', '1346358560427216896', '1347047555588042752', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708732071936', '1346358560427216896', '1347047640145211392', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708732071937', '1346358560427216896', '1347047695002513408', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708736266240', '1346358560427216896', '1347047747305484288', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708740460544', '1346358560427216896', '1347048004105940992', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708744654848', '1346358560427216896', '1347048101875167232', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708744654849', '1346358560427216896', '1347048145877610496', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708748849152', '1346358560427216896', '1347048240677269504', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708753043456', '1346358560427216896', '1347048316216684544', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708757237760', '1346358560427216896', '1347048776029843456', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708757237761', '1346358560427216896', '1347048968414179328', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708761432064', '1346358560427216896', '1347049029323862016', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708765626368', '1346358560427216896', '1347049092552994816', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708769820672', '1346358560427216896', '1347049251395481600', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708774014976', '1346358560427216896', '1347049317178945536', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708774014977', '1346358560427216896', '1347049370014593024', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708778209280', '1346358560427216896', '1347049542417264640', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708782403584', '1346358560427216896', '1347049598155370496', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708786597888', '1346358560427216896', '1347049659023110144', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708790792192', '1346358560427216896', '1347049731047698432', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708794986496', '1346358560427216896', '1347049794008395776', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708799180800', '1346358560427216896', '1347050493052071936', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708799180801', '1346358560427216896', '1347050998931271680', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708803375104', '1346358560427216896', '1347051241320099840', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708807569408', '1346358560427216896', '1347051306788990976', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708807569409', '1346358560427216896', '1347051641725136896', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708811763712', '1346358560427216896', '1347051850521784320', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708815958016', '1346358560427216896', '1347051853025783808', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708815958017', '1346358560427216896', '1347051855538171904', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708820152320', '1346358560427216896', '1347051857962479616', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708824346624', '1346358560427216896', '1347051860495839232', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708828540928', '1346358560427216896', '1347052833968631808', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708828540929', '1346358560427216896', '1347052836300664832', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708832735232', '1346358560427216896', '1347052839198928896', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708836929536', '1346358560427216896', '1347052841824563200', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708836929537', '1346358560427216896', '1347052843993018368', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708841123840', '1346358560427216896', '1347053324018528256', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708845318144', '1346358560427216896', '1347053326988095488', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708849512448', '1346358560427216896', '1347053329378848768', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708853706752', '1346358560427216896', '1347053331744436224', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708857901056', '1346358560427216896', '1347053334470733824', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708857901057', '1346358560427216896', '1347053363814084608', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708862095360', '1346358560427216896', '1347053366552965120', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708866289664', '1346358560427216896', '1347053369413480448', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708866289665', '1346358560427216896', '1347053372164943872', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708870483968', '1346358560427216896', '1347053375029653504', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708874678272', '1346358560427216896', '1347053404050042880', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708874678273', '1346358560427216896', '1347053406939918336', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708878872576', '1346358560427216896', '1347053409842376704', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708878872577', '1346358560427216896', '1347053413067796480', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708883066880', '1346358560427216896', '1347053415945089024', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708887261184', '1346358560427216896', '1347053442419535872', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708891455488', '1346358560427216896', '1347053445191970816', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708891455489', '1346358560427216896', '1347053447695970304', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708895649792', '1346358560427216896', '1347053450304827392', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708895649793', '1346358560427216896', '1347053452737523712', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708899844096', '1346358560427216896', '1347053477844627456', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708904038400', '1346358560427216896', '1347053480977772544', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708904038401', '1346358560427216896', '1347053483712458752', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708908232704', '1346358560427216896', '1347053486426173440', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708912427008', '1346358560427216896', '1347053489571901440', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708916621312', '1346358560427216896', '1347053516423835648', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708920815616', '1346358560427216896', '1347053519401791488', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708920815617', '1346358560427216896', '1347053522182615040', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708925009920', '1346358560427216896', '1347053525034741760', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708929204224', '1346358560427216896', '1347053527819759616', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708933398528', '1346358560427216896', '1347053554310983680', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708933398529', '1346358560427216896', '1347053556512993280', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708937592832', '1346358560427216896', '1347053559050547200', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
commit;


insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708937592833', '1346358560427216896', '1347053561579712512', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708941787136', '1346358560427216896', '1347053564016603136', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708941787137', '1346358560427216896', '1347053595729735680', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708945981440', '1346358560427216896', '1347053598829326336', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708950175744', '1346358560427216896', '1347053601572401152', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708954370048', '1346358560427216896', '1347053604093177856', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708958564352', '1346358560427216896', '1347053606622343168', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708962758656', '1346358560427216896', '1347053631159021568', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708962758657', '1346358560427216896', '1347053633809821696', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708966952960', '1346358560427216896', '1347053636439650304', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708971147264', '1346358560427216896', '1347053638968815616', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708971147265', '1346358560427216896', '1347053641346985984', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708975341568', '1346358560427216896', '1347053666227597312', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708979535872', '1346358560427216896', '1347053668538658816', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708979535873', '1346358560427216896', '1347053670791000064', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708983730176', '1346358560427216896', '1347053673043341312', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708987924480', '1346358560427216896', '1347053675174047744', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992118784', '1346358560427216896', '1347063567603609600', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992118999', '1346358560427216896', '1350099836492595202', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119000', '1346358560427216896', '1350099836492595203', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119001', '1346358560427216896', '1350099836492595204', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119002', '1346358560427216896', '1350099836492595205', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119003', '1346358560427216896', '1350099836492595206', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119004', '1346358560427216896', '1350099836492595207', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119005', '1346358560427216896', '1350099836492595208', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708992119006', '1346358560427216896', '1350099836492595209', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007708996313088', '1346358560427216896', '1347064011369361408', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709000507392', '1346358560427216896', '1347064013848195072', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709000507393', '1346358560427216896', '1347064016373166080', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709004701696', '1346358560427216896', '1347064019007188992', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709008896000', '1346358560427216896', '1347064021486022656', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709008896001', '1346358560427216896', '1350096617689751552', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709013090304', '1346358560427216896', '1350096630197166080', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709013090305', '1346358560427216896', '1350098233939632128', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709017284608', '1346358560427216896', '1350098236741427200', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709021478912', '1346358560427216896', '1350099831950163968', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709021478913', '1346358560427216896', '1350099836492595200', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709025673216', '1346358560427216896', '1350099893203779584', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709029867520', '1346358560427216896', '1350099896441782272', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709029867521', '1346358560427216896', '1350099936379944960', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709034061824', '1346358560427216896', '1350099939177545728', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709034061825', '1346358560427216896', '1350099976435548160', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709038256128', '1346358560427216896', '1350099979434475520', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709038256129', '1346358560427216896', '1350100013341229056', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709042450432', '1346358560427216896', '1350100016319184896', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709042450433', '1346358560427216896', '1350100053757542400', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709046644736', '1346358560427216896', '1350100056525783040', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709050839040', '1346358560427216896', '1350100110510669824', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709050839041', '1346358560427216896', '1350100113283104768', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709055033344', '1346358560427216896', '1350100147437322240', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709059227648', '1346358560427216896', '1350100150096510976', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709059227649', '1346358560427216896', '1350100190894505984', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709063421952', '1346358560427216896', '1350100193801158656', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709067616256', '1346358560427216896', '1350100229360467968', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709067616257', '1346358560427216896', '1350100232451670016', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709071810560', '1346358560427216896', '1350100269307019264', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709071810561', '1346358560427216896', '1350100272083648512', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709076004864', '1346358560427216896', '1350100334205485056', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709076004865', '1346358560427216896', '1350100337363795968', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709080199168', '1346358560427216896', '1350106119681622016', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709080199169', '1346358560427216896', '1350107709494804480', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709084393472', '1346358560427216896', '1350107842236137472', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709084393473', '1346358560427216896', '1350112406754766848', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709088587776', '1346358560427216896', '1350112481253994496', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1351007709088587777', '1346358560427216896', '1350804501819195392', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1355167519859040256', '1346358560427216896', '1355163372527050752', to_date('29-01-2021 22:54:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-01-2021 22:58:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1355167519859040257', '1346358560427216896', '1355165158419750912', to_date('29-01-2021 22:54:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-01-2021 22:58:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1355167519859040258', '1346358560427216896', '1355165353534578688', to_date('29-01-2021 22:54:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-01-2021 22:58:42', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1355167519859040259', '1346358560427216896', '1355165475785957376', to_date('29-01-2021 22:54:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-01-2021 22:58:43', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1355167519859040260', '1346358560427216896', '1355165608565039104', to_date('29-01-2021 22:54:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-01-2021 22:58:43', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357956838021890049', '1346358560427216896', '1357956838021890048', to_date('06-02-2021 15:38:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 15:38:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977745893326848', '1346358560427216896', '1357977745889132544', to_date('06-02-2021 17:01:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:01:39', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977912126177281', '1346358560427216896', '1357977912126177280', to_date('06-02-2021 17:02:19', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:19', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900417', '1346358560427216896', '1357977971827900416', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900418', '1346358560427216896', '1350100337363795969', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900419', '1346358560427216896', '1350100337363795970', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900420', '1346358560427216896', '1350100337363795971', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900421', '1346358560427216896', '1350100337363795972', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900422', '1346358560427216896', '1350100337363795973', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900423', '1346358560427216896', '1350100337363795974', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900424', '1346358560427216896', '1350100337363795975', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900425', '1346358560427216896', '1347028169120821249', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900426', '1346358560427216896', '1347052833968631809', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900427', '1346358560427216896', '1347052836300664833', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900428', '1346358560427216896', '1347052839198928897', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900429', '1346358560427216896', '1347052841824563201', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900430', '1346358560427216896', '1347052843993018369', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900431', '1346358560427216896', '1350099831950163969', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900432', '1346358560427216896', '1350099836492595201', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1357977971827900433', '1346358560427216896', '1347027413357572097', to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1386680049203195905', '1346358560427216896', '1386680049203195904', to_date('26-04-2021 21:54:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-04-2021 21:54:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642195801722880', '1346358560427216896', '1387642195797528576', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642195986272256', '1346358560427216896', '1387642195982077952', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642196145655809', '1346358560427216896', '1387642196145655808', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642196409896961', '1346358560427216896', '1387642196409896960', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642196598640641', '1346358560427216896', '1387642196598640640', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642197181648897', '1346358560427216896', '1387642197181648896', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642197538164737', '1346358560427216896', '1387642197538164736', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1387642197689159681', '1346358560427216896', '1387642197689159680', to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390305479235194880', '1346358560427216896', '1390305479231000576', to_date('06-05-2021 22:00:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:00:31', 'dd-mm-yyyy hh24:mi:ss'));
commit;
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390305641097580545', '1346358560427216896', '1390305641097580544', to_date('06-05-2021 22:01:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:01:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309613569036289', '1346358560427216896', '1390309613569036288', to_date('06-05-2021 22:16:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:16:57', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309729176637441', '1346358560427216896', '1390309729176637440', to_date('06-05-2021 22:17:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:17:24', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309914883641345', '1346358560427216896', '1390309914883641344', to_date('06-05-2021 22:18:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309936706605057', '1346358560427216896', '1390309936706605056', to_date('06-05-2021 22:18:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309954016497665', '1346358560427216896', '1390309954016497664', to_date('06-05-2021 22:18:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:18', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309981166227457', '1346358560427216896', '1390309981166227456', to_date('06-05-2021 22:18:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:24', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390309998543228929', '1346358560427216896', '1390309998543228928', to_date('06-05-2021 22:18:29', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:29', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310018877214721', '1346358560427216896', '1390310018877214720', to_date('06-05-2021 22:18:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310036459737089', '1346358560427216896', '1390310036459737088', to_date('06-05-2021 22:18:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310053543137281', '1346358560427216896', '1390310053543137280', to_date('06-05-2021 22:18:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:42', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310073772265473', '1346358560427216896', '1390310073772265472', to_date('06-05-2021 22:18:47', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310094571819009', '1346358560427216896', '1390310094571819008', to_date('06-05-2021 22:18:52', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310112892538881', '1346358560427216896', '1390310112892538880', to_date('06-05-2021 22:18:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:18:56', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310128516321281', '1346358560427216896', '1390310128516321280', to_date('06-05-2021 22:19:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310145079627777', '1346358560427216896', '1390310145079627776', to_date('06-05-2021 22:19:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310166948728833', '1346358560427216896', '1390310166948728832', to_date('06-05-2021 22:19:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310188486479873', '1346358560427216896', '1390310188486479872', to_date('06-05-2021 22:19:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310205808955393', '1346358560427216896', '1390310205808955392', to_date('06-05-2021 22:19:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:18', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310247684886529', '1346358560427216896', '1390310247684886528', to_date('06-05-2021 22:19:28', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:28', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310264424353793', '1346358560427216896', '1390310264424353792', to_date('06-05-2021 22:19:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310282875097089', '1346358560427216896', '1390310282875097088', to_date('06-05-2021 22:19:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310298985418753', '1346358560427216896', '1390310298985418752', to_date('06-05-2021 22:19:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310354216013825', '1346358560427216896', '1390310354216013824', to_date('06-05-2021 22:19:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310376865255425', '1346358560427216896', '1390310376865255424', to_date('06-05-2021 22:19:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:19:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310406321852417', '1346358560427216896', '1390310406321852416', to_date('06-05-2021 22:20:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:06', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310423401058305', '1346358560427216896', '1390310423401058304', to_date('06-05-2021 22:20:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310441755332609', '1346358560427216896', '1390310441755332608', to_date('06-05-2021 22:20:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310459904086017', '1346358560427216896', '1390310459904086016', to_date('06-05-2021 22:20:19', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:19', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310476815519745', '1346358560427216896', '1390310476815519744', to_date('06-05-2021 22:20:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310492686766081', '1346358560427216896', '1390310492686766080', to_date('06-05-2021 22:20:27', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:26', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310509401067521', '1346358560427216896', '1390310509401067520', to_date('06-05-2021 22:20:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310527348494337', '1346358560427216896', '1390310527348494336', to_date('06-05-2021 22:20:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310544494809089', '1346358560427216896', '1390310544494809088', to_date('06-05-2021 22:20:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:39', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1390310562312212481', '1346358560427216896', '1390310562312212480', to_date('06-05-2021 22:20:43', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-05-2021 22:20:43', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768162320001', '1346358560427216896', '1397547768204263112', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768162320011', '1346358560427216896', '1397547768204263121', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768162320384', '1346358560427216896', '1397547768158126080', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768208457002', '1346358560427216896', '1397547768216846113', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768208457012', '1346358560427216896', '1397547768216846122', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768208457728', '1346358560427216896', '1397547768204263424', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768216846003', '1346358560427216896', '1397547768225234114', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768216846013', '1346358560427216896', '1397547768225234123', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768216846337', '1346358560427216896', '1397547768216846336', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768225234004', '1346358560427216896', '1397547768233623115', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768225234014', '1346358560427216896', '1397547768233623124', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768225234945', '1346358560427216896', '1397547768225234944', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768233623005', '1346358560427216896', '1397547768246206116', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768233623015', '1346358560427216896', '1397547768246206125', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768233623553', '1346358560427216896', '1397547768233623552', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768246206006', '1346358560427216896', '1397547768275566117', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768246206016', '1346358560427216896', '1397547768275566126', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768246206465', '1346358560427216896', '1397547768246206464', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768275566007', '1346358560427216896', '1397547768283955118', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768275566017', '1346358560427216896', '1397547768283955127', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768275566593', '1346358560427216896', '1397547768275566592', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768283955008', '1346358560427216896', '1397547768292343119', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768283955018', '1346358560427216896', '1397547768292343128', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768283955201', '1346358560427216896', '1397547768283955200', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768292343009', '1346358560427216896', '1397547768296538120', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768292343019', '1346358560427216896', '1397547768296538129', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768292343809', '1346358560427216896', '1397547768292343808', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768300732010', '1346358560427216896', '1347028169120821250', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768300732011', '1346358560427216896', '1347028169120821251', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1397547768300732416', '1346358560427216896', '1397547768296538112', to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-05-2021 21:38:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252532449280', '1346358560427216896', '1398994252528254976', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252570198016', '1346358560427216896', '1398994252566003712', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252582780929', '1346358560427216896', '1398994252582780928', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252591169537', '1346358560427216896', '1398994252591169536', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252603752449', '1346358560427216896', '1398994252603752448', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252620529665', '1346358560427216896', '1398994252620529664', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252645695489', '1346358560427216896', '1398994252645695488', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252658278401', '1346358560427216896', '1398994252658278400', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252666667009', '1346358560427216896', '1398994252666667008', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1398994252679249921', '1346358560427216896', '1398994252679249920', to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 21:26:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534378686054400', '1346358560427216896', '1405534378660888576', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534378979655680', '1346358560427216896', '1405534378971267072', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379000627201', '1346358560427216896', '1405534379000627200', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379046764545', '1346358560427216896', '1405534379046764544', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379071930369', '1346358560427216896', '1405534379071930368', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379092901889', '1346358560427216896', '1405534379092901888', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379122262017', '1346358560427216896', '1405534379122262016', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379139039233', '1346358560427216896', '1405534379139039232', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379168399360', '1346358560427216896', '1405534379164205056', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PERMISSION (id, object_id, resource_id, date_created, date_updated)
values ('1405534379185176577', '1346358560427216896', '1405534379185176576', to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'));
commit;

insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('1', '10', 'flowRuleGrade', 'flowRuleGrade', 3, 2, 8, '{"required":"1","defaultValue":"1","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('10', '2', 'statusCode', 'statusCode', 2, 2, 2, null, to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('1001', '14', 'contextPath', 'contextPath', 2, 2, 0, null, to_date('25-12-2020 16:13:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-12-2020 16:13:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('1002', '14', 'addPrefix', 'addPrefix', 2, 2, 0, null, to_date('25-12-2020 16:13:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-12-2020 16:13:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('101', '24', 'strategyName', 'strategyName', 3, 2, 1, null, to_date('06-08-2021 14:35:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-08-2021 14:35:50', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('103', '24', 'fieldNames', 'fieldNames', 2, 2, 3, null, to_date('06-08-2021 14:37:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-08-2021 14:37:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('104', '24', 'key', 'key', 2, 2, 3, null, to_date('06-08-2021 14:37:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-08-2021 14:37:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('108', '25', 'strategyName', 'strategyName', 3, 2, 2, null, to_date('13-08-2021 15:10:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-08-2021 15:11:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('109', '25', 'key', 'key', 2, 2, 3, null, to_date('13-08-2021 15:14:07', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-08-2021 15:14:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('11', '4', 'replenishRate', 'replenishRate', 2, 2, 2, '{"required":"1","defaultValue":"10","rule":""}', to_date('24-11-2020 00:17:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('24-11-2020 00:17:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('110', '25', 'fieldNames', 'fieldNames', 2, 2, 4, null, to_date('13-08-2021 15:16:30', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-08-2021 15:16:45', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('12', '4', 'burstCapacity', 'burstCapacity', 2, 2, 3, '{"required":"1","defaultValue":"100","rule":""}', to_date('24-11-2020 00:17:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('24-11-2020 00:17:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('130', '3', 'regex', 'regex', 2, 2, 1, null, to_date('24-05-2021 16:07:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('24-05-2021 16:07:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('131', '3', 'replace', 'replace', 2, 2, 2, null, to_date('24-05-2021 16:07:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('24-05-2021 16:07:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('14', '8', 'path', 'path', 2, 2, 1, null, to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('15', '8', 'timeout', 'timeout (ms)', 1, 2, 2, null, to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('16', '8', 'serviceId', 'serviceId', 2, 1, 1, null, to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('17', '12', 'timeoutDurationRate', 'timeoutDurationRate (ms)', 1, 2, 1, '{"required":"1","defaultValue":"5000","rule":""}', to_date('28-11-2020 11:08:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:19:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('18', '12', 'limitRefreshPeriod', 'limitRefreshPeriod (ms)', 1, 2, 0, '{"required":"1","defaultValue":"500","rule":""}', to_date('28-11-2020 11:18:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:22:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('19', '12', 'limitForPeriod', 'limitForPeriod', 1, 2, 0, '{"required":"1","defaultValue":"50","rule":""}', to_date('28-11-2020 11:20:11', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:20:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('2', '10', 'flowRuleControlBehavior', 'flowRuleControlBehavior', 3, 2, 5, '{"required":"1","defaultValue":"0","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('20', '12', 'circuitEnable', 'circuitEnable', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}', to_date('28-11-2020 11:23:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:24:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('21', '12', 'timeoutDuration', 'timeoutDuration (ms)', 1, 2, 2, '{"required":"1","defaultValue":"30000","rule":""}', to_date('28-11-2020 11:25:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:25:56', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('22', '12', 'fallbackUri', 'fallbackUri', 2, 2, 2, null, to_date('28-11-2020 11:26:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:26:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('23', '12', 'slidingWindowSize', 'slidingWindowSize', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}', to_date('28-11-2020 11:27:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:27:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('24', '12', 'slidingWindowType', 'slidingWindowType', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}', to_date('28-11-2020 11:28:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:28:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('25', '12', 'minimumNumberOfCalls', 'minimumNumberOfCalls', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}', to_date('28-11-2020 11:28:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:28:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('26', '12', 'waitIntervalFunctionInOpenState', 'waitIntervalInOpen', 1, 2, 2, '{"required":"1","defaultValue":"60000","rule":""}', to_date('28-11-2020 11:29:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:29:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('27', '12', 'permittedNumberOfCallsInHalfOpenState', 'bufferSizeInHalfOpen', 1, 2, 2, '{"required":"1","defaultValue":"10","rule":""}', to_date('28-11-2020 11:29:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:29:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('28', '12', 'failureRateThreshold', 'failureRateThreshold', 1, 2, 2, '{"required":"1","defaultValue":"50","rule":""}', to_date('28-11-2020 11:30:40', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-11-2020 11:30:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('3', '10', 'flowRuleEnable', 'flowRuleEnable (1 or 0)', 1, 2, 7, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('30', '4', 'mode', 'mode', 3, 3, 1, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('31', '4', 'master', 'master', 2, 3, 2, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('32', '4', 'url', 'url', 2, 3, 3, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('33', '4', 'password', 'password', 2, 3, 4, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('34', '11', 'protocol', 'protocol', 2, 3, 1, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('35', '11', 'register', 'register', 2, 3, 2, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('36', '2', 'model', 'model', 2, 3, 1, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('37', '6', 'register', 'register', 2, 3, 1, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('38', '7', 'metricsName', 'metricsName', 2, 3, 1, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('39', '7', 'host', 'host', 2, 3, 2, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('4', '10', 'flowRuleCount', 'flowRuleCount', 1, 2, 6, '{"required":"1","defaultValue":"0","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('40', '7', 'port', 'port', 2, 3, 3, '{"rule":"/^[0-9]*$/"}', to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('41', '7', 'async', 'async', 2, 3, 4, null, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('42', '16', 'redirectURI', 'redirectURI', 2, 2, 1, null, to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-11-2020 16:07:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('43', '4', 'algorithmName', 'algorithmName', 3, 2, 1, '{"required":"1","defaultValue":"slidingWindow","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('44', '5', 'upstreamHost', 'host', 2, 1, 0, null, to_date('06-03-2021 21:23:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('45', '5', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":""","placeholder":"http://","rule":""}', to_date('06-03-2021 21:25:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('46', '5', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":""","rule":""}', to_date('06-03-2021 21:25:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('47', '5', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', to_date('06-03-2021 21:26:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('48', '5', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', to_date('06-03-2021 21:27:11', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('49', '5', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}', to_date('06-03-2021 21:27:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('5', '10', 'degradeRuleEnable', 'degradeRuleEnable (1 or 0)', 1, 2, 2, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('50', '5', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', to_date('06-03-2021 21:29:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('51', '5', 'loadBalance', 'loadStrategy', 3, 2, 0, null, to_date('06-03-2021 21:30:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('52', '5', 'retry', 'retryCount', 1, 2, 1, null, to_date('06-03-2021 21:31:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('53', '5', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', to_date('07-03-2021 21:13:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('54', '5', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null, to_date('08-03-2021 13:18:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('55', '5', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null, to_date('08-03-2021 13:37:12', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('56', '13', 'upstreamHost', 'host', 2, 1, 0, null, to_date('06-03-2021 21:23:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('57', '13', 'protocol', 'protocol', 2, 1, 2, '{"defaultValue":""","rule":""}', to_date('06-03-2021 21:25:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('58', '13', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":""","rule":""}', to_date('06-03-2021 21:25:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('59', '13', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', to_date('06-03-2021 21:26:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('6', '10', 'degradeRuleGrade', 'degradeRuleGrade', 3, 2, 3, '{"required":"1","defaultValue":"0","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('60', '13', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', to_date('06-03-2021 21:27:11', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('61', '13', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}', to_date('06-03-2021 21:27:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('62', '13', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', to_date('06-03-2021 21:29:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('63', '13', 'loadBalance', 'loadStrategy', 3, 2, 0, null, to_date('06-03-2021 21:30:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('64', '13', 'retry', 'retryCount', 1, 2, 1, null, to_date('06-03-2021 21:31:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('65', '13', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', to_date('07-03-2021 21:13:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('66', '13', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null, to_date('08-03-2021 13:18:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('67', '13', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null, to_date('08-03-2021 13:37:12', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('7', '10', 'degradeRuleCount', 'degradeRuleCount', 1, 2, 1, '{"required":"1","defaultValue":"0","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('70', '15', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":""","rule":""}', to_date('06-03-2021 21:25:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('71', '15', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', to_date('06-03-2021 21:26:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('74', '15', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', to_date('06-03-2021 21:29:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('78', '15', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null, to_date('08-03-2021 13:18:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('79', '15', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null, to_date('08-03-2021 13:37:12', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-03-2021 10:32:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('8', '10', 'degradeRuleTimeWindow', 'degradeRuleTimeWindow', 1, 2, 4, '{"required":"1","defaultValue":"0","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('80', '5', 'headerMaxSize', 'headerMaxSize', 1, 2, 3, '{"defaultValue":"10240","rule":""}', to_date('29-04-2021 12:28:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 12:28:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('81', '5', 'requestMaxSize', 'requestMaxSize', 1, 2, 4, '{"defaultValue":"102400","rule":""}', to_date('29-04-2021 14:24:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 14:24:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('82', '4', 'keyResolverName', 'keyResolverName', 3, 2, 4, '{"required":"1","defaultValue":"WHOLE_KEY_RESOLVER","rule":""}', to_date('12-06-2021 19:17:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('12-06-2021 19:17:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('83', '10', 'degradeRuleMinRequestAmount', 'degradeRuleMinRequestAmount', 1, 2, 3, '{"required":"1","defaultValue":"5","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('84', '10', 'getDegradeRuleStatIntervals', 'getDegradeRuleStatIntervals', 1, 2, 3, '{"required":"1","defaultValue":"1","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('85', '10', 'degradeRuleSlowRatioThreshold', 'degradeRuleSlowRatioThreshold', 1, 2, 3, '{"required":"1","defaultValue":"0.5","rule":""}', to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('86', '20', 'ruleHandlePageType', 'ruleHandlePageType', 3, 3, 0, '{"required":"0","rule":""}', to_date('27-05-2021 23:43:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 19:58:28', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('88', '10', 'fallbackUri', 'fallbackUri', 2, 2, 9, '{"required":"0","rule":""}', to_date('07-07-2021 21:24:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('07-07-2021 21:35:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('89', '19', 'secretKey', 'secretKey', 2, 3, 0, null, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('9', '2', 'permission', 'permission', 3, 2, 1, null, to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('90', '19', 'filterPath', 'filterPath', 2, 3, 1, null, to_date('12-06-2021 19:17:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('12-06-2021 19:17:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.PLUGIN_HANDLE (id, plugin_id, field, label, data_type, type, sort, ext_obj, date_created, date_updated)
values ('99', '12', 'automaticTransitionFromOpenToHalfOpenEnabled', 'automaticHalfOpen', 3, 2, 1, '{"required":"1","defaultValue":"true","rule":""}', to_date('18-07-2021 22:52:20', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-07-2021 22:59:57', 'dd-mm-yyyy hh24:mi:ss'));
commit;





insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100190894505984', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jSelector:edit', 1, to_date('15-01-2021 23:19:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100193801158656', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jRule:edit', 1, to_date('15-01-2021 23:19:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100229360467968', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsSelector:edit', 1, to_date('15-01-2021 23:19:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100232451670016', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsRule:edit', 1, to_date('15-01-2021 23:19:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100269307019264', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathSelector:edit', 1, to_date('15-01-2021 23:19:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100272083648512', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathRule:edit', 1, to_date('15-01-2021 23:19:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100334205485056', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaSelector:edit', 1, to_date('15-01-2021 23:19:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795968', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaRule:edit', 1, to_date('15-01-2021 23:19:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795969', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcSelector:add', 1, to_date('07-01-2021 13:33:07', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795970', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcSelector:delete', 1, to_date('07-01-2021 13:33:08', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795971', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcRule:add', 1, to_date('07-01-2021 13:33:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795972', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcRule:delete', 1, to_date('07-01-2021 13:33:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795973', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:grpc:modify', 1, to_date('07-01-2021 13:33:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795974', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcSelector:edit', 1, to_date('15-01-2021 23:19:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100337363795975', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcRule:edit', 1, to_date('15-01-2021 23:19:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350106119681622016', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.ROLE', 'role', '/system/role', 'role', 1, 1, 'usergroup-add', 0, 0, null, 1, to_date('15-01-2021 23:42:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350107709494804480', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:role:add', 1, to_date('15-01-2021 23:48:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350107842236137472', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:role:list', 1, to_date('15-01-2021 23:49:28', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350112406754766848', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:role:delete', 1, to_date('16-01-2021 00:07:36', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350112481253994496', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:role:edit', 1, to_date('16-01-2021 00:07:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350804501819195392', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.EDITRESOURCEDETAILS', null, null, null, 2, 2, null, 1, 0, 'system:authen:editResourceDetails', 1, to_date('17-01-2021 21:57:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1355163372527050752', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.RESOURCE', 'resource', '/system/resource', 'resource', 1, 1, 'menu', 0, 0, null, 1, to_date('29-01-2021 22:38:20', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1355165158419750912', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.MENU.ADD', null, null, null, 2, 2, null, 1, 0, 'system:resource:addMenu', 1, to_date('29-01-2021 22:45:26', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1355165353534578688', '1355163372527050752', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:resource:list', 1, to_date('29-01-2021 22:46:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1355165475785957376', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.MENU.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:resource:deleteMenu', 1, to_date('29-01-2021 22:46:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('06-02-2021 16:59:02', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1355165608565039104', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.MENU.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:resource:editMenu', 1, to_date('29-01-2021 22:47:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1357956838021890048', null, 'SHENYU.MENU.CONFIG.MANAGMENT', 'config', '/config', 'config', 0, 0, 'api', 0, 0, null, 1, to_date('06-02-2021 15:38:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1357977745889132544', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.BUTTON.ADD', null, null, null, 2, 2, null, 1, 0, 'system:resource:addButton', 1, to_date('06-02-2021 17:01:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1357977912126177280', '1355163372527050752', 'SHENYU.SYSTEM.EDITOR', null, null, null, 2, 2, null, 1, 0, 'system:resource:editButton', 1, to_date('06-02-2021 17:02:19', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1357977971827900416', '1355163372527050752', 'SHENYU.SYSTEM.DELETEDATA', null, null, null, 2, 2, null, 1, 0, 'system:resource:deleteButton', 1, to_date('06-02-2021 17:02:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1386680049203195904', '1346777157943259136', 'SHENYU.BUTTON.DATA.PERMISSION.CONFIG', null, null, null, 2, 2, null, 1, 0, 'system:manager:configureDataPermission', 1, to_date('26-04-2021 21:54:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642195797528576', '1346775491550474240', 'logging', 'logging', '/plug/logging', 'logging', 1, 1, 'block', 0, 0, null, 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642195982077952', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingSelector:add', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642196145655808', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingSelector:delete', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642196409896960', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingSelector:edit', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642196598640640', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingRule:add', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642197181648896', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingRule:delete', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642197538164736', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingRule:edit', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1387642197689159680', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:logging:modify', 1, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390305479231000576', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:divideSelector:query', 1, to_date('06-05-2021 22:00:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390305641097580544', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:divideRule:query', 1, to_date('06-05-2021 22:01:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309613569036001', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtSelector:query', 1, to_date('06-05-2021 22:16:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309613569036288', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingSelector:query', 1, to_date('06-05-2021 22:16:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309729176637002', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtRule:query', 1, to_date('06-05-2021 22:17:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309729176637440', '1387642195797528576', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:loggingRule:query', 1, to_date('06-05-2021 22:17:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309914883641344', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixSelector:query', 1, to_date('06-05-2021 22:18:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309936706605056', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteSelector:query', 1, to_date('06-05-2021 22:18:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309954016497664', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudSelector:query', 1, to_date('06-05-2021 22:18:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309981166227456', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaSelector:query', 1, to_date('06-05-2021 22:18:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390309998543228928', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:motanSelector:query', 1, to_date('06-05-2021 22:18:29', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310018877214720', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:signSelector:query', 1, to_date('06-05-2021 22:18:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310036459737088', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:wafSelector:query', 1, to_date('06-05-2021 22:18:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310053543137280', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterSelector:query', 1, to_date('06-05-2021 22:18:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310073772265472', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboSelector:query', 1, to_date('06-05-2021 22:18:47', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310094571819008', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorSelector:query', 1, to_date('06-05-2021 22:18:52', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310112892538880', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelSelector:query', 1, to_date('06-05-2021 22:18:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310128516321280', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jSelector:query', 1, to_date('06-05-2021 22:19:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310145079627776', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsSelector:query', 1, to_date('06-05-2021 22:19:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310166948728832', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathSelector:query', 1, to_date('06-05-2021 22:19:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310188486479872', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcSelector:query', 1, to_date('06-05-2021 22:19:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310205808955392', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectSelector:query', 1, to_date('06-05-2021 22:19:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310247684886528', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixRule:query', 1, to_date('06-05-2021 22:19:28', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310264424353792', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteRule:query', 1, to_date('06-05-2021 22:19:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310282875097088', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudRule:query', 1, to_date('06-05-2021 22:19:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310298985418752', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaRule:query', 1, to_date('06-05-2021 22:19:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310354216013824', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:motanRule:query', 1, to_date('06-05-2021 22:19:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310376865255424', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:signRule:query', 1, to_date('06-05-2021 22:19:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310406321852416', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:wafRule:query', 1, to_date('06-05-2021 22:20:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310423401058304', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterRule:query', 1, to_date('06-05-2021 22:20:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310441755332608', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboRule:query', 1, to_date('06-05-2021 22:20:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310459904086016', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorRule:query', 1, to_date('06-05-2021 22:20:19', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310476815519744', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelRule:query', 1, to_date('06-05-2021 22:20:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310492686766080', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jRule:query', 1, to_date('06-05-2021 22:20:27', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310509401067520', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsRule:query', 1, to_date('06-05-2021 22:20:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310527348494336', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathRule:query', 1, to_date('06-05-2021 22:20:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310544494809088', '1347028169120821249', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:grpcRule:query', 1, to_date('06-05-2021 22:20:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1390310562312212480', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectRule:query', 1, to_date('06-05-2021 22:20:43', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768158126080', '1346775491550474240', 'request', 'request', '/plug/request', 'request', 1, 1, 'thunderbolt', 0, 0, null, 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768204263112', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtSelector:add', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768204263121', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Selector:add', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768204263424', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:requestSelector:add', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768216846113', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtSelector:delete', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768216846122', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Selector:delete', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768216846336', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:requestSelector:delete', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768225234114', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtSelector:edit', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768225234123', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Selector:edit', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768225234944', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:requestSelector:edit', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768233623115', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtSelector:query', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768233623124', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Selector:query', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768233623552', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:requestSelector:query', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768246206116', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtRule:add', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768246206125', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Rule:add', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768246206464', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:requestRule:add', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768275566117', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtRule:delete', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768275566126', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Rule:delete', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768275566592', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:requestRule:delete', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768283955118', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtRule:edit', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768283955127', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Rule:edit', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768283955200', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:requestRule:edit', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768292343119', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:jwtRule:query', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
commit;
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768292343128', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2Rule:query', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768292343808', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:requestRule:query', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768296538112', '1397547768158126080', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:request:modify', 1, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768296538120', '1347028169120821250', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:jwt:modify', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346775491550474240', null, 'SHENYU.MENU.PLUGIN.LIST', 'plug', '/plug', 'PluginList', 0, 0, 'dashboard', 0, 0, null, 1, to_date('06-01-2021 05:07:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('07-01-2021 18:34:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346776175553376256', null, 'SHENYU.MENU.SYSTEM.MANAGMENT', 'system', '/system', 'system', 0, 0, 'setting', 0, 0, null, 1, to_date('06-01-2021 05:10:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346777157943259136', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.USER', 'manage', '/system/manage', 'manage', 1, 1, 'user', 0, 0, null, 1, to_date('06-01-2021 05:14:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('15-01-2021 23:46:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346777449787125760', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.PLUGIN', 'plugin', '/config/plugin', 'plugin', 1, 1, 'book', 0, 0, null, 1, to_date('06-01-2021 05:15:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346777623011880960', '1357956838021890048', 'SHENYU.PLUGIN.PLUGINHANDLE', 'pluginhandle', '/config/pluginhandle', 'pluginhandle', 1, 1, 'down-square', 0, 0, null, 1, to_date('06-01-2021 05:16:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346777766301888512', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.AUTHEN', 'auth', '/config/auth', 'auth', 1, 1, 'audit', 0, 0, null, 1, to_date('06-01-2021 05:16:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346777907096285184', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.METADATA', 'metadata', '/config/metadata', 'metadata', 1, 1, 'snippets', 0, 0, null, 1, to_date('06-01-2021 05:17:30', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1346778036402483200', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.DICTIONARY', 'dict', '/config/dict', 'dict', 1, 1, 'ordered-list', 0, 0, null, 1, to_date('06-01-2021 05:18:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347026381504262144', '1346775491550474240', 'divide', 'divide', '/plug/divide', 'divide', 1, 1, 'border-bottom', 0, 0, null, 1, to_date('06-01-2021 21:44:51', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347026805170909184', '1346775491550474240', 'hystrix', 'hystrix', '/plug/hystrix', 'hystrix', 1, 1, 'stop', 0, 0, null, 1, to_date('06-01-2021 21:46:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('07-01-2021 11:46:31', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027413357572096', '1346775491550474240', 'rewrite', 'rewrite', '/plug/rewrite', 'rewrite', 1, 1, 'redo', 0, 0, null, 1, to_date('06-01-2021 21:48:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027413357572097', '1346775491550474240', 'redirect', 'redirect', '/plug/redirect', 'redirect', 1, 1, 'redo', 0, 0, null, 1, to_date('06-01-2021 21:48:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027482244820992', '1346775491550474240', 'springCloud', 'springCloud', '/plug/springCloud', 'springCloud', 1, 1, 'ant-cloud', 0, 0, null, 1, to_date('06-01-2021 21:49:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027526339538944', '1346775491550474240', 'sign', 'sign', '/plug/sign', 'sign', 1, 1, 'highlight', 0, 0, null, 1, to_date('06-01-2021 21:49:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027566034432000', '1346775491550474240', 'waf', 'waf', '/plug/waf', 'waf', 1, 1, 'database', 0, 0, null, 1, to_date('06-01-2021 21:49:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027647999520768', '1346775491550474240', 'rate_limiter', 'rate_limiter', '/plug/rate_limiter', 'rate_limiter', 1, 1, 'pause', 0, 0, null, 1, to_date('06-01-2021 21:49:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027717792739328', '1346775491550474240', 'dubbo', 'dubbo', '/plug/dubbo', 'dubbo', 1, 1, 'align-left', 0, 0, null, 1, to_date('06-01-2021 21:50:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027769747582976', '1346775491550474240', 'monitor', 'monitor', '/plug/monitor', 'monitor', 1, 1, 'camera', 0, 0, null, 1, to_date('06-01-2021 21:50:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027830602739712', '1346775491550474240', 'sentinel', 'sentinel', '/plug/sentinel', 'sentinel', 1, 1, 'pic-center', 0, 0, null, 1, to_date('06-01-2021 21:50:36', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027918121086976', '1346775491550474240', 'resilience4j', 'resilience4j', '/plug/resilience4j', 'resilience4j', 1, 1, 'pic-left', 0, 0, null, 1, to_date('06-01-2021 21:50:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347027995199811584', '1346775491550474240', 'tars', 'tars', '/plug/tars', 'tars', 1, 1, 'border-bottom', 0, 0, null, 1, to_date('06-01-2021 21:51:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347028169120821248', '1346775491550474240', 'context_path', 'context_path', '/plug/context_path', 'context_path', 1, 1, 'retweet', 0, 0, null, 1, to_date('06-01-2021 21:51:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347028169120821249', '1346775491550474240', 'grpc', 'grpc', '/plug/grpc', 'grpc', 1, 1, 'retweet', 0, 0, null, 1, to_date('06-01-2021 21:51:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347028169120821250', '1346775491550474240', 'jwt', 'jwt', '/plug/jwt', 'jwt', 1, 1, 'key', 0, 0, null, 1, to_date('18-06-2021 21:00:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347028169120821251', '1346775491550474240', 'oauth2', 'oauth2', '/plug/oauth2', 'oauth2', 1, 1, 'safety', 0, 0, null, 1, to_date('18-06-2021 21:00:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347032308726902784', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:manager:add', 1, to_date('06-01-2021 22:08:24', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347032395901317120', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:manager:list', 1, to_date('06-01-2021 22:08:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347032453707214848', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:manager:delete', 1, to_date('06-01-2021 22:08:58', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347032509051056128', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:manager:edit', 1, to_date('06-01-2021 22:09:11', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347034027070337024', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:plugin:list', 1, to_date('06-01-2021 22:15:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347039054925148160', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:plugin:delete', 1, to_date('06-01-2021 22:34:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347041326749691904', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:plugin:add', 1, to_date('06-01-2021 22:44:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347046566244003840', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'system:plugin:modify', 1, to_date('07-01-2021 13:05:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347047143350874112', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.ENABLE', null, null, null, 2, 2, null, 1, 0, 'system:plugin:disable', 1, to_date('07-01-2021 13:07:21', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347047203220369408', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:plugin:edit', 1, to_date('07-01-2021 13:07:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347047555588042752', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:pluginHandler:list', 1, to_date('07-01-2021 13:08:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347047640145211392', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:pluginHandler:delete', 1, to_date('07-01-2021 13:09:19', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347047695002513408', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:pluginHandler:add', 1, to_date('07-01-2021 13:09:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347047747305484288', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:pluginHandler:edit', 1, to_date('07-01-2021 13:09:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048004105940992', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:authen:list', 1, to_date('07-01-2021 13:10:46', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048101875167232', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:authen:delete', 1, to_date('07-01-2021 13:11:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048145877610496', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:authen:add', 1, to_date('07-01-2021 13:11:20', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048240677269504', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.ENABLE', null, null, null, 2, 2, null, 1, 0, 'system:authen:disable', 1, to_date('07-01-2021 13:11:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048316216684544', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'system:authen:modify', 1, to_date('07-01-2021 13:12:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048776029843456', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:authen:edit', 1, to_date('07-01-2021 13:13:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347048968414179328', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:meta:list', 1, to_date('07-01-2021 13:14:36', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049029323862016', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:meta:delete', 1, to_date('07-01-2021 13:14:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049092552994816', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:meta:add', 1, to_date('07-01-2021 13:15:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049251395481600', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.ENABLE', null, null, null, 2, 2, null, 1, 0, 'system:meta:disable', 1, to_date('07-01-2021 13:15:43', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049317178945536', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'system:meta:modify', 1, to_date('07-01-2021 13:15:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049370014593024', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:meta:edit', 1, to_date('07-01-2021 13:16:11', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049542417264640', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.LIST', null, null, null, 2, 2, null, 1, 0, 'system:dict:list', 1, to_date('07-01-2021 13:16:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049598155370496', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.DELETE', null, null, null, 2, 2, null, 1, 0, 'system:dict:delete', 1, to_date('07-01-2021 13:17:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049659023110144', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.ADD', null, null, null, 2, 2, null, 1, 0, 'system:dict:add', 1, to_date('07-01-2021 13:17:20', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:21:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049731047698432', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.ENABLE', null, null, null, 2, 2, null, 1, 0, 'system:dict:disable', 1, to_date('07-01-2021 13:17:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347049794008395776', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.EDIT', null, null, null, 2, 2, null, 1, 0, 'system:dict:edit', 1, to_date('07-01-2021 13:17:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347050493052071936', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:divideSelector:add', 1, to_date('07-01-2021 13:20:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347050998931271680', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:divideSelector:delete', 1, to_date('07-01-2021 13:22:40', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051241320099840', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:divideRule:add', 1, to_date('07-01-2021 13:23:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051306788990976', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:divideRule:delete', 1, to_date('07-01-2021 13:23:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051641725136896', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:divide:modify', 1, to_date('07-01-2021 13:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051850521784320', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixSelector:add', 1, to_date('07-01-2021 13:26:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051853025783808', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixSelector:delete', 1, to_date('07-01-2021 13:26:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051855538171904', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixRule:add', 1, to_date('07-01-2021 13:26:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051857962479616', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixRule:delete', 1, to_date('07-01-2021 13:26:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347051860495839232', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrix:modify', 1, to_date('07-01-2021 13:26:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052833968631808', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteSelector:add', 1, to_date('07-01-2021 13:29:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052833968631809', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectSelector:add', 1, to_date('07-01-2021 13:29:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052836300664832', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteSelector:delete', 1, to_date('07-01-2021 13:29:58', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052836300664833', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectSelector:delete', 1, to_date('07-01-2021 13:29:58', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052839198928896', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteRule:add', 1, to_date('07-01-2021 13:29:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052839198928897', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectRule:add', 1, to_date('07-01-2021 13:29:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052841824563200', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteRule:delete', 1, to_date('07-01-2021 13:29:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052841824563201', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectRule:delete', 1, to_date('07-01-2021 13:29:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052843993018368', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:rewrite:modify', 1, to_date('07-01-2021 13:30:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347052843993018369', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:redirect:modify', 1, to_date('07-01-2021 13:30:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053324018528256', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudSelector:add', 1, to_date('07-01-2021 13:31:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053326988095488', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudSelector:delete', 1, to_date('07-01-2021 13:31:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053329378848768', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudRule:add', 1, to_date('07-01-2021 13:31:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053331744436224', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudRule:delete', 1, to_date('07-01-2021 13:31:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053334470733824', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloud:modify', 1, to_date('07-01-2021 13:31:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053363814084608', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:signSelector:add', 1, to_date('07-01-2021 13:32:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053366552965120', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:signSelector:delete', 1, to_date('07-01-2021 13:32:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053369413480448', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:signRule:add', 1, to_date('07-01-2021 13:32:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053372164943872', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:signRule:delete', 1, to_date('07-01-2021 13:32:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053375029653504', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:sign:modify', 1, to_date('07-01-2021 13:32:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053404050042880', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:wafSelector:add', 1, to_date('07-01-2021 13:32:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053406939918336', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:wafSelector:delete', 1, to_date('07-01-2021 13:32:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053409842376704', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:wafRule:add', 1, to_date('07-01-2021 13:32:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053413067796480', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:wafRule:delete', 1, to_date('07-01-2021 13:32:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053415945089024', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:waf:modify', 1, to_date('07-01-2021 13:32:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053442419535872', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterSelector:add', 1, to_date('07-01-2021 13:32:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053445191970816', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterSelector:delete', 1, to_date('07-01-2021 13:32:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053447695970304', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterRule:add', 1, to_date('07-01-2021 13:32:24', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053450304827392', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterRule:delete', 1, to_date('07-01-2021 13:32:24', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053452737523712', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiter:modify', 1, to_date('07-01-2021 13:32:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
commit;
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053477844627456', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboSelector:add', 1, to_date('07-01-2021 13:32:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053480977772544', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboSelector:delete', 1, to_date('07-01-2021 13:32:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:47:02', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053483712458752', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboRule:add', 1, to_date('07-01-2021 13:32:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053486426173440', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboRule:delete', 1, to_date('07-01-2021 13:32:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053489571901440', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:dubbo:modify', 1, to_date('07-01-2021 13:32:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053516423835648', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorSelector:add', 1, to_date('07-01-2021 13:32:40', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053519401791488', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorSelector:delete', 1, to_date('07-01-2021 13:32:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053522182615040', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorRule:add', 1, to_date('07-01-2021 13:32:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053525034741760', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorRule:delete', 1, to_date('07-01-2021 13:32:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053527819759616', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:monitor:modify', 1, to_date('07-01-2021 13:32:43', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053554310983680', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelSelector:add', 1, to_date('07-01-2021 13:32:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053556512993280', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelSelector:delete', 1, to_date('07-01-2021 13:32:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053559050547200', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelRule:add', 1, to_date('07-01-2021 13:32:50', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053561579712512', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelRule:delete', 1, to_date('07-01-2021 13:32:51', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053564016603136', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinel:modify', 1, to_date('07-01-2021 13:32:51', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053595729735680', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jSelector:add', 1, to_date('07-01-2021 13:32:59', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053598829326336', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jSelector:delete', 1, to_date('07-01-2021 13:33:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053601572401152', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jRule:add', 1, to_date('07-01-2021 13:33:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053604093177856', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4jRule:delete', 1, to_date('07-01-2021 13:33:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053606622343168', '1347027918121086976', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:resilience4j:modify', 1, to_date('07-01-2021 13:33:02', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053631159021568', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsSelector:add', 1, to_date('07-01-2021 13:33:07', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053633809821696', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsSelector:delete', 1, to_date('07-01-2021 13:33:08', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053636439650304', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsRule:add', 1, to_date('07-01-2021 13:33:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053638968815616', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:tarsRule:delete', 1, to_date('07-01-2021 13:33:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053641346985984', '1347027995199811584', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:tars:modify', 1, to_date('07-01-2021 13:33:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053666227597312', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathSelector:add', 1, to_date('07-01-2021 13:33:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053668538658816', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathSelector:delete', 1, to_date('07-01-2021 13:33:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053670791000064', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathRule:add', 1, to_date('07-01-2021 13:33:17', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053673043341312', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:context_pathRule:delete', 1, to_date('07-01-2021 13:33:17', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347053675174047744', '1347028169120821248', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:context_path:modify', 1, to_date('07-01-2021 13:33:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347063567603609600', '1346775491550474240', 'sofa', 'sofa', '/plug/sofa', 'sofa', 1, 1, 'fire', 0, 0, null, 1, to_date('07-01-2021 14:12:36', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347064011369361408', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaSelector:add', 1, to_date('07-01-2021 14:14:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347064013848195072', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaSelector:delete', 1, to_date('07-01-2021 14:14:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347064016373166080', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaRule:add', 1, to_date('07-01-2021 14:14:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347064019007188992', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:sofaRule:delete', 1, to_date('07-01-2021 14:14:24', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1347064021486022656', '1347063567603609600', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:sofa:modify', 1, to_date('07-01-2021 14:14:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350096617689751552', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:divideSelector:edit', 1, to_date('15-01-2021 23:04:52', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350096630197166080', '1347026381504262144', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:divideRule:edit', 1, to_date('15-01-2021 23:04:55', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350098233939632128', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixSelector:edit', 1, to_date('15-01-2021 23:11:17', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350098236741427200', '1347026805170909184', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:hystrixRule:edit', 1, to_date('15-01-2021 23:11:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099831950163968', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteSelector:edit', 1, to_date('15-01-2021 23:17:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099831950163969', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectSelector:edit', 1, to_date('15-01-2021 23:17:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595200', '1347027413357572096', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:rewriteRule:edit', 1, to_date('15-01-2021 23:17:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595201', '1347027413357572097', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:redirectRule:edit', 1, to_date('15-01-2021 23:17:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595202', '1346775491550474240', 'motan', 'motan', '/plug/motan', 'motan', 1, 1, 'fire', 0, 0, null, 1, to_date('07-01-2021 14:12:36', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595203', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:motanSelector:add', 1, to_date('07-01-2021 14:14:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595204', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:motanSelector:delete', 1, to_date('07-01-2021 14:14:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595205', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:motanRule:add', 1, to_date('07-01-2021 14:14:23', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-01-2021 11:46:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595206', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:motanRule:delete', 1, to_date('07-01-2021 14:14:24', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595207', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:motan:modify', 1, to_date('07-01-2021 14:14:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595208', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:motanSelector:edit', 1, to_date('15-01-2021 23:19:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099836492595209', '1350099836492595202', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:motanRule:edit', 1, to_date('15-01-2021 23:19:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099893203779584', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudSelector:edit', 1, to_date('15-01-2021 23:17:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099896441782272', '1347027482244820992', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:springCloudRule:edit', 1, to_date('15-01-2021 23:17:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099936379944960', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:signSelector:edit', 1, to_date('15-01-2021 23:18:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099939177545728', '1347027526339538944', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:signRule:edit', 1, to_date('15-01-2021 23:18:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099976435548160', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:wafSelector:edit', 1, to_date('15-01-2021 23:18:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350099979434475520', '1347027566034432000', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:wafRule:edit', 1, to_date('15-01-2021 23:18:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100013341229056', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterSelector:edit', 1, to_date('15-01-2021 23:18:21', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100016319184896', '1347027647999520768', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:rate_limiterRule:edit', 1, to_date('15-01-2021 23:18:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100053757542400', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboSelector:edit', 1, to_date('15-01-2021 23:18:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100056525783040', '1347027717792739328', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:dubboRule:edit', 1, to_date('15-01-2021 23:18:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100110510669824', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorSelector:edit', 1, to_date('15-01-2021 23:18:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100113283104768', '1347027769747582976', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:monitorRule:edit', 1, to_date('15-01-2021 23:18:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100147437322240', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelSelector:edit', 1, to_date('15-01-2021 23:18:53', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1350100150096510976', '1347027830602739712', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:sentinelRule:edit', 1, to_date('15-01-2021 23:18:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1397547768296538129', '1347028169120821251', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:oauth2:modify', 1, to_date('18-06-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252528254976', '1346775491550474240', 'modifyResponse', 'modifyResponse', '/plug/modifyResponse', 'modifyResponse', 1, 1, 'block', 0, 0, null, 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252566003712', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseSelector:add', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252582780928', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseSelector:delete', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252591169536', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseSelector:edit', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252603752448', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseSelector:query', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252620529664', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseRule:add', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252645695488', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseRule:delete', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252658278400', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseRule:edit', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252666667008', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponseRule:query', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1398994252679249920', '1398994252528254976', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:modifyResponse:modify', 1, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534378660888576', '1346775491550474240', 'param_mapping', 'param_mapping', '/plug/param_mapping', 'param_mapping', 1, 1, 'block', 0, 0, null, 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534378971267072', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingSelector:add', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379000627200', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingSelector:delete', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379046764544', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingSelector:edit', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379071930368', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingSelector:query', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379092901888', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingRule:add', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379122262016', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingRule:delete', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379139039232', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingRule:edit', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379164205056', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mappingRule:query', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1405534379185176576', '1405534378660888576', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:param_mapping:modify', 1, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771386310656', '1346775491550474240', 'websocket', 'websocket', '/plug/websocket', 'websocket', 1, 1, 'block', 0, 0, null, 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771419865088', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketSelector:add', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771440836608', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketSelector:delete', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771457613824', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketSelector:edit', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771470196736', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketSelector:query', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771486973952', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketRule:add', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771516334080', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketRule:delete', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771528916992', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketRule:edit', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771545694208', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:websocketRule:query', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431217771558277120', '1431217771386310656', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:websocket:modify', 1, to_date('27-08-2021 19:31:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270939172864', '1346775491550474240', 'cryptor_request', 'cryptor_request', '/plug/cryptor_request', 'cryptor_request', 1, 1, 'block', 0, 0, null, 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270947561472', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestSelector:add', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270955950080', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestSelector:delete', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
commit;
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270968532992', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestSelector:edit', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270972727296', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestSelector:query', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270981115904', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestRule:add', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270989504512', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestRule:delete', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222270997893120', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestRule:edit', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222271002087424', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_requestRule:query', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222271006281728', '1431222270939172864', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_request:modify', 1, to_date('27-08-2021 19:49:15', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367693377537', '1346775491550474240', 'cryptor_response', 'cryptor_response', '/plug/cryptor_response', 'cryptor_response', 1, 1, 'block', 0, 0, null, 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367701766144', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseSelector:add', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367714349056', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseSelector:delete', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367722737664', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseSelector:edit', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367726931968', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseSelector:query', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367735320576', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseRule:add', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367743709184', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseRule:delete', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367752097792', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseRule:edit', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367760486400', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_responseRule:query', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1431222367768875008', '1431222367693377537', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', null, null, null, 2, 2, null, 1, 0, 'plugin:cryptor_response:modify', 1, to_date('27-08-2021 19:49:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434189567996579840', '1357956838021890048', '1', null, '1', null, 1, 1, null, 0, 0, null, 1, to_date('05-09-2021 00:20:14', 'dd-mm-yyyy hh24:mi:ss'), to_date('05-09-2021 00:20:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434189661223374848', '1347026381504262144', '4', null, null, null, 2, 2, null, 1, 0, '4', 1, to_date('05-09-2021 00:20:36', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434189675484008448', '1347026381504262144', '12', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 00:20:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434189701358669824', '1347026381504262144', '4141', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 00:20:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434201353576849408', '1347026381504262144', '1', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 01:07:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434201362141618176', '1347026381504262144', '1', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 01:07:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434201372031787008', '1347026381504262144', '1', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 01:07:08', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434201406085341184', '1347026381504262144', '123', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 01:07:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1434201414918545408', '1347026381504262144', '33', null, null, null, 2, 2, null, 1, 0, null, 1, to_date('05-09-2021 01:07:18', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu."RESOURCE" (id, parent_id, title, name, url, component, resource_type, sort, icon, is_leaf, is_route, perms, status, date_created, date_updated)
values ('1435595420728885248', '1347026381504262144', '123', null, null, null, 2, 2, null, 1, 0, '1', 1, to_date('08-09-2021 21:26:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-09-2021 02:36:54', 'dd-mm-yyyy hh24:mi:ss'));
commit;


insert into shenyu.ROLE (id, role_name, description, date_created, date_updated)
values ('1346358560427216896', 'super', '超级管理员', to_date('05-01-2021 01:31:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-01-2021 17:00:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.ROLE (id, role_name, description, date_created, date_updated)
values ('1385482862971723776', 'default', '普通用户', to_date('23-04-2021 14:37:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-04-2021 14:38:39', 'dd-mm-yyyy hh24:mi:ss'));
commit;

insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('1', 'degradeRuleGrade', 'DEGRADE_GRADE_RT', 'slow call ratio', '0', 'degrade type-slow call ratio', 1, 1, to_date('18-11-2020 14:39:56', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:43:43', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('10', 'permission', 'REJECT', 'reject', 'reject', 'reject', 0, 1, to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('11', 'permission', 'ALLOW', 'allow', 'allow', 'allow', 1, 1, to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('22-11-2020 12:04:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('12', 'mode', 'MODE', 'cluster', 'cluster', 'cluster', 0, 1, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('13', 'mode', 'MODE', 'sentinel', 'sentinel', 'sentinel', 1, 1, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('14', 'mode', 'MODE', 'standalone', 'standalone', 'standalone', 2, 1, to_date('25-12-2020', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('15', 'algorithmName', 'ALGORITHM_SLIDINGWINDOW', 'slidingWindow', 'slidingWindow', 'Sliding window algorithm', 0, 1, to_date('20-11-2020 15:42:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:42:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('16', 'algorithmName', 'ALGORITHM_LEAKYBUCKET', 'leakyBucket', 'leakyBucket', 'Leaky bucket algorithm', 1, 1, to_date('20-11-2020 15:44:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:44:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('17', 'algorithmName', 'ALGORITHM_CONCURRENT', 'concurrent', 'concurrent', 'Concurrent algorithm', 2, 1, to_date('20-11-2020 15:42:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:42:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('18', 'algorithmName', 'ALGORITHM_TOKENBUCKET', 'tokenBucket', 'tokenBucket', 'Token bucket algorithm', 3, 1, to_date('20-11-2020 15:44:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:44:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('19', 'loadBalance', 'LOAD_BALANCE', 'roundRobin', 'roundRobin', 'roundRobin', 2, 1, to_date('08-03-2021 19:11:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 19:11:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('2', 'degradeRuleGrade', 'DEGRADE_GRADE_EXCEPTION_RATIO', 'exception ratio', '1', 'degrade type-abnormal ratio', 0, 1, to_date('18-11-2020 16:42:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:42:58', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('20', 'loadBalance', 'LOAD_BALANCE', 'random', 'random', 'random', 1, 1, to_date('08-03-2021 19:10:17', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 19:10:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('21', 'loadBalance', 'LOAD_BALANCE', 'hash', 'hash', 'hash', 0, 1, to_date('08-03-2021 19:09:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 19:09:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('22', 'status', 'DIVIDE_STATUS', 'close', 'false', 'close', 1, 1, to_date('08-03-2021 14:21:58', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 14:21:58', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('23', 'status', 'DIVIDE_STATUS', 'open', 'true', 'open', 0, 1, to_date('08-03-2021 14:21:32', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 14:21:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('24', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'multiple rule', '1', 'multiple rule', 1, 1, to_date('08-03-2021 13:40:38', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 13:40:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('25', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'single rule', '0', 'single rule', 0, 1, to_date('08-03-2021 13:39:30', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 13:39:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('26', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'multiple handle', '1', 'multiple handle', 1, 1, to_date('08-03-2021 13:26:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 13:39:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('27', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'single handle', '0', 'single handle', 0, 1, to_date('08-03-2021 13:26:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('08-03-2021 13:27:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('3', 'degradeRuleGrade', 'DEGRADE_GRADE_EXCEPTION_COUNT', 'exception number strategy', '2', 'degrade type-abnormal number strategy', 2, 1, to_date('19-11-2020 16:23:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 16:01:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('30', 'matchMode', 'MATCH_MODE', 'and', '0', 'and', 0, 1, to_date('30-05-2021 19:29:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('31', 'matchMode', 'MATCH_MODE', 'or', '1', 'or', 1, 1, to_date('30-05-2021 19:29:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('32', 'operator', 'OPERATOR', 'match', 'match', 'match', 0, 1, to_date('30-05-2021 19:31:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('33', 'operator', 'OPERATOR', '=', '=', '=', 1, 1, to_date('30-05-2021 19:32:16', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('34', 'operator', 'OPERATOR', 'regex', 'regex', 'regex', 2, 1, to_date('30-05-2021 19:32:47', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('35', 'operator', 'OPERATOR', 'contains', 'contains', 'contains', 3, 1, to_date('30-05-2021 19:34:06', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('36', 'operator', 'OPERATOR', 'SpEL', 'SpEL', 'SpEL', 4, 1, to_date('30-05-2021 19:34:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('37', 'operator', 'OPERATOR', 'Groovy', 'Groovy', 'Groovy', 5, 1, to_date('30-05-2021 19:34:49', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('38', 'operator', 'OPERATOR', 'TimeBefore', 'TimeBefore', 'TimeBefore', 6, 1, to_date('30-05-2021 19:35:04', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('39', 'operator', 'OPERATOR', 'TimeAfter', 'TimeAfter', 'TimeAfter', 7, 1, to_date('30-05-2021 19:35:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('4', 'flowRuleGrade', 'FLOW_GRADE_QPS', 'QPS', '1', 'grade type-QPS', 0, 1, to_date('20-11-2020 15:42:03', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:42:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('40', 'paramType', 'PARAM_TYPE', 'post', 'post', 'post', 0, 1, to_date('30-05-2021 19:37:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('41', 'paramType', 'PARAM_TYPE', 'uri', 'uri', 'uri', 1, 1, to_date('30-05-2021 19:38:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('42', 'paramType', 'PARAM_TYPE', 'query', 'query', 'query', 2, 1, to_date('30-05-2021 19:38:26', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('43', 'paramType', 'PARAM_TYPE', 'host', 'host', 'host', 3, 1, to_date('30-05-2021 19:38:39', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('44', 'paramType', 'PARAM_TYPE', 'ip', 'ip', 'ip', 4, 1, to_date('30-05-2021 19:39:11', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('45', 'paramType', 'PARAM_TYPE', 'header', 'header', 'header', 5, 1, to_date('30-05-2021 19:39:29', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('46', 'paramType', 'PARAM_TYPE', 'cookie', 'cookie', 'cookie', 6, 1, to_date('30-05-2021 19:39:46', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('47', 'paramType', 'PARAM_TYPE', 'req_method', 'req_method', 'req_method', 7, 1, to_date('30-05-2021 19:40:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('48', 'keyResolverName', 'WHOLE_KEY_RESOLVER', 'whole', 'WHOLE_KEY_RESOLVER', 'Rate limit by all request', 0, 1, to_date('12-06-2021 19:28:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('12-06-2021 19:28:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('49', 'keyResolverName', 'REMOTE_ADDRESS_KEY_RESOLVER', 'remoteAddress', 'REMOTE_ADDRESS_KEY_RESOLVER', 'Rate limit by remote address', 1, 1, to_date('12-06-2021 19:28:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('12-06-2021 19:28:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('5', 'flowRuleGrade', 'FLOW_GRADE_THREAD', 'number of concurrent threads', '0', 'degrade type-number of concurrent threads', 1, 1, to_date('20-11-2020 15:44:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:44:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('50', 'automaticTransitionFromOpenToHalfOpenEnabled', 'AUTOMATIC_HALF_OPEN', 'open', 'true', null, 1, 1, to_date('18-07-2021 22:59:17', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-07-2021 22:59:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('51', 'automaticTransitionFromOpenToHalfOpenEnabled', 'AUTOMATIC_HALF_OPEN', 'close', 'false', null, 2, 1, to_date('18-07-2021 22:59:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-07-2021 22:59:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('52', 'paramType', 'PARAM_TYPE', 'domain', 'domain', 'domain', 8, 1, to_date('30-05-2021 19:40:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 20:15:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('53', 'strategyName', 'STRATEGY_NAME', 'rsa', 'rsa', 'rsa strategy', 1, 1, to_date('25-08-2021 11:47:29', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-08-2021 11:48:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('6', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_DEFAULT', 'direct rejection by default', '0', 'control behavior-direct rejection by default', 0, 1, to_date('20-11-2020 15:46:22', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:48:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('7', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_WARM_UP', 'warm up', '1', 'control behavior-warm up', 1, 1, to_date('20-11-2020 15:47:05', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:47:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('8', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_RATE_LIMITER', 'constant speed queuing', '2', 'control behavior-uniform speed queuing', 2, 1, to_date('20-11-2020 15:49:45', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:49:45', 'dd-mm-yyyy hh24:mi:ss'));
insert into shenyu.SHENYU_DICT (id, type, dict_code, dict_name, dict_value, "desc", sort, enabled, date_created, date_updated)
values ('9', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_WARM_UP_RATE_LIMITER', 'preheating uniformly queued', '3', 'control behavior-preheating uniformly queued', 3, 1, to_date('20-11-2020 15:51:25', 'dd-mm-yyyy hh24:mi:ss'), to_date('20-11-2020 15:51:37', 'dd-mm-yyyy hh24:mi:ss'));
commit;

insert into shenyu.USER_ROLE (id, user_id, role_id, date_created, date_updated)
values ('1351007709096976384', '1', '1346358560427216896', to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-01-2021 11:25:13', 'dd-mm-yyyy hh24:mi:ss'));
commit;


insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('1', 'sign', EMPTY_CLOB(), 'authentication', 7, 0, to_date('14-06-2018 10:17:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('14-06-2018 10:17:35', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('10', 'sentinel', EMPTY_CLOB(), 'fault tolerance', 12, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('11', 'sofa', '{"protocol":"zookeeper","register":"127.0.0.1:2181"}', 'rpc proxy', 18, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('12', 'resilience4j', EMPTY_CLOB(), 'fault tolerance', 13, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('13', 'tars', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', 'rpc proxy', 19, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('14', 'context_path', EMPTY_CLOB(), 'http process', 2, 1, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('15', 'grpc', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', 'rpc proxy', 20, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('16', 'redirect', EMPTY_CLOB(), 'http process', 3, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('17', 'motan', '{"register":"127.0.0.1:2181"}', 'rpc proxy', 21, 0, to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-11-2020 01:19:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('18', 'logging', EMPTY_CLOB(), 'logging', 14, 0, to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'), to_date('29-04-2021 13:37:35', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('19', 'jwt', '{"secretKey":"key","filterPath":""}', 'authentication', 9, 0, to_date('24-05-2021 17:58:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-05-2021 15:38:04', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('2', 'waf', '{"model":"black"}', 'authentication', 8, 0, to_date('23-06-2018 10:26:30', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-06-2018 15:43:10', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('20', 'request', EMPTY_CLOB(), 'http process', 4, 0, to_date('26-05-2021 21:38:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 19:55:22', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('21', 'oauth2', EMPTY_CLOB(), 'authentication', 10, 0, to_date('18-06-2021 10:53:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('18-06-2021 10:53:42', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('22', 'param_mapping', '{"ruleHandlePageType":"custom"}', 'http process', 5, 0, to_date('17-06-2021 22:34:44', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-06-2021 22:36:00', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('23', 'modifyResponse', '{"ruleHandlePageType":"custom"}', 'http process', 23, 0, to_date('30-05-2021 21:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('30-05-2021 23:26:11', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('24', 'cryptor_request', EMPTY_CLOB(), '1', 25, 1, to_date('06-08-2021 13:55:21', 'dd-mm-yyyy hh24:mi:ss'), to_date('17-08-2021 16:35:41', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('25', 'cryptor_response', EMPTY_CLOB(), '1', 26, 1, to_date('06-08-2021 13:55:30', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-08-2021 16:03:40', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('3', 'rewrite', EMPTY_CLOB(), 'http process', 6, 0, to_date('23-06-2018 10:26:34', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-06-2018 13:59:31', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('4', 'rate_limiter', '{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}', 'fault tolerance', 10, 0, to_date('23-06-2018 10:26:37', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-06-2018 15:34:48', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('5', 'divide', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', 'http process', 1, 1, to_date('25-06-2018 10:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('13-06-2018 13:56:04', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('6', 'dubbo', '{"register":"zookeeper://localhost:2181"}', 'rpc proxy', 16, 0, to_date('23-06-2018 10:26:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('11-06-2018 10:11:47', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('7', 'monitor', '{"metricsName":"prometheus","host":"localhost","port":"9190","async":"true"}', 'monitor', 15, 0, to_date('25-06-2018 13:47:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-06-2018 13:47:57', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('8', 'springCloud', EMPTY_CLOB(), 'rpc proxy', 17, 0, to_date('25-06-2018 13:47:57', 'dd-mm-yyyy hh24:mi:ss'), to_date('25-06-2018 13:47:57', 'dd-mm-yyyy hh24:mi:ss'));

insert into shenyu.PLUGIN (ID, NAME, CONFIG, ROLE, SORT, ENABLED, DATE_CREATED, DATE_UPDATED)
values ('9', 'hystrix', EMPTY_CLOB(), 'fault tolerance', 11, 0, to_date('15-01-2020 10:19:10', 'dd-mm-yyyy hh24:mi:ss'), to_date('15-01-2020 10:19:10', 'dd-mm-yyyy hh24:mi:ss'));

commit;

