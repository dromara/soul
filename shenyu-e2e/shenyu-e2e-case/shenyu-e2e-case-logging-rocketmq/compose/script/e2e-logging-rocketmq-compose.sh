#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# init kubernetes for mysql
SHENYU_TESTCASE_DIR=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
bash "${SHENYU_TESTCASE_DIR}"/k8s/script/storage/storage_init_mysql.sh

# init register center
CUR_PATH=$(readlink -f "$(dirname "$0")")
PRGDIR=$(dirname "$CUR_PATH")
# init shenyu sync
SYNC_ARRAY=("websocket" "http" "zookeeper" "etcd")
#SYNC_ARRAY=("websocket" "nacos")
#MIDDLEWARE_SYNC_ARRAY=("zookeeper" "etcd" "nacos")

docker network create -d bridge shenyu

for sync in "${SYNC_ARRAY[@]}"; do
  echo -e "------------------\n"
  echo "[Start ${sync} synchronous] create shenyu-admin-${sync}.yml shenyu-bootstrap-${sync}.yml "
  docker compose -f "$SHENYU_TESTCASE_DIR"/compose/sync/shenyu-sync-"${sync}".yml up -d --quiet-pull
  sleep 30s
  sh "$SHENYU_TESTCASE_DIR"/k8s/script/healthcheck.sh http://localhost:31095/actuator/health
  sh "$SHENYU_TESTCASE_DIR"/k8s/script/healthcheck.sh http://localhost:31195/actuator/health
  docker compose -f "${PRGDIR}"/shenyu-rocketmq-compose.yml up -d --quiet-pull
  docker compose -f "${PRGDIR}"/shenyu-examples-http-compose.yml up -d --quiet-pull
  sleep 30s
  sh "$SHENYU_TESTCASE_DIR"/k8s/script/healthcheck.sh http://localhost:31189/actuator/health
  sleep 10s
  docker ps -a
  ## run e2e-test
  ./mvnw -B -f ./shenyu-e2e/pom.xml -pl shenyu-e2e-case/shenyu-e2e-case-logging-rocketmq -am test
  # shellcheck disable=SC2181
  if (($?)); then
    echo "${sync}-sync-e2e-test failed"
    echo "------------------"
    echo "shenyu-admin log:"
    echo "------------------"
    docker compose -f "$SHENYU_TESTCASE_DIR"/compose/sync/shenyu-sync-"${sync}".yml logs shenyu-admin
    echo "shenyu-bootstrap log:"
    echo "------------------"
    docker compose -f "$SHENYU_TESTCASE_DIR"/compose/sync/shenyu-sync-"${sync}".yml logs shenyu-bootstrap
    echo "shenyu-rocketmq log:"
    echo "------------------"
    docker compose -f "${PRGDIR}"/shenyu-rocketmq-compose.yml logs
    exit 1
  fi
  docker compose -f "$SHENYU_TESTCASE_DIR"/compose/sync/shenyu-sync-"${sync}".yml down
  docker compose -f "${PRGDIR}"/shenyu-rocketmq-compose.yml down
  docker compose -f "${PRGDIR}"/shenyu-examples-http-compose.yml down
  echo "[Remove ${sync} synchronous] delete shenyu-admin-${sync}.yml shenyu-bootstrap-${sync}.yml "
done
