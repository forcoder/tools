#!/bin/sh
# parse config file and export config item
# @author qiaozhou qiaozhou@aliyun-inc.com
# @version 0.1

if [ "$#" -lt "1" ];then
    echo "Usage:source $0 config_file"
    exit 0
fi

#set the seperator to "linefeed(\n)"
IFS='
'

config_path=$1

get_prop(){
    key=$2
    grep  "^\s*${2}\s*=" ${config_path}| sed "s%\s*${2}\s*=\s*\(.*\)%\1%"
}

for line in $(grep -v "^#\|^$" $config_path)
do
    key=$(echo $line | awk -F "=" '{print $1}'|tr -d ' ')
    full_key=CONFIG_$key
    value=$(get_prop $config_path $key)
    export $full_key=$value
done

