#!/bin/bash
ProjTopDir=$(pwd)/../
ThirdPartyBinDir=${ProjTopDir}/out/linux
ThirdPartySrcDir=${ProjTopDir}/thirdparty

# vim :ff=unix
. auto_func.sh
# sudo apt-get install build-essential mercurial make cmake autoconf automake libtool libasound2-dev libpulse-dev libaudio-dev libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxxf86vm-dev libxss-dev libgl1-mesa-dev  libdbus-1-dev libudev-dev  libgles2-mesa-dev libegl1-mesa-dev libibus-1.0-dev fcitx-libs-dev libsamplerate0-dev libsndio-dev


function GitHubDownloadDep()
{
    urls=$1
    for url in $urls
    do
        extName=${url##*.}
        verName=${url##*/}
        verName=${verName%.*}
        fileName=${url#*/}
        fileName=${fileName#*/}
        fileName=${fileName#*/}
        fileName=${fileName#*/}
        fileName=${fileName%%/*}
        dirName="${fileName}-${verName}"
        pkgName="${fileName}-${verName}.${extName}"
        echo "wget $url -O ${pkgName}"
        if [ -f $pkgName ];then
            echo " skip $pkgName "
        else
            wget $url -O $pkgName
        fi
        if [ -d $dirName ];then
            echo " skip $dirName "
        else
            unzip $pkgName
        fi
    done
}

function FtpGnuDownloadDep()
{
    urls=$1
    for url in $urls
    do
        pkgName="${url##*/}"
        dirName="${pkgName%%.*}"
        if [ -f $pkgName ];then
            echo " skip $pkgName "
        else
            wget $url 
        fi
        if [ -d $dirName ];then
            echo " skip $dirName "
        else
            tar xf $pkgName
        fi
    done
}

function UnzipAllPkg()
{
    PkgDirName=$1
    AllPkgFile=$(ls -l | grep "^-")
    for pkg in $AllPkgFile
    do
        case $pkg in
            *.zip)
                unzip $pkg 
                ;;
            *.tar.*)
                tar xf $pkg
                ;;
            *)
                ;;
        esac;
    done
}

function GetSubDirList()
{
    PkgDirName=$1
    AllPkgDir=$(ls -l $PkgDirName | grep "^d" | awk -F' ' '{print $NF}')
    echo "${AllPkgDir}"
}

function CompilePkgByDir()
{
    DstDirPrefix=$1
    PkgDirName=$2
    AllPkgDir=$(GetSubDirList "${PkgDirName}")
    if [ "$AllPkgDir" == "" ];then
        UnzipAllPkg "$PkgDirName"
        AllPkgDir=$(GetSubDirList "${PkgDirName}")
    else
        echo "AllPkgDir:$AllPkgDir"
    fi
    for dir in $AllPkgDir
    do
        echo "cur dir:$dir"
        case $dir in
            *thread*)
            ;;
            *conv*)
            ;;
            *cairo*)
                AutoInstall "$dir" "$DstDirPrefix" 
            ;;
            *libusb*)
                #AutoInstall "$dir" "$DstDirPrefix" "  "
                #SpecInstall "$dir" "$DstDirPrefix" "" "CfgInstall"
                SpecInstall "$dir" "$DstDirPrefix" "" "Cfg"
            ;;
            *)
                #AutoInstall "$dir" "$DstDirPrefix" "  "
            ;;
        esac
    done
}

function InstallCompileTools()
{
   sudo apt update
   sudo apt list --upgradable
   sudo apt upgrade
   sudo apt update
   sudo apt install net-tools
   sudo apt install g++
   sudo apt install cmake
   sudo apt install dos2unix
   sudo apt install autoconf
   sudo apt install libtool
   sudo apt install pkg-config
   sudo apt install gperf
}

#GenEnvVarByFile "${ThirdPartyBinDir}" "$(ls *.tar.gz *.zip)"
GenEnvVarByDir   "${ThirdPartyBinDir}" "$(ls -d */)"
GenEnvVarByDir   "${ThirdPartyBinDir}" "${ThirdPartySrcDir}"
. bashrc

echo "PKG_CONFIG_PATH:$PKG_CONFIG_PATH"
#sudo apt install gtk-doc-tools

Urls="https://github.com/qiniu/iconv/archive/refs/tags/v1.2.0.zip"
#GitHubDownloadDep "$Urls"

#https://github.com/LuaDist/libiconv
Urls="https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz"
#FtpGnuDownloadDep "$Urls"

InstallCompileTools

CompilePkgByDir  "${ThirdPartyBinDir}" "./" 
