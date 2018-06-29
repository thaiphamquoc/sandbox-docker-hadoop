FROM sequenceiq/hadoop-docker:2.7.1
LABEL maintainer="thaiphamquoc@gmail.com"

# Remove Java 7 and install Java 8
ENV RPM_FILENAME jdk-8u65-linux-x64.rpm
ENV CURL_HEADER 'Cookie: oraclelicense=accept-securebackup-cookie'
ENV JAVA8_URL http://download.oracle.com/otn-pub/java/jdk/8u65-b17/${RPM_FILENAME}
RUN rpm -e jdk-1.7.0_71-fcs && curl -LO ${JAVA8_URL} -H "${CURL_HEADER}" && rpm -i ${RPM_FILENAME} && rm ${RPM_FILENAME}

# Copying customized YARN configuration file
COPY etc/hadoop/yarn-site.xml ${HADOOP_CONF_DIR}/yarn-site.xml
COPY etc/hadoop/mapred-site.xml ${HADOOP_CONF_DIR}/mapred-site.xml

# This will limit Hadoop daemons' heap size
ENV HADOOP_HEAPSIZE 256
# This will limit YARN daemon's heap size
ENV YARN_HEAPSIZE 256
ENV HADOOP_BIN_DIR ${HADOOP_COMMON_HOME}/bin

# Reduce maximum heap size, by default it is 1000MB each daemons
RUN sed -i "s/^# YARN_HEAPSIZE=.\+/YARN_HEAPSIZE=${YARN_HEAPSIZE}/" ${HADOOP_CONF_DIR}/yarn-env.sh
RUN sed -i "s/^#export HADOOP_HEAPSIZE=/export HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE}/" ${HADOOP_CONF_DIR}/hadoop-env.sh
