#!/bin/sh

cd /usr/local
wget http://mirror.bjtu.edu.cn/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz
tar zxvf zookeeper-3.4.5.tar.gz
cd zookeeper-3.4.5
cp conf/zoo_sample.cfg conf/zoo.cfg
myid=$(ifconfig eth0|grep 'inet addr:'|awk '{print $2}'|awk -F: '{print $2}'|awk -F. '{print $4}')
cat > /tmp/zookeeper/myid <<EOF
$myid
EOF
bin/zkServer.sh start
