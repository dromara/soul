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

CREATE EXTENSION IF NOT EXISTS dblink;
DO
$do$
DECLARE
  _db TEXT := 'shenyu';
  _user TEXT := 'userName';
  _password TEXT := 'password';
  _tablelock INTEGER :=0;
BEGIN
  IF EXISTS (SELECT 1 FROM pg_database WHERE datname = _db) THEN
    RAISE NOTICE 'Database already exists';
  ELSE
    PERFORM public.dblink_connect('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||current_database());
    PERFORM public.dblink_exec('CREATE DATABASE ' || _db || ' template template0;');
  END IF;

	PERFORM public.dblink_connect('init_conn','host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db);
	PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn','CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS
                                          $$
                                          BEGIN
                                          NEW.date_updated = NOW()::TIMESTAMP(0);
                                          RETURN NEW;
                                          END
                                          $$
                                          language plpgsql;');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');

-- ----------------------------------------
-- create table app_auth if not exist ---
-- ---------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'app_auth' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'app_auth already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
		PERFORM public.dblink_exec('init_conn', 'CREATE TABLE "app_auth" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "app_key" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
	  "app_secret" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "user_id" varchar(128) COLLATE "pg_catalog"."default",
	  "phone" varchar(255) COLLATE "pg_catalog"."default",
	  "ext_info" varchar(1024) COLLATE "pg_catalog"."default",
	  "open" int2 NOT NULL,
	  "enabled" int2 NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL,
	  CONSTRAINT "app_auth_pkey" PRIMARY KEY ("id")
	)');

	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."app_key" IS ''' || 'application identification key' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."app_secret" IS ''' || 'encryption algorithm secret' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."user_id" IS ''' || 'user id' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."phone" IS ''' || 'phone number when the user applies' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."ext_info" IS ''' || 'extended parameter json' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."open" IS ''' || 'open auth path or not' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."enabled" IS ''' || 'delete or not' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn','COMMENT ON COLUMN "app_auth"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn','CREATE TRIGGER app_auth_trigger
									  BEFORE UPDATE ON app_auth
									  FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table auth_param if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'auth_param' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'auth_param already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "auth_param" (
	  "id" varchar(129) COLLATE "pg_catalog"."default" NOT NULL,
	  "auth_id" varchar(129) COLLATE "pg_catalog"."default",
	  "app_name" varchar(256) COLLATE "pg_catalog"."default" NOT NULL,
	  "app_param" varchar(256) COLLATE "pg_catalog"."default",
	  "date_created" timestamp(7) NOT NULL default current_timestamp,
	  "date_updated" timestamp(7) NOT NULL default current_timestamp
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_param"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_param"."auth_id" IS ''' || 'Authentication table id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_param"."app_name" IS ''' || 'business Module' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_param"."app_param" IS ''' || 'service module parameters (parameters that need to be passed by the gateway) json type' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_param"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_param"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER auth_param_trigger
	          BEFORE UPDATE ON auth_param
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');

	-- ----------------------------
	-- Primary Key structure for table auth_param
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  ' ALTER TABLE "auth_param" ADD CONSTRAINT "auth_param_pkey" PRIMARY KEY ("id");');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table auth_path if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'auth_path' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'auth_path already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "auth_path" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "auth_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "app_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
	  "path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
	  "enabled" int2 NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."auth_id" IS ''' || 'auth table id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."app_name" IS ''' || 'module' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."path" IS ''' || 'path' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."enabled" IS ''' || 'whether pass 1 is' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "auth_path"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER auth_path_trigger
	          BEFORE UPDATE ON auth_path
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table auth_path
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "auth_path" ADD CONSTRAINT "auth_path_pkey" PRIMARY KEY ("id");');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table meta_data if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'meta_data' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'meta_data already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "meta_data" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "app_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
	  "path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
	  "path_desc" varchar(255) COLLATE "pg_catalog"."default",
	  "rpc_type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "service_name" varchar(255) COLLATE "pg_catalog"."default",
	  "method_name" varchar(255) COLLATE "pg_catalog"."default",
	  "parameter_types" varchar(255) COLLATE "pg_catalog"."default",
	  "rpc_ext" varchar(512) COLLATE "pg_catalog"."default",
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL,
	  "enabled" int2 NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."id" IS ''' || 'id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."app_name" IS ''' || 'application name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."path" IS ''' || 'path, cannot be repeated' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."path_desc" IS ''' || 'path description' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."rpc_type" IS ''' || 'rpc type' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."service_name" IS ''' || 'service name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."method_name" IS ''' || 'method name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."parameter_types" IS ''' || 'parameter types are provided with multiple parameter types separated by commas' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."rpc_ext" IS ''' || 'rpc extended information, json format' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "meta_data"."enabled" IS ''' || 'enabled state' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER meta_data_trigger
	          BEFORE UPDATE ON meta_data
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table meta_data
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "meta_data" ADD CONSTRAINT "meta_data_pkey" PRIMARY KEY ("id");');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table dashboard_user if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'dashboard_user' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'dashboard_user already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "dashboard_user" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "user_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "password" varchar(128) COLLATE "pg_catalog"."default",
	  "role" int4 NOT NULL,
	  "enabled" int2 NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."user_name" IS ''' || 'user name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."password" IS ''' || 'user password' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."role" IS ''' || 'role' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."enabled" IS ''' || 'delete or not' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "dashboard_user"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER dashboard_user_trigger
	          BEFORE UPDATE ON dashboard_user
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "dashboard_user" VALUES (''' || '1' || ''', ''' || 'admin' || ''', ''' || 'bbiB8zbUo3z3oA0VqEB/IA==' || ''', 1, 1, ''' || '2018-06-23 15:12:22' || ''', ''' || '2018-06-23 15:12:23' || ''');');

	-- ----------------------------
	-- Indexes structure for table dashboard_user
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'CREATE INDEX "unique_user_name" ON "dashboard_user" USING btree (
	  "user_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
	);');

	-- ----------------------------
	-- Primary Key structure for table dashboard_user
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "dashboard_user" ADD CONSTRAINT "dashboard_user_pkey" PRIMARY KEY ("id");');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table data_permission if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'data_permission' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'data_permission already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "data_permission" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "user_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "data_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "data_type" int4 NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "data_permission"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "data_permission"."user_id" IS ''' || 'user primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "data_permission"."data_id" IS ''' || 'data(selector,rule) primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "data_permission"."data_type" IS ''' || '0 selector type , 1 rule type' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "data_permission"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "data_permission"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON TABLE "data_permission" IS ''' || 'data permission table' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER data_permission_trigger
	          BEFORE UPDATE ON data_permission
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table data_permission
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "data_permission" ADD CONSTRAINT "data_permission_pkey" PRIMARY KEY ("id");');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table permission if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'permission' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'permission already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "permission" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "object_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "resource_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "permission"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "permission"."object_id" IS ''' || 'user primary key id or role primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "permission"."resource_id" IS ''' || 'resource primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "permission"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "permission"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON TABLE "permission" IS ''' || 'permission table' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER permission_trigger
	          BEFORE UPDATE ON permission
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table permission
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "permission" ADD CONSTRAINT "permission_pkey" PRIMARY KEY ("id");');

	----------------------------
	-- Records of permission
	-- ---------------------------
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708572688384' || ''', ''' || '1346358560427216896' || ''', ''' || '1346775491550474240' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708585271296' || ''', ''' || '1346358560427216896' || ''', ''' || '1346776175553376256' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708593659904' || ''', ''' || '1346358560427216896' || ''', ''' || '1346777157943259136' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708597854208' || ''', ''' || '1346358560427216896' || ''', ''' || '1346777449787125760' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708606242816' || ''', ''' || '1346358560427216896' || ''', ''' || '1346777623011880960' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708610437120' || ''', ''' || '1346358560427216896' || ''', ''' || '1346777766301888512' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708614631424' || ''', ''' || '1346358560427216896' || ''', ''' || '1346777907096285184' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708623020032' || ''', ''' || '1346358560427216896' || ''', ''' || '1346778036402483200' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708627214336' || ''', ''' || '1346358560427216896' || ''', ''' || '1347026381504262144' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708631408640' || ''', ''' || '1346358560427216896' || ''', ''' || '1347026805170909184' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708639797248' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027413357572096' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708643991552' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027482244820992' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708648185856' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027526339538944' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708652380160' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027566034432000' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708656574464' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027647999520768' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708660768768' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027717792739328' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708669157376' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027769747582976' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708673351680' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027830602739712' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708677545984' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027918121086976' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708681740288' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027995199811584' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708685934592' || ''', ''' || '1346358560427216896' || ''', ''' || '1347028169120821248' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708685934593' || ''', ''' || '1346358560427216896' || ''', ''' || '1347032308726902784' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708690128896' || ''', ''' || '1346358560427216896' || ''', ''' || '1347032395901317120' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708694323200' || ''', ''' || '1346358560427216896' || ''', ''' || '1347032453707214848' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708698517504' || ''', ''' || '1346358560427216896' || ''', ''' || '1347032509051056128' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708702711808' || ''', ''' || '1346358560427216896' || ''', ''' || '1347034027070337024' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708706906112' || ''', ''' || '1346358560427216896' || ''', ''' || '1347039054925148160' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708711100416' || ''', ''' || '1346358560427216896' || ''', ''' || '1347041326749691904' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708715294720' || ''', ''' || '1346358560427216896' || ''', ''' || '1347046566244003840' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708719489024' || ''', ''' || '1346358560427216896' || ''', ''' || '1347047143350874112' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708723683328' || ''', ''' || '1346358560427216896' || ''', ''' || '1347047203220369408' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708727877632' || ''', ''' || '1346358560427216896' || ''', ''' || '1347047555588042752' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708732071936' || ''', ''' || '1346358560427216896' || ''', ''' || '1347047640145211392' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708732071937' || ''', ''' || '1346358560427216896' || ''', ''' || '1347047695002513408' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708736266240' || ''', ''' || '1346358560427216896' || ''', ''' || '1347047747305484288' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708740460544' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048004105940992' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708744654848' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048101875167232' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708744654849' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048145877610496' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708748849152' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048240677269504' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708753043456' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048316216684544' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708757237760' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048776029843456' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708757237761' || ''', ''' || '1346358560427216896' || ''', ''' || '1347048968414179328' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708761432064' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049029323862016' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708765626368' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049092552994816' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708769820672' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049251395481600' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708774014976' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049317178945536' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708774014977' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049370014593024' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708778209280' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049542417264640' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708782403584' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049598155370496' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708786597888' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049659023110144' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708790792192' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049731047698432' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708794986496' || ''', ''' || '1346358560427216896' || ''', ''' || '1347049794008395776' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708799180800' || ''', ''' || '1346358560427216896' || ''', ''' || '1347050493052071936' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708799180801' || ''', ''' || '1346358560427216896' || ''', ''' || '1347050998931271680' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708803375104' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051241320099840' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708807569408' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051306788990976' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708807569409' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051641725136896' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708811763712' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051850521784320' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708815958016' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051853025783808' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708815958017' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051855538171904' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708820152320' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051857962479616' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708824346624' || ''', ''' || '1346358560427216896' || ''', ''' || '1347051860495839232' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708828540928' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052833968631808' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708828540929' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052836300664832' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708832735232' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052839198928896' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708836929536' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052841824563200' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708836929537' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052843993018368' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708841123840' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053324018528256' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708845318144' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053326988095488' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708849512448' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053329378848768' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708853706752' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053331744436224' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708857901056' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053334470733824' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708857901057' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053363814084608' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708862095360' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053366552965120' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708866289664' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053369413480448' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708866289665' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053372164943872' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708870483968' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053375029653504' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708874678272' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053404050042880' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708874678273' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053406939918336' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708878872576' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053409842376704' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708878872577' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053413067796480' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708883066880' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053415945089024' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708887261184' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053442419535872' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708891455488' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053445191970816' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708891455489' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053447695970304' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708895649792' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053450304827392' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708895649793' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053452737523712' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708899844096' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053477844627456' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708904038400' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053480977772544' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708904038401' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053483712458752' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708908232704' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053486426173440' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708912427008' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053489571901440' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708916621312' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053516423835648' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708920815616' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053519401791488' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708920815617' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053522182615040' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708925009920' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053525034741760' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708929204224' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053527819759616' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708933398528' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053554310983680' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708933398529' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053556512993280' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708937592832' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053559050547200' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708937592833' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053561579712512' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708941787136' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053564016603136' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708941787137' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053595729735680' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708945981440' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053598829326336' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708950175744' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053601572401152' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708954370048' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053604093177856' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708958564352' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053606622343168' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708962758656' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053631159021568' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708962758657' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053633809821696' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708966952960' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053636439650304' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708971147264' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053638968815616' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708971147265' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053641346985984' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708975341568' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053666227597312' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708979535872' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053668538658816' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708979535873' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053670791000064' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708983730176' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053673043341312' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708987924480' || ''', ''' || '1346358560427216896' || ''', ''' || '1347053675174047744' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992118784' || ''', ''' || '1346358560427216896' || ''', ''' || '1347063567603609600' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992118999' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595202' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119000' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595203' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119001' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595204' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119002' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595205' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119003' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595206' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119004' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595207' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119005' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595208' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708992119006' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595209' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007708996313088' || ''', ''' || '1346358560427216896' || ''', ''' || '1347064011369361408' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709000507392' || ''', ''' || '1346358560427216896' || ''', ''' || '1347064013848195072' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709000507393' || ''', ''' || '1346358560427216896' || ''', ''' || '1347064016373166080' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709004701696' || ''', ''' || '1346358560427216896' || ''', ''' || '1347064019007188992' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709008896000' || ''', ''' || '1346358560427216896' || ''', ''' || '1347064021486022656' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709008896001' || ''', ''' || '1346358560427216896' || ''', ''' || '1350096617689751552' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709013090304' || ''', ''' || '1346358560427216896' || ''', ''' || '1350096630197166080' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709013090305' || ''', ''' || '1346358560427216896' || ''', ''' || '1350098233939632128' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709017284608' || ''', ''' || '1346358560427216896' || ''', ''' || '1350098236741427200' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709021478912' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099831950163968' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709021478913' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595200' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709025673216' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099893203779584' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709029867520' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099896441782272' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709029867521' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099936379944960' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709034061824' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099939177545728' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709034061825' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099976435548160' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709038256128' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099979434475520' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709038256129' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100013341229056' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709042450432' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100016319184896' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709042450433' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100053757542400' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709046644736' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100056525783040' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709050839040' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100110510669824' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709050839041' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100113283104768' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709055033344' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100147437322240' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709059227648' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100150096510976' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709059227649' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100190894505984' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709063421952' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100193801158656' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709067616256' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100229360467968' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709067616257' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100232451670016' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709071810560' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100269307019264' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709071810561' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100272083648512' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709076004864' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100334205485056' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709076004865' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795968' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709080199168' || ''', ''' || '1346358560427216896' || ''', ''' || '1350106119681622016' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709080199169' || ''', ''' || '1346358560427216896' || ''', ''' || '1350107709494804480' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709084393472' || ''', ''' || '1346358560427216896' || ''', ''' || '1350107842236137472' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709084393473' || ''', ''' || '1346358560427216896' || ''', ''' || '1350112406754766848' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709088587776' || ''', ''' || '1346358560427216896' || ''', ''' || '1350112481253994496' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1351007709088587777' || ''', ''' || '1346358560427216896' || ''', ''' || '1350804501819195392' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1355167519859040256' || ''', ''' || '1346358560427216896' || ''', ''' || '1355163372527050752' || ''', ''' || '2021-01-29 22:54:49' || ''', ''' || '2021-01-29 22:58:41' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1355167519859040257' || ''', ''' || '1346358560427216896' || ''', ''' || '1355165158419750912' || ''', ''' || '2021-01-29 22:54:49' || ''', ''' || '2021-01-29 22:58:41' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1355167519859040258' || ''', ''' || '1346358560427216896' || ''', ''' || '1355165353534578688' || ''', ''' || '2021-01-29 22:54:49' || ''', ''' || '2021-01-29 22:58:42' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1355167519859040259' || ''', ''' || '1346358560427216896' || ''', ''' || '1355165475785957376' || ''', ''' || '2021-01-29 22:54:49' || ''', ''' || '2021-01-29 22:58:43' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1355167519859040260' || ''', ''' || '1346358560427216896' || ''', ''' || '1355165608565039104' || ''', ''' || '2021-01-29 22:54:49' || ''', ''' || '2021-01-29 22:58:43' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357956838021890049' || ''', ''' || '1346358560427216896' || ''', ''' || '1357956838021890048' || ''', ''' || '2021-02-06 15:38:34' || ''', ''' || '2021-02-06 15:38:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977745893326848' || ''', ''' || '1346358560427216896' || ''', ''' || '1357977745889132544' || ''', ''' || '2021-02-06 17:01:39' || ''', ''' || '2021-02-06 17:01:39' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977912126177281' || ''', ''' || '1346358560427216896' || ''', ''' || '1357977912126177280' || ''', ''' || '2021-02-06 17:02:19' || ''', ''' || '2021-02-06 17:02:19' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900417' || ''', ''' || '1346358560427216896' || ''', ''' || '1357977971827900416' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900418' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795969' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900419' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795970' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900420' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795971' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900421' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795972' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900422' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795973' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900423' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795974' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900424' || ''', ''' || '1346358560427216896' || ''', ''' || '1350100337363795975' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900425' || ''', ''' || '1346358560427216896' || ''', ''' || '1347028169120821249' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900426' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052833968631809' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900427' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052836300664833' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900428' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052839198928897' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900429' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052841824563201' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900430' || ''', ''' || '1346358560427216896' || ''', ''' || '1347052843993018369' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900431' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099831950163969' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900432' || ''', ''' || '1346358560427216896' || ''', ''' || '1350099836492595201' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1357977971827900433' || ''', ''' || '1346358560427216896' || ''', ''' || '1347027413357572097' || ''', ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:02:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1386680049203195905' || ''', ''' || '1346358560427216896' || ''', ''' || '1386680049203195904' || ''', ''' || '2021-04-26 21:54:22' || ''', ''' || '2021-04-26 21:54:21' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642195801722880' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642195797528576' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642195986272256' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642195982077952' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642196145655809' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642196145655808' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642196409896961' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642196409896960' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642196598640641' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642196598640640' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642197181648897' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642197181648896' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642197538164737' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642197538164736' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1387642197689159681' || ''', ''' || '1346358560427216896' || ''', ''' || '1387642197689159680' || ''', ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390305479235194880' || ''', ''' || '1346358560427216896' || ''', ''' || '1390305479231000576' || ''', ''' || '2021-05-06 22:00:32' || ''', ''' || '2021-05-06 22:00:31' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390305641097580545' || ''', ''' || '1346358560427216896' || ''', ''' || '1390305641097580544' || ''', ''' || '2021-05-06 22:01:10' || ''', ''' || '2021-05-06 22:01:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309613569036289' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309613569036288' || ''', ''' || '2021-05-06 22:16:57' || ''', ''' || '2021-05-06 22:16:57' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309729176637441' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309729176637440' || ''', ''' || '2021-05-06 22:17:25' || ''', ''' || '2021-05-06 22:17:24' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309914883641345' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309914883641344' || ''', ''' || '2021-05-06 22:18:09' || ''', ''' || '2021-05-06 22:18:09' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309936706605057' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309936706605056' || ''', ''' || '2021-05-06 22:18:14' || ''', ''' || '2021-05-06 22:18:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309954016497665' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309954016497664' || ''', ''' || '2021-05-06 22:18:18' || ''', ''' || '2021-05-06 22:18:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309981166227457' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309981166227456' || ''', ''' || '2021-05-06 22:18:25' || ''', ''' || '2021-05-06 22:18:24' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390309998543228929' || ''', ''' || '1346358560427216896' || ''', ''' || '1390309998543228928' || ''', ''' || '2021-05-06 22:18:29' || ''', ''' || '2021-05-06 22:18:29' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310018877214721' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310018877214720' || ''', ''' || '2021-05-06 22:18:34' || ''', ''' || '2021-05-06 22:18:33' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310036459737089' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310036459737088' || ''', ''' || '2021-05-06 22:18:38' || ''', ''' || '2021-05-06 22:18:38' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310053543137281' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310053543137280' || ''', ''' || '2021-05-06 22:18:42' || ''', ''' || '2021-05-06 22:18:42' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310073772265473' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310073772265472' || ''', ''' || '2021-05-06 22:18:47' || ''', ''' || '2021-05-06 22:18:46' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310094571819009' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310094571819008' || ''', ''' || '2021-05-06 22:18:52' || ''', ''' || '2021-05-06 22:18:51' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310112892538881' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310112892538880' || ''', ''' || '2021-05-06 22:18:56' || ''', ''' || '2021-05-06 22:18:56' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310128516321281' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310128516321280' || ''', ''' || '2021-05-06 22:19:00' || ''', ''' || '2021-05-06 22:19:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310145079627777' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310145079627776' || ''', ''' || '2021-05-06 22:19:04' || ''', ''' || '2021-05-06 22:19:03' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310166948728833' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310166948728832' || ''', ''' || '2021-05-06 22:19:09' || ''', ''' || '2021-05-06 22:19:09' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310188486479873' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310188486479872' || ''', ''' || '2021-05-06 22:19:14' || ''', ''' || '2021-05-06 22:19:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310205808955393' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310205808955392' || ''', ''' || '2021-05-06 22:19:18' || ''', ''' || '2021-05-06 22:19:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310247684886529' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310247684886528' || ''', ''' || '2021-05-06 22:19:28' || ''', ''' || '2021-05-06 22:19:28' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310264424353793' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310264424353792' || ''', ''' || '2021-05-06 22:19:32' || ''', ''' || '2021-05-06 22:19:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310282875097089' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310282875097088' || ''', ''' || '2021-05-06 22:19:37' || ''', ''' || '2021-05-06 22:19:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310298985418753' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310298985418752' || ''', ''' || '2021-05-06 22:19:41' || ''', ''' || '2021-05-06 22:19:40' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310354216013825' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310354216013824' || ''', ''' || '2021-05-06 22:19:54' || ''', ''' || '2021-05-06 22:19:53' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310376865255425' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310376865255424' || ''', ''' || '2021-05-06 22:19:59' || ''', ''' || '2021-05-06 22:19:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310406321852417' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310406321852416' || ''', ''' || '2021-05-06 22:20:06' || ''', ''' || '2021-05-06 22:20:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310423401058305' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310423401058304' || ''', ''' || '2021-05-06 22:20:10' || ''', ''' || '2021-05-06 22:20:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310441755332609' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310441755332608' || ''', ''' || '2021-05-06 22:20:15' || ''', ''' || '2021-05-06 22:20:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310459904086017' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310459904086016' || ''', ''' || '2021-05-06 22:20:19' || ''', ''' || '2021-05-06 22:20:19' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310476815519745' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310476815519744' || ''', ''' || '2021-05-06 22:20:23' || ''', ''' || '2021-05-06 22:20:23' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310492686766081' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310492686766080' || ''', ''' || '2021-05-06 22:20:27' || ''', ''' || '2021-05-06 22:20:26' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310509401067521' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310509401067520' || ''', ''' || '2021-05-06 22:20:31' || ''', ''' || '2021-05-06 22:20:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310527348494337' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310527348494336' || ''', ''' || '2021-05-06 22:20:35' || ''', ''' || '2021-05-06 22:20:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310544494809089' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310544494809088' || ''', ''' || '2021-05-06 22:20:39' || ''', ''' || '2021-05-06 22:20:39' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1390310562312212481' || ''', ''' || '1346358560427216896' || ''', ''' || '1390310562312212480' || ''', ''' || '2021-05-06 22:20:43' || ''', ''' || '2021-05-06 22:20:43' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768162320001' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768204263112' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768162320011' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768204263121' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768162320384' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768158126080' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768208457002' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768216846113' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768208457012' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768216846122' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768208457728' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768204263424' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768216846003' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768225234114' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768216846013' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768225234123' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768216846337' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768216846336' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768225234004' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768233623115' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768225234014' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768233623124' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768225234945' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768225234944' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768233623005' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768246206116' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768233623015' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768246206125' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768233623553' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768233623552' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768246206006' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768275566117' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768246206016' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768275566126' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768246206465' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768246206464' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768275566007' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768283955118' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768275566017' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768283955127' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768275566593' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768275566592' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768283955008' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768292343119' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768283955018' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768292343128' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768283955201' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768283955200' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768292343009' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768296538120' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768292343019' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768296538129' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768292343809' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768292343808' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768300732010' || ''', ''' || '1346358560427216896' || ''', ''' || '1347028169120821250' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768300732011' || ''', ''' || '1346358560427216896' || ''', ''' || '1347028169120821251' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1397547768300732416' || ''', ''' || '1346358560427216896' || ''', ''' || '1397547768296538112' || ''', ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252532449280' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252528254976' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252570198016' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252566003712' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252582780929' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252582780928' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252591169537' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252591169536' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252603752449' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252603752448' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252620529665' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252620529664' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252645695489' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252645695488' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252658278401' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252658278400' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252666667009' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252666667008' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1398994252679249921' || ''', ''' || '1346358560427216896' || ''', ''' || '1398994252679249920' || ''', ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534378686054400' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534378660888576' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534378979655680' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534378971267072' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379000627201' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379000627200' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379046764545' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379046764544' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379071930369' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379071930368' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379092901889' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379092901888' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379122262017' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379122262016' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379139039233' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379139039232' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379168399360' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379164205056' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1405534379185176577' || ''', ''' || '1346358560427216896' || ''', ''' || '1405534379185176576' || ''', ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771390504960' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771386310656' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771424059392' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771419865088' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771440836609' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771440836608' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771457613825' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771457613824' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771470196737' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771470196736' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771486973953' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771486973952' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771516334081' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771516334080' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771528916993' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771528916992' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771545694209' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771545694208' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431217771558277121' || ''', ''' || '1346358560427216896' || ''', ''' || '1431217771558277120' || ''', ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270939172865' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270939172864' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270947561473' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270947561472' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270955950081' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270955950080' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270968532993' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270968532992' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270972727297' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270972727296' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270981115905' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270981115904' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270989504513' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270989504512' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222270997893121' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222270997893120' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222271002087425' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222271002087424' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222271006281729' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222271006281728' || ''', ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367693377538' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367693377537' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367701766145' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367701766144' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367714349057' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367714349056' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367722737665' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367722737664' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367731126272' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367726931968' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367735320577' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367735320576' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367743709185' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367743709184' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367752097793' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367752097792' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367764680704' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367760486400' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875009' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875008' || ''', ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875010' || ''', ''' || '1346358560427216896' || ''', ''' || '1347028169120821252' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875011' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875009' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875012' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875010' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875013' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875011' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875014' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875012' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875015' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875013' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875016' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875014' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875017' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875015' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875018' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875016' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "permission" VALUES (''' || '1431222367768875019' || ''', ''' || '1346358560427216896' || ''', ''' || '1431222367768875017' || ''', ''' || '2021-11-24 19:49:38' || ''', ''' || '2021-11-24 19:49:37' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table plugin if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'plugin' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'plugin already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "plugin" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "name" varchar(62) COLLATE "pg_catalog"."default" NOT NULL,
	  "config" text COLLATE "pg_catalog"."default",
	  "role" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "sort" int4,
	  "enabled" int2 NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."name" IS ''' || 'plugin name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."config" IS ''' || 'plugin configuration' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."role" IS ''' || 'plug-in role' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."sort" IS ''' || 'sort' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."enabled" IS ''' || 'whether to open (0, not open, 1 open)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER plugin_trigger
	          BEFORE UPDATE ON plugin
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table plugin
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "plugin" ADD CONSTRAINT "plugin_pkey" PRIMARY KEY ("id");');

	-- ----------------------------
	-- Records of plugin
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '1' || ''', ''' || 'sign' || ''', NULL, ''' || 'Authentication' || ''', 20, 0, ''' || '2018-06-14 10:17:35' || ''', ''' || '2018-06-14 10:17:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '10' || ''', ''' || 'sentinel' || ''', NULL, ''' || 'FaultTolerance' || ''', 140, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '11' || ''', ''' || 'sofa' || ''', ''' || '{"protocol":"zookeeper","register":"127.0.0.1:2181"}' || ''', ''' || 'Proxy' || ''', 310, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '12' || ''', ''' || 'resilience4j' || ''', NULL, ''' || 'FaultTolerance' || ''', 310, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '13' || ''', ''' || 'tars' || ''', ''' || '{"multiSelectorHandle":"1","multiRuleHandle":"0"}' || ''', ''' || 'Proxy' || ''', 310, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '14' || ''', ''' || 'contextPath' || ''', NULL, ''' || 'HttpProcess' || ''', 80, 1, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '15' || ''', ''' || 'grpc' || ''', ''' || '{"multiSelectorHandle":"1","multiRuleHandle":"0"}' || ''', ''' || 'Proxy' || ''', 310, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '16' || ''', ''' || 'redirect' || ''', NULL, ''' || 'HttpProcess' || ''', 110, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '17' || ''', ''' || 'motan' || ''', ''' || '{"register":"127.0.0.1:2181"}' || ''', ''' || 'Proxy' || ''', 310, 0, ''' || '2020-11-09 01:19:10' || ''', ''' || '2020-11-09 01:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '18' || ''', ''' || 'logging' || ''', NULL, ''' || 'Logging' || ''', 160, 0, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '19' || ''', ''' || 'jwt' || ''', ''' || '{"secretKey":"key"}' || ''', ''' || 'Authentication' || ''', 30, 0, ''' || '2021-05-24 17:58:37' || ''', ''' || '2021-05-25 15:38:04' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '2' || ''', ''' || 'waf' || ''', ''' || '{"model":"black"}' || ''', ''' || 'Authentication' || ''', 50, 0, ''' || '2018-06-23 10:26:30' || ''', ''' || '2018-06-13 15:43:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '20' || ''', ''' || 'request' || ''', NULL, ''' || 'HttpProcess' || ''', 120, 0, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-30 19:55:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '21' || ''', ''' || 'oauth2' || ''', NULL, ''' || 'Authentication' || ''', 40, 0, ''' || '2021-06-18 10:53:42' || ''', ''' || '2021-06-18 10:53:42' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '22' || ''', ''' || 'paramMapping' || ''', ''' || '{"ruleHandlePageType":"custom"}' || ''', ''' || 'HttpProcess' || ''', 70, 0, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:36:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '23' || ''', ''' || 'modifyResponse' || ''', ''' || '{"ruleHandlePageType":"custom"}' || ''', ''' || 'HttpProcess' || ''', 220, 0, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 23:26:11' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '24' || ''', ''' || 'cryptorRequest' || ''', NULL, ''' || 'Cryptor' || ''', 100, 1, ''' || '2021-08-06 13:55:21' || ''', ''' || '2021-08-17 16:35:41' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '25' || ''', ''' || 'cryptorResponse' || ''', NULL, ''' || 'Cryptor' || ''', 410, 1, ''' || '2021-08-06 13:55:30' || ''', ''' || '2021-08-13 16:03:40' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '26' || ''', ''' || 'websocket' || ''', ''' || '{"multiSelectorHandle":"1"}' || ''', ''' || 'Proxy' || ''', 200, 1, ''' || '2021-08-27 13:55:30' || ''', ''' || '2021-08-27 16:03:40' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '3' || ''', ''' || 'rewrite' || ''', NULL, ''' || 'HttpProcess' || ''', 90, 0, ''' || '2018-06-23 10:26:34' || ''', ''' || '2018-06-25 13:59:31' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '4' || ''', ''' || 'rateLimiter' || ''', ''' || '{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}' || ''', ''' || 'FaultTolerance' || ''', 60, 0, ''' || '2018-06-23 10:26:37' || ''', ''' || '2018-06-13 15:34:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '5' || ''', ''' || 'divide' || ''', ''' || '{"multiSelectorHandle":"1","multiRuleHandle":"0"}' || ''', ''' || 'Proxy' || ''', 200, 1, ''' || '2018-06-25 10:19:10' || ''', ''' || '2018-06-13 13:56:04' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '6' || ''', ''' || 'dubbo' || ''', ''' || '{"register":"zookeeper://localhost:2181","multiSelectorHandle":"1"}' || ''', ''' || 'Proxy' || ''', 310, 0, ''' || '2018-06-23 10:26:41' || ''', ''' || '2018-06-11 10:11:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '7' || ''', ''' || 'monitor' || ''', ''' || '{"metricsName":"prometheus","host":"localhost","port":"9190","async":"true"}' || ''', ''' || 'Monitor' || ''', 170, 0, ''' || '2018-06-25 13:47:57' || ''', ''' || '2018-06-25 13:47:57' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '8' || ''', ''' || 'springCloud' || ''', NULL, ''' || 'Proxy' || ''', 200, 0, ''' || '2018-06-25 13:47:57' || ''', ''' || '2018-06-25 13:47:57' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '9' || ''', ''' || 'hystrix' || ''', NULL, ''' || 'FaultTolerance' || ''', 130, 0, ''' || '2020-01-15 10:19:10' || ''', ''' || '2020-01-15 10:19:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "plugin" VALUES (''' || '27' || ''', ''' || 'rpcContext' || ''', ''' || '{"multiRuleHandle":"1"}' || ''', ''' || 'Common' || ''', 125, 0, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table plugin_handle if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'plugin_handle' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'plugin_handle already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "plugin_handle" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "plugin_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "field" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
	  "label" varchar(100) COLLATE "pg_catalog"."default",
	  "data_type" int2 NOT NULL,
	  "type" int2,
	  "sort" int4,
	  "ext_obj" varchar(1024) COLLATE "pg_catalog"."default",
	  "date_created" TIMESTAMP NOT NULL DEFAULT TIMEZONE(''UTC-8''::TEXT, NOW()::TIMESTAMP(0) WITHOUT TIME ZONE),
	  "date_updated" TIMESTAMP NOT NULL DEFAULT TIMEZONE(''UTC-8''::TEXT, NOW()::TIMESTAMP(0) WITHOUT TIME ZONE)
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."plugin_id" IS ''' || 'plugin id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."field" IS ''' || 'field' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."label" IS ''' || 'label' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."data_type" IS ''' || 'data type 1 number 2 string' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."type" IS ''' || 'type, 1 means selector, 2 means rule, 3 means plugin' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."sort" IS ''' || 'sort' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."ext_obj" IS ''' || 'extra configuration (json format data)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "plugin_handle"."date_updated" IS ''' || 'update time' || '''');

    ----------------------------
	-- Create Rule for table shenyu_dict
	-- ----------------------------
    PERFORM public.dblink_exec('init_conn',  'create rule plugin_handle_insert_ignore as on insert to plugin_handle where exists (select 1 from plugin_handle where id = new.id) do instead nothing;');

	-- ----------------------------
	-- Primary Key structure for table plugin_handle
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "plugin_handle" ADD CONSTRAINT "plugin_handle_pkey" PRIMARY KEY ("id");');

	-- ----------------------------
	-- Create Sequence for table plugin_handle
	-- ----------------------------
    PERFORM public.dblink_exec('init_conn',  'CREATE SEQUENCE plugin_handle_ID_seq;	');
	PERFORM public.dblink_exec('init_conn',  'ALTER SEQUENCE plugin_handle_ID_seq OWNED BY plugin_handle.ID;');

	-- ----------------------------
	-- Indexes structure for table plugin_handle
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'CREATE INDEX "plugin_id_field_type" ON "plugin_handle" USING btree (
	  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
	  "field" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
	  "type" "pg_catalog"."int2_ops" ASC NULLS LAST
	);');

	-- ----------------------------
	-- Primary FUNCTION for table plugin_handle
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  ' CREATE OR REPLACE FUNCTION plugin_handle_insert() RETURNS trigger AS $BODY$
            BEGIN
                NEW.ID := nextval('''||'plugin_handle_ID_seq' || ''');
                RETURN NEW;
            END;
            $BODY$
              LANGUAGE plpgsql;'
    );

	-- ----------------------------
	-- Create TRIGGER for table plugin_handle
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER plugin_handle_check_insert
        BEFORE INSERT ON plugin_handle
        FOR EACH ROW
        WHEN (NEW.ID IS NULL)
        EXECUTE PROCEDURE plugin_handle_insert();'
    );
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER plugin_handle_trigger
	          BEFORE UPDATE ON plugin_handle
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()'
    );

    ----------------------------
	-- Records of plugin_handle
	-- ----------------------------
	/*insert "plugin_handle" data for sentinel*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'flowRuleGrade' || ''',''' || 'flowRuleGrade' || ''',''' || '3' || ''', 2, 8, ''' || '{"required":"1","defaultValue":"1","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'flowRuleControlBehavior' || ''',''' || 'flowRuleControlBehavior' || ''',''' || '3' || ''', 2, 5, ''' || '{"required":"1","defaultValue":"0","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'flowRuleEnable' || ''',''' || 'flowRuleEnable (1 or 0)' || ''', ''' || '1' || ''', 2, 7, ''' || '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'flowRuleCount' || ''',''' || 'flowRuleCount' || ''',''' || '1' || ''', 2, 6, ''' || '{"required":"1","defaultValue":"0","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleEnable' || ''',''' || 'degradeRuleEnable (1 or 0)' || ''', ''' || '1' || ''', 2, 2, ''' || '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleGrade' || ''',''' || 'degradeRuleGrade' || ''',''' || '3' || ''', 2, 3, ''' || '{"required":"1","defaultValue":"0","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleCount' || ''',''' || 'degradeRuleCount' || ''',''' || '1' || ''', 2, 1, ''' || '{"required":"1","defaultValue":"0","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleTimeWindow' || ''',''' || 'degradeRuleTimeWindow' || ''',''' || '1' || ''', 2, 4, ''' || '{"required":"1","defaultValue":"0","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleMinRequestAmount' || ''',''' || 'degradeRuleMinRequestAmount' || ''',''' || '1' || ''', 2, 3, ''' || '{"required":"1","defaultValue":"5","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleStatIntervals' || ''',''' || 'degradeRuleStatIntervals' || ''',''' || '1' || ''', 2, 3, ''' || '{"required":"1","defaultValue":"1","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''' ,''' || 'degradeRuleSlowRatioThreshold' || ''',''' || 'degradeRuleSlowRatioThreshold' || ''',''' || '1' || ''', 2, 3, ''' || '{"required":"1","defaultValue":"0.5","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '10' || ''', ''' || 'fallbackUri' || ''', ''' || 'fallbackUri' || ''', 2, 2, 9, ''' || '{"required":"0","rule":""}' || ''');');

    /*insert "plugin_handle" data for waf*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '2' || ''' ,''' || 'permission' || ''',''' || 'permission' || ''',''' || '3' || ''', 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '2' || ''' ,''' || 'statusCode' || ''',''' || 'statusCode' || ''',''' || '2' || ''', 2, 2);');

    /*insert "plugin_handle" data for rateLimiter*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '4' || ''' ,''' || 'replenishRate' || ''',''' || 'replenishRate' || ''', 2, 2, 2, ''' || '{"required":"1","defaultValue":"10","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '4' || ''' ,''' || 'burstCapacity' || ''',''' || 'burstCapacity' || ''', 2, 2, 3, ''' || '{"required":"1","defaultValue":"100","rule":""}' || ''');');

    /*insert "plugin_handle" data for rewrite*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '3' || ''', ''' || 'regex' || ''', ''' || 'regex' || ''', 2, 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '3' || ''', ''' || 'replace' || ''', ''' || 'replace' || ''', 2, 2, 2);');

    /*insert "plugin_handle" data for redirect*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '16' || ''' ,''' || 'redirectURI' || ''',''' || 'redirectURI' || ''', 2, 2, 1);');

    /*insert "plugin_handle" data for springCloud*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '8' || ''' ,''' || 'path' || ''',''' || 'path' || ''', 2, 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '8' || ''' ,''' || 'timeout' || ''',''' || 'timeout (ms)' || ''', 1, 2, 2);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '8' || ''' ,''' || 'serviceId' || ''',''' || 'serviceId' || ''', 2, 1, 1);');

    /*insert "plugin_handle" data for resilience4j*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'timeoutDurationRate' || ''',''' || 'timeoutDurationRate (ms)' || ''', 1, 2, 1, ''' || '{"required":"1","defaultValue":"5000","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'limitRefreshPeriod' || ''',''' || 'limitRefreshPeriod (ms)' || ''', 1, 2, 0, ''' || '{"required":"1","defaultValue":"500","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'limitForPeriod' || ''',''' || 'limitForPeriod' || ''', 1, 2, 0, ''' || '{"required":"1","defaultValue":"50","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'circuitEnable' || ''',''' || 'circuitEnable' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'timeoutDuration' || ''',''' || 'timeoutDuration (ms)' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"30000","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '12' || ''' ,''' || 'fallbackUri' || ''',''' || 'fallbackUri' || ''', 2, 2, 2);');

    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'slidingWindowSize' || ''',''' || 'slidingWindowSize' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"100","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'slidingWindowType' || ''',''' || 'slidingWindowType' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'minimumNumberOfCalls' || ''',''' || 'minimumNumberOfCalls' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"100","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'waitIntervalFunctionInOpenState' || ''',''' || 'waitIntervalInOpen' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"60000","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'permittedNumberOfCallsInHalfOpenState' || ''',''' || 'bufferSizeInHalfOpen' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"10","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''' ,''' || 'failureRateThreshold' || ''',''' || 'failureRateThreshold' || ''', 1, 2, 2, ''' || '{"required":"1","defaultValue":"50","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '12' || ''', ''' || 'automaticTransitionFromOpenToHalfOpenEnabled' || ''', ''' || 'automaticHalfOpen' || ''', 3, 2, 1, ''' || '{"required":"1","defaultValue":"true","rule":""}' || ''');');

    /*insert "plugin_handle" data for plugin*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '4' || ''', ''' || 'mode' || ''', ''' || 'mode' || ''', 3, 3, 1, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '4' || ''', ''' || 'master' || ''', ''' || 'master' || ''', 2, 3, 2, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '4' || ''', ''' || 'url' || ''', ''' || 'url' || ''', 2, 3, 3, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '4' || ''', ''' || 'password' || ''', ''' || 'password' || ''', 2, 3, 4, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '11' || ''', ''' || 'protocol' || ''', ''' || 'protocol' || ''', 2, 3, 1, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '11' || ''', ''' || 'register' || ''', ''' || 'register' || ''', 2, 3, 2, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '2' || ''', ''' || 'model' || ''', ''' || 'model' || ''', 2, 3, 1, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'register' || ''', ''' || 'register' || ''', 2, 3, 1, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '7' || ''', ''' || 'metricsName' || ''', ''' || 'metricsName' || ''', 2, 3, 1, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '7' || ''', ''' || 'host' || ''', ''' || 'host' || ''', 2, 3, 2, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '7' || ''', ''' || 'port' || ''', ''' || 'port' || ''', 2, 3, 3, ''' || '{"rule":"/^[0-9]*$/"}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '7' || ''', ''' || 'async' || ''', ''' || 'async' || ''', 2, 3, 4, NULL);');
    /*insert "plugin_handle" data for plugin rateLimiter*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '4' || ''' ,''' || 'algorithmName' || ''',''' || 'algorithmName' || ''',''' || '3' || ''', 2, 1, ''' || '{"required":"1","defaultValue":"slidingWindow","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '4' || ''' ,''' || 'keyResolverName' || ''',''' || 'keyResolverName' || ''',''' || '3' || ''', 2, 4, ''' || '{"required":"1","defaultValue":"WHOLE_KEY_RESOLVER","rule":""}' || ''');');

    /*insert "plugin_handle" data for divide*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'upstreamHost' || ''', ''' || 'host' || ''', 2, 1, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'protocol' || ''', ''' || 'protocol' || ''', 2, 1, 2, ''' || '{"required":"0","defaultValue":"","placeholder":"http://","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'upstreamUrl' || ''', ''' || 'ip:port' || ''', 2, 1, 1, ''' || '{"required":"1","placeholder":"","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'weight' || ''', ''' || 'weight' || ''', 1, 1, 3, ''' || '{"defaultValue":"50","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'timestamp' || ''', ''' || 'startupTime' || ''', 1, 1, 3, ''' || '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'warmup' || ''', ''' || 'warmupTime' || ''', 1, 1, 5, ''' || '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'status' || ''', ''' || 'status' || ''', 3, 1, 6, ''' || '{"defaultValue":"true","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'loadBalance' || ''', ''' || 'loadStrategy' || ''', 3, 2, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'retry' || ''', ''' || 'retryCount' || ''', 1, 2, 1, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'timeout' || ''', ''' || 'timeout' || ''', 1, 2, 2, ''' || '{"defaultValue":"3000","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'multiSelectorHandle' || ''', ''' || 'multiSelectorHandle' || ''', 3, 3, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'multiRuleHandle' || ''', ''' || 'multiRuleHandle' || ''', 3, 3, 1, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'headerMaxSize' || ''', ''' || 'headerMaxSize' || ''', 1, 2, 3, ''' || '{"defaultValue":"10240","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '5' || ''', ''' || 'requestMaxSize' || ''', ''' || 'requestMaxSize' || ''', 1, 2, 4, ''' || '{"defaultValue":"102400","rule":""}' || ''');');


    /*insert "plugin_handle" data for tars*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'upstreamHost' || ''', ''' || 'host' || ''', 2, 1, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'protocol' || ''', ''' || 'protocol' || ''', 2, 1, 2, ''' || '{"defaultValue":"","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'upstreamUrl' || ''', ''' || 'ip:port' || ''', 2, 1, 1, ''' || '{"required":"1","placeholder":"","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'weight' || ''', ''' || 'weight' || ''', 1, 1, 3, ''' || '{"defaultValue":"50","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'timestamp' || ''', ''' || 'startupTime' || ''', 1, 1, 3, ''' || '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'warmup' || ''', ''' || 'warmupTime' || ''', 1, 1, 5, ''' || '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'status' || ''', ''' || 'status' || ''', 3, 1, 6, ''' || '{"defaultValue":"true","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'loadBalance' || ''', ''' || 'loadStrategy' || ''', 3, 2, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'retry' || ''', ''' || 'retryCount' || ''', 1, 2, 1, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'timeout' || ''', ''' || 'timeout' || ''', 1, 2, 2, ''' || '{"defaultValue":"3000","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'multiSelectorHandle' || ''', ''' || 'multiSelectorHandle' || ''', 3, 3, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '13' || ''', ''' || 'multiRuleHandle' || ''', ''' || 'multiRuleHandle' || ''', 3, 3, 1, null);');

    /*insert "plugin_handle" data for grpc*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '15' || ''', ''' || 'upstreamUrl' || ''', ''' || 'ip:port' || ''', 2, 1, 1, ''' || '{"required":"1","placeholder":"","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '15' || ''', ''' || 'weight' || ''', ''' || 'weight' || ''', 1, 1, 3, ''' || '{"defaultValue":"50","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '15' || ''', ''' || 'status' || ''', ''' || 'status' || ''', 3, 1, 6, ''' || '{"defaultValue":"true","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '15' || ''', ''' || 'multiSelectorHandle' || ''', ''' || 'multiSelectorHandle' || ''', 3, 3, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '15' || ''', ''' || 'multiRuleHandle' || ''', ''' || 'multiRuleHandle' || ''', 3, 3, 1, null);');

    /*insert "plugin_handle" data for context path*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '14' || ''', ''' || 'contextPath' || ''', ''' || 'contextPath' || ''', 2, 2, 0);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort ) VALUES (''' || '14' || ''', ''' || 'addPrefix' || ''', ''' || 'addPrefix' || ''', 2, 2, 0);');

    /*insert "plugin_handle" data for request*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '20' || ''', ''' || 'ruleHandlePageType' || ''', ''' || 'ruleHandlePageType' || ''', 3, 3, 0, ''' || '{"required":"0","rule":""}' || ''');');

    /*insert "plugin_handle" data for plugin jwt*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '19' || ''' ,''' || 'secretKey' || ''',''' || 'secretKey' || ''',2, 3, 0, null);');

    /*insert "plugin_handle" data for plugin Cryptor*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '24' || ''', ''' || 'strategyName' || ''', ''' || 'strategyName' || ''', 3, 2, 1, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '24' || ''', ''' || 'fieldNames' || ''', ''' || 'fieldNames' || ''', 2, 2, 3, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '24' || ''', ''' || 'decryptKey' || ''', ''' || 'decryptKey' || ''', 2, 2, 3, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '24' || ''', ''' || 'encryptKey' || ''', ''' || 'encryptKey' || ''', 2, 2, 3, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '24' || ''', ''' || 'way' || ''', ''' || 'way' || ''', 3, 2, 3, NULL);');

    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '25' || ''', ''' || 'strategyName' || ''', ''' || 'strategyName' || ''', 3, 2, 2, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '25' || ''', ''' || 'decryptKey' || ''', ''' || 'decryptKey' || ''', 2, 2, 3, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '25' || ''', ''' || 'encryptKey' || ''', ''' || 'encryptKey' || ''', 2, 2, 3, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '25' || ''', ''' || 'fieldNames' || ''', ''' || 'fieldNames' || ''', 2, 2, 4, NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '25' || ''', ''' || 'way' || ''', ''' || 'way' || ''', 3, 2, 3, NULL);');

    /*insert "plugin_handle" data for dubbo*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'gray' || ''', ''' || 'gray' || ''', ''' || '3' || ''', ''' || '1' || ''', ''' || '9' || ''', ''' || '{"required":"0","defaultValue":"false","placeholder":"gray","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'group' || ''', ''' || 'group' || ''', ''' || '2' || ''', ''' || '1' || ''', ''' || '3' || ''', ''' || '{"required":"0","placeholder":"group","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'loadbalance' || ''', ''' || 'loadbalance' || ''', ''' || '2' || ''', ''' || '2' || ''', ''' || '0' || ''', ''' || '{"required":"0","placeholder":"loadbalance","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'multiSelectorHandle' || ''', ''' || 'multiSelectorHandle' || ''', ''' || '3' || ''', ''' || '3' || ''', ''' || '0' || ''', NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'protocol' || ''', ''' || 'protocol' || ''', ''' || '2' || ''', ''' || '1' || ''', ''' || '2' || ''', ''' || '{"required":"0","defaultValue":"","placeholder":"http://","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'status' || ''', ''' || 'status' || ''', ''' || '3' || ''', ''' || '1' || ''', ''' || '8' || ''', ''' || '{"defaultValue":"true","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'timestamp' || ''', ''' || 'startupTime' || ''', ''' || '1' || ''', ''' || '1' || ''', ''' || '7' || ''', ''' || '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'upstreamHost' || ''', ''' || 'host' || ''', ''' || '2' || ''', ''' || '1' || ''', ''' || '0' || ''', NULL);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'upstreamUrl' || ''', ''' || 'ip:port' || ''', ''' || '2' || ''', ''' || '1' || ''', ''' || '1' || ''', ''' || '{"required":"1","placeholder":"","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'version' || ''', ''' || 'version' || ''', ''' || '2' || ''', ''' || '1' || ''', ''' || '4' || ''', ''' || '{"required":"0","placeholder":"version","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'warmup' || ''', ''' || 'warmupTime' || ''', ''' || '1' || ''', ''' || '1' || ''', ''' || '6' || ''', ''' || '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id ,  field ,  label ,  data_type ,  type ,  sort ,  ext_obj ) VALUES (''' || '6' || ''', ''' || 'weight' || ''', ''' || 'weight' || ''', ''' || '1' || ''', ''' || '1' || ''', ''' || '5' || ''', ''' || '{"defaultValue":"50","rule":""}' || ''');');

    /*insert "plugin_handle" data for websocket*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'host' || ''', ''' || 'host' || ''', 2, 1, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'protocol' || ''', ''' || 'protocol' || ''', 2, 1, 2, ''' || '{"required":"0","defaultValue":"","placeholder":"ws://","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'url' || ''', ''' || 'ip:port' || ''', 2, 1, 1, ''' || '{"required":"1","placeholder":"","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'weight' || ''', ''' || 'weight' || ''', 1, 1, 3, ''' || '{"defaultValue":"50","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'timestamp' || ''', ''' || 'startupTime' || ''', 1, 1, 3, ''' || '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'warmup' || ''', ''' || 'warmupTime' || ''', 1, 1, 5, ''' || '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'status' || ''', ''' || 'status' || ''', 3, 1, 6, ''' || '{"defaultValue":"true","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'loadBalance' || ''', ''' || 'loadStrategy' || ''', 3, 2, 0, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'retry' || ''', ''' || 'retryCount' || ''', 1, 2, 1, null);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'timeout' || ''', ''' || 'timeout' || ''', 1, 2, 2, ''' || '{"defaultValue":"3000","rule":""}' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '26' || ''', ''' || 'multiSelectorHandle' || ''', ''' || 'multiSelectorHandle' || ''', 3, 3, 0, null);');

    /*insert "plugin_handle" data for plugin motan*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '17' || ''', ''' || 'register' || ''', ''' || 'register' || ''', 2, 3, 0, null);');

    /*insert "plugin_handle" data for plugin rpcContext*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '127' || ''', ''' || '27' || ''', ''' || 'multiRuleHandle' || ''', ''' || 'multiRuleHandle' || ''', 3, 3, 0, NULL, ''' || '2021-11-24 13:18:44' || ''', ''' || '2021-11-24 13:18:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '124' || ''', ''' || '27' || ''', ''' || 'rpcContextType' || ''', ''' || 'rpcContextType' || ''', 3, 2, 1, ''' || '{"required":"1","defaultValue":"addRpcContext","rule":""}' || ''', ''' || '2021-07-18 22:52:20' || ''', ''' || '2021-07-18 22:59:57' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '125' || ''', ''' || '27' || ''', ''' || 'rpcContextKey' || ''', ''' || 'rpcContextKey' || ''', 2, 2, 1, ''' || '{"required":"1","defaultValue":"","rule":""}' || ''', ''' || '2021-07-18 22:52:20' || ''', ''' || '2021-07-18 22:59:57' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT  INTO "plugin_handle" ( plugin_id , field , label , data_type , type , sort , ext_obj ) VALUES (''' || '126' || ''', ''' || '27' || ''', ''' || 'rpcContextValue' || ''', ''' || 'rpcContextValue' || ''', 2, 2, 1, ''' || '{"required":"0","defaultValue":"","rule":""}' || ''', ''' || '2021-07-18 22:52:20' || ''', ''' || '2021-07-18 22:59:57' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');

END IF;


-- ----------------------------------------------------
-- create table resource if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'resource' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'resource already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "resource" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "parent_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "title" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "name" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
	  "url" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
	  "component" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
	  "resource_type" int4 NOT NULL,
	  "sort" int4 NOT NULL,
	  "icon" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
	  "is_leaf" int2 NOT NULL,
	  "is_route" int4 NOT NULL,
	  "perms" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "status" int4 NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');

	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."parent_id" IS ''' || 'resource parent primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."title" IS ''' || 'title' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."name" IS ''' || 'route name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."url" IS ''' || 'route url' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."component" IS ''' || 'component' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."resource_type" IS ''' || 'resource type eg 0:main menu 1:child menu 2:function button' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."sort" IS ''' || 'sort' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."icon" IS ''' || 'icon' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."is_leaf" IS ''' || 'leaf node 0:no 1:yes' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."is_route" IS ''' || 'route 1:yes 0:no' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."perms" IS ''' || 'button permission description sys:user:add(add)/sys:user:edit(edit)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."status" IS ''' || 'status 1:enable 0:disable' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "resource"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON TABLE "resource" IS ''' || 'resource table' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER resource_trigger
	          BEFORE UPDATE ON resource
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table resource
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "resource" ADD CONSTRAINT "resource_pkey" PRIMARY KEY ("id");');

	-- ----------------------------
	-- Records of resource
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346775491550474240' || ''', ''' || '' || ''', ''' || 'SHENYU.MENU.PLUGIN.LIST' || ''', ''' || 'plug' || ''', ''' || '/plug' || ''', ''' || 'PluginList' || ''', 0, 0, ''' || 'dashboard' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:07:54' || ''', ''' || '2021-01-07 18:34:11' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346776175553376256' || ''', ''' || '' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT' || ''', ''' || 'system' || ''', ''' || '/system' || ''', ''' || 'system' || ''', 0, 2, ''' || 'setting' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:10:37' || ''', ''' || '2021-01-07 11:41:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346777157943259136' || ''', ''' || '1346776175553376256' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.USER' || ''', ''' || 'manage' || ''', ''' || '/system/manage' || ''', ''' || 'manage' || ''', 1, 1, ''' || 'user' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:14:31' || ''', ''' || '2021-01-15 23:46:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346777449787125760' || ''', ''' || '1357956838021890048' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.PLUGIN' || ''', ''' || 'plugin' || ''', ''' || '/config/plugin' || ''', ''' || 'plugin' || ''', 1, 2, ''' || 'book' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:15:41' || ''', ''' || '2021-01-15 23:46:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346777623011880960' || ''', ''' || '1357956838021890048' || ''', ''' || 'SHENYU.PLUGIN.PLUGINHANDLE' || ''', ''' || 'pluginhandle' || ''', ''' || '/config/pluginhandle' || ''', ''' || 'pluginhandle' || ''', 1, 3, ''' || 'down-square' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:16:22' || ''', ''' || '2021-01-15 23:46:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346777766301888512' || ''', ''' || '1357956838021890048' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.AUTHEN' || ''', ''' || 'auth' || ''', ''' || '/config/auth' || ''', ''' || 'auth' || ''', 1, 4, ''' || 'audit' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:16:56' || ''', ''' || '2021-01-15 23:46:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346777907096285184' || ''', ''' || '1357956838021890048' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.METADATA' || ''', ''' || 'metadata' || ''', ''' || '/config/metadata' || ''', ''' || 'metadata' || ''', 1, 5, ''' || 'snippets' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:17:30' || ''', ''' || '2021-01-15 23:46:39' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1346778036402483200' || ''', ''' || '1357956838021890048' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.DICTIONARY' || ''', ''' || 'dict' || ''', ''' || '/config/dict' || ''', ''' || 'dict' || ''', 1, 6, ''' || 'ordered-list' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 05:18:00' || ''', ''' || '2021-01-15 23:46:41' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347026381504262144' || ''', ''' || '1346775491550474240' || ''', ''' || 'divide' || ''', ''' || 'divide' || ''', ''' || '/plug/divide' || ''', ''' || 'divide' || ''', 1, 0, ''' || 'border-bottom' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:44:51' || ''', ''' || '2021-01-17 16:01:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347026805170909184' || ''', ''' || '1346775491550474240' || ''', ''' || 'hystrix' || ''', ''' || 'hystrix' || ''', ''' || '/plug/hystrix' || ''', ''' || 'hystrix' || ''', 1, 1, ''' || 'stop' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:46:32' || ''', ''' || '2021-01-07 11:46:31' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027413357572096' || ''', ''' || '1346775491550474240' || ''', ''' || 'rewrite' || ''', ''' || 'rewrite' || ''', ''' || '/plug/rewrite' || ''', ''' || 'rewrite' || ''', 1, 2, ''' || 'redo' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:48:57' || ''', ''' || '2021-01-07 11:48:56' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027413357572097' || ''', ''' || '1346775491550474240' || ''', ''' || 'redirect' || ''', ''' || 'redirect' || ''', ''' || '/plug/redirect' || ''', ''' || 'redirect' || ''', 1, 16, ''' || 'redo' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:48:57' || ''', ''' || '2021-01-07 11:48:56' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027482244820992' || ''', ''' || '1346775491550474240' || ''', ''' || 'springCloud' || ''', ''' || 'springCloud' || ''', ''' || '/plug/springCloud' || ''', ''' || 'springCloud' || ''', 1, 3, ''' || 'ant-cloud' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:49:13' || ''', ''' || '2021-01-07 11:49:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027526339538944' || ''', ''' || '1346775491550474240' || ''', ''' || 'sign' || ''', ''' || 'sign' || ''', ''' || '/plug/sign' || ''', ''' || 'sign' || ''', 1, 5, ''' || 'highlight' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:49:23' || ''', ''' || '2021-01-07 14:12:07' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027566034432000' || ''', ''' || '1346775491550474240' || ''', ''' || 'waf' || ''', ''' || 'waf' || ''', ''' || '/plug/waf' || ''', ''' || 'waf' || ''', 1, 6, ''' || 'database' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:49:33' || ''', ''' || '2021-01-07 14:12:09' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027647999520768' || ''', ''' || '1346775491550474240' || ''', ''' || 'rateLimiter' || ''', ''' || 'rateLimiter' || ''', ''' || '/plug/rateLimiter' || ''', ''' || 'rateLimiter' || ''', 1, 7, ''' || 'pause' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:49:53' || ''', ''' || '2021-01-07 14:12:11' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027717792739328' || ''', ''' || '1346775491550474240' || ''', ''' || 'dubbo' || ''', ''' || 'dubbo' || ''', ''' || '/plug/dubbo' || ''', ''' || 'dubbo' || ''', 1, 8, ''' || 'align-left' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:50:09' || ''', ''' || '2021-01-07 14:12:12' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027769747582976' || ''', ''' || '1346775491550474240' || ''', ''' || 'monitor' || ''', ''' || 'monitor' || ''', ''' || '/plug/monitor' || ''', ''' || 'monitor' || ''', 1, 9, ''' || 'camera' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:50:22' || ''', ''' || '2021-01-07 14:12:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027830602739712' || ''', ''' || '1346775491550474240' || ''', ''' || 'sentinel' || ''', ''' || 'sentinel' || ''', ''' || '/plug/sentinel' || ''', ''' || 'sentinel' || ''', 1, 10, ''' || 'pic-center' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:50:36' || ''', ''' || '2021-01-07 14:12:16' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027918121086976' || ''', ''' || '1346775491550474240' || ''', ''' || 'resilience4j' || ''', ''' || 'resilience4j' || ''', ''' || '/plug/resilience4j' || ''', ''' || 'resilience4j' || ''', 1, 11, ''' || 'pic-left' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:50:57' || ''', ''' || '2021-01-07 14:12:20' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347027995199811584' || ''', ''' || '1346775491550474240' || ''', ''' || 'tars' || ''', ''' || 'tars' || ''', ''' || '/plug/tars' || ''', ''' || 'tars' || ''', 1, 12, ''' || 'border-bottom' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:51:15' || ''', ''' || '2021-01-07 14:12:21' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347028169120821248' || ''', ''' || '1346775491550474240' || ''', ''' || 'contextPath' || ''', ''' || 'contextPath' || ''', ''' || '/plug/contextPath' || ''', ''' || 'contextPath' || ''', 1, 13, ''' || 'retweet' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:51:57' || ''', ''' || '2021-01-07 14:12:24' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347028169120821249' || ''', ''' || '1346775491550474240' || ''', ''' || 'grpc' || ''', ''' || 'grpc' || ''', ''' || '/plug/grpc' || ''', ''' || 'grpc' || ''', 1, 15, ''' || 'retweet' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-06 21:51:57' || ''', ''' || '2021-01-07 14:12:24' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347028169120821250' || ''', ''' || '1346775491550474240' || ''', ''' || 'jwt' || ''', ''' || 'jwt' || ''', ''' || '/plug/jwt' || ''', ''' || 'jwt' || ''', 1, 16, ''' || 'key' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-06-18 21:00:00' || ''', ''' || '2021-06-18 21:00:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347028169120821251' || ''', ''' || '1346775491550474240' || ''', ''' || 'oauth2' || ''', ''' || 'oauth2' || ''', ''' || '/plug/oauth2' || ''', ''' || 'oauth2' || ''', 1, 18, ''' || 'safety' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-06-18 21:00:00' || ''', ''' || '2021-06-18 21:00:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347032308726902784' || ''', ''' || '1346777157943259136' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:manager:add' || ''', 1, ''' || '2021-01-06 22:08:24' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347032395901317120' || ''', ''' || '1346777157943259136' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:manager:list' || ''', 1, ''' || '2021-01-06 22:08:44' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347032453707214848' || ''', ''' || '1346777157943259136' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:manager:delete' || ''', 1, ''' || '2021-01-06 22:08:58' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347032509051056128' || ''', ''' || '1346777157943259136' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:manager:edit' || ''', 1, ''' || '2021-01-06 22:09:11' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347034027070337024' || ''', ''' || '1346777449787125760' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:plugin:list' || ''', 1, ''' || '2021-01-06 22:15:00' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347039054925148160' || ''', ''' || '1346777449787125760' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:plugin:delete' || ''', 1, ''' || '2021-01-06 22:34:38' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347041326749691904' || ''', ''' || '1346777449787125760' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:plugin:add' || ''', 1, ''' || '2021-01-06 22:44:14' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347046566244003840' || ''', ''' || '1346777449787125760' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:plugin:modify' || ''', 1, ''' || '2021-01-07 13:05:03' || ''', ''' || '2021-01-17 12:06:23' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347047143350874112' || ''', ''' || '1346777449787125760' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ENABLE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'system:plugin:disable' || ''', 1, ''' || '2021-01-07 13:07:21' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347047203220369408' || ''', ''' || '1346777449787125760' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'system:plugin:edit' || ''', 1, ''' || '2021-01-07 13:07:35' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347047555588042752' || ''', ''' || '1346777623011880960' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:pluginHandler:list' || ''', 1, ''' || '2021-01-07 13:08:59' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347047640145211392' || ''', ''' || '1346777623011880960' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:pluginHandler:delete' || ''', 1, ''' || '2021-01-07 13:09:19' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347047695002513408' || ''', ''' || '1346777623011880960' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:pluginHandler:add' || ''', 1, ''' || '2021-01-07 13:09:32' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347047747305484288' || ''', ''' || '1346777623011880960' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:pluginHandler:edit' || ''', 1, ''' || '2021-01-07 13:09:45' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048004105940992' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:authen:list' || ''', 1, ''' || '2021-01-07 13:10:46' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048101875167232' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:authen:delete' || ''', 1, ''' || '2021-01-07 13:11:09' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048145877610496' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:authen:add' || ''', 1, ''' || '2021-01-07 13:11:20' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048240677269504' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ENABLE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:authen:disable' || ''', 1, ''' || '2021-01-07 13:11:42' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048316216684544' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'system:authen:modify' || ''', 1, ''' || '2021-01-07 13:12:00' || ''', ''' || '2021-01-17 12:06:23' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048776029843456' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'system:authen:edit' || ''', 1, ''' || '2021-01-07 13:13:50' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347048968414179328' || ''', ''' || '1346777907096285184' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:meta:list' || ''', 1, ''' || '2021-01-07 13:14:36' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049029323862016' || ''', ''' || '1346777907096285184' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:meta:delete' || ''', 1, ''' || '2021-01-07 13:14:50' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049092552994816' || ''', ''' || '1346777907096285184' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:meta:add' || ''', 1, ''' || '2021-01-07 13:15:05' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049251395481600' || ''', ''' || '1346777907096285184' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ENABLE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:meta:disable' || ''', 1, ''' || '2021-01-07 13:15:43' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049317178945536' || ''', ''' || '1346777907096285184' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'system:meta:modify' || ''', 1, ''' || '2021-01-07 13:15:59' || ''', ''' || '2021-01-17 12:06:23' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049370014593024' || ''', ''' || '1346777907096285184' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'system:meta:edit' || ''', 1, ''' || '2021-01-07 13:16:11' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049542417264640' || ''', ''' || '1346778036402483200' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:dict:list' || ''', 1, ''' || '2021-01-07 13:16:53' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049598155370496' || ''', ''' || '1346778036402483200' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:dict:delete' || ''', 1, ''' || '2021-01-07 13:17:06' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049659023110144' || ''', ''' || '1346778036402483200' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:dict:add' || ''', 1, ''' || '2021-01-07 13:17:20' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049731047698432' || ''', ''' || '1346778036402483200' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ENABLE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:dict:disable' || ''', 1, ''' || '2021-01-07 13:17:38' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347049794008395776' || ''', ''' || '1346778036402483200' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'system:dict:edit' || ''', 1, ''' || '2021-01-07 13:17:53' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347050493052071936' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:divideSelector:add' || ''', 1, ''' || '2021-01-07 13:20:39' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347050998931271680' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:divideSelector:delete' || ''', 1, ''' || '2021-01-07 13:22:40' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051241320099840' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:divideRule:add' || ''', 1, ''' || '2021-01-07 13:23:38' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051306788990976' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:divideRule:delete' || ''', 1, ''' || '2021-01-07 13:23:53' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051641725136896' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:divide:modify' || ''', 1, ''' || '2021-01-07 13:25:13' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051850521784320' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixSelector:add' || ''', 1, ''' || '2021-01-07 13:26:03' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051853025783808' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixSelector:delete' || ''', 1, ''' || '2021-01-07 13:26:03' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051855538171904' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixRule:add' || ''', 1, ''' || '2021-01-07 13:26:04' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051857962479616' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixRule:delete' || ''', 1, ''' || '2021-01-07 13:26:05' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347051860495839232' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrix:modify' || ''', 1, ''' || '2021-01-07 13:26:05' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052833968631808' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteSelector:add' || ''', 1, ''' || '2021-01-07 13:29:57' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052833968631809' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectSelector:add' || ''', 1, ''' || '2021-01-07 13:29:57' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052836300664832' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteSelector:delete' || ''', 1, ''' || '2021-01-07 13:29:58' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052836300664833' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectSelector:delete' || ''', 1, ''' || '2021-01-07 13:29:58' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052839198928896' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteRule:add' || ''', 1, ''' || '2021-01-07 13:29:59' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052839198928897' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectRule:add' || ''', 1, ''' || '2021-01-07 13:29:59' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052841824563200' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteRule:delete' || ''', 1, ''' || '2021-01-07 13:29:59' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052841824563201' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectRule:delete' || ''', 1, ''' || '2021-01-07 13:29:59' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052843993018368' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:rewrite:modify' || ''', 1, ''' || '2021-01-07 13:30:00' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347052843993018369' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:redirect:modify' || ''', 1, ''' || '2021-01-07 13:30:00' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053324018528256' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudSelector:add' || ''', 1, ''' || '2021-01-07 13:31:54' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053326988095488' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudSelector:delete' || ''', 1, ''' || '2021-01-07 13:31:55' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053329378848768' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudRule:add' || ''', 1, ''' || '2021-01-07 13:31:55' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053331744436224' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudRule:delete' || ''', 1, ''' || '2021-01-07 13:31:56' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053334470733824' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloud:modify' || ''', 1, ''' || '2021-01-07 13:31:57' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053363814084608' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:signSelector:add' || ''', 1, ''' || '2021-01-07 13:32:04' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053366552965120' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:signSelector:delete' || ''', 1, ''' || '2021-01-07 13:32:04' || ''', ''' || '2021-01-17 11:54:13' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053369413480448' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:signRule:add' || ''', 1, ''' || '2021-01-07 13:32:05' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053372164943872' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:signRule:delete' || ''', 1, ''' || '2021-01-07 13:32:06' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053375029653504' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:sign:modify' || ''', 1, ''' || '2021-01-07 13:32:06' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053404050042880' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:wafSelector:add' || ''', 1, ''' || '2021-01-07 13:32:13' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053406939918336' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:wafSelector:delete' || ''', 1, ''' || '2021-01-07 13:32:14' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053409842376704' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:wafRule:add' || ''', 1, ''' || '2021-01-07 13:32:15' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053413067796480' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:wafRule:delete' || ''', 1, ''' || '2021-01-07 13:32:15' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053415945089024' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:waf:modify' || ''', 1, ''' || '2021-01-07 13:32:16' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053442419535872' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterSelector:add' || ''', 1, ''' || '2021-01-07 13:32:22' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053445191970816' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterSelector:delete' || ''', 1, ''' || '2021-01-07 13:32:23' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053447695970304' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterRule:add' || ''', 1, ''' || '2021-01-07 13:32:24' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053450304827392' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterRule:delete' || ''', 1, ''' || '2021-01-07 13:32:24' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053452737523712' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiter:modify' || ''', 1, ''' || '2021-01-07 13:32:25' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053477844627456' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboSelector:add' || ''', 1, ''' || '2021-01-07 13:32:31' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053480977772544' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboSelector:delete' || ''', 1, ''' || '2021-01-07 13:32:32' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053483712458752' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboRule:add' || ''', 1, ''' || '2021-01-07 13:32:32' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053486426173440' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboRule:delete' || ''', 1, ''' || '2021-01-07 13:32:33' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053489571901440' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:dubbo:modify' || ''', 1, ''' || '2021-01-07 13:32:34' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053516423835648' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorSelector:add' || ''', 1, ''' || '2021-01-07 13:32:40' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053519401791488' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorSelector:delete' || ''', 1, ''' || '2021-01-07 13:32:41' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053522182615040' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorRule:add' || ''', 1, ''' || '2021-01-07 13:32:41' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053525034741760' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorRule:delete' || ''', 1, ''' || '2021-01-07 13:32:42' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053527819759616' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:monitor:modify' || ''', 1, ''' || '2021-01-07 13:32:43' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053554310983680' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelSelector:add' || ''', 1, ''' || '2021-01-07 13:32:49' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053556512993280' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelSelector:delete' || ''', 1, ''' || '2021-01-07 13:32:50' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053559050547200' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelRule:add' || ''', 1, ''' || '2021-01-07 13:32:50' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053561579712512' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelRule:delete' || ''', 1, ''' || '2021-01-07 13:32:51' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053564016603136' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinel:modify' || ''', 1, ''' || '2021-01-07 13:32:51' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053595729735680' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jSelector:add' || ''', 1, ''' || '2021-01-07 13:32:59' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053598829326336' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jSelector:delete' || ''', 1, ''' || '2021-01-07 13:33:00' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053601572401152' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jRule:add' || ''', 1, ''' || '2021-01-07 13:33:00' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053604093177856' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jRule:delete' || ''', 1, ''' || '2021-01-07 13:33:01' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053606622343168' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4j:modify' || ''', 1, ''' || '2021-01-07 13:33:02' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053631159021568' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsSelector:add' || ''', 1, ''' || '2021-01-07 13:33:07' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053633809821696' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsSelector:delete' || ''', 1, ''' || '2021-01-07 13:33:08' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053636439650304' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsRule:add' || ''', 1, ''' || '2021-01-07 13:33:09' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053638968815616' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsRule:delete' || ''', 1, ''' || '2021-01-07 13:33:09' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053641346985984' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:tars:modify' || ''', 1, ''' || '2021-01-07 13:33:10' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053666227597312' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathSelector:add' || ''', 1, ''' || '2021-01-07 13:33:16' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053668538658816' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathSelector:delete' || ''', 1, ''' || '2021-01-07 13:33:16' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053670791000064' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathRule:add' || ''', 1, ''' || '2021-01-07 13:33:17' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053673043341312' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathRule:delete' || ''', 1, ''' || '2021-01-07 13:33:17' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347053675174047744' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPath:modify' || ''', 1, ''' || '2021-01-07 13:33:18' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347063567603609600' || ''', ''' || '1346775491550474240' || ''', ''' || 'sofa' || ''', ''' || 'sofa' || ''', ''' || '/plug/sofa' || ''', ''' || 'sofa' || ''', 1, 4, ''' || 'fire' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-07 14:12:36' || ''', ''' || '2021-01-15 23:24:04' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347064011369361408' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaSelector:add' || ''', 1, ''' || '2021-01-07 14:14:22' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347064013848195072' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaSelector:delete' || ''', 1, ''' || '2021-01-07 14:14:23' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347064016373166080' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaRule:add' || ''', 1, ''' || '2021-01-07 14:14:23' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347064019007188992' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaRule:delete' || ''', 1, ''' || '2021-01-07 14:14:24' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347064021486022656' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:sofa:modify' || ''', 1, ''' || '2021-01-07 14:14:25' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350096617689751552' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:divideSelector:edit' || ''', 1, ''' || '2021-01-15 23:04:52' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350096630197166080' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:divideRule:edit' || ''', 1, ''' || '2021-01-15 23:04:55' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350098233939632128' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixSelector:edit' || ''', 1, ''' || '2021-01-15 23:11:17' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350098236741427200' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixRule:edit' || ''', 1, ''' || '2021-01-15 23:11:18' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099831950163968' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteSelector:edit' || ''', 1, ''' || '2021-01-15 23:17:38' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099831950163969' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectSelector:edit' || ''', 1, ''' || '2021-01-15 23:17:38' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595200' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteRule:edit' || ''', 1, ''' || '2021-01-15 23:17:39' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595201' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectRule:edit' || ''', 1, ''' || '2021-01-15 23:17:39' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595202' || ''', ''' || '1346775491550474240' || ''', ''' || 'motan' || ''', ''' || 'motan' || ''', ''' || '/plug/motan' || ''', ''' || 'motan' || ''', 1, 4, ''' || 'fire' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-07 14:12:36' || ''', ''' || '2021-01-15 23:24:04' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595203' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:motanSelector:add' || ''', 1, ''' || '2021-01-07 14:14:22' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595204' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:motanSelector:delete' || ''', 1, ''' || '2021-01-07 14:14:23' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595205' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:motanRule:add' || ''', 1, ''' || '2021-01-07 14:14:23' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595206' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:motanRule:delete' || ''', 1, ''' || '2021-01-07 14:14:24' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595207' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:motan:modify' || ''', 1, ''' || '2021-01-07 14:14:25' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595208' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:motanSelector:edit' || ''', 1, ''' || '2021-01-15 23:19:38' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099836492595209' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:motanRule:edit' || ''', 1, ''' || '2021-01-15 23:19:39' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099893203779584' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudSelector:edit' || ''', 1, ''' || '2021-01-15 23:17:53' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099896441782272' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudRule:edit' || ''', 1, ''' || '2021-01-15 23:17:54' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099936379944960' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:signSelector:edit' || ''', 1, ''' || '2021-01-15 23:18:03' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099939177545728' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:signRule:edit' || ''', 1, ''' || '2021-01-15 23:18:04' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099976435548160' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:wafSelector:edit' || ''', 1, ''' || '2021-01-15 23:18:13' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350099979434475520' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:wafRule:edit' || ''', 1, ''' || '2021-01-15 23:18:13' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100013341229056' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterSelector:edit' || ''', 1, ''' || '2021-01-15 23:18:21' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100016319184896' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterRule:edit' || ''', 1, ''' || '2021-01-15 23:18:22' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100053757542400' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboSelector:edit' || ''', 1, ''' || '2021-01-15 23:18:31' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100056525783040' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboRule:edit' || ''', 1, ''' || '2021-01-15 23:18:32' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100110510669824' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorSelector:edit' || ''', 1, ''' || '2021-01-15 23:18:45' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100113283104768' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorRule:edit' || ''', 1, ''' || '2021-01-15 23:18:45' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100147437322240' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelSelector:edit' || ''', 1, ''' || '2021-01-15 23:18:53' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100150096510976' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelRule:edit' || ''', 1, ''' || '2021-01-15 23:18:54' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100190894505984' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jSelector:edit' || ''', 1, ''' || '2021-01-15 23:19:04' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100193801158656' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jRule:edit' || ''', 1, ''' || '2021-01-15 23:19:05' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100229360467968' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsSelector:edit' || ''', 1, ''' || '2021-01-15 23:19:13' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100232451670016' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsRule:edit' || ''', 1, ''' || '2021-01-15 23:19:14' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100269307019264' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathSelector:edit' || ''', 1, ''' || '2021-01-15 23:19:23' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100272083648512' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathRule:edit' || ''', 1, ''' || '2021-01-15 23:19:23' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100334205485056' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaSelector:edit' || ''', 1, ''' || '2021-01-15 23:19:38' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795968' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaRule:edit' || ''', 1, ''' || '2021-01-15 23:19:39' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795969' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcSelector:add' || ''', 1, ''' || '2021-01-07 13:33:07' || ''', ''' || '2021-01-17 11:46:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795970' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcSelector:delete' || ''', 1, ''' || '2021-01-07 13:33:08' || ''', ''' || '2021-01-17 11:47:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795971' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcRule:add' || ''', 1, ''' || '2021-01-07 13:33:09' || ''', ''' || '2021-01-17 11:46:32' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795972' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcRule:delete' || ''', 1, ''' || '2021-01-07 13:33:09' || ''', ''' || '2021-01-17 11:46:59' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795973' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'plugin:grpc:modify' || ''', 1, ''' || '2021-01-07 13:33:10' || ''', ''' || '2021-01-17 11:56:30' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795974' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcSelector:edit' || ''', 1, ''' || '2021-01-15 23:19:13' || ''', ''' || '2021-01-17 11:57:34' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350100337363795975' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcRule:edit' || ''', 1, ''' || '2021-01-15 23:19:14' || ''', ''' || '2021-01-17 11:57:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350106119681622016' || ''', ''' || '1346776175553376256' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.ROLE' || ''', ''' || 'role' || ''', ''' || '/system/role' || ''', ''' || 'role' || ''', 1, 0, ''' || 'usergroup-add' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-15 23:42:37' || ''', ''' || '2021-01-17 16:00:24' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350107709494804480' || ''', ''' || '1350106119681622016' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:role:add' || ''', 1, ''' || '2021-01-15 23:48:56' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350107842236137472' || ''', ''' || '1350106119681622016' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:role:list' || ''', 1, ''' || '2021-01-15 23:49:28' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350112406754766848' || ''', ''' || '1350106119681622016' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:role:delete' || ''', 1, ''' || '2021-01-16 00:07:36' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350112481253994496' || ''', ''' || '1350106119681622016' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:role:edit' || ''', 1, ''' || '2021-01-16 00:07:54' || ''', ''' || '2021-01-17 11:21:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1350804501819195392' || ''', ''' || '1346777766301888512' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.EDITRESOURCEDETAILS' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'system:authen:editResourceDetails' || ''', 1, ''' || '2021-01-17 21:57:45' || ''', ''' || '2021-01-17 21:57:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1355163372527050752' || ''', ''' || '1346776175553376256' || ''', ''' || 'SHENYU.MENU.SYSTEM.MANAGMENT.RESOURCE' || ''', ''' || 'resource' || ''', ''' || '/system/resource' || ''', ''' || 'resource' || ''', 1, 2, ''' || 'menu' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-01-29 22:38:20' || ''', ''' || '2021-02-06 14:04:23' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1355165158419750912' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.BUTTON.RESOURCE.MENU.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 1, ''' || '' || ''', 1, 0, ''' || 'system:resource:addMenu' || ''', 1, ''' || '2021-01-29 22:45:26' || ''', ''' || '2021-02-06 17:10:40' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1355165353534578688' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.BUTTON.SYSTEM.LIST' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:resource:list' || ''', 1, ''' || '2021-01-29 22:46:13' || ''', ''' || '2021-02-06 17:10:40' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1355165475785957376' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.BUTTON.RESOURCE.MENU.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 2, ''' || '' || ''', 1, 0, ''' || 'system:resource:deleteMenu' || ''', 1, ''' || '2021-01-29 22:46:42' || ''', ''' || '2021-02-06 16:59:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1355165608565039104' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.BUTTON.RESOURCE.MENU.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 3, ''' || '' || ''', 1, 0, ''' || 'system:resource:editMenu' || ''', 1, ''' || '2021-01-29 22:47:13' || ''', ''' || '2021-02-06 16:59:02' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1357956838021890048' || ''', ''' || '' || ''', ''' || 'SHENYU.MENU.CONFIG.MANAGMENT' || ''', ''' || 'config' || ''', ''' || '/config' || ''', ''' || 'config' || ''', 0, 1, ''' || 'api' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-02-06 15:38:34' || ''', ''' || '2021-02-06 15:47:25' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1357977745889132544' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.BUTTON.RESOURCE.BUTTON.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 4, ''' || '' || ''', 1, 0, ''' || 'system:resource:addButton' || ''', 1, ''' || '2021-02-06 17:01:39' || ''', ''' || '2021-02-06 17:04:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1357977912126177280' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.SYSTEM.EDITOR' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 5, ''' || '' || ''', 1, 0, ''' || 'system:resource:editButton' || ''', 1, ''' || '2021-02-06 17:02:19' || ''', ''' || '2021-02-06 17:23:57' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1357977971827900416' || ''', ''' || '1355163372527050752' || ''', ''' || 'SHENYU.SYSTEM.DELETEDATA' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 6, ''' || '' || ''', 1, 0, ''' || 'system:resource:deleteButton' || ''', 1, ''' || '2021-02-06 17:02:33' || ''', ''' || '2021-02-06 17:25:28' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1386680049203195904' || ''', ''' || '1346777157943259136' || ''', ''' || 'SHENYU.BUTTON.DATA.PERMISSION.CONFIG' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'system:manager:configureDataPermission' || ''', 1, ''' || '2021-04-26 21:54:22' || ''', ''' || '2021-04-26 21:59:56' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642195797528576' || ''', ''' || '1346775491550474240' || ''', ''' || 'logging' || ''', ''' || 'logging' || ''', ''' || '/plug/logging' || ''', ''' || 'logging' || ''', 1, 0, ''' || 'block' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642195982077952' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingSelector:add' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642196145655808' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingSelector:delete' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642196409896960' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingSelector:edit' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642196598640640' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingRule:add' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642197181648896' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingRule:delete' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642197538164736' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingRule:edit' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1387642197689159680' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:logging:modify' || ''', 1, ''' || '2021-04-29 13:37:35' || ''', ''' || '2021-04-29 13:37:35' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390305479231000576' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:divideSelector:query' || ''', 1, ''' || '2021-05-06 22:00:32' || ''', ''' || '2021-05-06 22:07:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390305641097580544' || ''', ''' || '1347026381504262144' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:divideRule:query' || ''', 1, ''' || '2021-05-06 22:01:10' || ''', ''' || '2021-05-06 22:07:10' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309613569036001' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtSelector:query' || ''', 1, ''' || '2021-05-06 22:16:57' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309613569036288' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingSelector:query' || ''', 1, ''' || '2021-05-06 22:16:57' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309729176637002' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtRule:query' || ''', 1, ''' || '2021-05-06 22:17:25' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309729176637440' || ''', ''' || '1387642195797528576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:loggingRule:query' || ''', 1, ''' || '2021-05-06 22:17:25' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309914883641344' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixSelector:query' || ''', 1, ''' || '2021-05-06 22:18:09' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309936706605056' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteSelector:query' || ''', 1, ''' || '2021-05-06 22:18:14' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309954016497664' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudSelector:query' || ''', 1, ''' || '2021-05-06 22:18:18' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309981166227456' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaSelector:query' || ''', 1, ''' || '2021-05-06 22:18:25' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390309998543228928' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:motanSelector:query' || ''', 1, ''' || '2021-05-06 22:18:29' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310018877214720' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:signSelector:query' || ''', 1, ''' || '2021-05-06 22:18:34' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310036459737088' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:wafSelector:query' || ''', 1, ''' || '2021-05-06 22:18:38' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310053543137280' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterSelector:query' || ''', 1, ''' || '2021-05-06 22:18:42' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310073772265472' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboSelector:query' || ''', 1, ''' || '2021-05-06 22:18:47' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310094571819008' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorSelector:query' || ''', 1, ''' || '2021-05-06 22:18:52' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310112892538880' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelSelector:query' || ''', 1, ''' || '2021-05-06 22:18:56' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310128516321280' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jSelector:query' || ''', 1, ''' || '2021-05-06 22:19:00' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310145079627776' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsSelector:query' || ''', 1, ''' || '2021-05-06 22:19:04' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310166948728832' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathSelector:query' || ''', 1, ''' || '2021-05-06 22:19:09' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310188486479872' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcSelector:query' || ''', 1, ''' || '2021-05-06 22:19:14' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310205808955392' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectSelector:query' || ''', 1, ''' || '2021-05-06 22:19:18' || ''', ''' || '2021-05-06 22:37:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310247684886528' || ''', ''' || '1347026805170909184' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:hystrixRule:query' || ''', 1, ''' || '2021-05-06 22:19:28' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310264424353792' || ''', ''' || '1347027413357572096' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rewriteRule:query' || ''', 1, ''' || '2021-05-06 22:19:32' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310282875097088' || ''', ''' || '1347027482244820992' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:springCloudRule:query' || ''', 1, ''' || '2021-05-06 22:19:37' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310298985418752' || ''', ''' || '1347063567603609600' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:sofaRule:query' || ''', 1, ''' || '2021-05-06 22:19:41' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310354216013824' || ''', ''' || '1350099836492595202' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:motanRule:query' || ''', 1, ''' || '2021-05-06 22:19:54' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310376865255424' || ''', ''' || '1347027526339538944' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:signRule:query' || ''', 1, ''' || '2021-05-06 22:19:59' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310406321852416' || ''', ''' || '1347027566034432000' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:wafRule:query' || ''', 1, ''' || '2021-05-06 22:20:06' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310423401058304' || ''', ''' || '1347027647999520768' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rateLimiterRule:query' || ''', 1, ''' || '2021-05-06 22:20:10' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310441755332608' || ''', ''' || '1347027717792739328' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:dubboRule:query' || ''', 1, ''' || '2021-05-06 22:20:15' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310459904086016' || ''', ''' || '1347027769747582976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:monitorRule:query' || ''', 1, ''' || '2021-05-06 22:20:19' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310476815519744' || ''', ''' || '1347027830602739712' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:sentinelRule:query' || ''', 1, ''' || '2021-05-06 22:20:23' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310492686766080' || ''', ''' || '1347027918121086976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:resilience4jRule:query' || ''', 1, ''' || '2021-05-06 22:20:27' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310509401067520' || ''', ''' || '1347027995199811584' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:tarsRule:query' || ''', 1, ''' || '2021-05-06 22:20:31' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310527348494336' || ''', ''' || '1347028169120821248' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:contextPathRule:query' || ''', 1, ''' || '2021-05-06 22:20:35' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310544494809088' || ''', ''' || '1347028169120821249' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:grpcRule:query' || ''', 1, ''' || '2021-05-06 22:20:39' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1390310562312212480' || ''', ''' || '1347027413357572097' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:redirectRule:query' || ''', 1, ''' || '2021-05-06 22:20:43' || ''', ''' || '2021-05-06 22:36:06' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768158126080' || ''', ''' || '1346775491550474240' || ''', ''' || 'request' || ''', ''' || 'request' || ''', ''' || '/plug/request' || ''', ''' || 'request' || ''', 1, 0, ''' || 'thunderbolt' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-30 20:03:18' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768204263112' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtSelector:add' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768204263121' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Selector:add' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768204263424' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestSelector:add' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768216846113' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtSelector:delete' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768216846122' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Selector:delete' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768216846336' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestSelector:delete' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768225234114' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtSelector:edit' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768225234123' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Selector:edit' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768225234944' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestSelector:edit' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768233623115' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtSelector:query' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768233623124' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Selector:query' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768233623552' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestSelector:query' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768246206116' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtRule:add' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768246206125' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Rule:add' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768246206464' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestRule:add' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768275566117' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtRule:delete' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768275566126' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Rule:delete' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768275566592' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestRule:delete' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768283955118' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtRule:edit' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768283955127' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Rule:edit' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768283955200' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestRule:edit' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768292343119' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwtRule:query' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768292343128' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2Rule:query' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768292343808' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:requestRule:query' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768296538112' || ''', ''' || '1397547768158126080' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:request:modify' || ''', 1, ''' || '2021-05-26 21:38:48' || ''', ''' || '2021-05-26 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768296538120' || ''', ''' || '1347028169120821250' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:jwt:modify' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1397547768296538129' || ''', ''' || '1347028169120821251' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:oauth2:modify' || ''', 1, ''' || '2021-06-18 21:38:48' || ''', ''' || '2021-06-18 21:38:47' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252528254976' || ''', ''' || '1346775491550474240' || ''', ''' || 'modifyResponse' || ''', ''' || 'modifyResponse' || ''', ''' || '/plug/modifyResponse' || ''', ''' || 'modifyResponse' || ''', 1, 0, ''' || 'block' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252566003712' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseSelector:add' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252582780928' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseSelector:delete' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252591169536' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseSelector:edit' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252603752448' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseSelector:query' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252620529664' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseRule:add' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252645695488' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseRule:delete' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252658278400' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseRule:edit' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252666667008' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponseRule:query' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1398994252679249920' || ''', ''' || '1398994252528254976' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:modifyResponse:modify' || ''', 1, ''' || '2021-05-30 21:26:37' || ''', ''' || '2021-05-30 21:26:36' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534378660888576' || ''', ''' || '1346775491550474240' || ''', ''' || 'paramMapping' || ''', ''' || 'paramMapping' || ''', ''' || '/plug/paramMapping' || ''', ''' || 'paramMapping' || ''', 1, 0, ''' || 'block' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534378971267072' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingSelector:add' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379000627200' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingSelector:delete' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379046764544' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingSelector:edit' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379071930368' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingSelector:query' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379092901888' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingRule:add' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379122262016' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingRule:delete' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379139039232' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingRule:edit' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379164205056' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMappingRule:query' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1405534379185176576' || ''', ''' || '1405534378660888576' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:paramMapping:modify' || ''', 1, ''' || '2021-06-17 22:34:44' || ''', ''' || '2021-06-17 22:34:44' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771386310656' || ''', ''' || '1346775491550474240' || ''', ''' || 'websocket' || ''', ''' || 'websocket' || ''', ''' || '/plug/websocket' || ''', ''' || 'websocket' || ''', 1, 0, ''' || 'block' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771419865088' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketSelector:add' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771440836608' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketSelector:delete' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771457613824' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketSelector:edit' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771470196736' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketSelector:query' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771486973952' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketRule:add' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771516334080' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketRule:delete' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771528916992' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketRule:edit' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771545694208' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocketRule:query' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431217771558277120' || ''', ''' || '1431217771386310656' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:websocket:modify' || ''', 1, ''' || '2021-08-27 19:31:22' || ''', ''' || '2021-08-27 19:31:22' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270939172864' || ''', ''' || '1346775491550474240' || ''', ''' || 'cryptorRequest' || ''', ''' || 'cryptorRequest' || ''', ''' || '/plug/cryptorRequest' || ''', ''' || 'cryptorRequest' || ''', 1, 0, ''' || 'block' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270947561472' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestSelector:add' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270955950080' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestSelector:delete' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270968532992' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestSelector:edit' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270972727296' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestSelector:query' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270981115904' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestRule:add' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270989504512' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestRule:delete' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222270997893120' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestRule:edit' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222271002087424' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequestRule:query' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222271006281728' || ''', ''' || '1431222270939172864' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorRequest:modify' || ''', 1, ''' || '2021-08-27 19:49:15' || ''', ''' || '2021-08-27 19:49:14' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367693377537' || ''', ''' || '1346775491550474240' || ''', ''' || 'cryptorResponse' || ''', ''' || 'cryptorResponse' || ''', ''' || '/plug/cryptorResponse' || ''', ''' || 'cryptorResponse' || ''', 1, 0, ''' || 'block' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367701766144' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseSelector:add' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367714349056' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseSelector:delete' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367722737664' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseSelector:edit' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367726931968' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseSelector:query' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367735320576' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseRule:add' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367743709184' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseRule:delete' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367752097792' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseRule:edit' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367760486400' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponseRule:query' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875008' || ''', ''' || '1431222367693377537' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:cryptorResponse:modify' || ''', 1, ''' || '2021-08-27 19:49:38' || ''', ''' || '2021-08-27 19:49:37' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1347028169120821252' || ''', ''' || '1346775491550474240' || ''', ''' || 'rpcContext' || ''', ''' || 'rpcContext' || ''', ''' || '/plug/rpcContext' || ''', ''' || 'rpcContext' || ''', 1, 19, ''' || 'vertical-align-bottom' || ''', 0, 0, ''' || '' || ''', 1, ''' || '2021-11-24 21:00:00' || ''', ''' || '2021-11-24 21:00:00' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875009' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextSelector:add' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875010' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextSelector:delete' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875011' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextSelector:edit' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875012' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextSelector:query' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875013' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.ADD' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextRule:add' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875014' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.DELETE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextRule:delete' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875015' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.EDIT' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextRule:edit' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875016' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.RULE.QUERY' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextRule:query' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "resource" VALUES (''' || '1431222367768875017' || ''', ''' || '1347028169120821252' || ''', ''' || 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE' || ''', ''' || '' || ''', ''' || '' || ''', ''' || '' || ''', 2, 0, ''' || '' || ''', 1, 0, ''' || 'plugin:rpcContextRule:modify' || ''', 1, ''' || '2021-11-24 21:38:48' || ''', ''' || '2021-11-24 21:38:48' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table role if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'role' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'role already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "role" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "role_name" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
	  "description" varchar(255) COLLATE "pg_catalog"."default",
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "role"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "role"."role_name" IS ''' || 'role name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "role"."description" IS ''' || 'role describe' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "role"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "role"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON TABLE "role" IS ''' || 'role table' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER role_trigger
	          BEFORE UPDATE ON role
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table role
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "role" ADD CONSTRAINT "role_pkey" PRIMARY KEY ("id", "role_name");');
	-- ----------------------------
	-- Records of role
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "role" VALUES (''' || '1346358560427216896' || ''', ''' || 'super' || ''', ''' || 'Administrator' || ''', ''' || '2021-01-05 01:31:10' || ''', ''' || '2021-01-08 17:00:07' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "role" VALUES (''' || '1385482862971723776' || ''', ''' || 'default' || ''', ''' || 'Standard' || ''', ''' || '2021-04-23 14:37:10' || ''', ''' || '2021-04-23 14:38:39' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table rule if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'rule' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'rule already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "rule" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "selector_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "match_mode" int4 NOT NULL,
	  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "enabled" int2 NOT NULL,
	  "loged" int2 NOT NULL,
	  "sort" int4 NOT NULL,
	  "handle" varchar(1024) COLLATE "pg_catalog"."default",
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."selector_id" IS ''' || 'selector id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."match_mode" IS ''' || 'matching mode (0 and 1 or)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."name" IS ''' || 'rule name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."enabled" IS ''' || 'whether to open' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."loged" IS ''' || 'whether to log or not' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."sort" IS ''' || 'sort' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."handle" IS ''' || 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule"."date_updated" IS ''' || 'update time' || '''');

	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER rule_trigger
	          BEFORE UPDATE ON rule
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table rule
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "rule" ADD CONSTRAINT "rule_pkey" PRIMARY KEY ("id");');
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table rule_condition if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'rule_condition' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'rule_condition already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "rule_condition" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "rule_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "param_type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "operator" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "param_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "param_value" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."rule_id" IS ''' || 'rule id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."param_type" IS ''' || 'parameter type (post query uri, etc.)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."operator" IS ''' || 'matching character (=> <like match)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."param_name" IS ''' || 'parameter name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."param_value" IS ''' || 'parameter value' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "rule_condition"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER rule_condition_trigger
	          BEFORE UPDATE ON rule_condition
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- ----------------------------
	-- Primary Key structure for table rule_condition
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "rule_condition" ADD CONSTRAINT "rule_condition_pkey" PRIMARY KEY ("id");');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table selector if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'selector' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'selector already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "selector" (
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
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."id" IS ''' || 'primary key id varchar' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."plugin_id" IS ''' || 'plugin id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."name" IS ''' || 'selector name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."match_mode" IS ''' || 'matching mode (0 and 1 or)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."type" IS ''' || 'type (0, full flow, 1 custom flow)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."sort" IS ''' || 'sort' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."handle" IS ''' || 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."enabled" IS ''' || 'whether to open' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."loged" IS ''' || 'whether to print the log' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."continued" IS ''' || 'whether to continue execution' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector"."date_updated" IS ''' || 'update time' || '''');

	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER selector_trigger
	          BEFORE UPDATE ON selector
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	-- Primary Key structure for table selector
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'ALTER TABLE "selector" ADD CONSTRAINT "selector_pkey" PRIMARY KEY ("id");');
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table selector_condition if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'selector_condition' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'selector_condition already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "selector_condition" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "selector_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "param_type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "operator" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "param_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "param_value" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');

	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."selector_id" IS ''' || 'selector id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."param_type" IS ''' || 'parameter type (to query uri, etc.)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."operator" IS ''' || 'matching character (=> <like matching)' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."param_name" IS ''' || 'parameter name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."param_value" IS ''' || 'parameter value' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "selector_condition"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER selector_condition_trigger
	          BEFORE UPDATE ON selector_condition
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;


-- ----------------------------------------------------
-- create table shenyu_dict if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'shenyu_dict' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'shenyu_dict already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "shenyu_dict" (
	  "id" varchar(128) primary key,
	  "type" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
	  "dict_code" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
	  "dict_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
	  "dict_value" varchar(100) COLLATE "pg_catalog"."default",
	  "desc" varchar(255) COLLATE "pg_catalog"."default",
	  "sort" int4 NOT NULL,
	  "enabled" int2,
	  "date_created" TIMESTAMP NOT NULL DEFAULT TIMEZONE(''UTC-8''::TEXT, NOW()::TIMESTAMP(0) WITHOUT TIME ZONE),
	  "date_updated" TIMESTAMP NOT NULL DEFAULT TIMEZONE(''UTC-8''::TEXT, NOW()::TIMESTAMP(0) WITHOUT TIME ZONE)
	)');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."type" IS ''' || 'type' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."dict_code" IS ''' || 'dictionary encoding' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."dict_name" IS ''' || 'dictionary name' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."dict_value" IS ''' || 'dictionary value' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."desc" IS ''' || 'dictionary description or remarks' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."sort" IS ''' || 'sort' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."enabled" IS ''' || 'whether it is enabled' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "shenyu_dict"."date_updated" IS ''' || 'update time' || '''');
    ----------------------------
	-- Create Rule for table shenyu_dict
	-- ----------------------------
    PERFORM public.dblink_exec('init_conn',  'create rule shenyu_dict_insert_ignore as on insert to shenyu_dict where exists (select 1 from shenyu_dict where id = new.id) do instead nothing;');

    ----------------------------
	-- Create Sequence for table shenyu_dict
	-- ----------------------------
    PERFORM public.dblink_exec('init_conn',  'CREATE SEQUENCE shenyu_dict_ID_seq;	');
	PERFORM public.dblink_exec('init_conn',  'ALTER SEQUENCE shenyu_dict_ID_seq OWNED BY shenyu_dict.ID;');

	-- ----------------------------
	-- Primary FUNCTION for table shenyu_dict
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  ' CREATE OR REPLACE FUNCTION shenyu_dict_insert() RETURNS trigger AS $BODY$
            BEGIN
                NEW.ID := nextval('''||'shenyu_dict_ID_seq' || ''');
                RETURN NEW;
            END;
            $BODY$
              LANGUAGE plpgsql;'
    );

	-- ----------------------------
	-- Create TRIGGER for table shenyu_dict
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER shenyu_dict_check_insert
        BEFORE INSERT ON shenyu_dict
        FOR EACH ROW
        WHEN (NEW.ID IS NULL)
        EXECUTE PROCEDURE shenyu_dict_insert();');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER shenyu_dict_trigger
	          BEFORE UPDATE ON shenyu_dict
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');

	-- ----------------------------
	-- Records of shenyu_dict
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'degradeRuleGrade' || ''',''' || 'DEGRADE_GRADE_RT' || ''',''' || 'slow call ratio' || ''',''' || '0' || ''',''' || 'degrade type-slow call ratio' || ''',1,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'degradeRuleGrade' || ''',''' || 'DEGRADE_GRADE_EXCEPTION_RATIO' || ''',''' || 'exception ratio' || ''',''' || '1' || ''',''' || 'degrade type-abnormal ratio' || ''',0,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'degradeRuleGrade' || ''',''' || 'DEGRADE_GRADE_EXCEPTION_COUNT' || ''',''' || 'exception number strategy' || ''',''' || '2' || ''',''' || 'degrade type-abnormal number strategy' || ''',2,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'flowRuleGrade' || ''',''' || 'FLOW_GRADE_QPS' || ''',''' || 'QPS' || ''',''' || '1' || ''',''' || 'grade type-QPS' || ''',0,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'flowRuleGrade' || ''',''' || 'FLOW_GRADE_THREAD' || ''',''' || 'number of concurrent threads' || ''',''' || '0' || ''',''' || 'degrade type-number of concurrent threads' || ''',1,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'flowRuleControlBehavior' || ''',''' || 'CONTROL_BEHAVIOR_DEFAULT' || ''',''' || 'direct rejection by default' || ''',''' || '0' || ''',''' || 'control behavior-direct rejection by default' || ''',0,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'flowRuleControlBehavior' || ''',''' || 'CONTROL_BEHAVIOR_WARM_UP' || ''',''' || 'warm up' || ''',''' || '1' || ''',''' || 'control behavior-warm up' || ''',1,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'flowRuleControlBehavior' || ''',''' || 'CONTROL_BEHAVIOR_RATE_LIMITER' || ''',''' || 'constant speed queuing' || ''',''' || '2' || ''',''' || 'control behavior-uniform speed queuing' || ''',2,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'flowRuleControlBehavior' || ''',''' || 'CONTROL_BEHAVIOR_WARM_UP_RATE_LIMITER' || ''',''' || 'preheating uniformly queued' || ''',''' || '3' || ''',''' || 'control behavior-preheating uniformly queued' || ''',3,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'permission' || ''',''' || 'REJECT' || ''',''' || 'reject' || ''',''' || 'reject' || ''',''' || 'reject' || ''',0,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'permission' || ''',''' || 'ALLOW' || ''',''' || 'allow' || ''',''' || 'allow' || ''',''' || 'allow' || ''',1,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'algorithmName' || ''',''' || 'ALGORITHM_SLIDINGWINDOW' || ''',''' || 'slidingWindow' || ''',''' || 'slidingWindow' || ''',''' || 'Sliding window algorithm' || ''',0,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'algorithmName' || ''',''' || 'ALGORITHM_LEAKYBUCKET' || ''',''' || 'leakyBucket' || ''',''' || 'leakyBucket' || ''',''' || 'Leaky bucket algorithm' || ''',1,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'algorithmName' || ''',''' || 'ALGORITHM_CONCURRENT' || ''',''' || 'concurrent' || ''',''' || 'concurrent' || ''',''' || 'Concurrent algorithm' || ''',2,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'algorithmName' || ''',''' || 'ALGORITHM_TOKENBUCKET' || ''',''' || 'tokenBucket' || ''',''' || 'tokenBucket' || ''',''' || 'Token bucket algorithm' || ''',3,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'loadBalance' || ''', ''' || 'LOAD_BALANCE' || ''', ''' || 'roundRobin' || ''', ''' || 'roundRobin' || ''', ''' || 'roundRobin' || ''', 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'loadBalance' || ''', ''' || 'LOAD_BALANCE' || ''', ''' || 'random' || ''', ''' || 'random' || ''', ''' || 'random' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'loadBalance' || ''', ''' || 'LOAD_BALANCE' || ''', ''' || 'hash' || ''', ''' || 'hash' || ''', ''' || 'hash' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'status' || ''', ''' || 'DIVIDE_STATUS' || ''', ''' || 'close' || ''', ''' || 'false' || ''', ''' || 'close' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'status' || ''', ''' || 'DIVIDE_STATUS' || ''', ''' || 'open' || ''', ''' || 'true' || ''', ''' || 'open' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'multiRuleHandle' || ''', ''' || 'MULTI_RULE_HANDLE' || ''', ''' || 'multiple rule' || ''', ''' || '1' || ''', ''' || 'multiple rule' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'multiRuleHandle' || ''', ''' || 'MULTI_RULE_HANDLE' || ''', ''' || 'single rule' || ''', ''' || '0' || ''', ''' || 'single rule' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'multiSelectorHandle' || ''', ''' || 'MULTI_SELECTOR_HANDLE' || ''', ''' || 'multiple handle' || ''', ''' || '1' || ''', ''' || 'multiple handle' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'multiSelectorHandle' || ''', ''' || 'MULTI_SELECTOR_HANDLE' || ''', ''' || 'single handle' || ''', ''' || '0' || ''', ''' || 'single handle' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'matchMode' || ''', ''' || 'MATCH_MODE' || ''', ''' || 'and' || ''', ''' || '0' || ''', ''' || 'and' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'matchMode' || ''', ''' || 'MATCH_MODE' || ''', ''' || 'or' || ''', ''' || '1' || ''', ''' || 'or' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'match' || ''', ''' || 'match' || ''', ''' || 'match' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || '=' || ''', ''' || '=' || ''', ''' || '=' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'regex' || ''', ''' || 'regex' || ''', ''' || 'regex' || ''', 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'contains' || ''', ''' || 'contains' || ''', ''' || 'contains' || ''', 3, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'SpEL' || ''', ''' || 'SpEL' || ''', ''' || 'SpEL' || ''', 4, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'Groovy' || ''', ''' || 'Groovy' || ''', ''' || 'Groovy' || ''', 5, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'TimeBefore' || ''', ''' || 'TimeBefore' || ''', ''' || 'TimeBefore' || ''', 6, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'TimeAfter' || ''', ''' || 'TimeAfter' || ''', ''' || 'TimeAfter' || ''', 7, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'operator' || ''', ''' || 'OPERATOR' || ''', ''' || 'exclude' || ''', ''' || 'exclude' || ''', ''' || 'exclude' || ''', 8, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'post' || ''', ''' || 'post' || ''', ''' || 'post' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'uri' || ''', ''' || 'uri' || ''', ''' || 'uri' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'query' || ''', ''' || 'query' || ''', ''' || 'query' || ''', 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'host' || ''', ''' || 'host' || ''', ''' || 'host' || ''', 3, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'ip' || ''', ''' || 'ip' || ''', ''' || 'ip' || ''', 4, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'header' || ''', ''' || 'header' || ''', ''' || 'header' || ''', 5, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'cookie' || ''', ''' || 'cookie' || ''', ''' || 'cookie' || ''', 6, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'req_method' || ''', ''' || 'req_method' || ''', ''' || 'req_method' || ''', 7, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'keyResolverName' || ''',''' || 'WHOLE_KEY_RESOLVER' || ''',''' || 'whole' || ''',''' || 'WHOLE_KEY_RESOLVER' || ''',''' || 'Rate limit by all request' || ''',0,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'keyResolverName' || ''',''' || 'REMOTE_ADDRESS_KEY_RESOLVER' || ''',''' || 'remoteAddress' || ''',''' || 'REMOTE_ADDRESS_KEY_RESOLVER' || ''',''' || 'Rate limit by remote address' || ''',1,1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'automaticTransitionFromOpenToHalfOpenEnabled' || ''', ''' || 'AUTOMATIC_HALF_OPEN' || ''', ''' || 'open' || ''', ''' || 'true' || ''', ''' || '' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'automaticTransitionFromOpenToHalfOpenEnabled' || ''', ''' || 'AUTOMATIC_HALF_OPEN' || ''', ''' || 'close' || ''', ''' || 'false' || ''', ''' || '' || ''', 2, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'paramType' || ''', ''' || 'PARAM_TYPE' || ''', ''' || 'domain' || ''', ''' || 'domain' || ''', ''' || 'domain' || ''', 8, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'strategyName' || ''', ''' || 'STRATEGY_NAME' || ''', ''' || 'rsa' || ''', ''' || 'rsa' || ''', ''' || 'rsa strategy' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'way' || ''', ''' || 'WAY' || ''', ''' || 'encrypt' || ''', ''' || 'encrypt' || ''', ''' || 'encrypt' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO  shenyu_dict  ( type , dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'way' || ''', ''' || 'WAY' || ''', ''' || 'decrypt' || ''', ''' || 'decrypt' || ''', ''' || 'decrypt' || ''', 1, 1);');

    /*insert mode data for rateLimiter plugin*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO shenyu_dict ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'mode' || ''', ''' || 'MODE' || ''', ''' || 'cluster' || ''', ''' || 'cluster' || ''', ''' || 'cluster' || ''', 0, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO shenyu_dict ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'mode' || ''', ''' || 'MODE' || ''', ''' || 'sentinel' || ''', ''' || 'sentinel' || ''', ''' || 'sentinel' || ''', 1, 1);');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO shenyu_dict ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'mode' || ''', ''' || 'MODE' || ''', ''' || 'standalone' || ''', ''' || 'standalone' || ''', ''' || 'standalone' || ''', 2, 1);');

    /*insert dict for dubbo plugin*/
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO shenyu_dict ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'gray' || ''', ''' || 'GRAY_STATUS' || ''', ''' || 'close' || ''', ''' || 'false' || ''', ''' || 'close' || ''', ''' || '1' || ''', ''' || '1' || ''');');
    PERFORM public.dblink_exec('init_conn',  'INSERT  INTO shenyu_dict ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'gray' || ''', ''' || 'GRAY_STATUS' || ''', ''' || 'open' || ''', ''' || 'true' || ''', ''' || 'open' || ''', ''' || '0' || ''', ''' || '1' || ''');');

    /*insert dict for rpcContext plugin*/
    PERFORM public.dblink_exec('init_conn',  'INSERT INTO "shenyu_dict" ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES (''' || 'rpcContextType' || ''', ''' || 'RPC_CONTEXT_TYPE' || ''', ''' || 'addRpcContext' || ''', ''' || 'addRpcContext' || ''', ''' || 'addRpcContext' || ''', 1, 1, ''' || '2021-11-24 14:21:58' || ''', ''' || '2021-11-24 14:21:58' || ''');');
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "shenyu_dict" ( type ,  dict_code ,  dict_name ,  dict_value ,  "desc" ,  sort ,  enabled ) VALUES ( ''' || 'rpcContextType' || ''', ''' || 'RPC_CONTEXT_TYPE' || ''', ''' || 'transmitHeaderToRpcContext' || ''', ''' || 'transmitHeaderToRpcContext' || ''', ''' || 'transmitHeaderToRpcContext' || ''', 0, 1, ''' || '2021-11-24 14:21:32' || ''', ''' || '2021-11-24 14:21:32' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;

-- ----------------------------------------------------
-- create table user_role if not exist ---
-- ----------------------------------------------------
IF (SELECT * FROM dblink('host=localhost user=' || _user || ' password=' || _password || ' dbname=' ||_db,'SELECT COUNT(1) FROM pg_class  WHERE relname  = ''' ||'user_role' || '''')AS t(count BIGINT) )> 0 THEN
    RAISE NOTICE 'user_role already exists';
ELSE
    PERFORM public.dblink_exec('init_conn', 'BEGIN');
    PERFORM public.dblink_exec('init_conn', ' CREATE TABLE "user_role" (
	  "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "user_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "role_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
	  "date_created" timestamp(6) NOT NULL,
	  "date_updated" timestamp(6) NOT NULL
	)');

	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "user_role"."id" IS ''' || 'primary key id' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "user_role"."user_id" IS ''' || 'user primary key' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "user_role"."role_id" IS ''' || 'role primary key' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "user_role"."date_created" IS ''' || 'create time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON COLUMN "user_role"."date_updated" IS ''' || 'update time' || '''');
	PERFORM public.dblink_exec('init_conn', ' COMMENT ON TABLE "user_role" IS ''' || 'user and role bind table' || '''');
	PERFORM public.dblink_exec('init_conn',  ' CREATE TRIGGER user_role_trigger
	          BEFORE UPDATE ON user_role
	          FOR EACH ROW EXECUTE PROCEDURE update_timestamp()');
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

	-- ----------------------------
	-- Records of user_role
	-- ----------------------------
	PERFORM public.dblink_exec('init_conn',  'INSERT INTO "user_role" VALUES (''' || '1351007709096976384' || ''', ''' || '1' || ''', ''' || '1346358560427216896' || ''', ''' || '2021-01-18 11:25:13' || ''', ''' || '2021-01-18 11:25:13' || ''');');

	PERFORM public.dblink_exec('init_conn', 'COMMIT');
END IF;
	PERFORM public.dblink_disconnect('init_conn');
END
$do$;
