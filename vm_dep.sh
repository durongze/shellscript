#!/bin/bash
# vim :ff=unix
. auto_func.sh

ProjTopDir=$(pwd)/..

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

function CompilePkgByDir()
{
    PkgDirName=$1
    DstDirPrefix=$2
    for dir in $(ls -d ${PkgDirName}/*/)
    do
        if [[ $dir == *pthread-win32* ]];then
            echo "Skip $dir..........................."
            continue
        fi
        AutoInstall "$dir" "$DstDirPrefix" ""
    done
}

Urls="https://github.com/qiniu/iconv/archive/refs/tags/v1.2.0.zip"
#GitHubDownloadDep "$Urls"

#https://github.com/LuaDist/libiconv
Urls="https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz"
#FtpGnuDownloadDep "$Urls"

#GenEnvVar "${ProjTopDir}/out/linux" "$(ls *.tar.gz *.zip)"

CompilePkgByDir "./" "$(pwd)/../linux/"