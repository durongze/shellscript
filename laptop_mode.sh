#!/bin/bash

function EchoRed()
{
    Msg=$1
    Msg="[${FUNCNAME[1]}:${LINENO}]$Msg"
    echo -e "\033[31m$Msg\033[0m"
}

function EchoGreen()
{
    Msg=$1
    Msg="[${FUNCNAME[1]}:${LINENO}]$Msg"
    echo -e "\033[32m$Msg\033[0m"
}

function LapTopModeRun
{
    sudo laptop_mode start 
    if [[ $? -ne 0 ]];then
        sudo apt-get install laptop-mode-tools
        sudo laptop_mode start 
    fi
    cat /proc/sys/vm/laptop_mode
}

function LapTopModeCfgItem
{
    KeyWord=$1
    CfgFile=$2
    grep -Hn "$KeyWord=" $CfgFile
    if [[ $? -eq 0 ]];then
        echo "sed -e 's#"$KeyWord"=.*#"$KeyWord"=1#g' -i $CfgFile"
        sed -e 's#'"$KeyWord"'=.*#'"$KeyWord"'=1#g' -i $CfgFile
    else
        EchoRed "$KeyWord does not exist in $CfgFile."
    fi
}

function LapTopModeCfg
{
    CfgFile=$1
    EchoGreen CfgFile:$CfgFile
    LapTopModeCfgItem "ENABLE_LAPTOP_MODE" "$CfgFile"
    LapTopModeCfgItem "ENABLE_LAPTOP_MODE_TOOLS" "$CfgFile"
    LapTopModeCfgItem "ENABLE_LAPTOP_MODE_ON_BATTERY" "$CfgFile"
    LapTopModeCfgItem "ENABLE_LAPTOP_MODE_ON_AC" "$CfgFile"
    LapTopModeCfgItem "ENABLE_LAPTOP_MODE_WHEN_LID_CLOSED" "$CfgFile"
    grep -Hn "ENABLE_LAPTOP_MODE" $CfgFile
}

LapTopModeRun
CfgFile="/etc/default/acpi-support"
#LapTopModeCfg "$CfgFile"
CfgFile="/etc/laptop-mode/laptop-mode.conf"
#LapTopModeCfg "$CfgFile"
CfgFile="cfg_file.conf"
LapTopModeCfg "$CfgFile"
