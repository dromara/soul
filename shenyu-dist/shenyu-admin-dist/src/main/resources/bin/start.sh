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

SERVER_NAME=ShenYu-Admin

cd `dirname $0`
cd ..
DEPLOY_DIR=`pwd`

LOGS_DIR=${DEPLOY_DIR}/logs
if [ ! -d ${LOGS_DIR} ]; then
    mkdir ${LOGS_DIR}
fi
LOG_FILES=${LOGS_DIR}/shenyu-admin.log

if [ -z "${ADMIN_JVM}" ]; then
    JAVA_OPTS=" -server -Xmx2g -Xms2g -Xmn1g -Xss328k -XX:+DisableExplicitGC  -XX:LargePageSizeInBytes=128m"
    version=`java -version 2>&1 | sed '1!d' | sed -e 's/"//g' | awk '{print $3}'`
    echo "current jdk version:${version}"
    if [[ "$version" =~ "1.8" ]];then
        JAVA_OPTS="${JAVA_OPTS} -XX:+UseFastAccessorMethods  -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly  -XX:CMSInitiatingOccupancyFraction=70"
    elif [[ "$version" =~ "11" ]];then
        JAVA_OPTS="${JAVA_OPTS}"
    elif [[ "$version" =~ "17" ]];then
        JAVA_OPTS="${JAVA_OPTS}"
    fi
    echo "Use default jvm param: $JAVA_OPTS"
else
    JAVA_OPTS=${ADMIN_JVM}
    echo "Start with the environment variable JAVA_OPTS set: $JAVA_OPTS"
fi

MAIN_CLASS=org.apache.shenyu.admin.ShenyuAdminBootstrap

echo "Starting the $SERVER_NAME ..."
echo "Please check the log files: $LOG_FILES"

exec $DEPLOY_DIR/bin/run-class.sh $JAVA_OPTS $MAIN_CLASS >> $LOG_FILES 2>&1 & "$@"
