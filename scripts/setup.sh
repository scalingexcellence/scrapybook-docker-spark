#!/bin/bash

# Install Java
add-apt-repository -y ppa:webupd8team/java
apt-get -y update 

echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
echo "debconf shared/accepted-oracle-license-v1-1 seen true" | sudo debconf-set-selections
apt-get -y install oracle-java8-installer >/dev/null 2>&1

export JAVA_HOME=/usr/lib/jvm/java-8-oracle

echo '' >> /etc/profile
echo '# JDK' >> /etc/profile
echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile
echo 'export PATH="$PATH:$JAVA_HOME/bin"' >> /etc/profile
echo '' >> /etc/profile

# Install Spark
export SPARK_VERSION=1.5.2
export HADOOP_VERSION=2.6
export SPARK_PACKAGE=spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
export SPARK_HOME=/usr/$SPARK_PACKAGE
export PATH=$PATH:$SPARK_HOME/bin

curl -sL --retry 3 "http://apache.mirror.anlx.net/spark/spark-$SPARK_VERSION/${SPARK_PACKAGE}.tgz" | gunzip | tar x -C /usr/
ln -s $SPARK_HOME /usr/spark

apt-get -y install python

echo "export SPARK_HOME=$SPARK_HOME" >> /etc/profile
echo 'export PATH="$PATH:$SPARK_HOME/bin"' >> /etc/profile

# Install pureftp

#For anon. user to work
adduser --disabled-password --quiet --system ftp

#apt-get -y install pure-ftpd
# Disable capabilities, see here: https://hub.docker.com/r/stilliard/pure-ftpd/~/dockerfile/
dpkg -i /tmp/bin/pure-ftpd-common*.deb
apt-get -y install openbsd-inetd
dpkg -i /tmp/bin/pure-ftpd_*.deb
apt-mark hold pure-ftpd pure-ftpd-common

rm /etc/pure-ftpd/conf/NoAnonymous
echo "yes" > /etc/pure-ftpd/conf/CallUploadScript
echo "yes" > /etc/pure-ftpd/conf/AnonymousOnly
echo "30000 30009" > /etc/pure-ftpd/conf/PassivePortRange
mkdir /opt/pure-ftpd
mkdir /root/items
mv /tmp/scripts/on_upload.sh /opt/pure-ftpd/on_upload.sh
#chmod +x /home/ubuntu/scripts/on_upload.sh

mv /tmp/scripts/pure-ftpd-common /etc/default/pure-ftpd-common

# @startup
mkdir /etc/service/pureftp
mv /tmp/scripts/start_pureftp.sh /etc/service/pureftp/run



# Clean up APT when done.
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/scripts /tmp/bin

