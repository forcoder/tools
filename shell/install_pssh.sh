#!/bin/sh 
yum -y install python
wget http://parallel-ssh.googlecode.com/files/pssh-2.2.2.tar.gz
tar zxvf pssh-2.2.2.tar.gz
cd pssh-2.2.2
python setup.py install
