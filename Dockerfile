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

RUN wget https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz
RUN tar xvf spark-3.5.1-bin-hadoop3.tgz
RUN mv spark-3.5.1-bin-hadoop3 /opt/spark

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/opt/spark
ENV HADOOP_CONFIG_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=/usr/local/hadoop/bin:/usr/local/hadoop/sbin:$SPARK_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

COPY ditto.json /
COPY core-site.xml $HADOOP_CONFIG_DIR/core-site.xml
COPY hdfs-site.xml $HADOOP_CONFIG_DIR/hdfs-site.xml
COPY mapred-site.xml $HADOOP_CONFIG_DIR/mapred-site.xml
COPY yarn-site.xml $HADOOP_CONFIG_DIR/yarn-site.xml
COPY hadoop-functions.sh $HADOOP_HOME/libexec/hadoop-functions.sh

RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> $HADOOP_CONF_DIR/hadoop-env.sh

RUN /etc/init.d/ssh start
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN echo '/etc/init.d/ssh start' >> ~/.bashrc
RUN echo export JAVA_HOME=${JAVA_HOME} >> $HADOOP_CONFIG_DIR/hadoop-env.sh

RUN hdfs namenode -format
RUN echo 'start-dfs.sh' >> ~/.bashrc
RUN echo 'start-yarn.sh' >> ~/.bashrc

RUN echo 'hdfs dfs -mkdir -p pokemon' >> ~/.bashrc
RUN echo 'hdfs dfs -put /ditto.json pokemon' >> ~/.bashrc