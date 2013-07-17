#!/usr/bin/env python

import bmemcached
import time

begin = time.time()
memc = bmemcached.Client("host", "username", "password")
auth_time = time.time()
put_res = memc.set("test", "5555", 100000000);
print put_res
put_time = time.time()
get_res = memc.get("test")
print get_res
get_time = time.time()


print "total_time:%.3f s; auth_time:%.3f s; put_time:%.3f s; get_time:%.3f s" %(get_time - begin, auth_time - begin, put_time - auth_time, get_time - put_time)




