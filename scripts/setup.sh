#!/bin/bash

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

cp /tmp/scripts/spark-env.sh $SPARK_HOME/conf/

# Install pureftp

#For anon. user to work
adduser --disabled-password --quiet --system ftp

# We can't use the default pure-ftp unfortunatelly.
#apt-get -y install pure-ftpd

# Disable capabilities, see here: https://hub.docker.com/r/stilliard/pure-ftpd/~/dockerfile/
dpkg -i /tmp/scripts/pure-ftpd-common*.deb
apt-get -y install openbsd-inetd
dpkg -i /tmp/scripts/pure-ftpd_*.deb
apt-mark hold pure-ftpd pure-ftpd-common

mkdir /opt/pure-ftpd
mv /tmp/scripts/on_upload.sh /opt/pure-ftpd/on_upload.sh

mkdir /root/items

# @startup
mkdir /etc/service/pureftp
mv /tmp/scripts/start_pureftp.sh /etc/service/pureftp/run

mkdir /etc/service/uploadscript
mv /tmp/scripts/start_uploadscript.sh /etc/service/uploadscript/run

# Clean up APT when done.
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/scripts
