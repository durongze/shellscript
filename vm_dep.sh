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
    PkgDirName=$1
    DstDirPrefix=$2
    AllPkgDir=$(GetSubDirList "${PkgDirName}")
    if [ "$AllPkgDir" == "" ];then
        UnzipAllPkg "$PkgDirName"
        AllPkgDir=$(GetSubDirList "${PkgDirName}")
    fi
    for dir in $AllPkgDir
    do
        if [[ $dir == *SDL* ]];then
            AutoInstallStr="AutoInstall \"$dir\" \"$DstDirPrefix\" \"  -DSDL_TESTS=ON -DSDL_X11_XRANDR=OFF -DSDL_OPENGL=OFF -DSDL_OPENGLES=OFF \" "
            echo "$AutoInstallStr"
            eval $AutoInstallStr
        else
            echo "Skip $dir..........................."
            continue
        fi
    done
}

Urls="https://github.com/qiniu/iconv/archive/refs/tags/v1.2.0.zip"
#GitHubDownloadDep "$Urls"

#https://github.com/LuaDist/libiconv
Urls="https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz"
#FtpGnuDownloadDep "$Urls"

#GenEnvVar "${ProjTopDir}/out/linux" "$(ls *.tar.gz *.zip)"

CompilePkgByDir "./" "$(pwd)/../linux/"
