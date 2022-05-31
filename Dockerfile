FROM ubuntu:22.04

# set environment vars
ENV HADOOP_HOME /opt/hadoop
ENV SPARK_HOME /opt/spark
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# install packages
RUN \
  apt-get update && apt-get install -y \
  build-essential \
  curl \
  ssh \
  rsync \
  vim \
  openjdk-8-jdk \
  python3 \
  pip \
  maven

# install scala
RUN \
  curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs && ./cs setup


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

# installing spark
RUN \
  wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz && \
  tar -xvzf spark-3.2.1-bin-hadoop3.2.tgz && \
  mv spark-3.2.1-bin-hadoop3.2 $SPARK_HOME && \
  echo "export SPARK_HOME=/opt/spark" >> ~/.profile && \
  echo "export PATH=$PATH:/opt/spark/bin:/opt/spark/sbin" >> ~/.profile && \
  echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.profile && \
  echo "export SPARK_HOME=/opt/spark" >> ~/.bashrc && \
  echo "export PATH=$PATH:/opt/spark/bin:/opt/spark/sbin" >> ~/.bashrc && \
  echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.bashrc

# copy hadoop configs
ADD configs/*xml $HADOOP_HOME/etc/hadoop/

# copy ssh config
ADD configs/ssh_config /root/.ssh/config

# copy script to start hadoop
ADD start-hadoop.sh start-hadoop.sh

# expose various ports
EXPOSE 7077 8080 8088 9000 
# 50070 50075 50030 50060

# 7077 - spark servie
# 8080 - Spark UI
# 8088 - Hadoop UI
# 9000 - Hadoop monitor

# start hadoop
CMD bash start-hadoop.sh start-spark.sh