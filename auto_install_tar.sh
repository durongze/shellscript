#!/bin/bash

function AutoInstall()
{
    SrcDir=$1
    DstDir=$2
    pushd $FileDir
        if [ -f configure ];then
            ./configure --prefix=$DstDir/$SrcDir  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        elif [ -f CMakeLists.txt ];then
            mkdir build  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            pushd build
            export CXXFLAGS="-fPIC" && cmake  -DCMAKE_INSTALL_PREFIX=$DstDir/$SrcDir ..
            make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            make install  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            popd
        else
            echo -e "\033[31m Install $SrcDir Fail !!! \033[0m"
            exit 1
        fi
    popd
}

function TarXFFile()
{
    SrcDir=$1
    DstDir=$2
    pushd $SrcDir
        SrcFileList=$(ls *.tar.gz)
        for file in $SrcFileList
        do
            FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
            echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
            tar xf $file
            AutoInstall $FileDir $DstDir
        done
    popd
}
