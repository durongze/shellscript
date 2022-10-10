#!/bin/bash

EmsdkHomeDir=$(pwd)/emsdk

function InstallEmsdk()
{
    EmsdkDir=$1
    git clone https://github.com/emscripten-core/emsdk.git
    pushd ${EmsdkDir}
    	# 下载并安装最新的 SDK 工具.
    	./emsdk install latest
    	
    	# 为当前用户激活最新的 SDK. (写入 .emscripten 配置文件)
    	./emsdk activate latest
    	
    	# 激活当前 PATH 环境变量
      source ./emsdk_env.sh
    popd
}

function GenCode()
{
	 File=$1
	 echo "#include <stdio.h>"              >$File
   echo "int main() {"                   >>$File
   echo "    printf(\"Hello world!\");"  >>$File
   echo "    return 0;"                  >>$File
   echo "}"                              >>$File
}

function ActivateEmsdk()
{
    EmsdkDir=$1
    SrcDir="hello"
    SrcFile="hello.c"
    if [ ! -d $SrcDir ];then
        mkdir $SrcDir
    fi
    pushd $SrcDir
    	source ${EmsdkDir}/emsdk_env.sh
    	GenCode "$SrcFile"
			emcc $SrcFile -s EXIT_RUNTIME=1
    	node a.out.js
    popd
}

#InstallEmsdk "${EmsdkHomeDir}"
ActivateEmsdk "${EmsdkHomeDir}"
