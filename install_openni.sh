#!/bin/bash

sudo yum install usbutils-007-4.el7.x86_64.rpm 

function install_doxygen1814()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    file=doxygen-1.8.14.src.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    mkdir $FileDir/build -p
    pushd $FileDir/build
    cmake  -DCMAKE_INSTALL_PREFIX=${HOME}/opt/doxygen1814 ..  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_freeglut300()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    file=freeglut-3.0.0.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    mkdir $FileDir/build -p
    pushd $FileDir/build
    cmake  -DCMAKE_INSTALL_PREFIX=${HOME}/opt/freeglut300  ..  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_gobject1380()
{
    echo -e "\033[32m $FUNCNAME \033[0m"
    file=gobject-introspection-1.38.0.tar.xz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=${HOME}/opt/gobject1380/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_gperf304()
{
    file=gperf-3.0.4.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=${HOME}/opt/gperf304/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_graphviz()
{
    file=graphviz.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=${HOME}/opt/graphviz2401/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_libusb1022()
{
    file=libusb-1.0.22.tar.bz2
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=${HOME}/opt/libusb1022/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_udev174()
{
    file=udev-174.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=${HOME}/opt/udev174/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function install_usbutils008()
{
    file=usbutils-008.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=${HOME}/opt/usbutils008/   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}
function install_all()
{
    #install_gobject1380
    #install_gperf304
    #install_udev174
    #install_libusb1022
    #install_usbutils008
    #install_graphviz
    #install_doxygen1814
    install_freeglut300
}

function ubuntu_cfg_install()
{
    sudo apt-get update
    sudo apt-get install make cmake g++ flex bison  pkg-config  lrzsz libglib2.0-dev
}
install_all
