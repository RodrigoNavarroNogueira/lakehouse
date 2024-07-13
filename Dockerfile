FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install openssh-server -y
RUN apt-get install pdsh -y
RUN apt-get install openjdk-8-jdk -y
RUN apt-get install sudo -y
RUN apt-get install wget -y
RUN apt-get install python3 -y
RUN apt-get install nano -y
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
RUN tar xvf hadoop-3.4.0.tar.gz
RUN mv hadoop-3.4.0 /usr/local/hadoop

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/opt/spark
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$SPARK_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

COPY ditto.json /
COPY core-site.xml $HADOOP_CONFIG_DIR/core-site.xml
COPY hdfs-site.xml $HADOOP_CONFIG_DIR/hdfs-site.xml
COPY mapred-site.xml $HADOOP_CONFIG_DIR/mapred-site.xml
COPY yarn-site.xml $HADOOP_CONFIG_DIR/yarn-site.xml

RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> $HADOOP_CONF_DIR/hadoop-env.sh

RUN /etc/init.d/ssh start
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN hdfs namenode -format
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root

RUN sed -i "s/if \[\[ -e '\/usr\/bin\/pdsh' \]\]; then/if \[\[ ! -e '\/usr\/bin\/pdsh' \]\]; then/" $HADOOP_HOME/libexec/hadoop-functions.sh

#RUN start-dfs.sh
#RUN bin/hdfs dfs -mkdir -p input