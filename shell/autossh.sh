#!/usr/bin/expect -f

set timeout 15
set ip [lindex $argv 0] 
set PASSWORD "*******"

spawn /usr/bin/ssh qiaozhou@$ip
expect {
    timeout { send_user "Timeout."; exit 1 }
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$PASSWORD\r"; exp_continue }
    "*~]$ " { send "sudo su admin\r"; exp_continue }
    "*Password:" { send "$PASSWORD\r"; exp_continue }
    "*]$ " { }
}

interact
