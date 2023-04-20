#!/bin/bash

. auto_install_func.sh

function install_leveldb()
{
    file=$1
    echo -e "\033[32m $FUNCNAME \033[0m"
    FileDir=$(GenFileNameByFile "$file")
    pushd $(echo $FileDir | tr -s "_" ".")
    mkdir ${HOME}/opt/${FileDir} -p
    cp out-shared ${HOME}/opt/${FileDir}/lib -a
    cp include ${HOME}/opt/${FileDir}/ -a
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
    file=$1
    echo -e "\033[32m $FUNCNAME \033[0m"
    FileDir=$(GenFileNameByFile "$file")
    pushd $(echo $FileDir | tr -s "_" ".")
    make PREFIX=${HOME}/opt/${FileDir} install
    popd
}

function install_boost()
{
    file=boost_1_69_0.tar.gz
    echo -e "\033[32m $FUNCNAME \033[0m"
    tar xf $file 
    FileDir=$(GenFileNameByFile "$file")
    pushd $FileDir
    ./bootstrap.sh
    ./b2
    ./b2 install --prefix=${HOME}/opt/$FileDir
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

function record_install()
{
    sudo apt-get install flex bison
    sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install cuda-drivers
    nvidia-smi
    sudo apt remove nvidia-*
    sudo dpkg -r nvidia
    sudo init 5
    sudo apt upgrade
    sudo ./NVIDIA-Linux-x86_64-410.78.run --no-opengl-files
    sudo reboot
    sudo service gdm3 stop
    sudo service gdm stop
    sudo vi /etc/modprobe.d/blacklist.conf
    sudo reboot
    sudo apt-get install gnome-panel
    sudo apt-get install cuda-gpu-library-advisor-10-0
    sudo apt-get install xserver-xorg-video-nvidia-390
    sudo apt-get install cuda-driver-390
    find /usr/ -iname "cuda"
    sudo apt-get install gnome
    sudo apt-get install ubuntu-gnome-desktop
    sudo reboot
    sudo apt-get upgrade
    nvidia-smi
    sudo apt-get install caffe-cuda
    sudo apt-get install caffe-tools-cuda
    sudo apt-get install cuda
    sudo apt-get install cuda-cublas-dev-10-0
    find /usr/ -iname "cublas_v2.h"
    sudo apt-fast install nvidia-cuda-toolkit
    find /usr -iname "nvcc"
    /usr/lib/nvidia-cuda-toolkit/bin/nvcc --version
    /usr/bin/nvcc --version
    sudo ln -sf  /usr/bin/nvcc /usr/local/cuda-10.0/bin/
}

GenFileNameVar "$(ls *.tar.* )"
#GenEnvVar

function install_all()
{
    #sudo apt-get install autoconf libtool
    #TarXFFile "cmake-3.3.2.tar.gz" "${HOME}/opt" ""
    #TarXFFile "Python-2.7.14.tgz" "${HOME}/opt" ""
    #TarXFFile "zlib-1.2.3.tar.gz" "${HOME}/opt" "--shared"
    #TarXFFile "protobuf-3.6.1.tar.gz" "${HOME}/opt" ""
    #TarXFFile "gflags-2.2.2.tar.gz" "${HOME}/opt" " CXXFLAGS=-fPIC "
    #TarXFFile "glog-0.3.5.tar.gz" "${HOME}/opt" ""
    #TarXFFile "googletest-release-1.8.1.tar.gz" "${HOME}/opt" ""
    #TarXFFile "snappy-1.1.3.tar.gz" "${HOME}/opt" ""
    #TarXFFile "leveldb-1.20.tar.gz" "${HOME}/opt" ""   # cp out-shared ${HOME}/opt/leveldb/lib -a # cp include ${HOME}/opt/leveldb -a
    #install_leveldb
    #install_lmdb
    #TarXFFile "OpenBLAS-0.2.20.tar.gz" "${HOME}/opt" "DYNAMIC_ARCH=1  NO_AFFINITY=1 NO_LAPACKE=1  NO_AVX2=1" 
    #install_openblas
    #TarXFFile "hdf5-1.8.4.tar.bz2" "${HOME}/opt" "CFLAGS=-fPIC CXXFLAGS=-fPIC"
    #TarXFFile "opencv-3.4.0.tar.gz" "${HOME}/opt" "-D WITH_CUDA=OFF "
    install_boost
    #TarXFFile "termcap-1.3.1.tar.gz" "${HOME}/opt" ""
    #TarXFFile "cuda-gdb-8.0.61.src.tar.gz" "${HOME}/opt" "--disable-werror"
    #TarXFFile "cuda-gdb-9.1.85.src.tar.gz" "${HOME}/opt" ""
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

function create_caffe_dep()
{
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
}