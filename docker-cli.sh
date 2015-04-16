#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

jar='kafka-mesos*.jar'

check_jar() {
    jars=$(find . -maxdepth 1 -name "$jar" | wc -l)

    if [ $jars -eq 0 ]
    then
        echo "$jar not found"
        exit 1
    elif [ $jars -gt 1 ]
    then
        echo "More than one $jar found"
        exit 1
    fi
}

check_environment() {
	if [ ! -z "$DEBUG" ]; then
		sed -r -i "s|(debug=).*|\1$DEBUG|g" kafka-mesos.properties
	fi
	if [ ! -z "$CLUSTER_STORAGE" ]; then
		sed -r -i "s|(clusterStorage=).*|\1$CLUSTER_STORAGE|g" kafka-mesos.properties
	fi
	if [ ! -z "$MESOS_USER" ]; then
		sed -r -i "s|(mesos\.user=).*|\1$MESOS_USER|g" kafka-mesos.properties
	fi
	if [ ! -z "$MASTER_CONNECT" ]; then
		sed -r -i "s|(master\.connect=).*|\1$MASTER_CONNECT|g" kafka-mesos.properties
	fi
	if [ ! -z "$ZK_CONNECT" ]; then
		sed -r -i "s|(kafka\.zk\.connect=).*|\1$ZK_CONNECT|g" kafka-mesos.properties
	fi
	if [ ! -z "$SCHEDULER_URL" ]; then
		sed -r -i "s|(scheduler\.url=).*|\1$SCHEDULER_URL|g" kafka-mesos.properties
	fi
	if [ ! -z "$FAILOVER_TIMEOUT" ]; then
		sed -r -i "s|(failoverTimeout=).*|\1$FAILOVER_TIMEOUT|g" kafka-mesos.properties
	fi
}

check_jar
check_environment
java -jar $jar "$@"
