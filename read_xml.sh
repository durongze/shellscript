#!/bin/bash
FileName=$1
Filter=$2
idx=0
echo "$FileName" "$Filter"
grep -n "${Filter}" ${FileName} | awk -F'=' '{print $1 ":" $3}' | while read V
do 
    idx=$(expr $idx + 1)
    echo "V : $V"
    line=$(echo $"$V" | awk -F'>' '{print $1}' | cut -f1 -d':')
    key=$(echo $"$V" | awk -F'>' '{print $1}' | cut -f3 -d':')
    val=$(echo $"$V" | awk -F'>' '{print $2}' | cut -f1 -d'<')
    if [ "$key" != "" ] && [ "$val" != "" ];then
        echo "idx:$idx, line:$line, key:$key, val:\"$val\""
    fi
done
