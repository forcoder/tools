#!/bin/sh
yum -y install crypto 
yum -y install automake autoconf automake libtool make
yum -y install libuuid-devel
yum -y install fuse-devel
yum -y install libedit-devel
yum -y install libaio-devel
yum -y install keyutils-libs-devel
yum -y install gcc-c++
yum -y install cryptopp-devel
yum -y install expat-devel

cd /tmp
wget http://ceph.com/download/ceph-0.52.tar.gz
tar zxvf ceph-0.52.tar.gz
cd ceph-0.52
./autogen.sh
./bootstrap.sh
./bjam --with-date_time --with-system --with-regex --with-thread --with-filesystem --with-serialization --with-iostreams --with-math --with-mpi --with-program_options --with-python --with-math --with-signals --layout=tagged install variant=debug,release link=static --runtime-link=static threading=multi stage
./configure --without-tcmalloc --without-libatomic-ops
make
make install
