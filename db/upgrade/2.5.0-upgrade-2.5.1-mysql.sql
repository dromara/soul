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

-- this file works for MySQL.

/*insert plugin_handle data for plugin loggingElasticSearch*/
INSERT IGNORE INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`) VALUES ('1529402613204172906', '32', 'username', 'username', 2, 3, 3, '{"required":"0","defaultValue":""}');
INSERT IGNORE INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`) VALUES ('1529402613204172907', '32', 'password', 'password', 2, 3, 4, '{"required":"0","defaultValue":""}');
INSERT IGNORE INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`) VALUES ('1529402613204172908', '32', 'authCache', 'authCache', 2, 3, 5, '{"required":"0","defaultValue":"","placeholder":"true|false"}');
INSERT IGNORE INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`) VALUES ('1529402613204172909', '29', 'accessKey', 'accessKey', 2, 3, 4, '{"required":"0","defaultValue":"","placeholder":"accessKey"}');
INSERT IGNORE INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`) VALUES ('1529402613204172910', '29', 'secretKey', 'secretKey', 2, 3, 5, '{"required":"0","defaultValue":"","placeholder":"secretKey"}');
-- resort relation fields
UPDATE plugin_handle SET sort = sort + 3 WHERE plugin_id = '32' AND field in ('sampleRate', 'maxResponseBody', 'maxRequestBody', 'compressAlg');
UPDATE plugin_handle SET sort = sort + 2 WHERE plugin_id = '29' AND field in ('sampleRate', 'maxResponseBody', 'maxRequestBody', 'compressAlg');

/* insert plugin for loggingPulsar */
INSERT INTO `plugin` VALUES ('35', 'loggingPulsar', '{\"topic":\"shenyu-access-logging\", \"serviceUrl\": \"pulsar://localhost:6650\"}', 'Logging', 185, 0, '2022-06-30 21:00:00', '2022-06-30 21:00:00');

/* insert plugin_handle data for plugin loggingPulsar */
INSERT INTO `plugin_handle` VALUES ('1529402613204172906', '35', 'topic', 'topic', 2, 3, 1, '{\"required\":\"1\",\"defaultValue\":\"shenyu-access-logging\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO `plugin_handle` VALUES ('1529402613204172907', '35', 'serviceUrl', 'serviceUrl', 2, 3, 2, '{\"required":"1",\"defaultValue\":\"pulsar://localhost:6650\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO `plugin_handle` VALUES ('1529402613204172908', '35', 'sampleRate', 'sampleRate', 2, 3, 4, '{\"required":"0",\"defaultValue\":\"1\",\"placeholder\":\"optional,0,0.01~1\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO `plugin_handle` VALUES ('1529402613204172909', '35', 'maxResponseBody', 'maxResponseBody', 1, 3, 5, '{\"required\":\"0\",\"defaultValue\":524288}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO `plugin_handle` VALUES ('1529402613204172910', '35', 'maxRequestBody', 'maxRequestBody', 1, 3, 6, '{\"required\":\"0\",\"defaultValue\":524288}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');
INSERT INTO `plugin_handle` VALUES ('1529402613204172911', '35', 'compressAlg', 'compressAlg', 3, 3, 7, '{\"required\":\"0\",\"defaultValue\":\"none\"}', '2022-06-30 21:00:00', '2022-06-30 21:00:00');

