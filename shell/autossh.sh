#!/usr/bin/expect -f

set PASSWORD "password\r"
set IP "IP"

spawn /usr/bin/ssh qiaozhou@$IP
expect "*password:"
send "$PASSWORD"
expect "*~]$ "
send "sudo su admin\r"
expect "*Password:"
send "$PASSWORD"
expect "*]$ "
interact
