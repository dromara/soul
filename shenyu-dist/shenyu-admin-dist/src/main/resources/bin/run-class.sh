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

cd `dirname $0`
cd ..
DEPLOY_DIR=`pwd`
EXT_LIB=${DEPLOY_DIR}/ext-lib
LIB=${DEPLOY_DIR}/lib

lib_regex="^"$LIB"/(java|jakarta|reactor|netty|tomcat|spring|mybatis|shenyu).*\.jar$"
lib_exclude_file() {
  file=$1
  if [ -z "$(echo "$file" | grep -E "$lib_regex")" ] ; then
    return 0
  else
    return 1
  fi
}

# conf files
for file in "$DEPLOY_DIR"/conf/*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

# lib files
for file in "$DEPLOY_DIR"/lib/java*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/jakarta*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/reactor*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/netty*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/tomcat*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/spring*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/mybatis*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/shenyu*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

for file in "$DEPLOY_DIR"/lib/*;
do
  if lib_exclude_file "$file"; then
   CLASS_PATH="$CLASS_PATH":"$file"
  fi
done

# ext_lib files
for file in "$EXT_LIB"/*;
do
   CLASS_PATH="$CLASS_PATH":"$file"
done

if [ -z "$JAVA_HOME" ]; then
  JAVA="java"
else
  JAVA="$JAVA_HOME/bin/java"
fi

nohup "$JAVA" -cp "$CLASS_PATH" "$@"

