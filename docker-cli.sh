#!/bin/bash
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
	# DEBUG=true
	# CLUSTER_STORAGE=file:kafka-mesos.json
	# MESOS_USER=
	# MASTER_CONNECT=zk://localhost:2181/mesos
	# KAFKA_ZK_CONNECT=localhost:2181
	# SCHEDULER_URL=http://localhost:7000
	# FAILOVER_TIMEOUT=36000

	if [ ! -z "$DEBUG" ]; then
		sed -r -i "s/(debug=).*/\1$DEBUG/g" kafka-mesos.properties
	fi
	if [ ! -z "$CLUSTER_STORAGE" ]; then
		sed -r -i "s/(clusterStorage=).*/\1$CLUSTER_STORAGE/g" kafka-mesos.properties
	fi
	if [ ! -z "$MESOS_USER" ]; then
		sed -r -i "s/(mesos\.user=).*/\1$MESOS_USER/g" kafka-mesos.properties
	fi
	if [ ! -z "$MASTER_CONNECT" ]; then
		sed -r -i "s/(master\.connect=).*/\1$MASTER_CONNECT/g" kafka-mesos.properties
	fi
	if [ ! -z "$ZK_CONNECT" ]; then
		sed -r -i "s/(kafka\.zk\.connect=).*/\1$ZK_CONNECT/g" kafka-mesos.properties
	fi
	if [ ! -z "$SCHEDULER_URL" ]; then
		sed -r -i "s/(scheduler\.url=).*/\1$SCHEDULER_URL/g" kafka-mesos.properties
	fi
	if [ ! -z "$FAILOVER_TIMEOUT" ]; then
		sed -r -i "s/(failoverTimeout=).*/\1$FAILOVER_TIMEOUT/g" kafka-mesos.properties
	fi
}

check_jar
check_environment
java -jar $jar "$@"

