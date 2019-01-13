#!/bin/bash
if [ $# -ne 2 ];then
    echo "$0 exefile(../build/demo) libdir(../lib)"
    exit 1
fi

EXEC_FILE=$1
DEP_LIB_DIR=$2
RES_DIR=~/res
BUILD_DIR=../build
CAFFE_LIB_DIR=/opt/caffe
CMAKE_LIST_FILE=../CMakeLists.txt

function CheckGpuOrCpu()
{
    local CaffeDir=$1
    local LibIsCpu=0
    local CMakeListFile=$2
    local CfgIsCpu=0    

    if [ 2 -ne $# ];then
        return 2
    fi  
    
    ls -l "$CaffeDir" | grep "cpu"    
    LibIsCpu=$?
    cat "$CMakeListFile" | grep "DCPU_ONLY"
    CfgIsCpu=$?
    if [ "$LibIsCpu" -eq "$CfgIsCpu" ];then
        return 0
    else
        echo -e "\033[31m $LibIsCpu : $CfgIsCpu\033[0m"
        return 1
    fi  
}

function ResetBuildDir()
{
    local BuildDir=$1
    local ResDir=$2

    if [ 2 -ne $# ];then
        return 1
    fi

    pushd ${BuildDir}
    rm -rf CMakeCache.txt  CMakeFiles  cmake_install.cmake  demo  detect_img.jpg  libfacesdk_api.so  Makefile  pack_data
    ln -sf ${ResDir}/pic .
    ln -sf ${ResDir}/cfg .
    ln -sf ${ResDir}/models .
    popd

    return 0
}

function BuildProject()
{
    local ProjHome=$1

    if [ 1 -ne $# ];then
        return 1
    fi

    pushd $ProjHome
    cmake ../
    make
    popd

    return 0
}

function GetTwoLevelDepFile()
{
    local TargetFile=$1

    if [ 1 -ne $# ];then
        return
    fi

    local SrcFile=$(ldd demo | cut -f2 -d '>' | cut -f1 -d '(' | xargs ldd | cut -f2 -d '>' | cut -f1 -d '(' | cut -f1 -d ':'| sed '
s/^[ \t]*//g' | sed 's/[ \t]*$//g' | sort | uniq)

    echo $SrcFile
}

function GetDepFile()
{
    local TargetFile=$1

    if [ 1 -ne $# ];then
        return
    fi

    local SrcFile=$(ldd $TargetFile | cut -f2 -d '>' | cut -f1 -d '(')

    echo $SrcFile
}

function CopyDepFileToSpecDir()
{
    local SrcFile=$1
    local DstDir=$2

    if [ 2 -ne $# ];then
        return 1
    fi

    for tmpFile in $SrcFile
    do
        cp $tmpFile $DstDir
    done
    
    return 0
}

function CreatLinkDepFile()
{
    local LibDir=$1

    if [ 1 -ne $# ];then
        return 1
    fi

    pushd $LibDir
    #libboost_filesystem.so.1.64.0
    #libboost_system.so.1.64.0
    #libboost_thread.so.1.64.0
    #libcaffe.so.1.0.0
    #libcublas.so.8.0
    #libcudart.so.8.0
    #libcurand.so.8.0
    ln -sf libgfortran.so.3 libgfortran.so
    ln -sf libglog.so.0 libglog.so
    ln -sf libhdf5_hl.so.0 libhdf5_hl.so
    ln -sf libhdf5.so.5 libhdf5.so
    ln -sf libleveldb.so.1 libleveldb.so
    ln -sf libopenblas.so.0 libopenblas.so
    ln -sf libopencv_core.so.3.3 libopencv_core.so
    ln -sf libopencv_highgui.so.3.3 libopencv_highgui.so
    ln -sf libopencv_imgcodecs.so.3.3 libopencv_imgcodecs.so
    ln -sf libopencv_imgproc.so.3.3 libopencv_imgproc.so
    ln -sf libopencv_ml.so.3.3 libopencv_ml.so
    ln -sf libopencv_objdetect.so.3.3 libopencv_objdetect.so
    ln -sf libopencv_videoio.so.3.3 libopencv_videoio.so
    ln -sf libprotobuf.so.9 libprotobuf.so
    ln -sf libsnappy.so.1 libsnappy.so
    popd
    return 0
}

CheckGpuOrCpu "$CAFFE_LIB_DIR" "$CMAKE_LIST_FILE"
if [ 0 -ne $? ];then
    echo "$CAFFE_LIB_DIR or $CMAKE_LIST_FILE error."
    exit 1
fi

ResetBuildDir "$BUILD_DIR" "$RES_DIR"
if [ 0 -ne $? ];then
    echo "$BUILD_DIR or $RES_DIR error."
    exit 1
fi
BuildProject "$BUILD_DIR"
if [ 0 -ne $? ];then
    echo "$BUILD_DIR error."
    exit 1
fi

mkdir "$DEP_LIB_DIR" -p
DepFiles=$(GetDepFile "$EXEC_FILE")
CopyDepFileToSpecDir "$DepFiles" "$DEP_LIB_DIR"
cp ../build/libfacesdk_api.so "$DEP_LIB_DIR"

CreatLinkDepFile "$DEP_LIB_DIR"
