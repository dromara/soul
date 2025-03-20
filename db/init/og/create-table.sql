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

-- ----------------------------
-- Sequence structure for operation_record_log_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."operation_record_log_id_seq";
CREATE SEQUENCE "public"."operation_record_log_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for plugin_handle_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."plugin_handle_id_seq";
CREATE SEQUENCE "public"."plugin_handle_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for shenyu_dict_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."shenyu_dict_id_seq";
CREATE SEQUENCE "public"."shenyu_dict_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;


-- ----------------------------
-- Table structure for api
-- ----------------------------
DROP TABLE IF EXISTS "public"."api";
CREATE TABLE "public"."api" (
  "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "context_path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "api_path"     varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "http_method" int4 NOT NULL,
  "consume"      varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "produce"      varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "version"      varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "rpc_type"     varchar(64) COLLATE "pg_catalog"."default"  NOT NULL,
  "state" int2 NOT NULL,
  "ext"          varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "api_owner"    varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "api_desc"     varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "api_source" int4 NOT NULL,
  "document"     text COLLATE "pg_catalog"."default"         NOT NULL,
  "document_md5" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now()):: timestamp (0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now()):: timestamp (0) without time zone)
)
;
COMMENT ON COLUMN "public"."api"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."api"."context_path" IS 'the context_path';
COMMENT ON COLUMN "public"."api"."api_path" IS 'the api_path';
COMMENT ON COLUMN "public"."api"."http_method" IS '0-get,1-head,2-post,3-put,4-patch,5-delete,6-options,7-trace';
COMMENT ON COLUMN "public"."api"."consume" IS 'consume content-type';
COMMENT ON COLUMN "public"."api"."produce" IS 'produce content-type';
COMMENT ON COLUMN "public"."api"."version" IS 'api version,for example V0.01';
COMMENT ON COLUMN "public"."api"."rpc_type" IS 'http,dubbo,sofa,tars,websocket,motan,grpc';
COMMENT ON COLUMN "public"."api"."state" IS '0-unpublished,1-published,2-offline';
COMMENT ON COLUMN "public"."api"."ext" IS 'extended fields';
COMMENT ON COLUMN "public"."api"."api_owner" IS 'api_owner';
COMMENT ON COLUMN "public"."api"."api_desc" IS 'the api description';
COMMENT ON COLUMN "public"."api"."api_source" IS '0-swagger,1-annotation generation,2-create manually,3-import swagger,4-import yapi';
COMMENT ON COLUMN "public"."api"."document" IS 'complete documentation of the api, including request parameters and response parameters';
COMMENT ON COLUMN "public"."api"."document_md5" IS 'document_md5';
COMMENT ON COLUMN "public"."api"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."api"."date_updated" IS 'update time';



-- ----------------------------
-- Table structure for api_rule_relation
-- ----------------------------
DROP TABLE IF EXISTS "public"."api_rule_relation";
CREATE TABLE "public"."api_rule_relation" (
  "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "api_id"       varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "rule_id"      varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now()):: timestamp (0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now()):: timestamp (0) without time zone)
)
;
COMMENT ON COLUMN "public"."api_rule_relation"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."api_rule_relation"."api_id" IS 'the table api primary key id';
COMMENT ON COLUMN "public"."api_rule_relation"."rule_id" IS 'the table rule primary key id';
COMMENT ON COLUMN "public"."api_rule_relation"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."api_rule_relation"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for app_auth
-- ----------------------------
DROP TABLE IF EXISTS "public"."app_auth";
CREATE TABLE "public"."app_auth" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "app_key" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "app_secret" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(128) COLLATE "pg_catalog"."default",
  "phone" varchar(255) COLLATE "pg_catalog"."default",
  "ext_info" varchar(1024) COLLATE "pg_catalog"."default",
  "open" int2 NOT NULL,
  "enabled" int2 NOT NULL,
  "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."app_auth"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."app_auth"."app_key" IS 'application identification key';
COMMENT ON COLUMN "public"."app_auth"."app_secret" IS 'encryption algorithm secret';
COMMENT ON COLUMN "public"."app_auth"."user_id" IS 'user id';
COMMENT ON COLUMN "public"."app_auth"."phone" IS 'phone number when the user applies';
COMMENT ON COLUMN "public"."app_auth"."ext_info" IS 'extended parameter json';
COMMENT ON COLUMN "public"."app_auth"."open" IS 'open auth path or not (0 close, 1 open) ';
COMMENT ON COLUMN "public"."app_auth"."enabled" IS 'delete or not (0 close, 1 open) ';
COMMENT ON COLUMN "public"."app_auth"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."app_auth"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."app_auth"."date_updated" IS 'update time';

-- ----------------------------
-- Records of app_auth
-- ----------------------------

-- ----------------------------
-- Table structure for auth_param
-- ----------------------------
DROP TABLE IF EXISTS "public"."auth_param";
CREATE TABLE "public"."auth_param" (
  "id" varchar(129) COLLATE "pg_catalog"."default" NOT NULL,
  "auth_id" varchar(129) COLLATE "pg_catalog"."default",
  "app_name" varchar(256) COLLATE "pg_catalog"."default" NOT NULL,
  "app_param" varchar(256) COLLATE "pg_catalog"."default",
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."auth_param"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."auth_param"."auth_id" IS 'Authentication table id';
COMMENT ON COLUMN "public"."auth_param"."app_name" IS 'business Module';
COMMENT ON COLUMN "public"."auth_param"."app_param" IS 'service module parameters (parameters that need to be passed by the gateway) json type';
COMMENT ON COLUMN "public"."auth_param"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."auth_param"."date_updated" IS 'update time';

-- ----------------------------
-- Records of auth_param
-- ----------------------------

-- ----------------------------
-- Table structure for auth_path
-- ----------------------------
DROP TABLE IF EXISTS "public"."auth_path";
CREATE TABLE "public"."auth_path" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "auth_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "app_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "enabled" int2 NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."auth_path"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."auth_path"."auth_id" IS 'auth table id';
COMMENT ON COLUMN "public"."auth_path"."app_name" IS 'module';
COMMENT ON COLUMN "public"."auth_path"."path" IS 'path';
COMMENT ON COLUMN "public"."auth_path"."enabled" IS 'whether pass 1 is (0 close, 1 open) ';
COMMENT ON COLUMN "public"."auth_path"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."auth_path"."date_updated" IS 'update time';

-- ----------------------------
-- Records of auth_path
-- ----------------------------

-- ----------------------------
-- Table structure for dashboard_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."dashboard_user";
CREATE TABLE "public"."dashboard_user" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "user_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(128) COLLATE "pg_catalog"."default",
  "role" int4 NOT NULL,
  "enabled" int2 NOT NULL,
  "client_id" varchar(32) COLLATE "pg_catalog"."default",
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."dashboard_user"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."dashboard_user"."user_name" IS 'user name';
COMMENT ON COLUMN "public"."dashboard_user"."password" IS 'user password';
COMMENT ON COLUMN "public"."dashboard_user"."role" IS 'role';
COMMENT ON COLUMN "public"."dashboard_user"."enabled" IS 'delete or not (0 close, 1 open) ';
COMMENT ON COLUMN "public"."dashboard_user"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."dashboard_user"."date_updated" IS 'update time';

-- ----------------------------
-- Records of dashboard_user
-- ----------------------------
INSERT INTO "public"."dashboard_user" VALUES ('1', 'admin', 'ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413', 1, 1, null, '2022-05-25 18:08:01', '2022-05-25 18:08:01');

-- ----------------------------
-- Table structure for data_permission
-- ----------------------------
DROP TABLE IF EXISTS "public"."data_permission";
CREATE TABLE "public"."data_permission" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "data_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "data_type" int4 NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."data_permission"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."data_permission"."user_id" IS 'user primary key id';
COMMENT ON COLUMN "public"."data_permission"."data_id" IS 'data(selector,rule) primary key id';
COMMENT ON COLUMN "public"."data_permission"."data_type" IS '0 selector type , 1 rule type';
COMMENT ON COLUMN "public"."data_permission"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."data_permission"."date_updated" IS 'update time';
COMMENT ON TABLE "public"."data_permission" IS 'data permission table';

-- ----------------------------
-- Records of data_permission
-- ----------------------------

-- ----------------------------
-- Table structure for detail
-- ----------------------------
DROP TABLE IF EXISTS "public"."detail";
CREATE TABLE "public"."detail" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "field_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "is_example" int2 NOT NULL,
  "field_value" text COLLATE "pg_catalog"."default" NOT NULL,
  "value_desc" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."detail"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."detail"."field_id" IS 'the field id';
COMMENT ON COLUMN "public"."detail"."is_example" IS 'is example or not (0 not, 1 is)';
COMMENT ON COLUMN "public"."detail"."field_value" IS 'the field value';
COMMENT ON COLUMN "public"."detail"."value_desc" IS 'field value description';
COMMENT ON COLUMN "public"."detail"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."detail"."date_updated" IS 'update time';

-- ----------------------------
-- Records of detail
-- ----------------------------

-- ----------------------------
-- Table structure for field
-- ----------------------------
DROP TABLE IF EXISTS "public"."field";
CREATE TABLE "public"."field" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "model_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "self_model_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "field_desc" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "required" int2 NOT NULL,
  "ext" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."field"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."field"."model_id" IS 'this field belongs to which model';
COMMENT ON COLUMN "public"."field"."self_model_id" IS 'which model of this field is';
COMMENT ON COLUMN "public"."field"."name" IS 'field name';
COMMENT ON COLUMN "public"."field"."field_desc" IS 'field description';
COMMENT ON COLUMN "public"."field"."required" IS 'whether to require (0 not required, 1 required)';
COMMENT ON COLUMN "public"."field"."ext" IS 'extended fields,can store genericTypes,eg..{"genericTypes":[model_id1,model_id2]}';
COMMENT ON COLUMN "public"."field"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."field"."date_updated" IS 'update time';

-- ----------------------------
-- Records of field
-- ----------------------------

-- ----------------------------
-- Table structure for meta_data
-- ----------------------------
DROP TABLE IF EXISTS "public"."meta_data";
CREATE TABLE "public"."meta_data" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "app_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "path_desc" varchar(255) COLLATE "pg_catalog"."default",
  "rpc_type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "service_name" varchar(255) COLLATE "pg_catalog"."default",
  "method_name" varchar(255) COLLATE "pg_catalog"."default",
  "parameter_types" varchar(255) COLLATE "pg_catalog"."default",
  "rpc_ext" varchar(512) COLLATE "pg_catalog"."default",
  "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "enabled" int2 NOT NULL
)
;
COMMENT ON COLUMN "public"."meta_data"."id" IS 'id';
COMMENT ON COLUMN "public"."meta_data"."app_name" IS 'application name';
COMMENT ON COLUMN "public"."meta_data"."path" IS 'path, cannot be repeated';
COMMENT ON COLUMN "public"."meta_data"."path_desc" IS 'path description';
COMMENT ON COLUMN "public"."meta_data"."rpc_type" IS 'rpc type';
COMMENT ON COLUMN "public"."meta_data"."service_name" IS 'service name';
COMMENT ON COLUMN "public"."meta_data"."method_name" IS 'method name';
COMMENT ON COLUMN "public"."meta_data"."parameter_types" IS 'parameter types are provided with multiple parameter types separated by commas';
COMMENT ON COLUMN "public"."meta_data"."rpc_ext" IS 'rpc extended information, json format';
COMMENT ON COLUMN "public"."meta_data"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."meta_data"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."meta_data"."date_updated" IS 'update time';
COMMENT ON COLUMN "public"."meta_data"."enabled" IS 'enabled state (0 close, 1 open) ';

-- ----------------------------
-- Records of meta_data
-- ----------------------------

-- ----------------------------
-- Table structure for mock_request_record
-- ----------------------------
DROP TABLE IF EXISTS "public"."mock_request_record";
CREATE TABLE "public"."mock_request_record"  (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "api_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "host" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "port" int4 NOT NULL,
  "url" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "path_variable" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT '',
  "query" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL DEFAULT '',
  "header" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL DEFAULT '',
  "body" text COLLATE "pg_catalog"."default",
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."mock_request_record"."id" IS 'id';
COMMENT ON COLUMN "public"."mock_request_record"."api_id" IS 'the api id';
COMMENT ON COLUMN "public"."mock_request_record"."host" IS 'the request host';
COMMENT ON COLUMN "public"."mock_request_record"."port" IS 'the request port';
COMMENT ON COLUMN "public"."mock_request_record"."url" IS 'the request url';
COMMENT ON COLUMN "public"."mock_request_record"."path_variable" IS 'the request param in url';
COMMENT ON COLUMN "public"."mock_request_record"."query" IS 'the request param after url';
COMMENT ON COLUMN "public"."mock_request_record"."header" IS 'the request param in header';
COMMENT ON COLUMN "public"."mock_request_record"."body" IS 'the request body';
COMMENT ON COLUMN "public"."mock_request_record"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."mock_request_record"."date_updated" IS 'update time';

-- ----------------------------
-- Records of mock_request_record
-- ----------------------------

-- ----------------------------
-- Table structure for model
-- ----------------------------
DROP TABLE IF EXISTS "public"."model";
CREATE TABLE "public"."model"  (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "model_desc" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."model"."id" IS 'id';
COMMENT ON COLUMN "public"."model"."name" IS 'the model name';
COMMENT ON COLUMN "public"."model"."model_desc" IS 'the model description';
COMMENT ON COLUMN "public"."model"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."model"."date_updated" IS 'update time';

-- ----------------------------
-- Records of model
-- ----------------------------
-- todo add some simple model, like java.lang.String long java.lang.Long

-- ----------------------------
-- Table structure for operation_record_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."operation_record_log";
CREATE TABLE "public"."operation_record_log" (
  "id" int8 NOT NULL DEFAULT nextval('operation_record_log_id_seq'::regclass),
  "color" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "context" text COLLATE "pg_catalog"."default" NOT NULL,
  "operator" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "operation_time" timestamp(6) NOT NULL,
  "operation_type" varchar(60) COLLATE "pg_catalog"."default" NOT NULL
)
;
COMMENT ON COLUMN "public"."operation_record_log"."id" IS 'id';
COMMENT ON COLUMN "public"."operation_record_log"."color" IS 'log color';
COMMENT ON COLUMN "public"."operation_record_log"."context" IS 'log context';
COMMENT ON COLUMN "public"."operation_record_log"."operator" IS 'operator [user or app]]';
COMMENT ON COLUMN "public"."operation_record_log"."operation_time" IS 'operation time';
COMMENT ON COLUMN "public"."operation_record_log"."operation_type" IS 'operation type：create/update/delete/register...';
COMMENT ON TABLE "public"."operation_record_log" IS 'operation record log';

-- ----------------------------
-- Records of operation_record_log
-- ----------------------------

-- ----------------------------
-- Table structure for param
-- ----------------------------
DROP TABLE IF EXISTS "public"."param";
CREATE TABLE "public"."param" (
  "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "api_id"       varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "model_id"     varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "type"         int4 NOT NULL,
  "name"         varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "param_desc"   varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "required"     int2 NOT NULL,
  "ext"          varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
);
COMMENT ON COLUMN "public"."param"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."param"."api_id" IS 'the api id';
COMMENT ON COLUMN "public"."param"."model_id" IS 'the model id, empty if not a model';
COMMENT ON COLUMN "public"."param"."type" IS '0-requestPathVariable,1-requestUrlParam,2-requestHeader,3-requestBody,4-responseHeader,5-responseBody';
COMMENT ON COLUMN "public"."param"."name" IS 'the param name';
COMMENT ON COLUMN "public"."param"."param_desc" IS 'the param description';
COMMENT ON COLUMN "public"."param"."required" IS 'whether to require (0 not required, 1 required)';
COMMENT ON COLUMN "public"."param"."ext" IS 'extended fields';
COMMENT ON COLUMN "public"."param"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."param"."date_updated" IS 'update time';

-- ----------------------------
-- Records of param
-- ----------------------------

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS "public"."permission";
CREATE TABLE "public"."permission" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "object_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "resource_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."permission"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."permission"."object_id" IS 'user primary key id or role primary key id';
COMMENT ON COLUMN "public"."permission"."resource_id" IS 'resource primary key id';
COMMENT ON COLUMN "public"."permission"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."permission"."date_updated" IS 'update time';
COMMENT ON TABLE "public"."permission" IS 'permission table';

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO "public"."permission" VALUES ('1351007708572688384', '1346358560427216896', '1346775491550474240', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1357956838021890049', '1346358560427216896', '1357956838021890048', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708597854208', '1346358560427216896', '1346777449787125760', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708702711808', '1346358560427216896', '1347034027070337024', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708706906112', '1346358560427216896', '1347039054925148160', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708711100416', '1346358560427216896', '1347041326749691904', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708715294720', '1346358560427216896', '1347046566244003840', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708719489024', '1346358560427216896', '1347047143350874112', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708723683328', '1346358560427216896', '1347047203220369408', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708606242816', '1346358560427216896', '1346777623011880960', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708727877632', '1346358560427216896', '1347047555588042752', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708732071936', '1346358560427216896', '1347047640145211392', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708732071937', '1346358560427216896', '1347047695002513408', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708736266240', '1346358560427216896', '1347047747305484288', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708610437120', '1346358560427216896', '1346777766301888512', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708740460544', '1346358560427216896', '1347048004105940992', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708614631424', '1346358560427216896', '1346777907096285184', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708744654848', '1346358560427216896', '1347048101875167232', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708744654849', '1346358560427216896', '1347048145877610496', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708748849151', '1346358560427216896', '1347048240677269503', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708748849152', '1346358560427216896', '1347048240677269504', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708753043456', '1346358560427216896', '1347048316216684544', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708757237760', '1346358560427216896', '1347048776029843456', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708757237761', '1346358560427216896', '1347048968414179328', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007709088587777', '1346358560427216896', '1350804501819195392', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708623020032', '1346358560427216896', '1346778036402483200', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708761432064', '1346358560427216896', '1347049029323862016', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708765626368', '1346358560427216896', '1347049092552994816', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708769820672', '1346358560427216896', '1347049251395481600', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708774014976', '1346358560427216896', '1347049317178945536', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708774014977', '1346358560427216896', '1347049370014593024', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708778209280', '1346358560427216896', '1347049542417264640', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708782403584', '1346358560427216896', '1347049598155370496', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708786597888', '1346358560427216896', '1347049659023110144', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708790792192', '1346358560427216896', '1347049731047698432', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708585271296', '1346358560427216896', '1346776175553376256', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708593659904', '1346358560427216896', '1346777157943259136', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708685934593', '1346358560427216896', '1347032308726902784', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708690128896', '1346358560427216896', '1347032395901317120', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708694323200', '1346358560427216896', '1347032453707214848', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708698517504', '1346358560427216896', '1347032509051056128', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007708794986496', '1346358560427216896', '1347049794008395776', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007709080199168', '1346358560427216896', '1350106119681622016', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007709080199169', '1346358560427216896', '1350107709494804480', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007709084393472', '1346358560427216896', '1350107842236137472', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007709084393473', '1346358560427216896', '1350112406754766848', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1351007709088587776', '1346358560427216896', '1350112481253994496', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1355167519859040256', '1346358560427216896', '1355163372527050752', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1355167519859040257', '1346358560427216896', '1355165158419750912', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1355167519859040258', '1346358560427216896', '1355165353534578688', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1355167519859040259', '1346358560427216896', '1355165475785957376', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1355167519859040260', '1346358560427216896', '1355165608565039104', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1357977745893326848', '1346358560427216896', '1357977745889132544', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1357977912126177281', '1346358560427216896', '1357977912126177280', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1357977971827900417', '1346358560427216896', '1357977971827900416', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1386680049203195905', '1346358560427216896', '1386680049203195904', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1386680049203195906', '1346358560427216896', '1386680049203195915', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1386680049203195907', '1346358560427216896', '1386680049203195916', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."permission" VALUES ('1529403932797964288', '1346358560427216896', '1529403932772798464', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964289', '1346358560427216896', '1529403932781187072', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964290', '1346358560427216896', '1529403932781187073', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964291', '1346358560427216896', '1529403932781187074', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964292', '1346358560427216896', '1529403932781187075', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964293', '1346358560427216896', '1529403932781187076', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964294', '1346358560427216896', '1529403932781187077', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964295', '1346358560427216896', '1529403932781187078', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964296', '1346358560427216896', '1529403932781187079', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964297', '1346358560427216896', '1529403932781187080', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964298', '1346358560427216896', '1529403932781187081', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964299', '1346358560427216896', '1529403932781187082', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964300', '1346358560427216896', '1529403932781187083', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964301', '1346358560427216896', '1529403932781187084', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964302', '1346358560427216896', '1529403932781187085', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964303', '1346358560427216896', '1529403932781187086', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964304', '1346358560427216896', '1529403932781187087', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964305', '1346358560427216896', '1529403932781187088', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964306', '1346358560427216896', '1529403932781187089', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964307', '1346358560427216896', '1529403932781187090', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964308', '1346358560427216896', '1529403932781187091', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964309', '1346358560427216896', '1529403932781187092', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964310', '1346358560427216896', '1529403932781187093', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964311', '1346358560427216896', '1529403932781187094', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964312', '1346358560427216896', '1529403932781187095', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964313', '1346358560427216896', '1529403932781187096', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964314', '1346358560427216896', '1529403932781187097', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964315', '1346358560427216896', '1529403932781187098', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932797964316', '1346358560427216896', '1529403932781187099', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850512', '1346358560427216896', '1529403932877656064', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850513', '1346358560427216896', '1529403932877656065', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850514', '1346358560427216896', '1529403932877656066', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850515', '1346358560427216896', '1529403932877656067', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850516', '1346358560427216896', '1529403932877656068', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850517', '1346358560427216896', '1529403932877656069', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850518', '1346358560427216896', '1529403932877656070', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850519', '1346358560427216896', '1529403932877656071', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850520', '1346358560427216896', '1529403932877656072', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850521', '1346358560427216896', '1529403932877656073', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850522', '1346358560427216896', '1529403932877656074', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850523', '1346358560427216896', '1529403932877656075', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850524', '1346358560427216896', '1529403932877656076', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850525', '1346358560427216896', '1529403932877656077', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850526', '1346358560427216896', '1529403932877656078', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850527', '1346358560427216896', '1529403932877656079', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850528', '1346358560427216896', '1529403932877656080', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850529', '1346358560427216896', '1529403932877656081', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850530', '1346358560427216896', '1529403932877656082', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850531', '1346358560427216896', '1529403932877656083', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850532', '1346358560427216896', '1529403932877656084', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850533', '1346358560427216896', '1529403932877656085', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850534', '1346358560427216896', '1529403932877656086', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850535', '1346358560427216896', '1529403932877656087', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850536', '1346358560427216896', '1529403932877656088', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850537', '1346358560427216896', '1529403932877656089', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850538', '1346358560427216896', '1529403932877656090', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850539', '1346358560427216896', '1529403932877656091', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850540', '1346358560427216896', '1529403932877656092', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850541', '1346358560427216896', '1529403932877656093', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850542', '1346358560427216896', '1529403932877656094', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850543', '1346358560427216896', '1529403932877656095', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850544', '1346358560427216896', '1529403932877656096', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850545', '1346358560427216896', '1529403932877656097', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850546', '1346358560427216896', '1529403932877656098', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850547', '1346358560427216896', '1529403932877656099', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850548', '1346358560427216896', '1529403932877656100', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850549', '1346358560427216896', '1529403932877656101', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850550', '1346358560427216896', '1529403932877656102', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850551', '1346358560427216896', '1529403932877656103', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850552', '1346358560427216896', '1529403932877656104', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850553', '1346358560427216896', '1529403932877656105', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850554', '1346358560427216896', '1529403932877656106', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850555', '1346358560427216896', '1529403932877656107', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850556', '1346358560427216896', '1529403932877656108', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850557', '1346358560427216896', '1529403932877656109', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850558', '1346358560427216896', '1529403932877656110', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850559', '1346358560427216896', '1529403932877656111', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850560', '1346358560427216896', '1529403932877656112', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850561', '1346358560427216896', '1529403932877656113', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850562', '1346358560427216896', '1529403932877656114', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850563', '1346358560427216896', '1529403932877656115', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850564', '1346358560427216896', '1529403932877656116', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850565', '1346358560427216896', '1529403932877656117', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850566', '1346358560427216896', '1529403932877656118', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850567', '1346358560427216896', '1529403932877656119', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850568', '1346358560427216896', '1529403932877656120', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850569', '1346358560427216896', '1529403932877656121', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850570', '1346358560427216896', '1529403932877656122', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850571', '1346358560427216896', '1529403932877656123', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850572', '1346358560427216896', '1529403932877656124', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850573', '1346358560427216896', '1529403932877656125', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850574', '1346358560427216896', '1529403932877656126', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850575', '1346358560427216896', '1529403932877656127', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850576', '1346358560427216896', '1529403932877656128', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850577', '1346358560427216896', '1529403932877656129', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850578', '1346358560427216896', '1529403932877656130', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850579', '1346358560427216896', '1529403932877656131', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850580', '1346358560427216896', '1529403932877656132', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850581', '1346358560427216896', '1529403932877656133', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850582', '1346358560427216896', '1529403932877656134', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850583', '1346358560427216896', '1529403932877656135', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850584', '1346358560427216896', '1529403932877656136', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850585', '1346358560427216896', '1529403932877656137', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850586', '1346358560427216896', '1529403932877656138', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850587', '1346358560427216896', '1529403932877656139', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850588', '1346358560427216896', '1529403932877656140', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850589', '1346358560427216896', '1529403932877656141', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850590', '1346358560427216896', '1529403932877656142', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850591', '1346358560427216896', '1529403932877656143', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850592', '1346358560427216896', '1529403932877656144', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850593', '1346358560427216896', '1529403932877656145', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850594', '1346358560427216896', '1529403932877656146', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850595', '1346358560427216896', '1529403932877656147', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850596', '1346358560427216896', '1529403932877656148', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850597', '1346358560427216896', '1529403932877656149', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850598', '1346358560427216896', '1529403932877656150', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850599', '1346358560427216896', '1529403932877656151', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850600', '1346358560427216896', '1529403932877656152', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850601', '1346358560427216896', '1529403932877656153', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850602', '1346358560427216896', '1529403932877656154', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850603', '1346358560427216896', '1529403932877656155', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850604', '1346358560427216896', '1529403932877656156', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850605', '1346358560427216896', '1529403932877656157', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850606', '1346358560427216896', '1529403932877656158', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850607', '1346358560427216896', '1529403932877656159', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850608', '1346358560427216896', '1529403932877656160', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850609', '1346358560427216896', '1529403932877656161', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850610', '1346358560427216896', '1529403932877656162', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850611', '1346358560427216896', '1529403932877656163', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850612', '1346358560427216896', '1529403932877656164', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850613', '1346358560427216896', '1529403932877656165', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850614', '1346358560427216896', '1529403932877656166', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850615', '1346358560427216896', '1529403932877656167', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850616', '1346358560427216896', '1529403932877656168', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850617', '1346358560427216896', '1529403932877656169', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850618', '1346358560427216896', '1529403932877656170', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850619', '1346358560427216896', '1529403932877656171', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850620', '1346358560427216896', '1529403932877656172', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850621', '1346358560427216896', '1529403932877656173', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850622', '1346358560427216896', '1529403932877656174', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850623', '1346358560427216896', '1529403932877656175', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850624', '1346358560427216896', '1529403932877656176', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850625', '1346358560427216896', '1529403932877656177', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850626', '1346358560427216896', '1529403932877656178', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850627', '1346358560427216896', '1529403932877656179', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850628', '1346358560427216896', '1529403932877656180', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850629', '1346358560427216896', '1529403932881850368', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850630', '1346358560427216896', '1529403932881850369', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850631', '1346358560427216896', '1529403932881850370', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850632', '1346358560427216896', '1529403932881850371', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850633', '1346358560427216896', '1529403932881850372', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850634', '1346358560427216896', '1529403932881850373', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850635', '1346358560427216896', '1529403932881850374', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850636', '1346358560427216896', '1529403932881850375', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850637', '1346358560427216896', '1529403932881850376', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850638', '1346358560427216896', '1529403932881850377', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850639', '1346358560427216896', '1529403932881850378', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850640', '1346358560427216896', '1529403932881850379', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850641', '1346358560427216896', '1529403932881850380', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850642', '1346358560427216896', '1529403932881850381', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850643', '1346358560427216896', '1529403932881850382', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850644', '1346358560427216896', '1529403932881850383', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850645', '1346358560427216896', '1529403932881850384', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850646', '1346358560427216896', '1529403932881850385', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850647', '1346358560427216896', '1529403932881850386', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850648', '1346358560427216896', '1529403932881850387', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850649', '1346358560427216896', '1529403932881850388', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850650', '1346358560427216896', '1529403932881850389', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850651', '1346358560427216896', '1529403932881850390', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850652', '1346358560427216896', '1529403932881850391', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850653', '1346358560427216896', '1529403932881850392', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850654', '1346358560427216896', '1529403932881850393', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850655', '1346358560427216896', '1529403932881850394', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850656', '1346358560427216896', '1529403932881850395', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850657', '1346358560427216896', '1529403932881850396', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850658', '1346358560427216896', '1529403932881850397', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850659', '1346358560427216896', '1529403932881850398', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850660', '1346358560427216896', '1529403932881850399', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850661', '1346358560427216896', '1529403932881850400', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850662', '1346358560427216896', '1529403932881850401', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850663', '1346358560427216896', '1529403932881850402', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850664', '1346358560427216896', '1529403932881850403', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850665', '1346358560427216896', '1529403932881850404', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850666', '1346358560427216896', '1529403932881850405', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850667', '1346358560427216896', '1529403932881850406', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850668', '1346358560427216896', '1529403932881850407', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850669', '1346358560427216896', '1529403932881850408', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850670', '1346358560427216896', '1529403932881850409', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850671', '1346358560427216896', '1529403932881850410', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850672', '1346358560427216896', '1529403932881850411', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850673', '1346358560427216896', '1529403932881850412', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850674', '1346358560427216896', '1529403932881850413', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850675', '1346358560427216896', '1529403932881850414', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850676', '1346358560427216896', '1529403932881850415', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932881850677', '1346358560427216896', '1529403932881850416', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044672', '1346358560427216896', '1529403932881850417', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044673', '1346358560427216896', '1529403932881850418', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044674', '1346358560427216896', '1529403932881850419', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044675', '1346358560427216896', '1529403932881850420', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044676', '1346358560427216896', '1529403932881850421', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044677', '1346358560427216896', '1529403932881850422', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044678', '1346358560427216896', '1529403932881850423', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044679', '1346358560427216896', '1529403932881850424', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044680', '1346358560427216896', '1529403932881850425', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044681', '1346358560427216896', '1529403932881850426', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044682', '1346358560427216896', '1529403932881850427', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044683', '1346358560427216896', '1529403932881850428', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044684', '1346358560427216896', '1529403932881850429', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044685', '1346358560427216896', '1529403932881850430', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044686', '1346358560427216896', '1529403932881850431', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044687', '1346358560427216896', '1529403932881850432', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044688', '1346358560427216896', '1529403932881850433', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044689', '1346358560427216896', '1529403932881850434', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044690', '1346358560427216896', '1529403932881850435', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044691', '1346358560427216896', '1529403932881850436', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044692', '1346358560427216896', '1529403932881850437', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044693', '1346358560427216896', '1529403932881850438', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044694', '1346358560427216896', '1529403932881850439', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044695', '1346358560427216896', '1529403932881850440', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044696', '1346358560427216896', '1529403932881850441', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044697', '1346358560427216896', '1529403932881850442', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044698', '1346358560427216896', '1529403932881850443', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044699', '1346358560427216896', '1529403932881850444', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044700', '1346358560427216896', '1529403932881850445', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044701', '1346358560427216896', '1529403932881850446', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044702', '1346358560427216896', '1529403932881850447', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044703', '1346358560427216896', '1529403932881850448', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044704', '1346358560427216896', '1529403932881850449', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044705', '1346358560427216896', '1529403932881850450', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044706', '1346358560427216896', '1529403932881850451', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044707', '1346358560427216896', '1529403932881850452', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044708', '1346358560427216896', '1529403932881850453', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044709', '1346358560427216896', '1529403932881850454', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044710', '1346358560427216896', '1529403932881850455', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044711', '1346358560427216896', '1529403932881850456', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044712', '1346358560427216896', '1529403932881850457', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044713', '1346358560427216896', '1529403932881850458', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044714', '1346358560427216896', '1529403932881850459', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044715', '1346358560427216896', '1529403932881850460', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044716', '1346358560427216896', '1529403932881850461', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044717', '1346358560427216896', '1529403932881850462', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044718', '1346358560427216896', '1529403932881850463', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044719', '1346358560427216896', '1529403932881850464', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044720', '1346358560427216896', '1529403932881850465', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044721', '1346358560427216896', '1529403932881850466', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044722', '1346358560427216896', '1529403932881850467', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044723', '1346358560427216896', '1529403932881850468', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044724', '1346358560427216896', '1529403932881850469', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044725', '1346358560427216896', '1529403932881850470', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044726', '1346358560427216896', '1529403932881850471', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044727', '1346358560427216896', '1529403932881850472', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044728', '1346358560427216896', '1529403932881850473', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044729', '1346358560427216896', '1529403932881850474', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044730', '1346358560427216896', '1529403932881850475', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044731', '1346358560427216896', '1529403932881850476', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044732', '1346358560427216896', '1529403932881850477', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044733', '1346358560427216896', '1529403932881850478', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044734', '1346358560427216896', '1529403932881850479', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044735', '1346358560427216896', '1529403932881850480', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044736', '1346358560427216896', '1529403932881850481', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044737', '1346358560427216896', '1529403932881850482', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044738', '1346358560427216896', '1529403932881850483', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044739', '1346358560427216896', '1529403932881850484', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044740', '1346358560427216896', '1529403932881850485', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044741', '1346358560427216896', '1529403932881850486', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044742', '1346358560427216896', '1529403932881850487', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044743', '1346358560427216896', '1529403932881850488', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044744', '1346358560427216896', '1529403932881850489', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044745', '1346358560427216896', '1529403932881850490', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044746', '1346358560427216896', '1529403932881850491', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044747', '1346358560427216896', '1529403932881850492', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044748', '1346358560427216896', '1529403932881850493', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044749', '1346358560427216896', '1529403932881850494', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044750', '1346358560427216896', '1529403932881850495', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044751', '1346358560427216896', '1529403932881850496', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044752', '1346358560427216896', '1529403932881850497', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044753', '1346358560427216896', '1529403932881850498', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044754', '1346358560427216896', '1529403932881850499', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044755', '1346358560427216896', '1529403932881850500', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044756', '1346358560427216896', '1529403932881850501', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044757', '1346358560427216896', '1529403932881850502', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044758', '1346358560427216896', '1529403932881850503', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044759', '1346358560427216896', '1529403932881850504', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044760', '1346358560427216896', '1529403932881850505', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044761', '1346358560427216896', '1529403932881850506', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044762', '1346358560427216896', '1529403932881850507', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044763', '1346358560427216896', '1529403932881850508', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044764', '1346358560427216896', '1529403932881850509', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044765', '1346358560427216896', '1529403932881850510', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044766', '1346358560427216896', '1529403932881850511', '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."permission" VALUES ('1529403932886044767', '1346358560427216896', '1534577121923309568', '2022-06-09 00:44:32', '2022-06-09 00:44:31');
INSERT INTO "public"."permission" VALUES ('1529403932886044768', '1346358560427216896', '1534585430311051264', '2022-06-09 01:17:33', '2022-06-09 01:17:32');
INSERT INTO "public"."permission" VALUES ('1529403932886044769', '1346358560427216896', '1534585531108564992', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1529403932886044770', '1346358560427216896', '1534585531108564993', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044771', '1346358560427216896', '1534585531108564994', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044772', '1346358560427216896', '1534585531108564995', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044773', '1346358560427216896', '1534585531108564996', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044774', '1346358560427216896', '1534585531108564997', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044775', '1346358560427216896', '1534585531108564998', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044776', '1346358560427216896', '1534585531108564999', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044777', '1346358560427216896', '1534585531108565000', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044778', '1346358560427216896', '1534585531108565001', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044779', '1346358560427216896', '1534585531108565002', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1529403932886044780', '1346358560427216896', '1534585531108565003', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044781', '1346358560427216896', '1534585531108565004', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044782', '1346358560427216896', '1534585531108565005', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044783', '1346358560427216896', '1534585531108565006', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044784', '1346358560427216896', '1534585531108565007', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044785', '1346358560427216896', '1534585531108565008', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044786', '1346358560427216896', '1534585531108565009', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044787', '1346358560427216896', '1534585531108565010', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044788', '1346358560427216896', '1534585531108565011', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044789', '1346358560427216896', '1534585531108565012', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1529403932886044790', '1346358560427216896', '1534585531108565013', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044791', '1346358560427216896', '1534585531108565014', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044792', '1346358560427216896', '1534585531108565015', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044793', '1346358560427216896', '1534585531108565016', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044794', '1346358560427216896', '1534585531108565017', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044795', '1346358560427216896', '1534585531108565018', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044796', '1346358560427216896', '1534585531108565019', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044797', '1346358560427216896', '1534585531108565020', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044798', '1346358560427216896', '1534585531108565021', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044799', '1346358560427216896', '1534585531108565022', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1529403932886044800', '1346358560427216896', '1534585531108565023', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044801', '1346358560427216896', '1534585531108565024', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044802', '1346358560427216896', '1534585531108565025', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044803', '1346358560427216896', '1534585531108565026', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044804', '1346358560427216896', '1534585531108565027', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044805', '1346358560427216896', '1534585531108565028', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044806', '1346358560427216896', '1534585531108565029', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044807', '1346358560427216896', '1534585531108565030', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044808', '1346358560427216896', '1534585531108565031', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044809', '1346358560427216896', '1534585531108565032', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1529403932886044810', '1346358560427216896', '1534585531108565033', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044811', '1346358560427216896', '1534585531108565034', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044812', '1346358560427216896', '1534585531108565035', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044813', '1346358560427216896', '1534585531108565036', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044814', '1346358560427216896', '1534585531108565037', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044815', '1346358560427216896', '1534585531108565038', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044816', '1346358560427216896', '1534585531108565039', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044817', '1346358560427216896', '1534585531108565040', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044818', '1346358560427216896', '1534585531108565041', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044819', '1346358560427216896', '1534585531108565042', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1529403932886044820', '1346358560427216896', '1534585531108565043', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044821', '1346358560427216896', '1534585531108565044', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044822', '1346358560427216896', '1534585531108565045', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044823', '1346358560427216896', '1534585531108565046', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044824', '1346358560427216896', '1534585531108565047', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044825', '1346358560427216896', '1534585531108565048', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044826', '1346358560427216896', '1534585531108565049', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044827', '1346358560427216896', '1534585531108565050', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044828', '1346358560427216896', '1534585531108565051', '2022-06-09 01:17:57', '2022-06-09 01:17:56');
INSERT INTO "public"."permission" VALUES ('1529403932886044829', '1346358560427216896', '1534585531108565052', '2022-06-09 01:17:57', '2022-06-09 01:17:56');

INSERT INTO "public"."permission" VALUES ('1572525965658820609', '1346358560427216896', '1572525965625266177', '2023-07-07 23:20:04.962', '2023-07-07 23:20:14.170');
INSERT INTO "public"."permission" VALUES ('1572525965658820610', '1346358560427216896', '1572525965625266178', '2023-07-07 23:21:23.648', '2023-07-07 23:21:23.648');
INSERT INTO "public"."permission" VALUES ('1572525965658820611', '1346358560427216896', '1572525965625266179', '2023-07-07 23:23:40.409', '2023-07-07 23:23:40.409');
INSERT INTO "public"."permission" VALUES ('1572525965658820612', '1346358560427216896', '1572525965625266180', '2023-07-07 23:24:03.398', '2023-07-07 23:24:03.398');
INSERT INTO "public"."permission" VALUES ('1572525965658820613', '1346358560427216896', '1572525965625266181', '2023-07-07 23:24:19.165', '2023-07-07 23:24:19.165');
INSERT INTO "public"."permission" VALUES ('1572525965658820614', '1346358560427216896', '1572525965625266182', '2023-07-07 23:24:52.339', '2023-07-07 23:24:52.339');
INSERT INTO "public"."permission" VALUES ('1572525965658820615', '1346358560427216896', '1572525965625266183', '2023-07-07 23:25:30.528', '2023-07-07 23:25:30.528');
INSERT INTO "public"."permission" VALUES ('1572525965658820616', '1346358560427216896', '1572525965625266184', '2023-07-07 23:25:50.772', '2023-07-07 23:25:50.772');
INSERT INTO "public"."permission" VALUES ('1572525965658820617', '1346358560427216896', '1572525965625266185', '2023-07-07 23:26:11.518', '2023-07-07 23:26:11.518');
INSERT INTO "public"."permission" VALUES ('1572525965658820618', '1346358560427216896', '1572525965625266186', '2023-07-07 23:26:37.388', '2023-07-07 23:26:37.388');

INSERT INTO "public"."permission" VALUES ('1572525965658820608', '1346358560427216896', '1572525965625266176', '2022-09-28 11:50:58', '2022-09-28 11:50:58');
INSERT INTO "public"."permission" VALUES ('1697141926281318400','1346358560427216896','1697141926247763968', '2023-08-31 14:59:01', '2023-08-31 06:59:01');
INSERT INTO "public"."permission" VALUES ('1697145808239693824','1346358560427216896','1697145808210333696', '2023-08-31 15:14:26', '2023-08-31 07:14:26');
INSERT INTO "public"."permission" VALUES ('1697146375754190848','1346358560427216896','1697146375729025024', '2023-08-31 15:16:42', '2023-08-31 07:16:42');
INSERT INTO "public"."permission" VALUES ('1697146617543233536','1346358560427216896','1697146617513873408', '2023-08-31 15:17:39', '2023-08-31 07:17:39');
INSERT INTO "public"."permission" VALUES ('1697146860569595904','1346358560427216896','1697146860540235776', '2023-08-31 15:18:37', '2023-08-31 07:18:37');

INSERT INTO "public"."permission" VALUES ('1697141926281381720','1346358560427216896','1844015648095666176', '2023-08-31 06:59:01', '2023-08-31 06:59:01');
INSERT INTO "public"."permission" VALUES ('1697145808239621836','1346358560427216896','1844025735425183744', '2023-08-31 07:22:07', '2023-08-31 07:22:07');
INSERT INTO "public"."permission" VALUES ('1697146375754129471','1346358560427216896','1844025850382667776', '2023-08-31 07:14:26', '2023-08-31 07:14:26');
INSERT INTO "public"."permission" VALUES ('1697146617543248162','1346358560427216896','1844025989214130176', '2023-08-31 07:22:07', '2023-08-31 07:22:07');
INSERT INTO "public"."permission" VALUES ('1697146860569542740','1346358560427216896','1844026099075534848', '2023-08-31 07:18:37', '2023-08-31 07:18:37');

-- ----------------------------
-- Table structure for plugin
-- ----------------------------
DROP TABLE IF EXISTS "public"."plugin";
CREATE TABLE "public"."plugin" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(62) COLLATE "pg_catalog"."default" NOT NULL,
  "config" text COLLATE "pg_catalog"."default",
  "role" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "sort" int4,
  "enabled" int2 NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "plugin_jar" bytea
);
COMMENT ON COLUMN "public"."plugin"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."plugin"."name" IS 'plugin name';
COMMENT ON COLUMN "public"."plugin"."config" IS 'plugin configuration';
COMMENT ON COLUMN "public"."plugin"."role" IS 'plug-in role';
COMMENT ON COLUMN "public"."plugin"."sort" IS 'sort';
COMMENT ON COLUMN "public"."plugin"."enabled" IS 'whether to open (0, not open, 1 open)';
COMMENT ON COLUMN "public"."plugin"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."plugin"."date_updated" IS 'update time';
COMMENT ON COLUMN "public"."plugin"."plugin_jar" IS 'plugin jar';

-- ----------------------------
-- Records of plugin
-- ----------------------------
INSERT INTO "public"."plugin" VALUES ('1', 'sign', NULL, 'Authentication', 20, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('10', 'sentinel', NULL, 'FaultTolerance', 140, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('11', 'sofa', '{"protocol":"zookeeper","register":"127.0.0.1:2181","threadpool":"shared"}', 'Proxy', 310, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('12', 'resilience4j', NULL, 'FaultTolerance', 310, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('13', 'tars', '{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}', 'Proxy', 310, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('14', 'contextPath', NULL, 'HttpProcess', 80, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('15', 'grpc', '{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}', 'Proxy', 310, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('16', 'redirect', NULL, 'HttpProcess', 110, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('17', 'motan', '{"registerProtocol":"direct",registerAddress":"127.0.0.1:2181","corethreads":0,"threads":2147483647,"queues":0,"threadpool":"shared"}', 'Proxy', 310, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('18', 'loggingConsole', NULL, 'Logging', 160, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('19', 'jwt', '{"secretKey":"key"}', 'Authentication', 30, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('2', 'waf', '{"model":"black"}', 'Authentication', 50, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('20', 'request', NULL, 'HttpProcess', 120, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('21', 'oauth2', NULL, 'Authentication', 40, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('22', 'paramMapping', '{"ruleHandlePageType":"custom"}', 'HttpProcess', 70, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('23', 'modifyResponse', '{"ruleHandlePageType":"custom"}', 'HttpProcess', 220, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('24', 'cryptorRequest', NULL, 'Cryptor', 100, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('25', 'cryptorResponse', NULL, 'Cryptor', 410, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('26', 'websocket', '{"multiSelectorHandle":"1"}', 'Proxy', 200, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('3', 'rewrite', NULL, 'HttpProcess', 90, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('4', 'rateLimiter', '{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}', 'FaultTolerance', 60, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('5', 'divide', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', 'Proxy', 200, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('6', 'dubbo', '{"register":"zookeeper://localhost:2181","multiSelectorHandle":"1","threadpool":"shared","corethreads":0,"threads":2147483647,"queues":0}', 'Proxy', 310, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('9', 'hystrix', NULL, 'FaultTolerance', 130, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('27', 'generalContext', NULL, 'Common', 125, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('28', 'mqtt', '{"port": 9500,"bossGroupThreadCount": 1,"maxPayloadSize": 65536,"workerGroupThreadCount": 12,"userName": "shenyu","password": "shenyu","isEncryptPassword": false,"encryptMode": "","leakDetectorLevel": "DISABLED"}', 'Proxy', 125, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('29', 'loggingRocketMQ', '{"topic":"shenyu-access-logging", "namesrvAddr": "localhost:9876","producerGroup":"shenyu-plugin-logging-rocketmq"}', 'Logging', 170, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('30', 'cache', '{"cacheType":"memory"}', 'Cache', 10, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('31', 'mock', null, 'Mock', 1, 0, '2022-06-16 14:40:35', '2022-06-16 14:40:55', null);
INSERT INTO "public"."plugin" VALUES ('32', 'loggingElasticSearch', '{"host":"localhost", "port": "9200"}', 'Logging', 190, 0, '2022-06-19 22:00:00', '2022-06-19 22:00:00', null);
INSERT INTO "public"."plugin" VALUES ('33', 'loggingKafka', '{"topic":"shenyu-access-logging", "namesrvAddr": "localhost:9092"}', 'Logging', 180, 0, '2022-07-04 22:00:00', '2022-07-04 22:00:00', null);
INSERT INTO "public"."plugin" VALUES ('34', 'loggingAliyunSls', '{"projectName": "shenyu", "logStoreName": "shenyu-logstore", "topic": "shenyu-topic"}', 'Logging', 175, 0, '2022-06-30 21:00:00', '2022-06-30 21:00:00', null);
INSERT INTO "public"."plugin" VALUES ('35', 'loggingPulsar', '{"topic":"shenyu-access-logging", "serviceUrl": "pulsar://localhost:6650"}', 'Logging', 185, 0, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('36', 'loggingTencentCls', '{"endpoint": "ap-guangzhou.cls.tencentcs.com", "topic": "shenyu-topic"}', 'Logging', 176, 0, '2022-06-30 21:00:00', '2022-06-30 21:00:00', null);
INSERT INTO "public"."plugin" VALUES ('38', 'loggingClickHouse', '{"host":"127.0.0.1","port":"8123","databse":"shenyu-gateway","username":"foo","password":"bar"}', 'Logging', 195, 0, '2022-06-30 21:00:00', '2022-06-30 21:00:00', null);
INSERT INTO "public"."plugin" VALUES ('39', 'casdoor', '{"endpoint":"http://localhost:8000"}', 'Authentication', 40, 0, '2022-09-11 12:00:00', '2022-09-11 12:00:00', null);
INSERT INTO "public"."plugin" VALUES ('40', 'keyAuth', NULL, 'Authentication', 150, 0, '2022-07-24 19:00:00', '2022-07-24 19:00:00', null);
INSERT INTO "public"."plugin" VALUES ('42', 'tcp', null, 'Proxy', 320, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('43', 'loggingHuaweiLts', '{ "totalSizeInBytes": "104857600","maxBlockMs":"0","ioThreadCount":"1","batchSizeThresholdInBytes":"524288","batchCountThreshold":"4096","lingerMs":"2000","retries":"100","baseRetryBackoffMs":"100","maxRetryBackoffMs":"100","enableLocalTest":"true","setGiveUpExtraLongSingleLog":"false"}', 'Logging', 177, 0, '2023-07-05 14:03:53', '2023-07-06 12:42:07', null);
INSERT INTO "public"."plugin" VALUES ('44', 'basicAuth', '{"defaultHandleJson":"{"authorization":"test:test123"}"}', 'Authentication', 150, 0, '2022-07-24 19:00:00', '2022-07-24 19:00:00', null);
INSERT INTO "public"."plugin" VALUES ('45', 'loggingRabbitMQ', '{"host":"127.0.0.1","port":5672,"password":"admin","username":"admin","exchangeName":"exchange.logging.plugin","queueName":"queue.logging.plugin","routingKey":"topic.logging","virtualHost":"/","exchangeType":"direct","durable":"true","exclusive":"false","autoDelete":"false"}', 'Logging', 171, 0, '2023-11-06 15:49:56.454', '2023-11-10 10:40:58.447', NULL);
INSERT INTO "public"."plugin" VALUES ('50', 'aiProxy', '{"provider":"OpenAI","baseUrl":"https://api.openai.com/v1/chat/completions","model":"gpt-4o-mini","apiKey":"your_api_key","temperature":"0.5","maxTokens":"1000","stream":"false","prompt":""}', 'Ai', 199, 0, '2023-12-20 18:02:53', '2023-12-20 18:02:53', null);
INSERT INTO "public"."plugin" VALUES ('51', 'aiTokenLimiter', NULL, 'Ai', 171, 0, '2023-12-20 18:02:53', '2023-12-20 18:02:53', null);

-- ----------------------------
-- Table structure for plugin_handle
-- ----------------------------
DROP TABLE IF EXISTS "public"."plugin_handle";
CREATE TABLE "public"."plugin_handle" (
  "id" varchar(128) NOT NULL DEFAULT nextval('plugin_handle_id_seq'::regclass),
  "plugin_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "field" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "label" varchar(100) COLLATE "pg_catalog"."default",
  "data_type" int2 NOT NULL,
  "type" int2,
  "sort" int4,
  "ext_obj" varchar(1024) COLLATE "pg_catalog"."default",
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."plugin_handle"."plugin_id" IS 'plugin id';
COMMENT ON COLUMN "public"."plugin_handle"."field" IS 'field';
COMMENT ON COLUMN "public"."plugin_handle"."label" IS 'label';
COMMENT ON COLUMN "public"."plugin_handle"."data_type" IS 'data type 1 number 2 string';
COMMENT ON COLUMN "public"."plugin_handle"."type" IS 'type, 1 means selector, 2 means rule, 3 means plugin';
COMMENT ON COLUMN "public"."plugin_handle"."sort" IS 'sort';
COMMENT ON COLUMN "public"."plugin_handle"."ext_obj" IS 'extra configuration (json format data)';
COMMENT ON COLUMN "public"."plugin_handle"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."plugin_handle"."date_updated" IS 'update time';

-- ----------------------------
-- Records of plugin_handle
-- ----------------------------
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941952', '10', 'flowRuleGrade', 'flowRuleGrade', 3, 2, 8, '{"required":"1","defaultValue":"1","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941953', '10', 'flowRuleControlBehavior', 'flowRuleControlBehavior', 3, 2, 5, '{"required":"1","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941954', '10', 'flowRuleEnable', 'flowRuleEnable 1 or 0', 1, 2, 7, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941955', '10', 'flowRuleCount', 'flowRuleCount', 1, 2, 6, '{"required":"1","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941956', '10', 'degradeRuleEnable', 'degradeRuleEnable 1 or 0', 1, 2, 2, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941957', '10', 'degradeRuleGrade', 'degradeRuleGrade', 3, 2, 3, '{"required":"1","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136256', '10', 'degradeRuleCount', 'degradeRuleCount', 1, 2, 1, '{"required":"1","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136257', '10', 'degradeRuleTimeWindow', 'degradeRuleTimeWindow', 1, 2, 4, '{"required":"1","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136258', '10', 'degradeRuleMinRequestAmount', 'degradeRuleMinRequestAmount', 1, 2, 3, '{"required":"1","defaultValue":"5","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136259', '10', 'degradeRuleStatIntervals', 'degradeRuleStatIntervals', 1, 2, 3, '{"required":"1","defaultValue":"1","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136260', '10', 'degradeRuleSlowRatioThreshold', 'degradeRuleSlowRatioThreshold', 1, 2, 3, '{"required":"1","defaultValue":"0.5","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136261', '10', 'fallbackUri', 'fallbackUri', 2, 2, 9, '{"required":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136262', '2', 'permission', 'permission', 3, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136263', '2', 'statusCode', 'statusCode', 2, 2, 2, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136264', '4', 'replenishRate', 'replenishRate', 2, 2, 2, '{"required":"1","defaultValue":"10","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136265', '4', 'burstCapacity', 'burstCapacity', 2, 2, 3, '{"required":"1","defaultValue":"100","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136266', '3', 'regex', 'regex', 2, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136267', '3', 'replace', 'replace', 2, 2, 2, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1697146860569596304', '3', 'percentage', 'percentage', 1, 2, 3, NULL, '2023-09-15 20:25:53', '2023-09-15 20:25:53');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136268', '16', 'redirectURI', 'redirectURI', 2, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136272', '12', 'timeoutDurationRate', 'timeoutDurationRate ms)', 1, 2, 1, '{"required":"1","defaultValue":"5000","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136273', '12', 'limitRefreshPeriod', 'limitRefreshPeriod ms)', 1, 2, 0, '{"required":"1","defaultValue":"500","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136274', '12', 'limitForPeriod', 'limitForPeriod', 1, 2, 0, '{"required":"1","defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136275', '12', 'circuitEnable', 'circuitEnable', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136276', '12', 'timeoutDuration', 'timeoutDuration ms)', 1, 2, 2, '{"required":"1","defaultValue":"30000","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136277', '12', 'fallbackUri', 'fallbackUri', 2, 2, 2, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136278', '12', 'slidingWindowSize', 'slidingWindowSize', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136279', '12', 'slidingWindowType', 'slidingWindowType', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136280', '12', 'minimumNumberOfCalls', 'minimumNumberOfCalls', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136281', '12', 'waitIntervalFunctionInOpenState', 'waitIntervalInOpen', 1, 2, 2, '{"required":"1","defaultValue":"60000","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136282', '12', 'permittedNumberOfCallsInHalfOpenState', 'bufferSizeInHalfOpen', 1, 2, 2, '{"required":"1","defaultValue":"10","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136283', '12', 'failureRateThreshold', 'failureRateThreshold', 1, 2, 2, '{"required":"1","defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136284', '12', 'automaticTransitionFromOpenToHalfOpenEnabled', 'automaticHalfOpen', 3, 2, 1, '{"required":"1","defaultValue":"true","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136285', '4', 'mode', 'mode', 3, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136286', '4', 'master', 'master', 2, 3, 2, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136287', '4', 'url', 'url', 2, 3, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136288', '4', 'password', 'password', 2, 3, 4, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136289', '11', 'protocol', 'protocol', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136290', '11', 'register', 'register', 2, 3, 2, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136291', '2', 'model', 'model', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136292', '6', 'register', 'register', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136293', '4', 'algorithmName', 'algorithmName', 3, 2, 1, '{"required":"1","defaultValue":"slidingWindow","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136294', '4', 'keyResolverName', 'keyResolverName', 3, 2, 4, '{"required":"1","defaultValue":"WHOLE_KEY_RESOLVER","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136295', '5', 'upstreamHost', 'host', 2, 1, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136296', '5', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"http://","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136297', '5', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136298', '5', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136299', '5', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136300', '5', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902775136301', '5', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330560', '5', 'loadBalance', 'loadStrategy', 3, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330561', '5', 'retry', 'retryCount', 1, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330562', '5', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330563', '5', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330564', '5', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330565', '5', 'headerMaxSize', 'headerMaxSize', 1, 2, 3, '{"defaultValue":"10240","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330566', '5', 'requestMaxSize', 'requestMaxSize', 1, 2, 4, '{"defaultValue":"102400","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330567', '5', 'retryStrategy', 'retryStrategy', 3, 2, 0, '{"required":"0","defaultValue":"current","placeholder":"retryStrategy","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330568', '13', 'upstreamHost', 'host', 2, 1, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330569', '13', 'protocol', 'protocol', 2, 1, 2, '{"defaultValue":"","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330570', '13', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330571', '13', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330572', '13', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330573', '13', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330574', '13', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330575', '13', 'loadBalance', 'loadStrategy', 3, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330576', '13', 'retry', 'retryCount', 1, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330577', '13', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330578', '13', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330579', '13', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330580', '15', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330581', '15', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330582', '15', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330583', '15', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330584', '15', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330585', '15', 'threadpool', 'threadpool', 3, 3, 0, '{"required":"0","defaultValue":"cached","placeholder":"threadpool","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330586', '14', 'contextPath', 'contextPath', 2, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330587', '14', 'addPrefix', 'addPrefix', 2, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330588', '20', 'ruleHandlePageType', 'ruleHandlePageType', 3, 3, 0, '{"required":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330589', '19', 'secretKey', 'secretKey', 2, 3, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330590', '24', 'strategyName', 'strategyName', 3, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330591', '24', 'fieldNames', 'fieldNames', 2, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330592', '24', 'decryptKey', 'decryptKey', 2, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330593', '24', 'encryptKey', 'encryptKey', 2, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330594', '24', 'way', 'way', 3, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1630760188111376384', '24', 'mapType', 'mapType', 3, 2, 3, '{"required":"0","defaultValue":"all","rule":""}', '2023-03-01 10:41:41', '2023-03-01 10:42:21');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330595', '25', 'strategyName', 'strategyName', 3, 2, 2, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330596', '25', 'decryptKey', 'decryptKey', 2, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330597', '25', 'encryptKey', 'encryptKey', 2, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330598', '25', 'fieldNames', 'fieldNames', 2, 2, 4, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330599', '25', 'way', 'way', 3, 2, 3, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1630768384280514560', '25', 'mapType', 'mapType', 3, 2, 4, '{"required":"0","defaultValue":"all","rule":""}', '2023-03-01 11:14:15', '2023-03-01 11:15:14');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330600', '6', 'gray', 'gray', 3, 1, 9, '{"required":"0","defaultValue":"false","placeholder":"gray","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330601', '6', 'group', 'group', 2, 1, 3, '{"required":"0","placeholder":"group","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330602', '6', 'loadBalance', 'loadStrategy', 3, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330603', '6', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330604', '6', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"http://","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330605', '6', 'status', 'status', 3, 1, 8, '{"defaultValue":"true","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330606', '6', 'timestamp', 'startupTime', 1, 1, 7, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330607', '6', 'upstreamHost', 'host', 2, 1, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330608', '6', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330609', '6', 'version', 'version', 2, 1, 4, '{"required":"0","placeholder":"version","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330610', '6', 'warmup', 'warmupTime', 1, 1, 6, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902779330611', '6', 'weight', 'weight', 1, 1, 5, '{"defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524864', '6', 'threadpool', 'threadpool', 3, 3, 0, '{"required":"0","defaultValue":"cached","placeholder":"threadpool","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524865', '6', 'corethreads', 'corethreads', 1, 3, 0, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524866', '6', 'threads', 'threads', 1, 3, 0, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524867', '6', 'queues', 'queues', 1, 3, 0, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204173923', '6', 'timeout', 'timeout', 3, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204173924', '6', 'retries', 'retries', 3, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524868', '26', 'host', 'host', 2, 1, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524869', '26', 'protocol', 'protocol', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"ws://","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524870', '26', 'url', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524871', '26', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524872', '26', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524873', '26', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time ms)","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524874', '26', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524875', '26', 'loadBalance', 'loadStrategy', 3, 2, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524876', '26', 'retry', 'retryCount', 1, 2, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524877', '26', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524878', '26', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524879', '17', 'registerProtocol', 'registerProtocol', 2, 3, 0, '{"required":"0","defaultValue":"zk","placeholder":"registerProtocol","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1678997557628272641', '17', 'registerAddress', 'registerAddress', 2, 3, 1, '{"required":"0","defaultValue":"127.0.0.1:2181","placeholder":"registerAddress","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524880', '17', 'corethreads', 'corethreads', 1, 3, 2, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524881', '17', 'threads', 'threads', 1, 3, 3, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524882', '17', 'queues', 'queues', 1, 3, 4, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524883', '17', 'threadpool', 'threadpool', 3, 3, 5, '{"required":"0","defaultValue":"cached","placeholder":"threadpool","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524884', '28', 'port', 'port', 1, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524885', '28', 'bossGroupThreadCount', 'bossGroupThreadCount', 1, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524886', '28', 'maxPayloadSize', 'maxPayloadSize', 1, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524887', '28', 'workerGroupThreadCount', 'workerGroupThreadCount', 1, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524888', '28', 'userName', 'userName', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524889', '28', 'password', 'password', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524890', '28', 'isEncryptPassword', 'isEncryptPassword', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524891', '28', 'encryptMode', 'encryptMode', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524892', '28', 'leakDetectorLevel', 'leakDetectorLevel', 2, 3, 1, NULL, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524893', '29', 'topic', 'topic', 2, 3, 1, '{"required":"1","defaultValue":"shenyu-access-logging"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524894', '29', 'namesrvAddr', 'namesrvAddr', 2, 3, 2, '{"required":"1","defaultValue":"localhost:9876"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524895', '29', 'producerGroup', 'producerGroup', 2, 3, 3, '{"required":"1","defaultValue":"shenyu-plugin-logging-rocketmq"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941947', '29', 'accessKey', 'accessKey', 2, 3, 4, '{"required":"0","defaultValue":"","placeholder":"accessKey"}', '2022-08-20 21:00:00', '2022-08-20 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941948', '29', 'secretKey', 'secretKey', 2, 3, 5, '{"required":"0","defaultValue":"","placeholder":"secretKey"}', '2022-08-20 21:00:00', '2022-08-20 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524896', '29', 'sampleRate', 'sampleRate', 2, 3, 6, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524897', '29', 'maxResponseBody', 'maxResponseBody', 1, 3, 7, '{"required":"0","defaultValue":524288}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524898', '29', 'maxRequestBody', 'maxRequestBody', 1, 3, 8, '{"required":"0","defaultValue":524288}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524899', '29', 'compressAlg', 'compressAlg', 3, 3, 9, '{"required":"0","defaultValue":"none"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524900', '29', 'topic', 'topic', 2, 1, 1, '{"required":"0","defaultValue":"","placeholder":"optional"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524901', '29', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524902', '30', 'cacheType', 'cacheType', 3, 3, 1, '{"required":"1","defaultValue":"memory","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524903', '30', 'database', 'database', 1, 3, 2, '{"required":"0","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524904', '30', 'master', 'master', 2, 3, 3, '{"required":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524905', '30', 'mode', 'mode', 2, 3, 4, '{"required":"0","defaultValue":"standalone","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524906', '30', 'url', 'url', 2, 3, 5, '{"required":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524907', '30', 'password', 'password', 2, 3, 6, '{"required":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524908', '30', 'maxIdle', 'maxIdle', 1, 3, 7, '{"required":"0","defaultValue":"8","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524909', '30', 'minIdle', 'minIdle', 1, 3, 8, '{"required":"0","defaultValue":"0","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524910', '30', 'maxActive', 'maxActive', 1, 3, 9, '{"required":"0","defaultValue":"8","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524911', '30', 'maxWait', 'maxWait', 3, 3, 10, '{"required":"0","defaultValue":"-1","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524912', '30', 'timeoutSeconds', 'timeoutSeconds', 1, 2, 0, '{"required":"0","defaultValue":"60","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524913', '13', 'corethreads', 'corethreads', 1, 3, 3, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524914', '13', 'threads', 'threads', 1, 3, 4, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524915', '13', 'queues', 'queues', 1, 3, 5, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524916', '13', 'threadpool', 'threadpool', 3, 3, 2, '{"required":"0","defaultValue":"default","placeholder":"threadpool","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524917', '11', 'corethreads', 'corethreads', 1, 3, 4, '{"required":"0","defaultValue":"0","placeholder":"corethreads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524918', '11', 'threads', 'threads', 1, 3, 5, '{"required":"0","defaultValue":"2147483647","placeholder":"threads","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524919', '11', 'queues', 'queues', 1, 3, 6, '{"required":"0","defaultValue":"0","placeholder":"queues","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524920', '11', 'threadpool', 'threadpool', 3, 3, 3, '{"required":"0","defaultValue":"default","placeholder":"threadpool","rule":""}', '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1537326008606343168', '31', 'responseContent', 'responseContent', 2, 2, 0, '{"required":"0","rule":""}', '2022-06-16 14:47:37', '2022-06-16 14:50:39');
INSERT INTO "public"."plugin_handle" VALUES ('1537325892176658432', '31', 'httpStatusCode', 'httpStatusCode', 1, 2, 0, '{"required":"0","defaultValue":"200","rule":""}', '2022-06-16 14:47:09', '2022-06-16 14:50:39');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524921', '32', 'host', 'host', 2, 3, 2, '{"required":"1","defaultValue":"localhost"}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524922', '32', 'port', 'port', 2, 3, 3, '{"required":"1","defaultValue":"9200"}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941949', '32', 'username', 'username', 2, 3, 4, '{"required":"0","defaultValue":"","placeholder":"username"}', '2022-08-20 21:00:00', '2022-08-20 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941950', '32', 'password', 'password', 2, 3, 5, '{"required":"0","defaultValue":"","placeholder":"username"}', '2022-08-20 21:00:00', '2022-08-20 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902770941951', '32', 'authCache', 'authCache', 2, 3, 6, '{"required":"0","defaultValue":"","placeholder":"true|false"}', '2022-08-20 21:00:00', '2022-08-20 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524923', '32', 'sampleRate', 'sampleRate', 2, 3, 7, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524924', '32', 'maxResponseBody', 'maxResponseBody', 1, 3, 8, '{"required":"0","defaultValue":524288}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524925', '32', 'maxRequestBody', 'maxRequestBody', 1, 3, 9, '{"required":"0","defaultValue":524288}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524926', '32', 'compressAlg', 'compressAlg', 3, 3, 10, '{"required":"0","defaultValue":"none"}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524927', '32', 'indexName', 'indexName', 2, 3, 10, '{"required":"0","defaultValue":"shenyu-access-logging"}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524928', '32', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-06-19 22:00:00', '2022-06-19 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524929', '1', 'signRequestBody', 'signRequestBody', 3, 2, 9, '{"required":"0","defaultValue":"false","placeholder":"signRequestBody","rule":""}', '2022-06-29 10:08:02', '2022-06-29 10:08:02');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524950', '33', 'topic', 'topic', 2, 3, 1, '{"required":"1","defaultValue":"shenyu-access-logging"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524951', '33', 'namesrvAddr', 'namesrvAddr', 2, 3, 2, '{"required":"1","defaultValue":"localhost:9092"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524952', '33', 'sampleRate', 'sampleRate', 2, 3, 4, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524953', '33', 'maxResponseBody', 'maxResponseBody', 1, 3, 5, '{"required":"0","defaultValue":524288}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524954', '33', 'maxRequestBody', 'maxRequestBody', 1, 3, 6, '{"required":"0","defaultValue":524288}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524955', '33', 'compressAlg', 'compressAlg', 3, 3, 7, '{"required":"0","defaultValue":"none"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524956', '33', 'topic', 'topic', 2, 1, 1, '{"required":"0","defaultValue":"","placeholder":"optional"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524957', '33', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172858', '33', 'securityProtocol', 'securityProtocol', 3, 3, 8, '{"required":"0","defaultValue":""}', '2022-09-01 22:00:00', '2022-09-01 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172859', '33', 'saslMechanism', 'saslMechanism', 3, 3, 9, '{"required":"0","defaultValue":""}', '2022-09-01 22:00:00', '2022-09-01 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172860', '33', 'userName', 'userName', 2, 3, 10, '{"required":"0","defaultValue":""}', '2022-09-01 22:00:00', '2022-09-01 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172861', '33', 'passWord', 'passWord', 2, 3, 11, '{"required":"0","defaultValue":""}', '2022-09-01 22:00:00', '2022-09-01 22:00:00');


INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524962', '34', 'accessId', 'accessId', 2, 3, 0, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524963', '34', 'accessKey', 'accessKey', 2, 3, 1, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524964', '34', 'host', 'host', 2, 3, 2, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524965', '34', 'projectName', 'projectName', 2, 3, 3, '{"required":"0","defaultValue":"shenyu","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524966', '34', 'logStoreName', 'logStoreName', 2, 3, 4, '{"required":"0","defaultValue":"shenyu-logstore","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524967', '34', 'topic', 'topic', 2, 3, 5, '{"required":"0","defaultValue":"shenyu-topic","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524968', '34', 'ttlInDay', 'ttlInDay', 1, 3, 6, '{"required":"0","defaultValue":3,"placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524969', '34', 'shardCount', 'shardCount', 1, 3, 7, '{"required":"0","defaultValue":10,"placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524970', '34', 'sendThreadCount', 'sendThreadCount', 1, 3, 8, '{"required":"0","defaultValue":1,"placeholder":"1-500"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524971', '34', 'ioThreadCount', 'ioThreadCount', 1, 3, 9, '{"required":"0","defaultValue":1,"placeholder":"1-500"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524972', '34', 'sampleRate', 'sampleRate', 2, 3, 10, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524973', '34', 'maxRequestBody', 'maxRequestBody', 1, 3, 11, '{"required":"0","defaultValue":524288,"placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524974', '34', 'maxResponseBody', 'maxResponseBody', 1, 3, 12, '{"required":"0","defaultValue":524288,"placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524975', '34', 'bufferQueueSize', 'bufferQueueSize', 1, 3, 13, '{"required":"0","defaultValue":50000,"placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524976', '35', 'topic', 'topic', 2, 3, 1, '{"required":"1","defaultValue":"shenyu-access-logging"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524977', '35', 'serviceUrl', 'serviceUrl', 2, 3, 2, '{"required":"1","defaultValue":"pulsar://localhost:6650"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524978', '35', 'sampleRate', 'sampleRate', 2, 3, 4, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524979', '35', 'maxResponseBody', 'maxResponseBody', 1, 3, 5, '{"required":"0","defaultValue":524288}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524980', '35', 'maxRequestBody', 'maxRequestBody', 1, 3, 6, '{"required":"0","defaultValue":524288}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524981', '35', 'compressAlg', 'compressAlg', 3, 3, 7, '{"required":"0","defaultValue":"none"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524982', '36', 'secretId', 'secretId', 2, 3, 1, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524983', '36', 'secretKey', 'secretKey', 2, 3, 2, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524984', '36', 'endpoint', 'endpoint', 2, 3, 3, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524985', '36', 'topic', 'topic', 2, 3, 4, '{"required":"1","defaultValue":"","placeholder":""}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524986', '36', 'sendThreadCount', 'sendThreadCount', 1, 3, 5, '{"required":"0","defaultValue":1,"placeholder":"1-500"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524987', '36', 'totalSizeInBytes', 'totalSizeInBytes', 1, 3, 6, '{"required":"0","defaultValue":104857600}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524988', '36', 'maxSendThreadCount', 'maxSendThreadCount', 1, 3, 7, '{"required":"0","defaultValue":1,"placeholder":"availableProcessors + 1"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524989', '36', 'maxBlockSec', 'maxBlockSec', 1, 3, 8, '{"required":"0","defaultValue":60000}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524990', '36', 'maxBatchSize', 'maxBatchSize', 1, 3, 9, '{"required":"0","defaultValue":524288}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524991', '36', 'maxBatchCount', 'maxBatchCount', 1, 3, 10, '{"required":"0","defaultValue":4096}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524992', '36', 'lingerMs', 'lingerMs', 1, 3, 11, '{"required":"0","defaultValue":2000}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524993', '36', 'retries', 'retries', 1, 3, 12, '{"required":"0","defaultValue":10}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524994', '36', 'maxReservedAttempts', 'maxReservedAttempts', 1, 3, 13, '{"required":"0","defaultValue":11}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524995', '36', 'baseRetryBackoffMs', 'baseRetryBackoffMs', 1, 3, 14, '{"required":"0","defaultValue":100}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524996', '36', 'maxRetryBackoffMs', 'maxRetryBackoffMs', 1, 3, 15, '{"required":"0","defaultValue":50000}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524997', '38', 'host', 'host', 2, 3, 1, '{"required":"0","defaultValue":"127.0.0.1"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524998', '38', 'port', 'port', 2, 3, 2, '{"required":"0","defaultValue":"8123"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524999', '38', 'database', 'database', 2, 2, 0, '{"required":"0","defaultValue":"shenyu-gateway","placeholder":"database"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172800', '38', 'username', 'username', 2, 2, 0, '{"required":"0","defaultValue":"foo","placeholder":"username"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172801', '38', 'password', 'password', 2, 2, 0, '{"required":"0","defaultValue":"bar","placeholder":"password"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172777', '38', 'ttl', 'ttl', 3, 3, 10, '{"required":"0","defaultValue":"30"}', '2023-03-01 11:14:15', '2023-08-16 11:15:14');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172803', '10', 'flowRuleMaxQueueingTimeMs', 'flowRuleMaxQueueingTimeMs', 1, 2, 6, '{"required":"0","defaultValue":"500"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172804', '10', 'flowRuleWarmUpPeriodSec', 'flowRuleWarmUpPeriodSec', 1, 2, 6, '{"required":"0","defaultValue":"10"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172805', '14', 'addPrefixed', 'addPrefixed', 3, 2, 3, '{"required":"1","defaultValue":"false"}', '2022-09-27 12:00:00', '2022-09-27 12:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172806', '18', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172807', '18', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172808', '18', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172809', '29', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172810', '29', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172811', '29', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172812', '32', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172813', '32', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172814', '32', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172815', '33', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172816', '33', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172817', '33', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172818', '34', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172819', '34', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172820', '34', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172821', '35', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172822', '35', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172823', '35', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172824', '36', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172825', '36', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172826', '36', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}', '2022-09-22 00:17:21.150', '2022-09-22 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172827', '38', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2022-09-22 00:15:56.158', '2022-09-22 00:23:36.169');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172829', '38', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2022-09-22 00:16:27.342', '2022-09-22 00:16:27.342');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172830', '38', 'host', 'host', 2, 3, 3, '{"required":"1","defaultValue":"127.0.0.1"}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172831', '38', 'port', 'port', 2, 3, 4, '{"required":"1","defaultValue":"8123"}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172832', '38', 'database', 'database', 2, 3, 5, '{"required":"0","defaultValue":"shenyu-gateway"}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172833', '38', 'username', 'username', 2, 3, 6, '{"required":"1","defaultValue":""}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172834', '38', 'password', 'password', 2, 3, 7, '{"required":"1","defaultValue":""}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172835', '38', 'engine', 'engine', 3, 3, 8, '{"required":"0","defaultValue":"MergeTree"}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');
INSERT INTO "public"."plugin_handle" VALUES ('1529402613204172836', '38', 'clusterName', 'clusterName', 3, 3, 9, '{"required":"1","defaultValue":"cluster"}', '2023-01-02 00:17:21.150', '2023-01-02 00:17:21.150');


INSERT INTO "public"."plugin_handle" VALUES ('1570590990341775360', '39', 'endpoint', 'casdoor endpoint', 2, 3, 0, '{"required":"1","rule":""}', '2022-09-16 09:50:46', '2022-09-16 09:50:46');
INSERT INTO "public"."plugin_handle" VALUES ('1570591047635968000', '39', 'client_id', 'client_id', 2, 3, 0, '{"required":"1","rule":""}', '2022-09-16 09:50:46', '2022-09-16 09:50:46');
INSERT INTO "public"."plugin_handle" VALUES ('1570591109623586816', '39', 'client_secrect', 'client_secrect', 2, 3, 0, '{"required":"1","rule":""}', '2022-09-16 09:50:46', '2022-09-16 09:50:46');
INSERT INTO "public"."plugin_handle" VALUES ('1570591165374275584', '39', 'certificate', 'certificate', 2, 3, 0, '{"required":"1","rule":""}', '2022-09-16 09:50:46', '2022-09-16 09:50:46');
INSERT INTO "public"."plugin_handle" VALUES ('1570591215131303936', '39', 'organization-name', 'organization-name', 2, 3, 0, '{"required":"1","rule":""}', '2022-09-16 09:50:46', '2022-09-16 09:50:46');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312064', '39', 'application-name', 'application-name', 2, 3, 0, '{"required":"1","rule":""}', '2022-09-16 09:50:46', '2022-09-16 09:50:46');

INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312065', '43', 'projectId', 'projectId', 2, 3, 0, '{"required":"1","rule":""}', '2023-07-05 14:06:00.893', '2023-07-07 22:50:00.597');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312066', '43', 'logGroupId', 'logGroupId', 2, 3, 1, '{"required":"1","rule":""}', '2023-07-05 14:09:19.928', '2023-07-07 22:50:00.606');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312067', '43', 'logStreamId', 'logStreamId', 2, 3, 2, '{"required":"1","rule":""}', '2023-07-05 14:09:53.224', '2023-07-07 22:50:00.607');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312068', '43', 'accessKeyId', 'AccessKey', 2, 3, 4, '{"required":"1","rule":""}', '2023-07-05 14:10:41.897', '2023-07-07 22:50:00.608');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312069', '43', 'accessKeySecret', 'accessKey', 2, 3, 5, '{"required":"1","rule":""}', '2023-07-05 14:12:16.828', '2023-07-07 22:50:00.609');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312070', '43', 'regionName', 'regionName', 2, 3, 6, '{"required":"1","rule":""}', '2023-07-05 14:13:24.703', '2023-07-07 22:50:00.610');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312071', '43', 'totalSizeInBytes', 'totalSizeInBytes', 1, 3, 8, '{"required":"0","defaultValue":"104857600","rule":""}', '2023-07-05 14:15:16.913', '2023-07-07 22:50:00.611');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312072', '43', 'maxBlockMs', 'maxBlockMs', 1, 3, 9, '{"required":"0","defaultValue":"0","rule":""}', '2023-07-05 14:16:14.236', '2023-07-07 22:50:00.612');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312073', '43', 'ioThreadCount', 'ioThreadCount', 1, 3, 10, '{"required":"0","defaultValue":"1","rule":""}', '2023-07-05 14:17:12.065', '2023-07-07 22:50:00.612');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312074', '43', 'batchSizeThresholdInBytes', 'batchSizeThresholdInBytes', 1, 3, 11, '{"required":"0","defaultValue":"524288","rule":""}', '2023-07-05 14:18:27.915', '2023-07-07 22:50:00.614');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312075', '43', 'batchCountThreshold', 'batchCountThreshold', 1, 3, 12, '{"required":"0","defaultValue":"4096","rule":""}', '2023-07-05 14:19:27.704', '2023-07-07 22:50:00.615');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312076', '43', 'lingerMs', 'lingerMs', 1, 3, 12, '{"required":"0","defaultValue":"2000","rule":""}', '2023-07-05 14:20:11.908', '2023-07-07 22:50:00.616');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312077', '43', 'retries', 'retries', 1, 3, 13, '{"required":"0","defaultValue":"100","rule":""}', '2023-07-05 14:20:50.052', '2023-07-07 22:50:00.617');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312078', '43', 'baseRetryBackoffMs', 'baseRetryBackoffMs', 1, 3, 14, '{"required":"0","defaultValue":"100","rule":""}', '2023-07-05 14:22:03.347', '2023-07-07 22:50:00.618');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312079', '43', 'maxRetryBackoffMs', 'maxRetryBackoffMs', 1, 3, 15, '{"required":"0","defaultValue":"100","rule":""}', '2023-07-05 14:22:33.010', '2023-07-07 22:50:00.619');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312080', '43', 'enableLocalTest', 'enableLocalTest', 2, 3, 15, '{"required":"0","defaultValue":"false","rule":""}', '2023-07-05 14:25:13.500', '2023-07-07 22:50:00.619');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312081', '43', 'setGiveUpExtraLongSingleLog', 'setGiveUpExtraLongSingleLog', 2, 3, 16, '{"required":"0","defaultValue":"false","rule":""}', '2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312082', '43', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312083', '43', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312084', '43', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}','2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');

INSERT INTO "public"."plugin_handle" VALUES ('1678293333363167232', '42', 'discoveryHandler', 'discoveryHandler', 2, 1, 0, '{"required":"0","defaultValue":"url,protocol,status,weight","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997037438107648', '42', 'bossGroupThreadCount', 'bossGroupThreadCount', 2, 1, 1, '{"required":"0","defaultValue":"1","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997142656417792', '42', 'workerGroupThreadCount', 'workerGroupThreadCount', 2, 1, 2, '{"required":"0","defaultValue":"12","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997399104552960', '42', 'clientMaxIdleTimeMs', 'clientMaxIdleTimeMs', 2, 1, 7, '{"required":"0","defaultValue":"30000","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997479614218240', '42', 'clientPendingAcquireMaxCount', 'clientPendingAcquireMaxCount', 2, 1, 4, '{"required":"0","defaultValue":"5","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678996921914392576', '42', 'loadBalance', 'loadBalance', 3, 1, 3, '{"required":"0","defaultValue":"random","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997769998467072', '42', 'clientMaxLifeTimeMs', 'clientMaxLifeTimeMs', 2, 1, 8, '{"required":"0","defaultValue":"60000","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997277012557824', '42', 'clientMaxConnections', 'clientMaxConnections', 2, 1, 6, '{"required":"0","defaultValue":"20","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1678997557628272640', '42', 'clientPendingAcquireTimeout', 'clientPendingAcquireTimeout', 2, 1, 5, '{"required":"0","defaultValue":"5","rule":""}');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312085', '6', 'loadBalance', 'loadBalance', 3, 2, 3, '{"required":"0","defaultValue":"random","rule":""}', '2023-09-05 18:08:01', '2023-09-05 18:08:01');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312086', '44', 'defaultHandleJson', 'defaultHandleJson', 2, 3, 2, '{"required":"0","defaultValue":"{"authorization":"test:test123"}","placeholder":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');

INSERT INTO "public"."plugin_handle" VALUES ('1721435546642157568', '45', 'host', 'host', 2, 3, 0, '{"required":"1","defaultValue":"127.0.0.1","rule":""}', '2023-11-06 15:53:11.704', '2023-11-07 13:31:41.010');
INSERT INTO "public"."plugin_handle" VALUES ('1721435708743618560', '45', 'port', 'port', 1, 3, 0, '{"required":"1","defaultValue":"15672","rule":""}', '2023-11-06 15:53:50.352', '2023-11-07 13:31:41.016');
INSERT INTO "public"."plugin_handle" VALUES ('1721436368046264320', '45', 'password', 'password', 2, 3, 0, '{"required":"0","defaultValue":"admin","rule":""}', '2023-11-06 15:56:27.541', '2023-11-07 13:31:41.021');
INSERT INTO "public"."plugin_handle" VALUES ('1721436500343001088', '45', 'username', 'username', 2, 3, 0, '{"required":"0","defaultValue":"admin","rule":""}', '2023-11-06 15:56:59.084', '2023-11-07 13:31:41.025');
INSERT INTO "public"."plugin_handle" VALUES ('1721436639635836928', '45', 'exchangeName', 'exchangeName', 2, 3, 0, '{"required":"1","defaultValue":"","rule":""}', '2023-11-06 15:57:32.295', '2023-11-07 13:31:41.030');
INSERT INTO "public"."plugin_handle" VALUES ('1721436745583955968', '45', 'queueName', 'queueName', 2, 3, 0, '{"required":"1","defaultValue":"","rule":""}', '2023-11-06 15:57:57.553', '2023-11-07 13:31:41.035');
INSERT INTO "public"."plugin_handle" VALUES ('1721509996347617280', '45', 'routingKey', 'routingKey', 2, 3, 0, '{"required":"1","defaultValue":"","rule":""}', '2023-11-06 20:49:01.897', '2023-11-07 13:31:41.039');
INSERT INTO "public"."plugin_handle" VALUES ('1721725585461706752', '45', 'virtualHost', 'virtualHost', 2, 3, 0, '{"required":"1","defaultValue":"/","rule":""}', '2023-11-07 11:05:42.350', '2023-11-07 13:31:41.044');
INSERT INTO "public"."plugin_handle" VALUES ('1721725662875975680', '45', 'exchangeType', 'exchangeType', 2, 3, 0, '{"required":"1","defaultValue":"direct","rule":""}', '2023-11-07 11:06:00.803', '2023-11-07 13:31:41.048');
INSERT INTO "public"."plugin_handle" VALUES ('1722804180904927232', '45', 'durable', 'durable', 2, 3, 0, '{"required":"1","defaultValue":"true","placeholder":"true / false","rule":"/^(true|false)$/"}', '2023-11-07 11:06:00.803', '2023-11-07 13:31:41.048');
INSERT INTO "public"."plugin_handle" VALUES ('1722804370575548416', '45', 'exclusive', 'exclusive', 2, 3, 0, '{"required":"1","defaultValue":"false","placeholder":"true / false","rule":"/^(true|false)$/"}', '2023-11-07 11:06:00.803', '2023-11-07 13:31:41.048');
INSERT INTO "public"."plugin_handle" VALUES ('1722804461256400896', '45', 'autoDelete', 'autoDelete', 2, 3, 0, '{"required":"1","defaultValue":"false","placeholder":"true / false","rule":"/^(true|false)$/"}', '2023-11-07 11:06:00.803', '2023-11-07 13:31:41.048');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507008', '45', 'args', 'args', 2, 3, 0, '{"required":"0","defaultValue":"","placeholder":"args json","rule":""}', '2023-11-07 11:06:00.803', '2023-11-07 13:31:41.048');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507009', '45', 'sampleRate', 'sampleRate', 2, 3, 4, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507010', '45', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507011', '43', 'sampleRate', 'sampleRate', 2, 3, 17, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507012', '43', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507013', '36', 'sampleRate', 'sampleRate', 2, 3, 16, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507014', '36', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507015', '34', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507016', '35', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507017', '36', 'sampleRate', 'sampleRate', 2, 3, 11, '{"required":"0","defaultValue":"1","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507018', '36', 'sampleRate', 'sampleRate', 2, 1, 2, '{"required":"0","defaultValue":"","placeholder":"optional,0,0.01~1"}', '2022-07-04 22:00:00', '2022-07-04 22:00:00');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507021', '14', 'rewriteContextPath', 'rewriteContextPath', 2, 2, 2, '{"required":"0","defaultValue":""}', '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507022', '14', 'percentage', 'percentage', 1, 2, 3, '{"required":"1","defaultValue":"100"}', '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507023', '3', 'rewriteMetaData', 'rewriteMetaData', 3, 2, 3, '{"required":"1","defaultValue":"false"}', '2024-02-07 14:31:49', '2024-02-07 14:31:49');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507024', '8', 'registerType', 'registerType', 2, 3, 1, NULL, '2024-08-24 09:40:03.293', '2024-08-24 21:52:27.920');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507025', '8', 'serverLists', 'serverLists', 2, 3, 2, NULL, '2024-08-24 21:52:51.179', '2024-08-24 21:53:27.483');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507026', '8', 'props', 'props', 4, 3, 3, NULL, '2024-08-24 21:53:25.764', '2024-08-24 21:53:30.255');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507027', '20', 'preserveHost', 'preserveHost', 3, 2, 0, '{"required":"0","defaultValue":"false","rule":""}', '2024-12-05 22:00:02.251', '2024-12-05 22:00:02.251');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507028', '20', 'requestHeaderUniqueStrategy', 'requestHeaderUniqueStrategy', 2, 2, 1, '{"required":"0","rule":""}', '2024-12-13 22:36:54.299', '2024-12-13 22:36:54.299');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507029', '20', 'requestUniqueHeaders', 'requestUniqueHeaders', 2, 2, 2, '{"required":"0","rule":""}', '2024-12-13 22:37:29.959', '2024-12-13 22:37:29.959');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507030', '20', 'respHeaderUniqueStrategy', 'respHeaderUniqueStrategy', 2, 2, 3, '{"required":"0","rule":""}', '2024-12-13 22:37:48.239', '2024-12-13 22:37:48.239');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507031', '20', 'respUniqueHeaders', 'respUniqueHeaders', 2, 2, 4, '{"required":"0","rule":""}', '2024-12-13 22:38:05.726', '2024-12-13 22:38:05.726');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507032', '19', 'handleType', 'handleType', 2, 3, 1, '{"required":"0","rule":""}', '2025-01-02 17:20:50.233', '2025-01-02 17:20:50.233');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507033', '50', 'provider', 'provider', 3, 3, 1, '{"required":"1","defaultValue":"OpenAI","placeholder":"provider","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507034', '50', 'baseUrl', 'baseUrl', 2, 3, 2, '{"required":"1","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507036', '50', 'model', 'model', 2, 3, 3, '{"required":"1","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507035', '50', 'apiKey', 'apiKey', 2, 3, 4, '{"required":"1","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507037', '50', 'temperature', 'temperature', 2, 3, 5, '{"required":"0","rule":"", "placeholder":"optional,0,0.01~1"}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507038', '50', 'maxTokens', 'maxTokens', 2, 3, 6, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507039', '50', 'stream', 'stream', 3, 3, 7, '{"defaultValue":"false","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507040', '50', 'prompt', 'prompt', 2, 3, 8, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507049', '51', 'database', 'database', 1, 3, 2, '{"required":"0","defaultValue":"0","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507050', '51', 'master', 'master', 2, 3, 3, '{"required":"0","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507051', '51', 'mode', 'mode', 2, 3, 4, '{"required":"0","defaultValue":"standalone","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507052', '51', 'url', 'url', 2, 3, 5, '{"required":"0","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507053', '51', 'password', 'password', 2, 3, 6, '{"required":"0","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507054', '51', 'maxIdle', 'maxIdle', 1, 3, 7, '{"required":"0","defaultValue":"8","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507055', '51', 'minIdle', 'minIdle', 1, 3, 8, '{"required":"0","defaultValue":"0","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507056', '51', 'maxActive', 'maxActive', 1, 3, 9, '{"required":"0","defaultValue":"8","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507057', '51', 'maxWait', 'maxWait', 3, 3, 10, '{"required":"0","defaultValue":"-1","rule":""}', '2022-05-25 18:02:53', '2022-05-25 18:02:53');

-- ----------------------------
-- Table structure for resource
-- ----------------------------
DROP TABLE IF EXISTS "public"."resource";
CREATE TABLE "public"."resource" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "parent_id" varchar(128) COLLATE "pg_catalog"."default" NULL,
  "title" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(32) COLLATE "pg_catalog"."default" NULL,
  "url" varchar(32) COLLATE "pg_catalog"."default" NULL,
  "component" varchar(32) COLLATE "pg_catalog"."default" NULL,
  "resource_type" int4 NOT NULL,
  "sort" int4 NOT NULL,
  "icon" varchar(32) COLLATE "pg_catalog"."default" NULL,
  "is_leaf" int2 NOT NULL,
  "is_route" int4 NOT NULL,
  "perms" varchar(64) COLLATE "pg_catalog"."default" NULL,
  "status" int4 NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."resource"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."resource"."parent_id" IS 'resource parent primary key id';
COMMENT ON COLUMN "public"."resource"."title" IS 'title';
COMMENT ON COLUMN "public"."resource"."name" IS 'route name';
COMMENT ON COLUMN "public"."resource"."url" IS 'route url';
COMMENT ON COLUMN "public"."resource"."component" IS 'component';
COMMENT ON COLUMN "public"."resource"."resource_type" IS 'resource type eg 0:main menu 1:child menu 2:function button';
COMMENT ON COLUMN "public"."resource"."sort" IS 'sort';
COMMENT ON COLUMN "public"."resource"."icon" IS 'icon';
COMMENT ON COLUMN "public"."resource"."is_leaf" IS 'leaf node 0:no 1:yes';
COMMENT ON COLUMN "public"."resource"."is_route" IS 'route 1:yes 0:no';
COMMENT ON COLUMN "public"."resource"."perms" IS 'button permission description sys:user:add(add)/sys:user:edit(edit)';
COMMENT ON COLUMN "public"."resource"."status" IS 'status 1:enable 0:disable';
COMMENT ON COLUMN "public"."resource"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."resource"."date_updated" IS 'update time';
COMMENT ON TABLE "public"."resource" IS 'resource table';

-- ----------------------------
-- Records of resource
-- ----------------------------
INSERT INTO "public"."resource" VALUES ('1346775491550474240', '', 'SHENYU.MENU.PLUGIN.LIST', 'plug', '/plug', 'PluginList', 0, 0, 'dashboard', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346776175553376256', '', 'SHENYU.MENU.SYSTEM.MANAGMENT', 'system', '/system', 'system', 0, 2, 'setting', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346777157943259136', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.USER', 'manage', '/system/manage', 'manage', 1, 1, 'user', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346777449787125760', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.PLUGIN', 'plugin', '/config/plugin', 'plugin', 1, 2, 'book', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346777623011880960', '1357956838021890048', 'SHENYU.PLUGIN.PLUGINHANDLE', 'pluginhandle', '/config/pluginhandle', 'pluginhandle', 1, 3, 'down-square', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346777766301888512', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.AUTHEN', 'auth', '/config/auth', 'auth', 1, 4, 'audit', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346777907096285184', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.METADATA', 'metadata', '/config/metadata', 'metadata', 1, 5, 'snippets', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1346778036402483200', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.DICTIONARY', 'dict', '/config/dict', 'dict', 1, 6, 'ordered-list', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347032308726902784', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 0, '', 1, 0, 'system:manager:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347032395901317120', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 1, '', 1, 0, 'system:manager:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347032453707214848', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 2, '', 1, 0, 'system:manager:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347032509051056128', '1346777157943259136', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 3, '', 1, 0, 'system:manager:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347034027070337024', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:plugin:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347039054925148160', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:plugin:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347041326749691904', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:plugin:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347046566244003840', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', '', '', '', 2, 3, '', 1, 0, 'system:plugin:modify', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347047143350874112', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.ENABLE', '', '', '', 2, 4, '', 1, 0, 'system:plugin:disable', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347047203220369408', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 5, '', 1, 0, 'system:plugin:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347047555588042752', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:pluginHandler:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347047640145211392', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:pluginHandler:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347047695002513408', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:pluginHandler:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347047747305484288', '1346777623011880960', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 3, '', 1, 0, 'system:pluginHandler:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048004105940992', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:authen:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048101875167232', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:authen:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048145877610496', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:authen:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048240677269503', '1346777766301888512', 'SHENYU.PLUGIN.BATCH.OPENED', '', '', '', 2, 3, '', 1, 0, 'system:authen:open', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048240677269504', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.ENABLE', '', '', '', 2, 3, '', 1, 0, 'system:authen:disable', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048316216684544', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', '', '', '', 2, 4, '', 1, 0, 'system:authen:modify', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048776029843456', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 5, '', 1, 0, 'system:authen:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347048968414179328', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:meta:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049029323862016', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:meta:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049092552994816', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:meta:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049251395481600', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.ENABLE', '', '', '', 2, 3, '', 1, 0, 'system:meta:disable', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049317178945536', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', '', '', '', 2, 4, '', 1, 0, 'system:meta:modify', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049370014593024', '1346777907096285184', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 5, '', 1, 0, 'system:meta:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049542417264640', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:dict:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049598155370496', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:dict:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049659023110144', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:dict:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049731047698432', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.ENABLE', '', '', '', 2, 3, '', 1, 0, 'system:dict:disable', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1347049794008395776', '1346778036402483200', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 4, '', 1, 0, 'system:dict:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1350106119681622016', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.ROLE', 'role', '/system/role', 'role', 1, 0, 'usergroup-add', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1350107709494804480', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 0, '', 1, 0, 'system:role:add', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1350107842236137472', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 1, '', 1, 0, 'system:role:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1350112406754766848', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 2, '', 1, 0, 'system:role:delete', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1350112481253994496', '1350106119681622016', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 3, '', 1, 0, 'system:role:edit', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1350804501819195392', '1346777766301888512', 'SHENYU.BUTTON.SYSTEM.EDITRESOURCEDETAILS', '', '', '', 2, 6, '', 1, 0, 'system:authen:editResourceDetails', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1355163372527050752', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.RESOURCE', 'resource', '/system/resource', 'resource', 1, 2, 'menu', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1355165158419750912', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.MENU.ADD', '', '', '', 2, 1, '', 1, 0, 'system:resource:addMenu', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1355165353534578688', '1355163372527050752', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:resource:list', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1355165475785957376', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.MENU.DELETE', '', '', '', 2, 2, '', 1, 0, 'system:resource:deleteMenu', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1355165608565039104', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.MENU.EDIT', '', '', '', 2, 3, '', 1, 0, 'system:resource:editMenu', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1357956838021890048', '', 'SHENYU.MENU.CONFIG.MANAGMENT', 'config', '/config', 'config', 0, 1, 'api', 0, 0, '', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1357977745889132544', '1355163372527050752', 'SHENYU.BUTTON.RESOURCE.BUTTON.ADD', '', '', '', 2, 4, '', 1, 0, 'system:resource:addButton', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1357977912126177280', '1355163372527050752', 'SHENYU.SYSTEM.EDITOR', '', '', '', 2, 5, '', 1, 0, 'system:resource:editButton', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1357977971827900416', '1355163372527050752', 'SHENYU.SYSTEM.DELETEDATA', '', '', '', 2, 6, '', 1, 0, 'system:resource:deleteButton', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1386680049203195904', '1346777157943259136', 'SHENYU.BUTTON.DATA.PERMISSION.CONFIG', '', '', '', 2, 0, '', 1, 0, 'system:manager:configureDataPermission', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1386680049203195915', '1346777157943259136', 'SHENYU.COMMON.EXPORT', '', '', '', 2, 0, '', 1, 0, 'system:manager:exportConfig', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1386680049203195916', '1346777157943259136', 'SHENYU.COMMON.IMPORT', '', '', '', 2, 0, '', 1, 0, 'system:manager:importConfig', 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01');
INSERT INTO "public"."resource" VALUES ('1529403932772798464', '1346775491550474240', 'sign', 'sign', '/plug/sign', 'sign', 1, 0, 'pic-center', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187072', '1346775491550474240', 'sentinel', 'sentinel', '/plug/sentinel', 'sentinel', 1, 0, 'database', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187073', '1346775491550474240', 'sofa', 'sofa', '/plug/sofa', 'sofa', 1, 0, 'key', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187074', '1346775491550474240', 'resilience4j', 'resilience4j', '/plug/resilience4j', 'resilience4j', 1, 0, 'align-left', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187075', '1346775491550474240', 'tars', 'tars', '/plug/tars', 'tars', 1, 0, 'align-left', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187076', '1346775491550474240', 'contextPath', 'contextPath', '/plug/contextPath', 'contextPath', 1, 0, 'thunderbolt', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187077', '1346775491550474240', 'grpc', 'grpc', '/plug/grpc', 'grpc', 1, 0, 'highlight', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187078', '1346775491550474240', 'redirect', 'redirect', '/plug/redirect', 'redirect', 1, 0, 'align-left', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187079', '1346775491550474240', 'motan', 'motan', '/plug/motan', 'motan', 1, 0, 'highlight', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187080', '1346775491550474240', 'loggingConsole', 'loggingConsole', '/plug/loggingConsole', 'loggingConsole', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187081', '1346775491550474240', 'jwt', 'jwt', '/plug/jwt', 'jwt', 1, 0, 'pic-left', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187082', '1346775491550474240', 'waf', 'waf', '/plug/waf', 'waf', 1, 0, 'border-bottom', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187083', '1346775491550474240', 'request', 'request', '/plug/request', 'request', 1, 0, 'camera', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187084', '1346775491550474240', 'oauth2', 'oauth2', '/plug/oauth2', 'oauth2', 1, 0, 'retweet', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187085', '1346775491550474240', 'paramMapping', 'paramMapping', '/plug/paramMapping', 'paramMapping', 1, 0, 'pic-left', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187086', '1346775491550474240', 'modifyResponse', 'modifyResponse', '/plug/modifyResponse', 'modifyResponse', 1, 0, 'border-bottom', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187087', '1346775491550474240', 'cryptorRequest', 'cryptorRequest', '/plug/cryptorRequest', 'cryptorRequest', 1, 0, 'safety', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187088', '1346775491550474240', 'cryptorResponse', 'cryptorResponse', '/plug/cryptorResponse', 'cryptorResponse', 1, 0, 'database', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187089', '1346775491550474240', 'websocket', 'websocket', '/plug/websocket', 'websocket', 1, 0, 'border-bottom', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187090', '1346775491550474240', 'rewrite', 'rewrite', '/plug/rewrite', 'rewrite', 1, 0, 'redo', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187091', '1346775491550474240', 'rateLimiter', 'rateLimiter', '/plug/rateLimiter', 'rateLimiter', 1, 0, 'pic-center', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187092', '1346775491550474240', 'divide', 'divide', '/plug/divide', 'divide', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187093', '1346775491550474240', 'dubbo', 'dubbo', '/plug/dubbo', 'dubbo', 1, 0, 'align-left', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187095', '1346775491550474240', 'hystrix', 'hystrix', '/plug/hystrix', 'hystrix', 1, 0, 'fire', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187096', '1346775491550474240', 'generalContext', 'generalContext', '/plug/generalContext', 'generalContext', 1, 0, 'highlight', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187097', '1346775491550474240', 'mqtt', 'mqtt', '/plug/mqtt', 'mqtt', 1, 0, 'database', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187098', '1346775491550474240', 'loggingRocketMQ', 'loggingRocketMQ', '/plug/loggingRocketMQ', 'loggingRocketMQ', 1, 0, 'stop', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932781187099', '1346775491550474240', 'cache', 'cache', '/plug/cache', 'cache', 1, 0, 'stop', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656064', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:signSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656065', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:signSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656066', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:signSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656067', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:signSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656068', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:signRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656069', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:signRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656070', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:signRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656071', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:signRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656072', '1529403932772798464', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:sign:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656073', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656074', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656075', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656076', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656077', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656078', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656079', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656080', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinelRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656081', '1529403932781187072', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:sentinel:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656082', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656083', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656084', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656085', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656086', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656087', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656088', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656089', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:sofaRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656090', '1529403932781187073', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:sofa:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656091', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656092', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656093', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656094', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656095', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656096', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656097', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656098', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4jRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656099', '1529403932781187074', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:resilience4j:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656100', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656101', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656102', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656103', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656104', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656105', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656106', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656107', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:tarsRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656108', '1529403932781187075', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:tars:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656109', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656110', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656111', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656112', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656113', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656114', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656115', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656116', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPathRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656117', '1529403932781187076', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:contextPath:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656118', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656119', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656120', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656121', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656122', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656123', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656124', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656125', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:grpcRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656126', '1529403932781187077', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:grpc:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656127', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656128', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656129', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656130', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656131', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656132', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656133', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656134', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656135', '1529403932781187078', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:redirect:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656136', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:motanSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656137', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:motanSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656138', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:motanSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656139', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:motanSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656140', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:motanRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656141', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:motanRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656142', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:motanRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656143', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:motanRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656144', '1529403932781187079', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:motan:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656145', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656146', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656147', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656148', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656149', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656150', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656151', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656152', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsoleRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656153', '1529403932781187080', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingConsole:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656154', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656155', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656156', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656157', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656158', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656159', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656160', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656161', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:jwtRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656162', '1529403932781187081', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:jwt:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656163', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:wafSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656164', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:wafSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656165', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:wafSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656166', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:wafSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656167', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:wafRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656168', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:wafRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656169', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:wafRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656170', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:wafRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656171', '1529403932781187082', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:waf:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656172', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:requestSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656173', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:requestSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656174', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:requestSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656175', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:requestSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656176', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:requestRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656177', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:requestRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656178', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:requestRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656179', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:requestRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932877656180', '1529403932781187083', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:request:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850368', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Selector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850369', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Selector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850370', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Selector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850371', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Selector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850372', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Rule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850373', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Rule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850374', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Rule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850375', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2Rule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850376', '1529403932781187084', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:oauth2:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850377', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850378', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850379', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850380', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850381', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850382', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850383', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850384', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMappingRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850385', '1529403932781187085', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:paramMapping:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850386', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850387', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850388', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850389', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850390', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850391', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850392', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850393', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponseRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850394', '1529403932781187086', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:modifyResponse:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850395', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850396', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850397', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850398', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850399', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850400', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850401', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850402', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequestRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850403', '1529403932781187087', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorRequest:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850404', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850405', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850406', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850407', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850408', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850409', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850410', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850411', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponseRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850412', '1529403932781187088', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:cryptorResponse:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850413', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850414', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850415', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850416', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850417', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850418', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850419', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850420', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:websocketRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850421', '1529403932781187089', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:websocket:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850422', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850423', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850424', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850425', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850426', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850427', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850428', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850429', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:rewriteRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850430', '1529403932781187090', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:rewrite:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850431', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850432', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850433', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850434', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850435', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850436', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850437', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850438', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiterRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850439', '1529403932781187091', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:rateLimiter:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850440', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:divideSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850441', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:divideSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850442', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:divideSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850443', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:divideSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850444', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:divideRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850445', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:divideRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850446', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:divideRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850447', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:divideRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850448', '1529403932781187092', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:divide:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850449', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850450', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850451', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850452', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850453', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850454', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850455', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850456', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:dubboRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850457', '1529403932781187093', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:dubbo:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850467', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850468', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850469', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850470', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850471', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850472', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850473', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850474', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrixRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850475', '1529403932781187095', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:hystrix:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850476', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850477', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850478', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850479', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850480', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850481', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850482', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850483', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContextRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850484', '1529403932781187096', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:generalContext:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850485', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850486', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850487', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850488', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850489', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850490', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850491', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850492', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:mqttRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850493', '1529403932781187097', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:mqtt:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850494', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850495', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850496', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850497', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850498', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850499', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850500', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850501', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850502', '1529403932781187098', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingRocketMQ:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850503', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850504', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850505', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850506', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850507', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850508', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850509', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850510', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:cacheRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1529403932881850511', '1529403932781187099', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:cache:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534577121923309568', '', 'SHENYU.MENU.DOCUMENT', '', '/document', '', 0, 3, 'file-text', 0, 0, '', 1, '2022-06-09 00:44:32', '2022-06-09 01:06:45');
INSERT INTO "public"."resource" VALUES ('1534585430311051264', '1534577121923309568', 'SHENYU.MENU.DOCUMENT.APIDOC', '', '/document/apidoc', '', 1, 0, 'api', 0, 0, '', 1, '2022-06-09 01:17:32', '2022-06-09 01:17:32');
INSERT INTO "public"."resource" VALUES ('1534585531108564992', '1534585430311051264', 'send', '', '', '', 2, 0, '', 1, 0, 'document:apirun:send', 1, '2022-06-09 01:17:56', '2022-06-09 01:17:56');

INSERT INTO "public"."resource" VALUES ('1534585531108564993', '1346775491550474240', 'loggingAliyunSls', 'loggingAliyunSls', '/plug/loggingAliyunSls', 'loggingAliyunSls', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108564994', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108564995', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108564996', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108564997', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108564998', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108564999', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565000', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565001', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSlsRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565002', '1534585531108564993', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingAliyunSls:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');

INSERT INTO "public"."resource" VALUES ('1534585531108565003', '1346775491550474240', 'loggingTencentCls', 'loggingTencentCls', '/plug/loggingTencentCls', 'loggingTencentCls', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565004', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565005', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565006', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565007', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565008', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565009', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565010', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565011', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentClsRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565012', '1534585531108565003', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingTencentCls:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');

INSERT INTO "public"."resource" VALUES ('1534585531108565013', '1346775491550474240', 'loggingKafka', 'loggingKafka', '/plug/loggingKafka', 'loggingKafka', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565014', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565015', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565016', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565017', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565018', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565019', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565020', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565021', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafkaRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565022', '1534585531108565013', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingKafka:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');

INSERT INTO "public"."resource" VALUES ('1534585531108565023', '1346775491550474240', 'loggingPulsar', 'loggingPulsar', '/plug/loggingPulsar', 'loggingPulsar', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565024', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565025', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565026', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565027', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565028', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565029', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565030', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565031', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsarRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565032', '1534585531108565023', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingPulsar:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');

INSERT INTO "public"."resource" VALUES ('1534585531108565033', '1346775491550474240', 'loggingElasticSearch', 'loggingElasticSearch', '/plug/loggingElasticSearch', 'loggingElasticSearch', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565034', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565035', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565036', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565037', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565038', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565039', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565040', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565041', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearchRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565042', '1534585531108565033', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingElasticSearch:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');

INSERT INTO "public"."resource" VALUES ('1534585531108565043', '1346775491550474240', 'loggingClickHouse', 'loggingClickHouse', '/plug/loggingClickHouse', 'loggingClickHouse', 1, 0, 'block', 0, 0, '', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565044', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseSelector:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565045', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseSelector:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565046', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseSelector:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565047', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseSelector:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565048', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseRule:add', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565049', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseRule:query', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565050', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseRule:edit', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565051', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouseRule:delete', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');
INSERT INTO "public"."resource" VALUES ('1534585531108565052', '1534585531108565043', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingClickHouse:modify', 1, '2022-05-25 18:08:07', '2022-05-25 18:08:07');

INSERT INTO "public"."resource" VALUES ('1572525965625266177', '1346775491550474240', 'loggingHuaweiLts', 'loggingHuaweiLts', '/plug/loggingHuaweiLts', 'loggingHuaweiLts', 1, 0, 'block', 0, 0, '', 1, '2023-07-05 14:03:53.699', '2023-07-05 14:03:53.709');
INSERT INTO "public"."resource" VALUES ('1572525965625266178', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:add', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266179', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:delete', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266180', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:edit', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266181', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:query', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266182', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:add', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266183', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:delete', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266184', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:edit', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266185', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:query', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266186', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLts:modify', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');

INSERT INTO "public"."resource" VALUES ('1572525965625266176', '1346777449787125760', 'SHENYU.BUTTON.SYSTEM.RESOURCE', '', '', '', 2, 6, '', 1, 0, 'system:plugin:resource', 1, '2022-09-28 11:50:58', '2022-09-28 11:50:58');
INSERT INTO "public"."resource" VALUES ('1697141926247763968','1346776175553376256','SHENYU.MENU.SYSTEM.MANAGMENT.ALERT','','/system/alert','',1,3,'alert',0,0,'',1,'2023-08-31 14:59:01.245','2023-08-31 06:59:01.249');
INSERT INTO "public"."resource" VALUES ('1697146375729025024', '1697141926247763968', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, 'unordered-list', 1, 0, 'system:alert:list', 1, '2023-08-31 15:16:42.249', '2023-08-31 07:22:07.249');
INSERT INTO "public"."resource" VALUES ('1697145808210333696','1697141926247763968','SHENYU.BUTTON.SYSTEM.ADD','','','',2,0,'plus',1,0,'system:alert:add',1,'2023-08-31 15:14:26.778','2023-08-31 07:14:26.780');
INSERT INTO "public"."resource" VALUES ('1697146617513873408','1697141926247763968','SHENYU.BUTTON.SYSTEM.DELETE','','','',2,0,'delete',1,0,'system:alert:delete',1,'2023-08-31 15:17:39.731','2023-08-31 07:22:07.675');
INSERT INTO "public"."resource" VALUES ('1697146860540235776','1697141926247763968','SHENYU.BUTTON.SYSTEM.EDIT','','','',2,0,'edit',1,0,'system:alert:edit',1,'2023-08-31 15:18:37.673','2023-08-31 07:18:37.675');

INSERT INTO "public"."resource" VALUES ('1844015648095666176', '1346776175553376256', 'SHENYU.MENU.SYSTEM.MANAGMENT.SCALE', '', '/system/scale', '', 1, 4, 'sliders', 0, 0, '', 1, '2024-10-09 22:02:45.317000', '2024-10-10 14:33:43.897017');
INSERT INTO "public"."resource" VALUES ('1844025735425183744', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, 'unordered-list', 1, 0, 'system:scale:list', 1, '2024-10-09 22:42:50.322000', '2024-10-09 22:42:50.325462');
INSERT INTO "public"."resource" VALUES ('1844025850382667776', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 0, 'plus', 1, 0, 'system:scale:add', 1, '2024-10-09 22:43:17.731000', '2024-10-09 22:43:17.731661');
INSERT INTO "public"."resource" VALUES ('1844025989214130176', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 0, 'delete', 1, 0, 'system:scale:delete', 1, '2024-10-09 22:43:50.831000', '2024-10-09 22:43:50.831705');
INSERT INTO "public"."resource" VALUES ('1844026099075534848', '1844015648095666176', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 0, 'edit', 1, 0, 'system:scale:edit', 1, '2024-10-09 22:44:17.024000', '2024-10-09 22:44:17.024555');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS "public"."role";
CREATE TABLE "public"."role" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "role_name" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."role"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."role"."role_name" IS 'role name';
COMMENT ON COLUMN "public"."role"."description" IS 'role describe';
COMMENT ON COLUMN "public"."role"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."role"."date_updated" IS 'update time';
COMMENT ON TABLE "public"."role" IS 'role table';

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO "public"."role" VALUES ('1346358560427216896', 'super', 'Administrator', '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."role" VALUES ('1385482862971723776', 'default', 'Standard', '2022-05-25 18:08:02', '2022-05-25 18:08:02');

-- ----------------------------
-- Table structure for rule
-- ----------------------------
DROP TABLE IF EXISTS "public"."rule";
CREATE TABLE "public"."rule" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "selector_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "match_mode" int4 NOT NULL,
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "enabled" int2 NOT NULL,
  "loged" int2 NOT NULL,
  "match_restful" int2 NOT NULL,
  "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "sort" int4 NOT NULL,
  "handle" varchar(1024) COLLATE "pg_catalog"."default",
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."rule"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."rule"."selector_id" IS 'selector id';
COMMENT ON COLUMN "public"."rule"."match_mode" IS 'matching mode (0 and 1 or)';
COMMENT ON COLUMN "public"."rule"."name" IS 'rule name';
COMMENT ON COLUMN "public"."rule"."enabled" IS 'whether to open (0 close, 1 open) ';
COMMENT ON COLUMN "public"."rule"."loged" IS 'whether to log or not (0 no print, 1 print) ';
COMMENT ON COLUMN "public"."rule"."match_restful" IS 'whether to match restful(0 cache, 1 not cache)';
COMMENT ON COLUMN "public"."rule"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."rule"."sort" IS 'sort';
COMMENT ON COLUMN "public"."rule"."handle" IS 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)';
COMMENT ON COLUMN "public"."rule"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."rule"."date_updated" IS 'update time';

-- ----------------------------
-- Records of rule
-- ----------------------------

-- ----------------------------
-- Table structure for rule_condition
-- ----------------------------
DROP TABLE IF EXISTS "public"."rule_condition";
CREATE TABLE "public"."rule_condition" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "rule_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "param_type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "operator" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "param_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "param_value" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."rule_condition"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."rule_condition"."rule_id" IS 'rule id';
COMMENT ON COLUMN "public"."rule_condition"."param_type" IS 'parameter type (post query uri, etc.)';
COMMENT ON COLUMN "public"."rule_condition"."operator" IS 'matching character (=> <like match)';
COMMENT ON COLUMN "public"."rule_condition"."param_name" IS 'parameter name';
COMMENT ON COLUMN "public"."rule_condition"."param_value" IS 'parameter value';
COMMENT ON COLUMN "public"."rule_condition"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."rule_condition"."date_updated" IS 'update time';

-- ----------------------------
-- Records of rule_condition
-- ----------------------------

-- ----------------------------
-- Table structure for selector
-- ----------------------------
DROP TABLE IF EXISTS "public"."selector";
CREATE TABLE "public"."selector" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "plugin_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "match_mode" int4 NOT NULL,
  "type" int4 NOT NULL,
  "sort" int4 NOT NULL,
  "handle" varchar(1024) COLLATE "pg_catalog"."default",
  "enabled" int2 NOT NULL,
  "loged" int2 NOT NULL,
  "continued" int2 NOT NULL,
  "match_restful" int2 NOT NULL,
  "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."selector"."id" IS 'primary key id varchar';
COMMENT ON COLUMN "public"."selector"."plugin_id" IS 'plugin id';
COMMENT ON COLUMN "public"."selector"."name" IS 'selector name';
COMMENT ON COLUMN "public"."selector"."match_mode" IS 'matching mode (0 and 1 or)';
COMMENT ON COLUMN "public"."selector"."type" IS 'type (0, full flow, 1 custom flow)';
COMMENT ON COLUMN "public"."selector"."sort" IS 'sort';
COMMENT ON COLUMN "public"."selector"."handle" IS 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)';
COMMENT ON COLUMN "public"."selector"."enabled" IS 'whether to open (0 close, 1 open) ';
COMMENT ON COLUMN "public"."selector"."loged" IS 'whether to print the log (0 no print, 1 print) ';
COMMENT ON COLUMN "public"."selector"."continued" IS 'whether to continue execution';
COMMENT ON COLUMN "public"."selector"."match_restful" IS 'whether to match restful(0 cache, 1 not cache)';
COMMENT ON COLUMN "public"."selector"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."selector"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."selector"."date_updated" IS 'update time';

-- ----------------------------
-- Records of selector
-- ----------------------------

-- ----------------------------
-- Table structure for selector_condition
-- ----------------------------
DROP TABLE IF EXISTS "public"."selector_condition";
CREATE TABLE "public"."selector_condition" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "selector_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "param_type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "operator" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "param_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "param_value" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."selector_condition"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."selector_condition"."selector_id" IS 'selector id';
COMMENT ON COLUMN "public"."selector_condition"."param_type" IS 'parameter type (to query uri, etc.)';
COMMENT ON COLUMN "public"."selector_condition"."operator" IS 'matching character (=> <like matching)';
COMMENT ON COLUMN "public"."selector_condition"."param_name" IS 'parameter name';
COMMENT ON COLUMN "public"."selector_condition"."param_value" IS 'parameter value';
COMMENT ON COLUMN "public"."selector_condition"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."selector_condition"."date_updated" IS 'update time';

-- ----------------------------
-- Records of selector_condition
-- ----------------------------

-- ----------------------------
-- Table structure for shenyu_dict
-- ----------------------------
DROP TABLE IF EXISTS "public"."shenyu_dict";
CREATE TABLE "public"."shenyu_dict" (
  "id" varchar(128) NOT NULL DEFAULT nextval('shenyu_dict_id_seq'::regclass),
  "type" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "dict_code" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "dict_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "dict_value" varchar(2048) COLLATE "pg_catalog"."default",
  "desc" varchar(255) COLLATE "pg_catalog"."default",
  "sort" int4 NOT NULL,
  "enabled" int2,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."shenyu_dict"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."shenyu_dict"."type" IS 'type';
COMMENT ON COLUMN "public"."shenyu_dict"."dict_code" IS 'dictionary encoding';
COMMENT ON COLUMN "public"."shenyu_dict"."dict_name" IS 'dictionary name';
COMMENT ON COLUMN "public"."shenyu_dict"."dict_value" IS 'dictionary value';
COMMENT ON COLUMN "public"."shenyu_dict"."desc" IS 'dictionary description or remarks';
COMMENT ON COLUMN "public"."shenyu_dict"."sort" IS 'sort';
COMMENT ON COLUMN "public"."shenyu_dict"."enabled" IS 'whether it is enabled (0 close, 1 open) ';
COMMENT ON COLUMN "public"."shenyu_dict"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."shenyu_dict"."date_updated" IS 'update time';

-- ----------------------------
-- Records of shenyu_dict
-- ----------------------------
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107776', 'degradeRuleGrade', 'DEGRADE_GRADE_RT', 'slow call ratio', '0', 'degrade type-slow call ratio', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107777', 'degradeRuleGrade', 'DEGRADE_GRADE_EXCEPTION_RATIO', 'exception ratio', '1', 'degrade type-abnormal ratio', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107778', 'degradeRuleGrade', 'DEGRADE_GRADE_EXCEPTION_COUNT', 'exception number strategy', '2', 'degrade type-abnormal number strategy', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107779', 'flowRuleGrade', 'FLOW_GRADE_QPS', 'QPS', '1', 'grade type-QPS', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107780', 'flowRuleGrade', 'FLOW_GRADE_THREAD', 'number of concurrent threads', '0', 'degrade type-number of concurrent threads', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107781', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_DEFAULT', 'direct rejection by default', '0', 'control behavior-direct rejection by default', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107782', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_WARM_UP', 'warm up', '1', 'control behavior-warm up', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107783', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_RATE_LIMITER', 'constant speed queuing', '2', 'control behavior-uniform speed queuing', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107784', 'flowRuleControlBehavior', 'CONTROL_BEHAVIOR_WARM_UP_RATE_LIMITER', 'preheating uniformly queued', '3', 'control behavior-preheating uniformly queued', 3, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107785', 'permission', 'REJECT', 'reject', 'reject', 'reject', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107786', 'permission', 'ALLOW', 'allow', 'allow', 'allow', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107787', 'algorithmName', 'ALGORITHM_SLIDINGWINDOW', 'slidingWindow', 'slidingWindow', 'Sliding window algorithm', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107788', 'algorithmName', 'ALGORITHM_LEAKYBUCKET', 'leakyBucket', 'leakyBucket', 'Leaky bucket algorithm', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107789', 'algorithmName', 'ALGORITHM_CONCURRENT', 'concurrent', 'concurrent', 'Concurrent algorithm', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107790', 'algorithmName', 'ALGORITHM_TOKENBUCKET', 'tokenBucket', 'tokenBucket', 'Token bucket algorithm', 3, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107791', 'loadBalance', 'LOAD_BALANCE', 'roundRobin', 'roundRobin', 'roundRobin', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107792', 'loadBalance', 'LOAD_BALANCE', 'random', 'random', 'random', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107793', 'loadBalance', 'LOAD_BALANCE', 'hash', 'hash', 'hash', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107794', 'status', 'DIVIDE_STATUS', 'close', 'false', 'close', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107795', 'status', 'DIVIDE_STATUS', 'open', 'true', 'open', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107796', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'multiple rule', '1', 'multiple rule', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107797', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'single rule', '0', 'single rule', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107798', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'multiple handle', '1', 'multiple handle', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107799', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'single handle', '0', 'single handle', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107800', 'matchMode', 'MATCH_MODE', 'and', '0', 'and', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107801', 'matchMode', 'MATCH_MODE', 'or', '1', 'or', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107802', 'operator', 'OPERATOR', 'match', 'match', 'match', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107803', 'operator', 'OPERATOR', '=', '=', '=', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107804', 'operator', 'OPERATOR', 'regex', 'regex', 'regex', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107805', 'operator', 'OPERATOR', 'contains', 'contains', 'contains', 3, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107806', 'operator', 'OPERATOR', 'TimeBefore', 'TimeBefore', 'TimeBefore', 4, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107807', 'operator', 'OPERATOR', 'TimeAfter', 'TimeAfter', 'TimeAfter', 5, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107808', 'operator', 'OPERATOR', 'exclude', 'exclude', 'exclude', 6, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107809', 'operator', 'OPERATOR', 'startsWith', 'startsWith', 'startsWith', 7, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107810', 'operator', 'OPERATOR', 'endsWith', 'endsWith', 'endWiths', 8, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1629403902796107810', 'operator', 'OPERATOR', 'pathPattern', 'pathPattern', 'pathPattern', 9, 1, '2022-07-19 18:08:02', '2022-07-19 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1629403902796107811', 'operator', 'OPERATOR', 'isBlank', 'isBlank', 'isBlank', 10, 1, '2023-08-10 11:11:18', '2023-08-10 11:11:18');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107811', 'paramType', 'PARAM_TYPE', 'post', 'post', 'post', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107812', 'paramType', 'PARAM_TYPE', 'uri', 'uri', 'uri', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107813', 'paramType', 'PARAM_TYPE', 'query', 'query', 'query', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107814', 'paramType', 'PARAM_TYPE', 'host', 'host', 'host', 3, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107815', 'paramType', 'PARAM_TYPE', 'ip', 'ip', 'ip', 4, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107816', 'paramType', 'PARAM_TYPE', 'header', 'header', 'header', 5, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107817', 'paramType', 'PARAM_TYPE', 'cookie', 'cookie', 'cookie', 6, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107818', 'paramType', 'PARAM_TYPE', 'req_method', 'req_method', 'req_method', 7, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107819', 'keyResolverName', 'WHOLE_KEY_RESOLVER', 'whole', 'WHOLE_KEY_RESOLVER', 'Rate limit by all request', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107820', 'keyResolverName', 'REMOTE_ADDRESS_KEY_RESOLVER', 'remoteAddress', 'REMOTE_ADDRESS_KEY_RESOLVER', 'Rate limit by remote address', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107821', 'automaticTransitionFromOpenToHalfOpenEnabled', 'AUTOMATIC_HALF_OPEN', 'open', 'true', '', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107822', 'automaticTransitionFromOpenToHalfOpenEnabled', 'AUTOMATIC_HALF_OPEN', 'close', 'false', '', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107823', 'paramType', 'PARAM_TYPE', 'domain', 'domain', 'domain', 8, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107824', 'strategyName', 'STRATEGY_NAME', 'rsa', 'rsa', 'rsa strategy', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902796107825', 'way', 'WAY', 'encrypt', 'encrypt', 'encrypt', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302080', 'way', 'WAY', 'decrypt', 'decrypt', 'decrypt', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302081', 'mode', 'MODE', 'cluster', 'cluster', 'cluster', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302082', 'mode', 'MODE', 'sentinel', 'sentinel', 'sentinel', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302083', 'mode', 'MODE', 'standalone', 'standalone', 'standalone', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302084', 'gray', 'GRAY_STATUS', 'close', 'false', 'close', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302085', 'gray', 'GRAY_STATUS', 'open', 'true', 'open', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302086', 'threadpool', 'THREADPOOL', 'shared', 'shared', '', 4, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302087', 'threadpool', 'THREADPOOL', 'fixed', 'fixed', '', 3, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302088', 'threadpool', 'THREADPOOL', 'eager', 'eager', '', 2, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302089', 'threadpool', 'THREADPOOL', 'cached', 'cached', '', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302090', 'threadpool', 'THREADPOOL', 'limited', 'limited', '', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302091', 'retryStrategy', 'RETRY_STRATEGY', 'current', 'current', 'current', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302092', 'retryStrategy', 'RETRY_STRATEGY', 'failover', 'failover', 'failover', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302094', 'compressAlg', 'COMPRESS_ALG', 'none', 'none', '', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302095', 'compressAlg', 'COMPRESS_ALG', 'LZ4', 'LZ4', '', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302096', 'cacheType', 'CACHE_TYPE_MEMORY', 'memory', 'memory', 'use memory to cache data', 0, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302097', 'cacheType', 'CACHE_TYPE_REDIS', 'redis', 'redis', 'use redis to cache data', 1, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302093', 'table', 'INIT_FLAG', 'status', 'true', 'table(resource,permission) init status', 0, 0, '2022-05-25 18:08:02', '2022-05-25 18:08:07.275');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302098', 'threadpool', 'THREADPOOL', 'default', 'default', '', 5, 1, '2022-05-25 18:08:02', '2022-05-25 18:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302099', 'signRequestBody', 'SIGN_REQUEST_BODY', 'close', 'false', 'close', 1, 1, '2022-06-29 10:08:02', '2022-06-29 10:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1529403902800302100', 'signRequestBody', 'SIGN_REQUEST_BODY', 'open', 'true', 'open', 0, 1, '2022-06-29 10:08:02', '2022-06-29 10:08:02');
INSERT INTO "public"."shenyu_dict" VALUES ('1545811989312315392', 'apidoc', 'API_DOC_GLOBAL_FLAG', 'status', 'true', 'Global switching (on or off) of API documents.', 0, 1, '2022-07-10 00:47:52', '2022-07-10 00:47:52');
INSERT INTO "public"."shenyu_dict" VALUES ('1545812101056962560', 'apidocEnv', 'ENV_LABEL_OFFLINE', 'Offline', 'http://127.0.0.1:9195', 'Offline environment', 0, 1, '2022-07-10 00:48:19', '2022-07-10 00:48:19');
INSERT INTO "public"."shenyu_dict" VALUES ('1545812228228259840', 'apidocEnv', 'ENV_LABEL_ONLINE', 'Online', 'http://127.0.0.1:9196', 'Online environment', 1, 1, '2022-07-10 00:48:49', '2022-07-10 00:48:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784271', 'securityProtocol', 'SECURITY_PROTOCOL', 'default', '', '', 0, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784272', 'securityProtocol', 'SECURITY_PROTOCOL', 'SSL', 'SSL', '', 1, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784273', 'securityProtocol', 'SECURITY_PROTOCOL', 'PLAINTEXT', 'PLAINTEXT', '', 2, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784274', 'securityProtocol', 'SECURITY_PROTOCOL', 'SASL_PLAINTEXT', 'SASL_PLAINTEXT', '', 3, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784275', 'securityProtocol', 'SECURITY_PROTOCOL', 'SASL_SSL', 'SASL_SSL', '', 4, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784276', 'saslMechanism', 'SASL_MECHANISM', 'default', '', '', 0, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784277', 'saslMechanism', 'SASL_MECHANISM', 'GSSAPI', 'GSSAPI', '', 1, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784278', 'saslMechanism', 'SASL_MECHANISM', 'PLAIN', 'PLAIN', '', 2, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784279', 'saslMechanism', 'SASL_MECHANISM', 'OAUTHBEARER', 'OAUTHBEARER', '', 3, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784280', 'saslMechanism', 'SASL_MECHANISM', 'SCRAM-SHA-256', 'SCRAM-SHA-256', '', 4, 1,'2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784281', 'saslMechanism', 'SASL_MECHANISM', 'SCRAM-SHA-512', 'SCRAM-SHA-512', '', 5, 1, '2022-09-02 00:00:00', '2022-09-02 00:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784282', 'addPrefixed', 'ADD_PREFIXED', 'open', 'true', '', 0, 1, '2022-09-27 12:00:00', '2022-09-27 12:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1529402613195784283', 'addPrefixed', 'ADD_PREFIXED', 'close', 'false', '', 1, 1, '2022-09-27 12:00:00', '2022-09-27 12:00:00');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621145865248768', 'keyword', 'MASK_KEYWORD', 'keyword', 'keyword', '', 0, 1, '2022-09-22 00:17:55.137', '2022-09-22 00:17:55.137');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621497251454976', 'maskType', 'MASKTYPE_ENCRYPT', 'encrypt', 'dataMaskByMD5', '', 0, 1, '2022-09-22 00:19:17.595', '2022-09-22 00:19:17.595');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621587282190336', 'maskType', 'MASKTYPE_REPLACE', 'replace', 'dataMaskByCharReplace', '', 0, 1, '2022-09-22 00:19:39.060', '2022-09-22 00:19:39.060');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621912915369984', 'maskStatus', 'MASK_STATUS_FALSE', 'notmask', 'false', '', 0, 1, '2022-09-22 00:20:56.693', '2022-09-22 00:20:56.693');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762304', 'maskStatus', 'MASK_STATUS_TRUE', 'mask', 'true', '', 0, 1, '2022-09-22 00:21:11.924', '2022-09-22 00:21:11.924');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762305', 'engine', 'engine', 'ReplacingMergeTree', 'ReplacingMergeTree', '', 0, 1, '2022-09-22 00:21:11.924', '2022-09-22 00:21:11.924');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762306', 'engine', 'engine', 'MergeTree', 'MergeTree', '', 1, 1, '2022-09-22 00:21:11.924', '2022-09-22 00:21:11.924');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762310', 'engine', 'engine', 'ReplicatedReplicatedMergeTree', 'ReplicatedReplicatedMergeTree', '', 2, 1, '2023-03-01 11:14:15', '2023-08-16 11:15:14');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762311', 'engine', 'engine', 'ReplicatedMergeTree', 'ReplicatedMergeTree', '', 3, 1, '2023-03-01 11:14:15', '2023-08-16 11:15:14');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762307', 'loadBalance', 'LOAD_BALANCE', 'leastActive', 'leastActive', 'leastActive', 3, 1, '2023-01-17 18:02:52.924', '2023-01-17 18:02:52.924');
INSERT INTO "public"."shenyu_dict" VALUES ('1630761573833920512', 'mapType', 'mapType', 'all', 'all', '', 1, 1, '2023-03-01 10:47:11', '2023-03-01 10:47:11');
INSERT INTO "public"."shenyu_dict" VALUES ('1630761984393367552', 'mapType', 'mapType', 'field', 'field', '', 1, 1, '2023-03-01 10:48:49', '2023-03-01 10:48:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762308', 'loadBalance', 'LOAD_BALANCE', 'p2c', 'p2c', 'p2c', 4, 1, '2023-03-07 22:15:16.846', '2023-03-07 22:15:16.846');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762309', 'loadBalance', 'LOAD_BALANCE', 'shortestResponse', 'shortestResponse', 'shortestResponse', 5, 1, '2023-03-17 10:15:16.846', '2023-03-07 10:15:16.846');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737472', 'discoveryMode', 'DISCOVERY_MODE', 'zookeeper', '{"baseSleepTimeMilliseconds":"1000","maxRetries":"3","maxSleepTimeMilliseconds":"1000","connectionTimeoutMilliseconds":"1000","sessionTimeoutMilliseconds":"1000","namespace":"","digest":null}', 'discoery mode to link zookeeper', 0, 1,'2023-03-17 10:15:16.846', '2023-03-07 10:15:16.846');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737473', 'discoveryMode', 'DISCOVERY_MODE', 'etcd', '{"etcdTimeout": "3000", "etcdTTL": "5"}', 'discoery mode to link etcd', 0, 1 ,'2023-03-01 10:48:49', '2023-03-01 10:48:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737474', 'discoveryMode', 'DISCOVERY_MODE', 'nacos', '{"groupName": "SHENYU_GROUP", "nacosNameSpace": "", "username": "", "password": "", "accessKey": "", "secretKey": ""}', 'discoery mode to link nacos', 0, 1,'2023-03-01 10:48:49', '2023-03-01 10:48:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737475', 'discoveryMode', 'DISCOVERY_MODE', 'eureka', '{"eurekaClientRefreshInterval": "10", "eurekaClientRegistryFetchIntervalSeconds": "10"}', 'discoery mode to link eureka', 0, 1,'2023-03-01 10:48:49', '2023-03-01 10:48:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737478', 'rewriteMetaData', 'REWRITE_META_DATA', 'true', 'true', '', 4, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737479', 'rewriteMetaData', 'REWRITE_META_DATA', 'false', 'false', '', 4, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737480', 'preserveHost', 'PRESERVE_HOST', 'true', 'true', '', 0, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737481', 'preserveHost', 'PRESERVE_HOST', 'false', 'false', '', 1, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');

INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737482', 'provider', 'PROVIDER_TYPE_OPENAI', 'OpenAI', 'OpenAI', 'OpenAI', 0, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737483', 'provider', 'PROVIDER_TYPE_DEEPSEEK', 'DeepSeek', 'DeepSeek', 'DeepSeek', 1, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737484', 'provider', 'PROVIDER_TYPE_MOONSHOT', 'Moonshot', 'Moonshot', 'Moonshot', 2, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737485', 'provider', 'PROVIDER_TYPE_OPENAPI', 'OpenAPI', 'OpenAPI', 'OpenAPI', 3, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737486', 'provider', 'PROVIDER_TYPE_ALIYUN', 'ALiYun', 'ALiYun', 'ALiYun', 4, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_role";
CREATE TABLE "public"."user_role" (
  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "role_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
  "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."user_role"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."user_role"."user_id" IS 'user primary key';
COMMENT ON COLUMN "public"."user_role"."role_id" IS 'role primary key';
COMMENT ON COLUMN "public"."user_role"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."user_role"."date_updated" IS 'update time';
COMMENT ON TABLE "public"."user_role" IS 'user and role bind table';

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO "public"."user_role" VALUES ('1351007709096976384', '1', '1346358560427216896', '2022-05-25 18:08:02', '2022-05-25 18:08:02');

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."operation_record_log_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."plugin_handle_id_seq"
OWNED BY "public"."plugin_handle"."id";
SELECT setval('"public"."plugin_handle_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."shenyu_dict_id_seq"
OWNED BY "public"."shenyu_dict"."id";
SELECT setval('"public"."shenyu_dict_id_seq"', 2, false);

-- ----------------------------
-- Primary Key structure for table app_auth
-- ----------------------------
ALTER TABLE "public"."app_auth" ADD CONSTRAINT "app_auth_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table auth_param
-- ----------------------------
ALTER TABLE "public"."auth_param" ADD CONSTRAINT "auth_param_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table auth_path
-- ----------------------------
ALTER TABLE "public"."auth_path" ADD CONSTRAINT "auth_path_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dashboard_user
-- ----------------------------
CREATE INDEX "unique_user_name" ON "public"."dashboard_user" USING btree (
  "user_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dashboard_user
-- ----------------------------
ALTER TABLE "public"."dashboard_user" ADD CONSTRAINT "dashboard_user_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table data_permission
-- ----------------------------
ALTER TABLE "public"."data_permission" ADD CONSTRAINT "data_permission_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table meta_data
-- ----------------------------
ALTER TABLE "public"."meta_data" ADD CONSTRAINT "meta_data_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table operation_record_log
-- ----------------------------
ALTER TABLE "public"."operation_record_log" ADD CONSTRAINT "operation_record_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table permission
-- ----------------------------
ALTER TABLE "public"."permission" ADD CONSTRAINT "permission_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table plugin
-- ----------------------------
ALTER TABLE "public"."plugin" ADD CONSTRAINT "plugin_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table plugin_handle
-- ----------------------------
CREATE INDEX "plugin_id_field_type" ON "public"."plugin_handle" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "field" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" "pg_catalog"."int2_ops" ASC NULLS LAST
);

-- ----------------------------
-- Rules structure for table plugin_handle
-- ----------------------------
CREATE RULE "plugin_handle_insert_ignore" AS ON INSERT TO "public"."plugin_handle" WHERE (EXISTS ( SELECT 1
           FROM plugin_handle
          WHERE ((plugin_handle.id)::text = (new.id)::text))) DO INSTEAD NOTHING;;

-- ----------------------------
-- Primary Key structure for table plugin_handle
-- ----------------------------
ALTER TABLE "public"."plugin_handle" ADD CONSTRAINT "plugin_handle_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table resource
-- ----------------------------
ALTER TABLE "public"."resource" ADD CONSTRAINT "resource_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table role
-- ----------------------------
ALTER TABLE "public"."role" ADD CONSTRAINT "role_pkey" PRIMARY KEY ("id", "role_name");

-- ----------------------------
-- Primary Key structure for table rule
-- ----------------------------
ALTER TABLE "public"."rule" ADD CONSTRAINT "rule_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rule_condition
-- ----------------------------
ALTER TABLE "public"."rule_condition" ADD CONSTRAINT "rule_condition_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table selector
-- ----------------------------
ALTER TABLE "public"."selector" ADD CONSTRAINT "selector_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Rules structure for table shenyu_dict
-- ----------------------------
CREATE RULE "shenyu_dict_insert_ignore" AS ON INSERT TO "public"."shenyu_dict" WHERE (EXISTS ( SELECT 1
           FROM shenyu_dict
          WHERE ((shenyu_dict.id)::text = (new.id)::text))) DO INSTEAD NOTHING;;

-- ----------------------------
-- Primary Key structure for table shenyu_dict
-- ----------------------------
ALTER TABLE "public"."shenyu_dict" ADD CONSTRAINT "shenyu_dict_pkey" PRIMARY KEY ("id");


-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS "public"."tag";
CREATE TABLE "public"."tag" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "tag_desc" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "parent_tag_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "ext" varchar(1024) COLLATE "pg_catalog"."default",
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."tag"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."tag"."name" IS 'tag name';
COMMENT ON COLUMN "public"."tag"."tag_desc" IS 'tag desc';
COMMENT ON COLUMN "public"."tag"."parent_tag_id" IS 'parent tag id';
COMMENT ON COLUMN "public"."tag"."ext" IS 'extension';
COMMENT ON COLUMN "public"."tag"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."tag"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for tag_relation
-- ----------------------------
DROP TABLE IF EXISTS "public"."tag_relation";
CREATE TABLE "public"."tag_relation" (
    "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "api_id"       varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "tag_id"      varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."tag_relation"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."tag_relation"."api_id" IS 'the table api primary key id';
COMMENT ON COLUMN "public"."tag_relation"."tag_id" IS 'tag id';
COMMENT ON COLUMN "public"."tag_relation"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."tag_relation"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for discovery
-- ----------------------------
DROP TABLE IF EXISTS "public"."discovery";
CREATE TABLE "public"."discovery" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "level" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "plugin_name" varchar(255) COLLATE "pg_catalog"."default",
    "type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "server_list" varchar(255) COLLATE "pg_catalog"."default",
    "props" text COLLATE "pg_catalog"."default",
    "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."discovery"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery"."name" IS 'the discovery name';
COMMENT ON COLUMN "public"."discovery"."level" IS '0 selector,1 plugin  2 global';
COMMENT ON COLUMN "public"."discovery"."plugin_name" IS 'the plugin name';
COMMENT ON COLUMN "public"."discovery"."type" IS 'local,zookeeper,etcd,consul,nacos';
COMMENT ON COLUMN "public"."discovery"."server_list" IS 'register server url (,)';
COMMENT ON COLUMN "public"."discovery"."props" IS 'the discovery pops (json) ';
COMMENT ON COLUMN "public"."discovery"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."discovery"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for discovery_handler
-- ----------------------------
DROP TABLE IF EXISTS "public"."discovery_handler";
CREATE TABLE "public"."discovery_handler" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "discovery_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "handler" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "listener_node" varchar(255) COLLATE "pg_catalog"."default",
    "props" text COLLATE "pg_catalog"."default",
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."discovery_handler"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery_handler"."discovery_id" IS 'the discovery id';
COMMENT ON COLUMN "public"."discovery_handler"."handler" IS 'the handler';
COMMENT ON COLUMN "public"."discovery_handler"."listener_node" IS 'register server listener to node';
COMMENT ON COLUMN "public"."discovery_handler"."props" IS 'the discovery pops (json) ';
COMMENT ON COLUMN "public"."discovery_handler"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery_handler"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for discovery_rel
-- ----------------------------
DROP TABLE IF EXISTS "public"."discovery_rel";
CREATE TABLE "public"."discovery_rel" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "plugin_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "discovery_handler_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "selector_id" varchar(128) COLLATE "pg_catalog"."default",
    "proxy_selector_id" varchar(128) COLLATE "pg_catalog"."default",
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."discovery_rel"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery_rel"."plugin_name" IS 'the plugin name';
COMMENT ON COLUMN "public"."discovery_rel"."discovery_handler_id" IS 'the discovery handler id';
COMMENT ON COLUMN "public"."discovery_rel"."selector_id" IS 'the selector id';
COMMENT ON COLUMN "public"."discovery_rel"."proxy_selector_id" IS 'the proxy selector id';
COMMENT ON COLUMN "public"."discovery_rel"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery_rel"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for proxy_selector
-- ----------------------------
DROP TABLE IF EXISTS "public"."proxy_selector";
CREATE TABLE "public"."proxy_selector"
(
    "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name"         varchar(128) COLLATE "pg_catalog"."default",
    "plugin_name"  varchar(128) COLLATE "pg_catalog"."default",
    "type"         varchar(128) COLLATE "pg_catalog"."default",
    "forward_port" int4 NOT NULL,
    "props"        text COLLATE "pg_catalog"."default",
    "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."proxy_selector"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."proxy_selector"."name" IS 'the proxy_selector name';
COMMENT ON COLUMN "public"."proxy_selector"."plugin_name" IS 'the plugin name';
COMMENT ON COLUMN "public"."proxy_selector"."type" IS 'the type ';
COMMENT ON COLUMN "public"."proxy_selector"."forward_port" IS 'the forward port';
COMMENT ON COLUMN "public"."proxy_selector"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."proxy_selector"."date_updated" IS 'update time';



-- ----------------------------
-- Table structure for discovery_upstream
-- ----------------------------
DROP TABLE IF EXISTS "public"."discovery_upstream";
CREATE TABLE "public"."discovery_upstream"
(
    "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "discovery_handler_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
    "protocol"    varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "url"         varchar(128) COLLATE "pg_catalog"."default",
    "status"      int4  NOT NULL,
    "weight"      int4  NOT NULL,
    "props"        text COLLATE "pg_catalog"."default",
    "date_created" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."discovery_upstream"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery_upstream"."discovery_handler_id" IS 'the discovery handler id';
COMMENT ON COLUMN "public"."discovery_upstream"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."discovery_upstream"."protocol" IS 'for http, https, tcp, ws';
COMMENT ON COLUMN "public"."discovery_upstream"."url" IS 'ip:port';
COMMENT ON COLUMN "public"."discovery_upstream"."status" IS 'type (0, healthy, 1 unhealthy)';
COMMENT ON COLUMN "public"."discovery_upstream"."weight" IS 'the weight for lists';
COMMENT ON COLUMN "public"."discovery_upstream"."props" IS 'the other field (json)';
COMMENT ON COLUMN "public"."discovery_upstream"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery_upstream"."date_updated" IS 'update time';
CREATE INDEX "unique_discovery_upstream_discovery_handler_id" ON "public"."discovery_upstream" USING btree (
  "discovery_handler_id" , "url"
);



-- ----------------------------
-- Table structure for alert_template
-- ----------------------------
DROP TABLE IF EXISTS "public"."alert_template";
CREATE TABLE "public"."alert_template" (
    "id"            varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name"          varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "strategy_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "content"       varchar(1000) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created"  timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"  timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."alert_template"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."alert_template"."name" IS  'alert template name';
COMMENT ON COLUMN "public"."alert_template"."strategy_name" IS 'alert template strategy name';
COMMENT ON COLUMN "public"."alert_template"."content" IS 'alert template content';
COMMENT ON COLUMN "public"."alert_template"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."alert_template"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for alert_receiver
-- ----------------------------
DROP TABLE IF EXISTS "public"."alert_receiver";
CREATE TABLE "public"."alert_receiver"
(
    "id"                   varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name"                 varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "enable"               int4     NOT NULL,
    "type"                 int4     NOT NULL,
    "phone"                varchar(255) COLLATE "pg_catalog"."default",
    "email"                varchar(255) COLLATE "pg_catalog"."default",
    "hook_url"             varchar(255) COLLATE "pg_catalog"."default",
    "wechat_id"            varchar(255) COLLATE "pg_catalog"."default",
    "access_token"         varchar(255) COLLATE "pg_catalog"."default",
    "tg_bot_token"         varchar(255) COLLATE "pg_catalog"."default",
    "tg_user_id"           varchar(255) COLLATE "pg_catalog"."default",
    "slack_web_hook_url"   varchar(255) COLLATE "pg_catalog"."default",
    "corp_id"              varchar(255) COLLATE "pg_catalog"."default",
    "agent_id"             varchar(255) COLLATE "pg_catalog"."default",
    "app_secret"           varchar(255) COLLATE "pg_catalog"."default",
    "discord_channel_id"   varchar(255) COLLATE "pg_catalog"."default",
    "discord_bot_token"    varchar(255) COLLATE "pg_catalog"."default",
    "smn_ak"               varchar(255) COLLATE "pg_catalog"."default",
    "smn_sk"               varchar(255) COLLATE "pg_catalog"."default",
    "smn_project_id"       varchar(255) COLLATE "pg_catalog"."default",
    "smn_region"           varchar(255) COLLATE "pg_catalog"."default",
    "smn_topic_urn"        varchar(255) COLLATE "pg_catalog"."default",
    "match_all"            int4      NOT NULL,
    "labels"               varchar(255) COLLATE "pg_catalog"."default",
    "levels"               varchar(255) COLLATE "pg_catalog"."default",
    "namespace_id"         varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created"  timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"  timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."alert_receiver"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."alert_receiver"."name" IS 'alarm receiver name';
COMMENT ON COLUMN "public"."alert_receiver"."enable" IS 'enable or not';
COMMENT ON COLUMN "public"."alert_receiver"."type" IS 'notice type 0-SMS 1-Email 2-webhook 3-WeChat Official Account 4-Enterprise WeChat Robot 5-DingTalk Robot 6-FeiShu Robot 7-Telegram Bot 8-SlackWebHook 9-Discord Bot 10-Enterprise WeChat';
COMMENT ON COLUMN "public"."alert_receiver"."match_all" IS 'match all or not';
COMMENT ON COLUMN "public"."alert_receiver"."namespace_id" IS 'namespace id';
COMMENT ON COLUMN "public"."alert_receiver"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."alert_receiver"."date_updated" IS 'update time';

-- ----------------------------
-- Table structure for shenyu_lock
-- ----------------------------
DROP TABLE IF EXISTS "public"."shenyu_lock";
CREATE TABLE "public"."shenyu_lock" (
    "lock_key" CHAR(36) NOT NULL,
    "region" VARCHAR(100) NOT NULL,
    "client_id" CHAR(36),
    "created_date" TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT shenyu_lock_pk PRIMARY KEY ("lock_key", "region")
);
COMMENT ON COLUMN "public"."shenyu_lock"."lock_key" IS 'lock_key';
COMMENT ON COLUMN "public"."shenyu_lock"."region" IS 'region';
COMMENT ON COLUMN "public"."shenyu_lock"."client_id" IS 'client_id';
COMMENT ON COLUMN "public"."shenyu_lock"."created_date" IS 'created_date';


-- ----------------------------
-- Table structure for cluster_master
-- ----------------------------
DROP TABLE IF EXISTS "public"."cluster_master";
CREATE TABLE "public"."cluster_master"
(
    "id"            varchar(128) COLLATE "pg_catalog"."default" NOT NULL PRIMARY KEY,
    "master_host"   varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "master_port"   varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "context_path"  varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created"  timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"  timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."cluster_master"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."cluster_master"."master_host" IS 'master host';
COMMENT ON COLUMN "public"."cluster_master"."master_port" IS 'master port';
COMMENT ON COLUMN "public"."cluster_master"."context_path" IS 'master context_path';
COMMENT ON COLUMN "public"."cluster_master"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."cluster_master"."date_updated" IS 'update time';

INSERT INTO "public"."resource" VALUES ('1792749362445840474', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.NAMESPACE', 'namespace', '/config/namespace', 'namespace', 1, 0, 'appstore', 0, 0, '', 1, '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840475', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 0, '', 1, 0, 'system:namespace:add', 1, '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840476', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 1, '', 1, 0, 'system:namespace:list', 1, '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840477', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 2, '', 1, 0, 'system:namespace:delete', 1,'2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840478', '1792749362445840474', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 3, '', 1, 0, 'system:namespace:edit', 1, '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');

INSERT INTO "public"."permission" VALUES ('1792779493541343252', '1346358560427216896', '1792749362445840474', '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343253', '1346358560427216896', '1792749362445840475', '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343254', '1346358560427216896', '1792749362445840476', '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343255', '1346358560427216896', '1792749362445840477', '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343256', '1346358560427216896', '1792749362445840478', '2024-06-22 17:00:00.000', '2024-06-22 17:00:00.000');



DROP TABLE IF EXISTS "public"."namespace";
CREATE TABLE "public"."namespace" (
                                      "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
                                      "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
                                      "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                      "description" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                      "date_created" timestamp(3) NOT NULL DEFAULT now(),
                                      "date_updated" timestamp(3) NOT NULL DEFAULT now(),
                                      PRIMARY KEY ("id")
);
COMMENT ON COLUMN "public"."namespace"."id" IS 'Namespace primary key';
COMMENT ON COLUMN "public"."namespace"."namespace_id" IS 'Namespace ID';
COMMENT ON COLUMN "public"."namespace"."name" IS 'Namespace name';
COMMENT ON COLUMN "public"."namespace"."description" IS 'Namespace description';
COMMENT ON COLUMN "public"."namespace"."date_created" IS 'Creation time';
COMMENT ON COLUMN "public"."namespace"."date_updated" IS 'Update time';


INSERT INTO "public"."namespace" VALUES ('1', '649330b6-c2d7-4edc-be8e-8a54df9eb385', 'default', 'default-namespace', '2024-06-22 20:25:14.359', '2024-06-22 23:27:40.778');

DROP TABLE IF EXISTS "public"."namespace_plugin_rel";
CREATE TABLE "public"."namespace_plugin_rel" (
                                          "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
                                          "namespace_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
                                          "plugin_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
                                          "config" text ,
                                          "sort" int,
                                          "enabled" smallint NOT NULL DEFAULT 0 CHECK (enabled IN (0, 1)),
                                          "date_created" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          "date_updated" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          PRIMARY KEY (id)
);

COMMENT ON COLUMN "public"."namespace_plugin_rel"."id" IS 'Primary key ID';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."namespace_id" IS 'Namespace ID';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."plugin_id" IS 'Plugin ID';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."config" IS 'Plugin configuration';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."sort" IS 'Sort order';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."enabled" IS 'Whether the plugin is enabled (0 = not open, 1 = open)';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."date_created" IS 'Creation time';
COMMENT ON COLUMN "public"."namespace_plugin_rel"."date_updated" IS 'Update time';


INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822145','649330b6-c2d7-4edc-be8e-8a54df9eb385','1', NULL, 20, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822146','649330b6-c2d7-4edc-be8e-8a54df9eb385','10', NULL, 140, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822147','649330b6-c2d7-4edc-be8e-8a54df9eb385','11', '{"protocol":"zookeeper","register":"127.0.0.1:2181","threadpool":"shared"}', 310, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822148','649330b6-c2d7-4edc-be8e-8a54df9eb385','12', NULL, 310, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822149','649330b6-c2d7-4edc-be8e-8a54df9eb385','13', '{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}', 310, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822150','649330b6-c2d7-4edc-be8e-8a54df9eb385','14', NULL, 80, 1, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822151','649330b6-c2d7-4edc-be8e-8a54df9eb385','15', '{"multiSelectorHandle":"1","multiRuleHandle":"0","threadpool":"shared"}', 310, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822152','649330b6-c2d7-4edc-be8e-8a54df9eb385','16', NULL, 110, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822153','649330b6-c2d7-4edc-be8e-8a54df9eb385','17', '{"registerProtocol":"direct","registerAddress":"127.0.0.1:2181","corethreads":0,"threads":2147483647,"queues":0,"threadpool":"shared"}', 310, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822154','649330b6-c2d7-4edc-be8e-8a54df9eb385','18', NULL, 160, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822155','649330b6-c2d7-4edc-be8e-8a54df9eb385','19', '{"secretKey":"key"}', 30, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822156','649330b6-c2d7-4edc-be8e-8a54df9eb385','2', '{"model":"black"}', 50, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822157','649330b6-c2d7-4edc-be8e-8a54df9eb385','20', NULL, 120, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822158','649330b6-c2d7-4edc-be8e-8a54df9eb385','21', NULL, 40, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822159','649330b6-c2d7-4edc-be8e-8a54df9eb385','22', NULL, 70, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822160','649330b6-c2d7-4edc-be8e-8a54df9eb385','23', NULL, 220, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822161','649330b6-c2d7-4edc-be8e-8a54df9eb385','24', NULL, 100, 1, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822162','649330b6-c2d7-4edc-be8e-8a54df9eb385','25', NULL, 410, 1, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822163','649330b6-c2d7-4edc-be8e-8a54df9eb385','26', '{"multiSelectorHandle":"1"}', 200, 1, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822164','649330b6-c2d7-4edc-be8e-8a54df9eb385','27', NULL, 125, 1, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822165','649330b6-c2d7-4edc-be8e-8a54df9eb385','28', '{"port": 9500,"bossGroupThreadCount": 1,"maxPayloadSize": 65536,"workerGroupThreadCount": 12,"userName": "shenyu","password": "shenyu","isEncryptPassword": false,"encryptMode": "","leakDetectorLevel": "DISABLED"}', 125, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822166','649330b6-c2d7-4edc-be8e-8a54df9eb385','29', '{"topic":"shenyu-access-logging", "namesrvAddr": "localhost:9876","producerGroup":"shenyu-plugin-logging-rocketmq"}', 170, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822167','649330b6-c2d7-4edc-be8e-8a54df9eb385','3', NULL, 90, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822168','649330b6-c2d7-4edc-be8e-8a54df9eb385','30', '{"cacheType":"memory"}', 10, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822169','649330b6-c2d7-4edc-be8e-8a54df9eb385','31', NULL, 1, 0, '2022-06-16 14:40:35.000', '2022-06-16 14:40:55.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822170','649330b6-c2d7-4edc-be8e-8a54df9eb385','32', '{"host":"localhost", "port": "9200"}', 190, 0, '2022-06-19 22:00:00.000', '2022-06-19 22:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822171','649330b6-c2d7-4edc-be8e-8a54df9eb385','33', '{"host":"localhost", "port": "9092"}', 180, 0, '2022-07-04 22:00:00.000', '2022-07-02 22:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822172','649330b6-c2d7-4edc-be8e-8a54df9eb385','34', '{"projectName": "shenyu", "logStoreName": "shenyu-logstore", "topic": "shenyu-topic"}', 175, 0, '2022-06-30 21:00:00.000', '2022-06-30 21:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822173','649330b6-c2d7-4edc-be8e-8a54df9eb385','35', '{"topic":"shenyu-access-logging", "serviceUrl": "pulsar://localhost:6650"}', 185, 0, '2022-06-30 21:00:00.000', '2022-06-30 21:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822174','649330b6-c2d7-4edc-be8e-8a54df9eb385','36', '{"endpoint": "ap-guangzhou.cls.tencentcs.com", "topic": "shenyu-topic"}', 176, 0, '2022-06-30 21:00:00.000', '2022-06-30 21:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822175','649330b6-c2d7-4edc-be8e-8a54df9eb385','38', '{"host":"127.0.0.1","port":"8123","databse":"shenyu-gateway","username":"foo","password":"bar"}', 195, 0, '2022-06-30 21:00:00.000', '2022-06-30 21:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822176','649330b6-c2d7-4edc-be8e-8a54df9eb385','39', '{"endpoint":"http://localhost:8000"}', 40, 0, '2022-09-11 12:00:00.000', '2022-09-11 12:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822177','649330b6-c2d7-4edc-be8e-8a54df9eb385','4', '{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}', 60, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822178','649330b6-c2d7-4edc-be8e-8a54df9eb385','40', NULL, 150, 0, '2022-07-24 19:00:00.000', '2022-07-24 19:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822179','649330b6-c2d7-4edc-be8e-8a54df9eb385','42', NULL, 320, 1, '2023-05-30 18:02:53.000', '2022-05-30 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822180','649330b6-c2d7-4edc-be8e-8a54df9eb385','43', '{"totalSizeInBytes":"104857600","maxBlockMs":"0","ioThreadCount":"1","batchSizeThresholdInBytes":"524288","batchCountThreshold":"4096","lingerMs":"2000","retries":"100","baseRetryBackoffMs":"100","maxRetryBackoffMs":"100","enableLocalTest":"true","setGiveUpExtraLongSingleLog":"false"}', 177, 0, '2023-07-05 14:03:53.686', '2023-07-06 12:42:07.234');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822181','649330b6-c2d7-4edc-be8e-8a54df9eb385','44', '{"defaultHandleJson":"{\"authorization\":\"test:test123\"}"}', 150, 0, '2022-07-24 19:00:00.000', '2022-07-24 19:00:00.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822182','649330b6-c2d7-4edc-be8e-8a54df9eb385','45', '{"host":"127.0.0.1","port":5672,"password":"admin","username":"admin","exchangeName":"exchange.logging.plugin","queueName":"queue.logging.plugin","routingKey":"topic.logging","virtualHost":"/","exchangeType":"direct","durable":"true","exclusive":"false","autoDelete":"false"}', 171, 0, '2023-11-06 15:49:56.454', '2023-11-10 10:40:58.447');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822183','649330b6-c2d7-4edc-be8e-8a54df9eb385','5', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', 200, 1, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822184','649330b6-c2d7-4edc-be8e-8a54df9eb385','6', '{"register":"zookeeper://localhost:2181","multiSelectorHandle":"1","threadpool":"shared","corethreads":0,"threads":2147483647,"queues":0}', 310, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822186','649330b6-c2d7-4edc-be8e-8a54df9eb385','9', NULL, 130, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822187','649330b6-c2d7-4edc-be8e-8a54df9eb385','50', '{"provider":"OpenAI","baseUrl":"https://api.openai.com/v1/chat/completions","model":"gpt-4o-mini","apiKey":"your_api_key","temperature":"0.5","maxTokens":"1000","stream":"false","prompt":""}', 199, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');
INSERT INTO "public"."namespace_plugin_rel" VALUES ('1801816010882822188','649330b6-c2d7-4edc-be8e-8a54df9eb385','51', NULL, 171, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');


INSERT INTO "public"."resource" VALUES ('1792749362445840479', '1357956838021890048', 'SHENYU.MENU.SYSTEM.MANAGMENT.NAMESPACEPLUGIN', 'namespacePlugin', '/config/namespacePlugin', 'namespacePlugin', 1, 2, 'build', 0, 0, '', 1, '2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840480', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.LIST', '', '', '', 2, 0, '', 1, 0, 'system:namespacePlugin:list', 1, '2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840481', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.DELETE', '', '', '', 2, 1, '', 1, 0, 'system:namespacePlugin:delete', 1, '2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840482', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.ADD', '', '', '', 2, 2, '', 1, 0, 'system:namespacePlugin:add', 1, '2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840483', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE', '', '', '', 2, 3, '', 1, 0, 'system:namespacePlugin:modify', 1, '2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840484', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.ENABLE', '', '', '', 2, 4, '', 1, 0, 'system:namespacePlugin:disable', 1, '2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840485', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.EDIT', '', '', '', 2, 5, '', 1, 0, 'system:namespacePlugin:edit', 1,'2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');
INSERT INTO "public"."resource" VALUES ('1792749362445840486', '1792749362445840479', 'SHENYU.BUTTON.SYSTEM.RESOURCE', '', '', '', 2, 6, '', 1, 0, 'system:namespacePlugin:resource', 1,'2024-06-25 18:02:53.000', '2024-06-25 18:02:53.000');


INSERT INTO "public"."permission" VALUES ('1792779493541343260', '1346358560427216896', '1792749362445840479', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343261', '1346358560427216896', '1792749362445840480', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343262', '1346358560427216896', '1792749362445840481', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343263', '1346358560427216896', '1792749362445840482', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343264', '1346358560427216896', '1792749362445840483', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343265', '1346358560427216896', '1792749362445840484', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343266', '1346358560427216896', '1792749362445840485', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');
INSERT INTO "public"."permission" VALUES ('1792779493541343267', '1346358560427216896', '1792749362445840486', '2024-06-25 20:00:00.000', '2024-06-25 20:00:00.000');


-- ----------------------------
-- Table structure for scale
-- ----------------------------
DROP TABLE IF EXISTS "public"."scale_policy";
CREATE TABLE IF NOT EXISTS "public"."scale_policy"
(
    "id"             varchar(128)   COLLATE "pg_catalog"."default" NOT NULL,
    "sort"           int4           NOT NULL,
    "status"         int2           NOT NULL,
    "num"            int4           ,
    "begin_time"     timestamp(6)   ,
    "end_time"       timestamp(6)   ,
    "date_created"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
);
COMMENT ON COLUMN "public"."scale_policy"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."scale_policy"."sort" IS 'sort';
COMMENT ON COLUMN "public"."scale_policy"."status" IS 'status 1:enable 0:disable';
COMMENT ON COLUMN "public"."scale_policy"."num" IS 'number of bootstrap';
COMMENT ON COLUMN "public"."scale_policy"."begin_time" IS 'begin time';
COMMENT ON COLUMN "public"."scale_policy"."end_time" IS 'end time';
COMMENT ON COLUMN "public"."scale_policy"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."scale_policy"."date_updated" IS 'update time';

INSERT INTO "public"."scale_policy" VALUES ('1', 3, 0, 10, NULL, NULL, '2024-07-31 20:00:00.000', '2024-07-31 20:00:00.000');
INSERT INTO "public"."scale_policy" VALUES ('2', 2, 0, 10, '2024-07-31 20:00:00.000', '2024-08-01 20:00:00.000', '2024-07-31 20:00:00.000', '2024-07-31 20:00:00.000');
INSERT INTO "public"."scale_policy" VALUES ('3', 1, 0, NULL, NULL, NULL, '2024-07-31 20:00:00.000', '2024-07-31 20:00:00.000');

DROP TABLE IF EXISTS "public"."scale_rule";
CREATE TABLE "public"."scale_rule"
(
    "id"             varchar(128)   COLLATE "pg_catalog"."default" NOT NULL,
    "metric_name"    varchar(128)   COLLATE "pg_catalog"."default" NOT NULL,
    "type"           int4           NOT NULL,
    "sort"           int4           NOT NULL,
    "status"         int2           NOT NULL,
    "minimum"        varchar(128)   COLLATE "pg_catalog"."default",
    "maximum"        varchar(128)   COLLATE "pg_catalog"."default",
    "date_created"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
);
COMMENT ON COLUMN "public"."scale_rule"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."scale_rule"."metric_name" IS 'metric name';
COMMENT ON COLUMN "public"."scale_rule"."type" IS 'type 0:shenyu 1:k8s 2:others';
COMMENT ON COLUMN "public"."scale_rule"."sort" IS 'sort';
COMMENT ON COLUMN "public"."scale_rule"."status" IS 'status 1:enable 0:disable';
COMMENT ON COLUMN "public"."scale_rule"."minimum" IS 'minimum of metric';
COMMENT ON COLUMN "public"."scale_rule"."maximum" IS 'maximum of metric';
COMMENT ON COLUMN "public"."scale_rule"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."scale_rule"."date_updated" IS 'update time';

DROP TABLE IF EXISTS "public"."scale_history";
CREATE TABLE "public"."scale_history"
(
    "id"             varchar(128)   COLLATE "pg_catalog"."default" NOT NULL,
    "config_id"      int4           NOT NULL,
    "num"            int4           NOT NULL,
    "action"         int4           NOT NULL,
    "msg"            text           COLLATE "pg_catalog"."default",
    "date_created"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
);
COMMENT ON COLUMN "public"."scale_history"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."scale_history"."config_id" IS '0:manual 1:period 2:dynamic';
COMMENT ON COLUMN "public"."scale_history"."num" IS 'number of bootstrap';
COMMENT ON COLUMN "public"."scale_history"."action" IS 'status 1:enable 0:disable';
COMMENT ON COLUMN "public"."scale_history"."msg" IS 'message';
COMMENT ON COLUMN "public"."scale_history"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."scale_history"."date_updated" IS 'update time';

DROP TABLE IF EXISTS "public"."namespace_user_rel";
CREATE TABLE "public"."namespace_user_rel"
(
    "id"             varchar(128)   COLLATE "pg_catalog"."default" NOT NULL,
    "namespace_id"   varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
    "user_id"        varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "date_created"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated"   timestamp(3)   NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
);
COMMENT ON COLUMN "public"."namespace_user_rel"."id" IS 'primary key';
COMMENT ON COLUMN "public"."namespace_user_rel"."namespace_id" IS 'namespace_id';
COMMENT ON COLUMN "public"."namespace_user_rel"."user_id" IS 'user_id';
COMMENT ON COLUMN "public"."namespace_user_rel"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."namespace_user_rel"."date_updated" IS 'update time';


INSERT INTO "public"."resource" VALUES ('1844026099075534849', '1346775491550474240', 'aiProxy', 'aiProxy', '/plug/aiProxy', 'aiProxy', 1, 0, 'pic-center', 0, 0, '', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534850', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:add', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534851', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:query', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534852', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:edit', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534853', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxySelector:delete', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534854', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:add', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534855', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:query', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534856', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:edit', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534857', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxyRule:delete', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534858', '1844026099075534849', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiProxy:modify', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');

INSERT INTO "public"."permission" VALUES ('1697146860569542741', '1346358560427216896', '1844026099075534849', '2023-08-31 06:59:01', '2023-08-31 06:59:01');
INSERT INTO "public"."permission" VALUES ('1697146860569542742', '1346358560427216896', '1844026099075534850', '2023-08-31 07:22:07', '2023-08-31 07:22:07');
INSERT INTO "public"."permission" VALUES ('1697146860569542743', '1346358560427216896', '1844026099075534851', '2023-08-31 07:14:26', '2023-08-31 07:14:26');
INSERT INTO "public"."permission" VALUES ('1697146860569542744', '1346358560427216896', '1844026099075534852', '2023-08-31 07:22:07', '2023-08-31 07:22:07');
INSERT INTO "public"."permission" VALUES ('1697146860569542745', '1346358560427216896', '1844026099075534853', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542746', '1346358560427216896', '1844026099075534854', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542747', '1346358560427216896', '1844026099075534855', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542748', '1346358560427216896', '1844026099075534856', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542749', '1346358560427216896', '1844026099075534857', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542750', '1346358560427216896', '1844026099075534858', '2023-08-31 07:18:37', '2023-08-31 07:18:37');

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507041', '50', 'provider', 'provider', 3, 1, 0, '{"required":"1","defaultValue":"OpenAI","placeholder":"provider","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507042', '50', 'baseUrl', 'baseUrl', 2, 1, 1, '{"required":"1","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507043', '50', 'model', 'model', 2, 1, 2, '{"required":"1","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507044', '50', 'apiKey', 'apiKey', 2, 1, 3, '{"required":"1","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507045', '50', 'temperature', 'temperature', 2, 1, 4, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507046', '50', 'maxTokens', 'maxTokens', 2, 1, 5, '{"required":"0","rule":"", "placeholder":"optional,0,0.01~1"}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507047', '50', 'stream', 'stream', 3, 1, 6, '{"defaultValue":"false","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507048', '50', 'prompt', 'prompt', 2, 1, 7, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');

INSERT INTO "public"."plugin" VALUES ('52', 'aiPrompt', null, 'Ai', 170, 0, '2023-12-20 18:02:53', '2023-12-20 18:02:53', null);

INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507140', '52', 'prepend', 'prepend', 2, 3, 1, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507141', '52', 'preRole', 'preRole', 3, 3, 2, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507142', '52', 'append', 'append', 2, 3, 3, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');
INSERT INTO "public"."plugin_handle" VALUES ('1722804548510507143', '52', 'postRole', 'postRole', 3, 3, 4, '{"required":"0","rule":""}', '2024-01-02 17:20:50.233', '2024-01-02 17:20:50.233');

INSERT INTO "public"."resource" VALUES ('1844026099075554850', '1346775491550474240', 'aiPrompt', 'aiPrompt', '/plug/aiPrompt', 'aiPrompt', 1, 0, 'pic-center', 0, 0, '', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554851', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:add', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554852', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:query', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554853', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:edit', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554854', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptSelector:delete', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554855', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:add', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554856', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:query', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554857', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:edit', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554858', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPromptRule:delete', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075554859', '1844026099075554850', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiPrompt:modify', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');

INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737580', 'preRole', 'ROLE_TYPE_SYSTEM', 'SYSTEM', 'system', 'system', 0, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737581', 'preRole', 'ROLE_TYPE_USER', 'USER', 'user', 'user', 1, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737582', 'postRole', 'ROLE_TYPE_SYSTEM', 'SYSTEM', 'system', 'system', 0, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737583', 'postRole', 'ROLE_TYPE_USER', 'USER', 'user', 'user', 1, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');

INSERT INTO "public"."namespace_plugin_rel" ("id","namespace_id","plugin_id", "config", "sort", "enabled", "date_created", "date_updated") VALUES ('1801816010882822189','649330b6-c2d7-4edc-be8e-8a54df9eb385','52', NULL, 171, 0, '2022-05-25 18:02:53.000', '2022-05-25 18:02:53.000');

INSERT INTO "public"."resource" VALUES ('1844026099075534859', '1346775491550474240', 'aiTokenLimiter', 'aiTokenLimiter', '/plug/aiTokenLimiter', 'aiTokenLimiter', 1, 0, 'pic-center', 0, 0, '', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534860', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:add', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534861', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:query', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534862', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:edit', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534863', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterSelector:delete', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534864', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:add', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534865', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:query', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534866', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:edit', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534867', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiterRule:delete', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');
INSERT INTO "public"."resource" VALUES ('1844026099075534868', '1844026099075534859', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:aiTokenLimiter:modify', 1, '2022-05-25 18:02:58', '2022-05-25 18:02:58');

INSERT INTO "public"."permission" VALUES ('1697146860569542751', '1346358560427216896', '1844026099075534859', '2023-08-31 06:59:01', '2023-08-31 06:59:01');
INSERT INTO "public"."permission" VALUES ('1697146860569542752', '1346358560427216896', '1844026099075534860', '2023-08-31 07:22:07', '2023-08-31 07:22:07');
INSERT INTO "public"."permission" VALUES ('1697146860569542753', '1346358560427216896', '1844026099075534861', '2023-08-31 07:14:26', '2023-08-31 07:14:26');
INSERT INTO "public"."permission" VALUES ('1697146860569542754', '1346358560427216896', '1844026099075534862', '2023-08-31 07:22:07', '2023-08-31 07:22:07');
INSERT INTO "public"."permission" VALUES ('1697146860569542755', '1346358560427216896', '1844026099075534863', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542756', '1346358560427216896', '1844026099075534864', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542757', '1346358560427216896', '1844026099075534865', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542758', '1346358560427216896', '1844026099075534866', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542759', '1346358560427216896', '1844026099075534867', '2023-08-31 07:18:37', '2023-08-31 07:18:37');
INSERT INTO "public"."permission" VALUES ('1697146860569542760', '1346358560427216896', '1844026099075534868', '2023-08-31 07:18:37', '2023-08-31 07:18:37');

INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737490', 'aiTokenLimitType', 'DEFAULT_KEY_RESOLVER', 'default', 'default', 'Rate limit by default', 0, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737491', 'aiTokenLimitType', 'IP_KEY_RESOLVER', 'ip', 'ip', 'Rate limit by request ip', 1, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737492', 'aiTokenLimitType', 'URI_KEY_RESOLVER', 'uri', 'uri', 'Rate limit by request uri', 2, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737493', 'aiTokenLimitType', 'HEADER_KEY_RESOLVER', 'header', 'header', 'Rate limit by request header', 3, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737494', 'aiTokenLimitType', 'PARAMETER_KEY_RESOLVER', 'parameter', 'parameter', 'Rate limit by request parameter', 4, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1679002911061737495', 'aiTokenLimitType', 'COOKIE_KEY_RESOLVER', 'cookie', 'cookie', 'Rate limit by request cookie', 5, 1, '2024-02-07 14:31:49', '2024-02-07 14:31:49');

INSERT INTO "public"."plugin_handle" VALUES ('1899702350766538752', '51', 'aiTokenLimitType', 'aiTokenLimitType', 3, 2, 0, '{"required":"0","rule":""}', '2025-03-12 06:01:49.725', '2025-03-12 06:07:49.856');
INSERT INTO "public"."plugin_handle" VALUES ('1899702411294539776', '51', 'timeWindowSeconds', 'timeWindowSeconds', 1, 2, 1, '{"required":"0","rule":""}', '2025-03-12 06:02:04.155', '2025-03-12 06:02:04.155');
INSERT INTO "public"."plugin_handle" VALUES ('1899702472330051584', '51', 'keyName', 'keyName', 2, 2, 2, '{"required":"0","rule":""}', '2025-03-12 06:02:18.707', '2025-03-12 06:02:18.707');
INSERT INTO "public"."plugin_handle" VALUES ('1899702529972371456', '51', 'tokenLimit', 'tokenLimit', 1, 2, 3, '{"required":"0","rule":""}', '2025-03-12 06:02:32.450', '2025-03-12 06:02:32.450');
