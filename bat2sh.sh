#!/bin/bash
FileName=$1
dos2unix ${FileName}
declare -A sermap=(["set"]="export"
                   ["move"]="mv"
                   ["%cd%"]="\$(pwd)"
                   ["%proj_name%"]="\$proj_name"
                   ["%proj_dir%"]="\$proj_dir"
                   ["%all_jar%"]="\$all_jar"
                   ["%PATH%"]="\$PATH"
                   ["%CLASSPATH%"]="\$CLASSPATH"
                   ["%JAVA_HOME%"]="\$JAVA_HOME"
                   [";"]=":"
                   ["pause"]="read pause")
                   #["\\"]="/")
for k in ${!sermap[@]}
do 
    v=${sermap[$k]}
    sed -i 's/'"$k"'/'"$v"'/g'  ${FileName} 
done

sed -i 's#\\#/#g' ${FileName}

idx=0
cat ${FileName} | awk -F' ' '{print $2}' | while read V 
do
    idx=$(expr $idx + 1)
    echo "$V" | awk -F'=' '{print $1" "$2}' | while read key val
    do
        if [ "$key" != "" ] && [ "$val" != "" ];then
            echo "$idx $key \"$val\""
            #sed -i "${idx}s/=/=\"/g" ${FileName}
            #sed -i "${idx}s/\$/\"/g" ${FileName}
            
            eval sed 's/'"$val"'/'\""$val"\"'/g' ${FileName}

            #sed "s/$val/\"$val\"/g" ${FileName}
        fi
    done
done

