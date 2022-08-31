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

-- this file works for PostgreSQL, can not use "`" syntax.

-- Note: it doesn't matter if you don't execute this SQL
-- Note: because most users have changed ZK configuration, this SQL is annotated to prevent erroneous execution
-- UPDATE plugin SET config='{"register":"127.0.0.1:2181","corethreads":0,"threads":2147483647,"queues":0}' WHERE "name" = 'motan';
-- if you want to execute this SQL, please replace it with your ZK configuration

-- insert loggingTencentCls plugin
INSERT INTO "public"."plugin" VALUES ('35', 'loggingTencentCls', '{"endpoint\": \"ap-guangzhou.cls.tencentcs.com\, \"topic\": \"shenyu-topic"}', 'Logging', 176, 0, '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524972', '35', 'secretId', 'secretId', 2, 3, 1, '{\"required\":\"1\",\"defaultValue\":\"\",\"placeholder\":\"\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524973', '35', 'secretKey', 'secretKey', 2, 3, 2, '{\"required\":\"1\",\"defaultValue\":\"\",\"placeholder\":\"\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524974', '35', 'endpoint', 'endpoint', 2, 3, 3, '{\"required\":\"1\",\"defaultValue\":\"\",\"placeholder\":\"\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524975', '35', 'topic', 'topic', 2, 3, 4, '{\"required\":\"1\",\"defaultValue\":\"\",\"placeholder\":\"\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524976', '35', 'sendThreadCount', 'sendThreadCount', 1, 3, 5, '{\"required\":\"0\",\"defaultValue\":1,\"placeholder\":\"1-500\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524977', '35', 'totalSizeInBytes', 'totalSizeInBytes', 1, 3, 6, '{\"required\":\"0\",\"defaultValue\":104857600}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524978', '35', 'maxSendThreadCount', 'maxSendThreadCount', 1, 3, 7, '{\"required\":\"0\",\"defaultValue\":1,\"placeholder\":\"availableProcessors + 1\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524979', '35', 'maxBlockSec', 'maxBlockSec', 1, 3, 8, '{\"required\":\"0\",\"defaultValue\":60000}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524980', '35', 'maxBatchSize', 'maxBatchSize', 1, 3, 9, '{\"required\":\"0\",\"defaultValue\":524288}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524981', '35', 'maxBatchCount', 'maxBatchCount', 1, 3, 10, '{\"required\":\"0\",\"defaultValue\":4096}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524982', '35', 'lingerMs', 'lingerMs', 1, 3, 11, '{\"required\":\"0\",\"defaultValue\":2000}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524983', '35', 'retries', 'retries', 1, 3, 12, '{\"required\":\"0\",\"defaultValue\":10}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524984', '35', 'maxReservedAttempts', 'maxReservedAttempts', 1, 3, 13, '{\"required\":\"0\",\"defaultValue\":11}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524985', '35', 'baseRetryBackoffMs', 'baseRetryBackoffMs', 1, 3, 14, '{\"required\":\"0\",\"defaultValue\":100}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO "public"."plugin_handle" VALUES ('1529403902783524986', '35', 'maxRetryBackoffMs', 'maxRetryBackoffMs', 1, 3, 15, '{\"required\":\"0\",\"defaultValue\":50000}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
