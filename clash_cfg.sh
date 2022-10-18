#!/bin/bash

CUR_USER_HOME_DIR=${HOME}
CLASH_CFG_DIR=$(pwd)/yaml_cfg_dir
CLASH_CFG_FILE=${CUR_USER_HOME_DIR}/.config/clash/config.yaml

CLASH_CFG_URL_PREFIX="https://to.runba.cyou/link/"
CLASH_CFG_URL_SUBFIX="?clash=1"

function InstallClash()
{
    clash_url="$1"
    clashFile="clash-linux-386-v1.11.8.gz"
    if [ -f $clashFile ];then
        echo "File: $clashFile exist."
        continue;
    else
        wget -U Mozilla/6.0 -O $clashFile $clash_url  --no-check-certificate
    fi    
    tar xf $clashFile
}

function DownloadClashYaml()
{
    yamlDir="$1"

    url_prefix=${CLASH_CFG_URL_PREFIX}
    url_subfix=${CLASH_CFG_URL_SUBFIX}
    declare -A sermap=(["1"]="xxxxxxx"
                       ["2"]="yyyyyyy"
                       ["3"]="zzzzzzz"
                       ["4"]="eeeeeee" )
                       #["\\"]="/")

    if [ ! -d $yamlDir ];then
    	mkdir $yamlDir
    fi

    pushd $yamlDir
    for k in ${!sermap[@]}
    do
        v=${sermap[$k]}
        cur_url="${url_prefix}${v}${url_subfix}"
        echo "cur_url: $cur_url"
        yamlFile="${k}.yaml"
        if [ -f $yamlFile ];then
            echo "File: $yamlFile exist."
            continue;
        else
            wget -U Mozilla/6.0 -O $yamlFile $cur_url  --no-check-certificate
        fi
    done
    popd
}

function UpdateClashYaml()
{
    yamlDir="$1"
	
	for yamlFile in $(ls $yamlDir)
    do
		echo "cp $yamlDir/$yamlFile $CLASH_CFG_FILE "
	done
}

function GetYamlIndex()
{
    yamlDir="$1"
    pushd $yamlDir	
	    for yamlFile in $(ls $yamlDir)
        do
	    	is_exist=$(diff $yamlFile ${CLASH_CFG_FILE})
            if [ "$is_exist" != "" ];then
                echo ""
            else
                echo "${yamlFile%.*}"
	    	fi
	    done
    popd
}

InstallClash "clash_url"
DownloadClashYaml "$CLASH_CFG_DIR" 
UpdateClashYaml "$CLASH_CFG_DIR"
GetYamlIndex "$CLASH_CFG_DIR"
