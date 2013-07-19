#!/bin/bash

for ip in `cat list`
do

expect -c "
spawn scp /tmp/a $ip:/tmp/
        expect {
                \"*yes/no*\" {send \"yes\r\"; exp_continue}
        }
"
done
