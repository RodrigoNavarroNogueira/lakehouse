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
RUN rm hadoop-3.4.0.tar.gz

RUN wget https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz
RUN tar xvf spark-3.5.1-bin-hadoop3.tgz
RUN mv spark-3.5.1-bin-hadoop3 /opt/spark
RUN rm spark-3.5.1-bin-hadoop3.tgz

RUN wget https://dlcdn.apache.org/hive/hive-4.0.0/apache-hive-4.0.0-bin.tar.gz
RUN tar -xzvf apache-hive-4.0.0-bin.tar.gz
RUN mv apache-hive-4.0.0-bin /opt/hive
RUN rm apache-hive-4.0.0-bin.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/opt/spark
ENV HIVE_HOME=/opt/hive
ENV HADOOP_CONFIG_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=/usr/local/hadoop/bin:/usr/local/hadoop/sbin:$SPARK_HOME/bin:$HIVE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

RUN mkdir files
COPY pokemon.json /files/
COPY pokemon_edit.json /files/
# COPY init.hql /files/
# COPY core-site.xml $HADOOP_CONFIG_DIR/core-site.xml
# COPY hdfs-site.xml $HADOOP_CONFIG_DIR/hdfs-site.xml
# COPY mapred-site.xml $HADOOP_CONFIG_DIR/mapred-site.xml
# COPY yarn-site.xml $HADOOP_CONFIG_DIR/yarn-site.xml
# COPY hadoop-functions.sh $HADOOP_HOME/libexec/hadoop-functions.sh
# COPY hive-site.xml /opt/hive/conf/
# COPY testando.py /opt/spark/workspace/
COPY spark-defaults.conf $SPARK_HOME/conf/
# RUN curl -L -o $SPARK_HOME/delta-spark_2.12-3.2.0.jar https://repo.maven.apache.org/maven2/io/delta/delta-spark_2.12/3.2.0/delta-spark_2.12-3.2.0.jar
# RUN /etc/init.d/ssh start
# RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
# RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# RUN chmod 0600 ~/.ssh/authorized_keys
# RUN echo '/etc/init.d/ssh start' >> ~/.bashrc
# RUN echo export JAVA_HOME=${JAVA_HOME} >> $HADOOP_CONFIG_DIR/hadoop-env.sh

# RUN hdfs namenode -format
# RUN echo 'start-dfs.sh' >> ~/.bashrc
# RUN echo 'start-yarn.sh' >> ~/.bashrc

# RUN echo 'hdfs dfs -mkdir -p pokemon' >> ~/.bashrc
# RUN echo 'hdfs dfs -put /files/pokemon.json pokemon' >> ~/.bashrc
# RUN echo 'hdfs dfs -put /files/pokemon_edit.json pokemon' >> ~/.bashrc

# RUN echo 'hdfs dfs -mkdir /tmp' >> ~/.bashrc
# RUN echo 'hdfs dfs -mkdir /user/hive' >> ~/.bashrc
# RUN echo 'hdfs dfs -mkdir /user/hive/warehouse' >> ~/.bashrc
# RUN echo 'hdfs dfs -chmod g+w /tmp' >> ~/.bashrc
# RUN echo 'hdfs dfs -chmod g+w /user/hive/warehouse' >> ~/.bashrc

# RUN echo 'schematool -dbType derby -initSchema' >> ~/.bashrc
# RUN echo 'beeline -u jdbc:hive2://localhost:10000 -f /files/init.hql' >> ~/.bashrc
# RUN echo '$HIVE_HOME/bin/beeline -u jdbc:hive2:// -f /files/init.hql' >> ~/.bashrc

WORKDIR $SPARK_HOME