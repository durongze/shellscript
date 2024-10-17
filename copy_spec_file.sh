#!/bin/bash

function CopySpecFile()
{
	local SpecFile=$1
	local SpecDir=$2
	
    if [[ "$SpecFile" == "" ]] || [[ "$SpecDir" == "" ]];then
		return 0
	fi
    SpecFileFilter=${SpecFile##*/}

	echo "$SpecFileFilter"
	TargetFiles=$(find "$SpecDir" -iname "$SpecFileFilter")
    FileNum=$(echo  $TargetFiles | wc -w)
    if [[ "$FileNum" != "1" ]];then
	    echo "File($FileNum):$TargetFiles"
    else
		echo "cp $SpecFile $TargetFiles"
    fi
	return 1
}

function CopyAllSpecFile()
{
	local SpecDir="$1"

	local idx=0
    for CurFile in $(ls ${SpecDir}/*.c)
	do
        idx=$(expr $idx + 1)
		echo "File[$idx]=$CurFile"
		CopySpecFile "$CurFile" "$SpecDir"
	done
}

function CreateAllSpecFile()
{
	local SpecDir="$1"
    local DestFiles="/home/lighthouse/code/lua/libavfilter/allfilters.c 
    /home/lighthouse/code/lua/libavdevice/alldevices.c 
    /home/lighthouse/code/lua/libavdevice/alldevices.c 
    /home/lighthouse/code/lua/libavformat/allformats.c 
    /home/lighthouse/code/lua/libavformat/allformats.c 
    /home/lighthouse/code/lua/libavcodec/allcodecs.c
    /home/lighthouse/code/lua/libavcodec/allcodecs.c
    /home/lighthouse/code/lua/libavcodec/parsers.c
    /home/lighthouse/code/lua/libavcodec/bitstream_filter.c
    /home/lighthouse/code/lua/libavcodec/hwaccels.h 
    /home/lighthouse/code/lua/libavformat/protocols.c"

    ls ${SpecDir}/*.c
    local SpecFileList=$(ls ${SpecDir}/*.c)
	for dstFile in $DestFiles
    do
        dstFileName=${dstFile##*/}
        dstFileDir=${dstFile%/*}
	    local idx=0
        for srcFile in $SpecFileList
	    do
            idx=$(expr $idx + 1)
            srcFileName=${srcFile##*/}
            if [[ "$dstFileName" == "$srcFileName" ]];then
                echo "dstFileName:$dstFileName"
                echo "dstFileDir :$dstFileDir"
                echo "srcFileName:$srcFileName"
                mkdir -p $dstFileDir
                cp $srcFile $dstFile
            fi
		done
    done
}

#CopyAllSpecFile "ffdir"
CreateAllSpecFile "ffdir"
