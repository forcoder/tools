#!/usr/bin/env python

import os,sys
import bmemcached
import time
import ConfigParser



parent_dir = os.path.join(os.getcwd(), os.path.pardir)
config_path = os.path.abspath(os.path.join(parent_dir, "config/ocs.ini"))
cp = ConfigParser.ConfigParser()
cp.read(config_path)

host = cp.get("connection", "host")
port = cp.get("connection", "port")
username = cp.get("connection", "username")
password = cp.get("connection", "password")

begin = time.time()
print "host:%s\r\nport:%s\r\nusername:%s\r\npassword:%s" % (host, port, username, password)
memc = bmemcached.Client(host+":"+port, username, password)
auth_time = time.time()

print memc.get("666666666")
print memc.set("a", 8)
print memc.get("a")
#print "key:EI-R1EIC-Engine-0-CSI.XService1.1-COUNT-sentToQueueCount";
#print memc.set("aa", 44, 0)
#print memc.get("aa")
#print memc.get("EI-R1EIC-Engine-0-CSI.XService1.1-COUNT-sentToQueueCount")
#print memc.delete("EI-R1EIC-Engine-0-CSI.XService1.1-COUNT-sentToQueueCount")
#print memc.delete("EI-R1EIC-Engine-0-CSI.XService1.1-Stat-receivedFromQueueCount")
#print memc.delete("EI-R1EIC-Engine-0-CSI.XService1.1-Stat-expiredCount")
#print memc.get("EI-R1EIC-Engine-0-CSI.XService1.1-COUNT-sentToQueueCount")
#print memc.set("EI-R1EIC-Engine-0-CSI.XService1.1-COUNT-sentToQueueCount", 1, 3600*24)
#print memc.get("EI-R1EIC-Engine-0-CSI.XService1.1-COUNT-sentToQueueCount")
#sys.exit()
#memc.set("incrKey", 5)
#incr_res = memc.incr("incrKey", 1)
#print memc.get("incrKey")
#incr_res = memc.incr("incrKey", 1)
#print memc.get("incrKey")
#result = memc.add("incrKey", 0)
#print "add result:%s" % result
#incr_res = memc.incr("incrKey", 1)
#print memc.get("incrKey")

sys.exit(1)
for i in range(0,100):
	put_res = memc.set("test" + str(i), "5555");
	print put_res
	put_time = time.time()
	get_res = memc.get("test" + str(i))
	print get_res
	get_time = time.time()
	del_res = memc.delete("test" + str(i))
	print del_res
#print "total_time:%.3f s; auth_time:%.3f s; put_time:%.3f s; get_time:%.3f s" %(get_time - begin, auth_time - begin, put_time - auth_time, get_time - put_time)




