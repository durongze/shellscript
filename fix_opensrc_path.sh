#!/bin/bash

function FixOpenSrcPath
{
    PrefixHomeDir=$1
    TargetHomeDir=$2
    if [ ! -d $TargetHomeDir ];then
        mkdir -p $TargetHomeDir
    fi
    for libDir in $(ls ${PrefixHomeDir})
    do
        libVerAll=""
        if [ ! -d $libDir/lib ];then
            libVerAll=$(ls ${libDir})
            echo "$libDir -> $libVerAll"
            for libVer in $libVerAll
            do
                echo ln -sf ${PrefixHomeDir}/${libDir}/${libVer} ${TargetHomeDir}/${libDir}
                break
            done
        else
            echo "$libDir -> ****************"
            echo ln -sf ${PrefixHomeDir}/${libDir}/${libVer} ${TargetHomeDir}/${libDir}
        fi
    done
}

