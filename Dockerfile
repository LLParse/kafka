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

FROM ubuntu:14.04

# Install Oracle JDK7
RUN \
  apt-get update && \
  apt-get install -y software-properties-common git curl && \
  add-apt-repository -y ppa:webupd8team/java && \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/cache/oracle-jdk7-installer && \
  rm -rf /var/lib/apt/lists/*

# Install Mesos (need native library)
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF && \
  echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
  apt-get update && \
  apt-get install -y mesos && \
  rm -rf /var/lib/apt/lists/*

# Build the scheduler
RUN \
  git clone https://github.com/mesos/kafka /opt/mesos-kafka && \
  cd /opt/mesos-kafka && \
  ./gradlew jar && \
  curl -O https://archive.apache.org/dist/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz

# Set wrapper script as entrypoint
ADD docker-cli.sh /opt/mesos-kafka/docker-cli.sh
WORKDIR /opt/mesos-kafka
ENTRYPOINT ["./docker-cli.sh"]

