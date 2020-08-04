#!/bin/bash
FileName=$1
Filter=$2
idx=0
echo "$FileName" "$Filter"
grep "${Filter}" ${FileName} | awk -F'=' '{print $3}' | while read V
do 
    idx=$(expr $idx + 1)
    #echo "V : $V"
    key=$(echo $"$V" | awk -F'>' '{print $1}')
    val=$(echo $"$V" | awk -F'>' '{print $2}' | cut -f1 -d'<')
    if [ "$key" != "" ] && [ "$val" != "" ];then
        echo "idx : $idx, key: $key , val: \"$val\""
    fi
done
