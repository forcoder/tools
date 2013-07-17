#!/usr/bin/env python
import urllib

inst_id_tuple = (1013,1014,1015,1016,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028)
for inst_id in inst_id_tuple:
    url = "http://%s/open?Action=DeleteInstance&UId=%s&BId=%s&InstanceId=%s" % (host, uid, bid, inst_id)
    resp = urllib.urlopen(url)
    print resp.read()
