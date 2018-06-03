#!/bin/bash

THIRD_LIBS=thirdlib

function remove_tmp_dir()
{
    ls -F | grep "/$" | xargs rm -rf 
}

function install_protobuf()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf protobuf-2.6.1.tar.gz
    pushd protobuf-2.6.1
    ./configure --prefix=${HOME}/opt/protobuf261 && make && make install
    popd
}

function install_leveldb()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    unzip leveldb-master.zip
    pushd  leveldb-master  
    mkdir ${HOME}/opt/leveldb -p
    make
    cp out-shared ${HOME}/opt/leveldb/lib -a
    cp include ${HOME}/opt/leveldb -a
    popd
}

function install_lmdb()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf lmdb-LMDB_0.9.18.tar.gz 
    pushd lmdb-LMDB_0.9.18/libraries/liblmdb
    mkdir ${HOME}/opt/liblmdb/lib -p
    mkdir ${HOME}/opt/liblmdb/include -p  
    make
    cp *.so *.a ${HOME}/opt/liblmdb/lib/  
    cp *.h ${HOME}/opt/liblmdb/include/   
    popd
}

function install_openblas()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    unzip OpenBLAS-develop.zip
    pushd  OpenBLAS-develop
    make clean
    make DYNAMIC_ARCH=1  NO_AFFINITY=1 NO_LAPACKE=1  NO_AVX2=1 
    make PREFIX=${HOME}/opt/OpenBLAS install
    popd
}

function install_hdf5()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf hdf5-1.8.0.tar.gz 
    pushd hdf5-1.8.0
    ./configure CFLAGS=-fPIC CXXFLAGS=-fPIC --prefix=${HOME}/opt/hdf5180
    make CFLAGS=-fPIC CXXFLAGS=-fPIC && make install
    popd
}

function install_gflags()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    unzip gflags-master.zip
    mkdir gflags-master/build -p
    pushd gflags-master/build
    export CXXFLAGS="-fPIC" && cmake  -DCMAKE_INSTALL_PREFIX=${HOME}/opt/gflags ..  
    make VERBOSE=1 
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install
    popd
}

function install_glog()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    unzip glog-master.zip
    pushd glog-master
    ./autogen.sh
    ./configure --prefix=${HOME}/opt/glog/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_opencv()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    unzip opencv-3.3.0.zip
    mkdir opencv-3.3.0/build/ -p
    pushd opencv-3.3.0/build/
    cmake  -D WITH_CUDA=OFF -DCMAKE_INSTALL_PREFIX=${HOME}/opt/opencv330 ..  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_python()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf Python-2.7.14.tgz
    pushd Python-2.7.14 
    ./configure --prefix=${HOME}/opt/python2714/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install
    popd
}

function install_boost()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf boost_1_64_0.tar.gz 
    pushd boost_1_64_0
    ./bootstrap.sh
    ./b2
    ./b2 install --prefix=${HOME}/opt/boost 
    popd
}

function install_cmake()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf cmake-3.3.2.tar.gz
    pushd cmake-3.3.2
    ./configure --prefix=${HOME}/opt/cmake332  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; } 
    gmake  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; } 
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}


function install_snappy()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf snappy-1.1.3.tar.gz
    pushd snappy-1.1.3
    ./configure --prefix=${HOME}/opt/snappy113  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}
function install_zlib()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf zlib-1.2.3.tar.gz
    pushd zlib-1.2.3
    ./configure --prefix=${HOME}/opt/zlib123/  --shared || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_caffe()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf caffe-libcaffe-decode.tar.gz 
    pushd caffe-libcaffe-decode
    make clean
    make 
    mkdir ${HOME}/opt -p
    grep "CPU_ONLY" Makefile.config | grep "#" 
    if [ 0 -eq $? ];then
        cp .build_release  ${HOME}/opt/caffe_gpu -a
        cp include  ${HOME}/opt/caffe_gpu/ -a
    else
        cp .build_release  ${HOME}/opt/caffe_cpu -a
        cp include  ${HOME}/opt/caffe_cpu/ -a
    fi  
    popd
}

function install_all()
{
    install_cmake
    install_python
    install_zlib
    install_protobuf
    install_snappy
    install_leveldb
    install_lmdb
    install_openblas
    install_hdf5
    install_gflags
    install_glog
    install_opencv
    install_boost
    install_caffe
}

function check_libs()
{
    if [ ! -d "$HOME/opt" ];then
        echo "all libs is not exist"‘
        exit 2
    fi  
    all_libs="boost_system boost_thread protobuf openblas glog 
                  opencv_core opencv_imgproc opencv_highgui opencv_ml
                  opencv_imgcodecs opencv_videoio opencv_objdetect caffe "
    for libfilter in $all_libs 
    do  
        curlib=$(find $HOME/opt -iname "lib$libfilter*.so*")
        if [ -z "$curlib" ];then
            echo -e "\033[31mlib: $libfilter is not exist.\033[0m" 
            #exit 3
        #else
            #echo -e "\033[32mlib: $libfilter is exist.\033[0m" 
        fi  
    done    
}

#pushd $THIRD_LIBS >>/dev/null
    #remove_tmp_dir
    cp .bashrc ${HOME}/
    . ${HOME}/.bashrc
    install_all
    check_libs
#popd >>/dev/null
