FROM ubuntu:22.04

# set environment vars
ENV HADOOP_HOME /opt/hadoop
ENV SPARK_HOME /opt/spark
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# install packages
RUN \
  apt-get update && apt-get install -y \
  ssh \
  rsync \
  vim \
  openjdk-8-jdk 

# download and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
RUN \
  wget http://mirror.intergrid.com.au/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz && \
  tar -xzf hadoop-3.3.0.tar.gz && \
  mv hadoop-3.3.0 $HADOOP_HOME && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

# create ssh keys
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

# copy hadoop configs
ADD configs/*xml $HADOOP_HOME/etc/hadoop/

# copy ssh config
ADD configs/ssh_config /root/.ssh/config

# copy script to start hadoop
ADD hadoop-start.sh hadoop-start.sh

# expose various ports
EXPOSE 8088 9000 50070 50075 50030 50060

# 8088 - Hadoop UI
# 9000 - Hadoop monitor

# start hadoop
CMD bash hadoop-start.sh