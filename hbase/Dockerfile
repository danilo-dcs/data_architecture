FROM ubuntu:22.04

# install packages
RUN \
  apt-get update && apt-get install -y \
  apt-utils \
  ssh \
  rsync \
  nano \
  openjdk-11-jdk 

# Making hbase repository
RUN \
  mkdir /opt/hbase


# download and extract hbase
RUN \
  wget https://dlcdn.apache.org/hbase/stable/hbase-2.4.13-bin.tar.gz && \
  tar -xvzf hbase-2.4.13-bin.tar.gz -C /opt/hbase

ENV HBASE_HOME /opt/hbase/hbase-2.4.13
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64


# Adicionando o hbase às variáveis de ambiente
RUN echo "PATH=$PATH:$HBASE_HOME/bin" >> ~/.bashrc


# create ssh keys
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_hbase && \
  cat ~/.ssh/id_hbase.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys


RUN \
  service ssh restart

# copy ssh config
ADD configs/ssh_config /root/.ssh/config

# copy hbase configs
ADD configs/*.xml $HBASE_HOME/conf

# copy script to start hbase
ADD hbase-start.sh hbase-start.sh

# expose various ports
EXPOSE 16000 16010 16020 2181 3010

# HBase Master: 16000
# HBase Ui: 16010
# HBase Server: 16020
# Zookeeper connector: 2181
# Hbase rest api: 3010

# start hbase
CMD bash hbase-start.sh