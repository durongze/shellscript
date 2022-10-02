#!/bin/bash

CUR_USER_HOME_DIR=${HOME}
CLASH_CFG_DIR=$(pwd)/yaml_cfg_dir
CLASH_CFG_FILE=${CUR_USER_HOME_DIR}/.config/clash/config.yaml

CLASH_CFG_URLS=""
CLASH_CFG_URLS="${CLASH_CFG_URLS} "

function InstallClash()
{
    wget https://objects.githubusercontent.com/github-production-release-asset-2e65be/136815833/a192875d-d981-471d-a501-9464648c44f1?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220923%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220923T012946Z&X-Amz-Expires=300&X-Amz-Signature=88a565813e771876fa2fb7ba4062b14093472b50aee249064c56eb8e9a642063&X-Amz-SignedHeaders=host&actor_id=4144559&key_id=0&repo_id=136815833&response-content-disposition=attachment%3B%20filename%3Dclash-linux-386-v1.11.8.gz&response-content-type=application%2Foctet-stream
    tar xf clash-linux-386-v1.11.8.gz
    
}

function DownloadClashYaml()
{
    yamlUrls="$1"
    yamlDir="$2"

    if [ ! -d $yamlDir ];then
    	mkdir $yamlDir
    fi

    pushd $yamlDir
	    curYaml=0
	    for url in ${yamlUrls}
        do
            curYaml=$(expr $curYaml + 1)
            yamlFile="${curYaml}.yaml"
            if [ -f $yamlFile ];then
                echo "File: $yamlFile exist."
                continue;
            else
	            wget -U Mozilla/6.0 -O $yamlFile $url
            fi
        done
    popd
}

function UpdateClashYaml()
{
    yamlDir="$1"
	
	for yamlFile in $(ls $yamlDir)
    do
		echo "mv $yamlDir/$yamlFile $CLASH_CFG_FILE "
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
                #echo "${yamlFile#*.}"
	    	fi
	    done
    popd
}

DownloadClashYaml "$CLASH_CFG_URLS" "$CLASH_CFG_DIR" 
UpdateClashYaml "$CLASH_CFG_DIR"
GetYamlIndex "$CLASH_CFG_DIR"
