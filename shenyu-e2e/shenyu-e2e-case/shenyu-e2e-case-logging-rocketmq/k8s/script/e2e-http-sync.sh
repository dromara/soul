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

docker save shenyu-examples-http:latest | sudo k3s ctr images import -

# init kubernetes for mysql
SHENYU_TESTCASE_DIR=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
bash "${SHENYU_TESTCASE_DIR}"/k8s/script/storage/storage_init_mysql.sh

# init register center
CUR_PATH=$(readlink -f "$(dirname "$0")")
PRGDIR=$(dirname "$CUR_PATH")
kubectl apply -f "${SHENYU_TESTCASE_DIR}"/k8s/sync/shenyu-cm.yml

# init shenyu sync
SYNC_ARRAY=("websocket" "http" "zookeeper" "etcd")
#SYNC_ARRAY=("websocket" "nacos")
MIDDLEWARE_SYNC_ARRAY=("zookeeper" "etcd" "nacos")
for sync in ${SYNC_ARRAY[@]}; do
  echo -e "------------------\n"
  kubectl apply -f "${PRGDIR}"/shenyu-kafka.yml
  sh "$SHENYU_TESTCASE_DIR"/k8s/script/healthcheck.sh http://localhost:9092/actuator/health

  sleep 30s
  echo "[Start ${sync} synchronous] create shenyu-admin-${sync}.yml shenyu-bootstrap-${sync}.yml shenyu-examples-springcloud.yml"
  # shellcheck disable=SC2199
  # shellcheck disable=SC2076
  # shellcheck disable=SC2154
  if [[ "${MIDDLEWARE_SYNC_ARRAY[@]}" =~ "${sync}" ]]; then
    kubectl apply -f "${SHENYU_TESTCASE_DIR}"/k8s/shenyu-"${sync}".yml
    sleep 10s
  fi
  kubectl apply -f "${SHENYU_TESTCASE_DIR}"/k8s/sync/shenyu-admin-"${sync}".yml
  sh "$SHENYU_TESTCASE_DIR"/k8s/script/healthcheck.sh http://localhost:31095/actuator/health
  kubectl apply -f "${SHENYU_TESTCASE_DIR}"/k8s/sync/shenyu-bootstrap-"${sync}".yml
  sh "$SHENYU_TESTCASE_DIR"/k8s/script/healthcheck.sh http://localhost:31195/actuator/health
  sleep 10s
  kubectl get pod -o wide

  kubectl logs "$(kubectl get pod -o wide | grep shenyu-admin | awk '{print $1}')"

  ## run e2e-test
  ./mvnw -B -f ./shenyu-e2e/pom.xml -pl shenyu-e2e-case/shenyu-e2e-case-logging-kafka -am test
  # shellcheck disable=SC2181
  if (($?)); then
    echo "${sync}-sync-e2e-test failed"
    echo "shenyu-admin log:"
    echo "------------------"
    kubectl logs "$(kubectl get pod -o wide | grep shenyu-admin | awk '{print $1}')"
    echo "shenyu-bootstrap log:"
    echo "------------------"
    kubectl logs "$(kubectl get pod -o wide | grep shenyu-bootstrap | awk '{print $1}')"
    exit 1
  fi
  kubectl delete -f "${SHENYU_TESTCASE_DIR}"/k8s/shenyu-mysql.yml
  kubectl delete -f "${SHENYU_TESTCASE_DIR}"/k8s/sync/shenyu-admin-"${sync}".yml
  kubectl delete -f "${SHENYU_TESTCASE_DIR}"/k8s/sync/shenyu-bootstrap-"${sync}".yml
  kubectl delete -f "${PRGDIR}"/shenyu-kafka.yml

  # shellcheck disable=SC2199
  # shellcheck disable=SC2076
  if [[ "${MIDDLEWARE_SYNC_ARRAY[@]}" =~ "${sync}" ]]; then
    kubectl delete -f "${SHENYU_TESTCASE_DIR}"/k8s/shenyu-"${sync}".yml
  fi
  echo "[Remove ${sync} synchronous] delete shenyu-admin-${sync}.yml shenyu-bootstrap-${sync}.yml shenyu-examples-springcloud.yml"
done
