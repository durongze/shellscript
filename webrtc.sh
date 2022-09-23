#!/bin/bash

#https://webrtc.org.cn/mirror/

export WORKSPACE=$(pwd)
export ProxyIp="127.0.0.1"
export ProxyPort="7890"
export ProxyIp=localhost
export ProxyPort=7890

function SetProxyFile()
{
    #/etc/boto.cfg
    #vi ${WORKSPACE}/depot_tools/external_bin/gsutil/gsutil_4.68/gsutil/gslib/vendored/boto/boto/pyami/config.py +69
    BotorcFile="${HOME}/.botorc" 
    is_exist=$(grep "Boto" ${BotorcFile})
    if [ "$is_exist" != "" ];then
        echo "[Boto]"                 > $BotorcFile
        # echo "proxy=\"${ProxyIp}\""        >> $BotorcFile
        # echo "proxy_port=\"${ProxyPort}\"" >> $BotorcFile
        echo "proxy=${ProxyIp}"        >> $BotorcFile
        echo "proxy_port=${ProxyPort}" >> $BotorcFile
    fi
    export NO_AUTH_BOTO_CONFIG=$BotorcFile
}

function DownloadDepotTool()
{
	cd $WORKSPACE
	#git clone https://webrtc.bj2.agoralab.co/webrtc-mirror/depot_tools.git
    pushd depot_tools
    #git pull --rebase
    popd
	chmod +x $WORKSPACE/depot_tools/cipd
}

function SetDepotToolCfg()
{
    # linux android
	TargetOS=$1
	mkdir -p $WORKSPACE/webrtc && cd $WORKSPACE/webrtc
    gClientCfgFile=".gclient"
     
	echo "solutions = ["                   >>$gClientCfgFile
	echo " { \"name\"        : \"src\", "  >>$gClientCfgFile
	echo "   \"url\"         : \"https://webrtc.bj2.agoralab.co/webrtc-mirror/src.git@65e8d9facab05de13634d777702b2c93288f8849\","  >>$gClientCfgFile
	echo "   \"deps_file\"   : \"DEPS\","  >>$gClientCfgFile
	echo "   \"managed\"     : False,"     >>$gClientCfgFile
	echo "   \"safesync_url\": \"\","      >>$gClientCfgFile
	echo "   \"custom_deps\" : {"          >>$gClientCfgFile   
	echo "   },"                           >>$gClientCfgFile
	echo " },"                             >>$gClientCfgFile
	echo "]"                               >>$gClientCfgFile
	echo "target_os = [\"$TargetOS\"]"         >>$gClientCfgFile 
}	
	
function DownloadWebRtcCode()
{
	#出现提示是否使用谷歌的depot_tools，推荐“n”，或者等1分钟提示框超时。
	#因为gclient sync获取源码之后，会向谷歌获取其它数据，如果因此报错，不想看到这个错误的话，可以设置代理之后再次sync
	export http_proxy=${ProxyIp}:${ProxyPort} #1080
	export https_proxy=${ProxyIp}:${ProxyPort} #1080
	export PATH=$PATH:$WORKSPACE/depot_tools
	cd $WORKSPACE/webrtc
    SetProxyFile
	echo http_proxy=${https_proxy} #1080
	echo https_proxy=${https_proxy} #1080
    
	date; gclient sync; date
}

function CompileWebRtcOnLinux()
{
	#sudo apt-get update
	#sudo apt-get install -y g++

	cd $WORKSPACE/webrtc/src
	#./build/install-build-deps.sh
	export PATH=$PATH:$WORKSPACE/depot_tools
	
    gn gen out/Release "--args=is_debug=false"
	ninja -C out/Release
}


function CompileWebRtcOnAndroid()
{
	# 安装依赖
	#sudo apt-get install -y software-properties-common
	#sudo add-apt-repository -y ppa:openjdk-r/ppa
	
	cd $WORKSPACE/webrtc
	./build/install-build-deps-android.sh
	
    gclient sync --patch-ref=https://chromium.googlesource.com/chromium/src/build.git@gitlab
	
	# 编译
	# cd $WORKSPACE/webrtc/src 这里是不是应该注释掉
	
	gn gen android/Release "--args=is_debug=false target_os=\"android\" target_cpu=\"arm64\""
	ninja -C android/Release
}

function CompileWebRtcOnWindows()
{
	#1.安装依赖
    #> 1.1 git - https://git-scm.com/download/win

    #2. visualstudio2017community - https://download.visualstudio.microsoft.com/download/pr/aaebc214-bc67-4137-9bea-04fcb0c90720/2e18f27594472d0c7515d9cbe237bd56/vs_community.exe
    #> 2.1 Modify "Windows Software Development Kit" > +Debugging Tools for Windows

    #3. Python2 - https://www.python.org/downloads/release/python-2716/
    #> 3.1 pip install pywin32

    #设置
    #1. 执行git.sh

    #安装depot_tools
    #cd %USERPROFILE%
    rd /s /q depot_tools webrtc & git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git -b gitlab

    #配置
    set PATH=%PATH%;%USERPROFILE%\depot_tools

    cd %USERPROFILE% && ^
    rd /s /q webrtc & mkdir webrtc

    cd %USERPROFILE%\webrtc && ^
    gclient config --name src https://chromium.googlesource.com/external/webrtc.git@gitlab

    #同步
    set DEPOT_TOOLS_WIN_TOOLCHAIN=0

    cd %USERPROFILE%\webrtc && ^
    gclient sync --patch-ref=https://chromium.googlesource.com/chromium/src/build.git@gitlab

    #生成
    cd %USERPROFILE%\webrtc\src && ^
    gn gen out/Release "--args=is_debug=false"

    #编译
    cd %USERPROFILE%\webrtc\src && ^
    ninja -C out/Release
}

#SetProxyFile
#DownloadDepotTool
#SetDepotToolCfg
DownloadWebRtcCode
CompileWebRtcOnLinux
