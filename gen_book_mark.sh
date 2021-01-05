#!/bin/bash
TargetFile=$1
FileName=$2

echo "$TargetFile" "$FileName" 
dos2unix "$TargetFile" "$FileName" 

function PretreatXmlFile()
{
    local FileName=$1
    sed -i 's#<a href=".*">#<a href="1">#g' $FileName
}

function PretreatTxtFile()
{
    local FileName=$1
    sed -i 's/\./:/g' $FileName
    sed -i 's/\…/:/g' $FileName
    sed -i 's/\…/:/g' $FileName
    sed -i 's/\…/:/g' $FileName
    sed -i 's/::/:/g' $FileName
    sed -i 's/::/:/g' $FileName
    sed -i 's/::/:/g' $FileName
    sed -i 's/::/:/g' $FileName
    sed -i 's/::/:/g' $FileName
    sed -i 's/::/:/g' $FileName
    sed -i 's/::/:/g' $FileName
}

function ModifyChapterByTargetFile()
{
    local TargetFile=$1
    local FileName=$2
    local idx=$3
    local line=$4
    local val=$5
    local key=$6
    local TargetIdx=0
    local TargetVal=""
    
    if [ "$val" == "" ];then
        return
    fi
    #cat $TargetFile | grep "$val" | while read target  # error : ChapterCnt increase fail
    while read target
    do
        targetIdx=$(expr $targetIdx + 1)
        if [ "$val" == "$target" ];then
            SectionCnt=0
            ChapterCnt=$(expr $ChapterCnt + 1)
            echo -e "\033[31m$line:Chapter:$ChapterCnt Section:$SectionCnt :$val | $target \033[0m"
        else
            SectionCnt=$(expr $SectionCnt + 1)
            echo -e "\033[32m$line:Chapter:$ChapterCnt Section:$SectionCnt :$val | $target \033[0m"
            #targetVal=$(echo ${target} | awk -F':' '{print $2}') 
            #echo "sed -i ${line}s#${key}#${targetVal}#g $FileName"
            #sed -e "${line}s#${key}#\"${targetVal}\"#g" -i $FileName
            #break
        fi
    done <<< $(cat $TargetFile | grep "$val")
}

function GenLesson()
{
    local FileName=$1
    local val=$2
    local key=$3
    echo "$line:Chapter:$ChapterCnt Section:$SectionCnt :$val | $key"
}

TargetCnt=0
function ProcLine()
{
    local idx=$1
    local line=$2
    local V=$3

    key=${V##*:}
    val=${V%%:*}
    #if [ "$key" == "" ] && [ "$val" == "" ];then
    if [ "$key" == "$val" ];then
        str=$(echo $V | grep "[0-9]")
        TargetCnt=$(expr $TargetCnt + 1)
        if [ "$str" != "" ];then
            echo "idx:$idx V : $V  TargetCnt : $TargetCnt"
        else
            ModifyChapterByTargetFile "$TargetFile" "$FileName" "$idx" "$line" "$val"
        fi
    elif [ "$key" != "" ] && [ "$val" != "" ];then
        #echo "idx:$idx, line:$line, key:$key, val:\"$val\""
        GenLesson "$FileName" "$val" "$key"
    elif [ "$key" == "" ] && [ "$val" != "" ];then
        echo "idx:$idx, line:$line, key:$key, val:\"$val\""
    else
        targetIdx=0
    fi
}

function ProcFile()
{
    local FileName=$1
    local idx=0
    cat ${FileName} | while read V
    do 
        idx=$(expr $idx + 1)
        ProcLine "$idx" "$idx" "$V"
    done
}

ChapterCnt=0
SectionCnt=0
PretreatTxtFile "$FileName"
ProcFile "$FileName"
