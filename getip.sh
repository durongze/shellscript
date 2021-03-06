#!/bin/bash
TTY_NAME=$(tty | cut -f3-4 -d'/')

ClientIp=$(who | grep "${TTY_NAME}" |grep -E "[0-9]{1,3}(\.[0-9]{1,3}){3}" | cut -f2 -d'(' | cut -f1 -d')')
ServerIpList=$(ifconfig | grep "inet " | awk '{print $2}')

ServerIpList=$(ip addr | grep "inet " | awk -F' ' '{print $2}' | awk -F'/' '{print $1}')

function GetServerIp()
{
    local cip="$1"
    local sip="$2"
    local realIp=""
    local max=0

    for curIp in $sip
    do
        local cnt=0
        for idx in $(echo $curIp | tr -s "." " " | wc | awk '{print $2}' | xargs seq)
        do
            curSubNet=$(echo $curIp | awk -F'.' '{print $'"$idx"'}')
            cSubNet=$(echo $cip | awk -F'.' '{print $'"$idx"'}')
            if [[ "$curSubNet" = "$cSubNet" ]];then
                cnt=$(expr $cnt + 1)
            fi
        done

        if [[ $cnt -gt $max ]];then
            max=$cnt
            realIp=$curIp
        fi
    done
    echo "$realIp"
}

echo "ClientIp:($ClientIp)"
echo "ServerIpList:($ServerIpList)"

ServerIp=$(GetServerIp "$ClientIp" "$ServerIpList")
echo "ServerIp:$ServerIp"

GateWay=$(ip route | grep "default" | awk -F' ' '{print $3}')
echo "GateWay:$GateWay"
