@rem
@rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem contributor license agreements.  See the NOTICE file distributed with
@rem this work for additional information regarding copyright ownership.
@rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem (the "License"); you may not use this file except in compliance with
@rem the License.  You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@echo off & setlocal enabledelayedexpansion

cd %~dp0
cd ..

set LOG_HOME=./logs

set SERVER_NAME=ShenYu-Admin

set CLASS_PATH=".;.\conf;.\lib\*;.\ext-lib\*"

set JAVA_OPTS=-server -Xmx2g -Xms2g -Xmn1g -Xss256k -XX:+DisableExplicitGC  -XX:LargePageSizeInBytes=128m
for /f tokens^=2-5^ delims^=^" %%j in ('java -fullversion 2^>^&1') do set "version=%%j"
echo %version%| findstr "^1.8" >nul && (
   set "JAVA_OPTS=%JAVA_OPTS%  -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"
)
echo %version%| findstr "^11" >nul && (
    set "JAVA_OPTS=%JAVA_OPTS%
)
echo %version%| findstr "^17" >nul && (
   set "JAVA_OPTS=%JAVA_OPTS%
)

set MAIN_CLASS=org.apache.shenyu.admin.ShenyuAdminBootstrap

echo Starting the %SERVER_NAME% ...

java %JAVA_OPTS% -Dfile.encoding=UTF-8 -Dlog.home=%LOG_HOME% -classpath %CLASS_PATH% %MAIN_CLASS%

pause
