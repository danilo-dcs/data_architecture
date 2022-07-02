FROM ubuntu:22.04

# install packages

RUN apg-get update && apt-get install -y apt-utils

RUN \
  apt-get install -y \
  ssh \
  rsync \
  nano \
  openjdk-8-jdk 


# Making hadoop repository
RUN \
  mkdir /opt/hadoop

# download and extract hadoop
RUN \
  wget http://mirror.intergrid.com.au/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz && \
  tar -xvzf hadoop-3.3.0.tar.gz -C /opt/hadoop

# set environment vars
ENV HADOOP_HOME /opt/hadoop/hadoop-3.3.0
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# configuring hadoop files

RUN \
  echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
  echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
  echo "export HDFS_DATANODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
  echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
  echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
  echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh
# create ssh keys
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

RUN \
  service ssh restart

# copy hadoop configs
ADD configs/*xml $HADOOP_HOME/etc/hadoop/

# copy ssh config
ADD configs/ssh_config /root/.ssh/config

# copy script to start hadoop
ADD hadoop-start.sh hadoop-start.sh

# expose various ports
EXPOSE 8088 9000 9864 9866 9870 50070 50075 50030 50060

# 8088 - Hadoop UI
# 9000 - Hadoop monitor
# 9870 - dfs monitor

# start hadoop
CMD bash hadoop-start.sh