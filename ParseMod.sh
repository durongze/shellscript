#!/bin/bash

ModCfgFile="env.txt"
ModWord="Mod"
ModLineNum=4

TagFile="tag.txt"
TagWord="LOG_TAG"
TagPos=3

function ParseModInfo()
{
    local ModCfgFile=$1
    local ModWord=$2
    local ModLineNum=$3
    while read line;do
        case $line in
            *00*)
                let num=num+1
                echo "num:$num ID:$line"
            ;; 
            *name*)
                echo "         Name:$line"
            ;; 
        esac 
    done < <(grep -C $ModLineNum "$ModWord" $ModCfgFile)
}

function ParseLogTag()
{
    local TagFile=$1
    local TagWord=$2
    local TagPos=$3
    TagList=$(grep "$TagWord" $TagFile | cut -d' ' -f$TagPos)
    for TagVal in $TagList
    do
        echo $TagVal
    done
}

ParseModInfo "$ModCfgFile" "$ModWord" "$ModLineNum"
ParseLogTag "$TagFile" "$TagWord" "$TagPos"

