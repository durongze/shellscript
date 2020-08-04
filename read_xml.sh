#!/bin/bash
TargetFile=$1
FileName=$2
Filter=$3
idx=0
echo "$TargetFile" "$FileName" "$Filter"
sed -i 's#<a href=".*">#<a href="1">#g' $FileName
grep -n "${Filter}" ${FileName} | awk -F'=' '{print $1 ":" $3}' | while read V
do 
    idx=$(expr $idx + 1)
    echo "V : $V"
    line=$(echo $"$V" | awk -F'>' '{print $1}' | cut -f1 -d':')
    key=$(echo $"$V" | awk -F'>' '{print $1}' | cut -f3 -d':')
    val=$(echo $"$V" | awk -F'>' '{print $2}' | cut -f1 -d'<')
    if [ "$key" != "" ] && [ "$val" != "" ];then
        echo "idx:$idx, line:$line, key:$key, val:\"$val\""
        targetIdx=0
        cat $TargetFile | while read target
        do
            targetIdx=$(expr $targetIdx + 1)
            if [ "$targetIdx" == "$idx" ];then
                targetVal=$(echo ${target} | awk -F':' '{print $2}') 
                echo "sed -i '${line}s#${key}#${targetVal}#g' $FileName"
                sed -e "${line}s#${key}#${targetVal}#g" -i $FileName
                break
            fi
        done
    fi
done
