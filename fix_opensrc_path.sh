#!/bin/bash

function FixOpenSrcPath
{
    PrefixHomeDir=$1
    TargetHomeDir=$2
    for libDir in $(ls ${PrefixHomeDir})
    do
        libVer=""
        if [ -d $libDir/lib ];then
            libVer=$(ls ${libDir})
            echo "$libDir -> $libVer"
            echo ln -sf ${PrefixHomeDir}/${libDir}/${libVer} ${TargetHomeDir}/${libDir}
        else
            echo "$libDir -> ****************"
            echo ln -sf ${PrefixHomeDir}/${libDir}/${libVer} ${TargetHomeDir}/${libDir}
        fi
    done
}

