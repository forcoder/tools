#!/bin/sh
# parse config file and export config item
# @author qiaozhou qiaozhou@aliyun-inc.com
# @version 0.1

if [ "$#" -lt "1" ];then
    echo "Usage:source $0 config_file(配置文件路径) var_prefix(变量前缀)"
    exit 0
fi

#set the seperator to "linefeed(\n)"

config_path=$1
prefix=$2

get_prop(){
    key=$2
    grep  "^\s*${2}\s*=" ${config_path}| sed "s%\s*${2}\s*=\s*\(.*\)%\1%"
}

while read line
do
    filter_line=$(echo $line|tr -d '' |grep -v '^\s*#\|^$')
    
    if [ "$filter_line" = "" ];then
        continue
    fi

    key=$(echo $line | awk -F "=" '{print $1}'|tr -d ' ')
    full_key=$prefix$key
    value=$(get_prop $config_path $key)
    export $full_key=$value
done < $config_path

