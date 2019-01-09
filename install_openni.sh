#!/bin/bash

. auto_install_func.sh

sudo yum install usbutils-007-4.el7.x86_64.rpm 

function remove_tmp_dir()
{
    ls -F | grep "/$" | xargs rm -rf
}

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

function install_mesa1802()
{
    file=mesa-18.0.2.tar.gz
    tar xf $file
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
    pushd $FileDir
    ./configure --prefix=/home/durongze/opt/mesa1802 --enable-llvm  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
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

function SetMesaEnv()
{
    fileList="cmake360 glib2482 python2714 OpenBLAS gobject1380 gperf304 udev174 libusb1022 graphviz2401 doxygen1814 freeglut300 boost xtrans-1.2.7 xproto-7.0.23 xcb-proto-1.13 libxcb-1.13 libxshmfence-1.3 expat-2.2.5 libpciaccess-0.10.3 libdrm-2.4.92 
llvm -6.0.0.src libxshmfence-1.3 expat-2.2.5 mesa-18.0.2"
    for tmpFile in $fileList
    do
        TMP_FILE_HOME=${HOME}/opt/$tmpFile
        export C_INCLUDE_PATH=$TMP_FILE_HOME/include:$C_INCLUDE_PATH
        export CPLUS_INCLUDE_PATH=$TMP_FILE_HOME/include:$CPLUS_INCLUDE_PATH
        export LIBRARY_PATH=$TMP_FILE_HOME/lib:$LIBRARY_PATH
        export LD_LIBRARY_PATH=$TMP_FILE_HOME/lib:$LD_LIBRARY_PATH
        export PKG_CONFIG_PATH=$TMP_FILE_HOME/lib/pkgconfig/:$PKG_CONFIG_PATH
        export PATH=$TMP_FILE_HOME/bin:$TMP_FILE_HOME/sbin:$PATH
    done
}

#TarXFFile "xcb-proto-1.13.tar.bz2" ~/opt ""
#TarXFFile "libxcb-1.13.tar.bz2" ~/opt  ""
#TarXFFile "libpciaccess-0.10.3.tar.bz2" ~/opt  ""
#TarXFFile "libdrm-2.4.92.tar.gz" ~/opt  " --enable-intel --enable-libkms "
#BUILD_SHARED_LIBS 改为 ON
#TarXFFile "llvm-6.0.0.src.tar.xz" ~/opt  ""
#TarXFFile "libxshmfence-1.3.tar.bz2" ~/opt  ""
#TarXFFile "expat-2.2.5.tar.bz2" ~/opt  ""
#TarXFFile "mesa-18.0.2.tar.gz" ~/opt  ""

function ubuntu_cfg_install()
{ 
    sudo apt-get update
    sudo apt-get install make cmake g++ flex bison  pkg-config  lrzsz 
    sudo apt-get install libglib2.0-dev  libffi-dev  python3-dev python python-dev  libkmod-dev libblkid-dev  x11proto-gl-dev 
    sudo apt-get install libdrm-dev
    sudo apt-get install libx11-dev libxext-dev libxdamage-dev  libxfixes-dev libx11-xcb-dev libxcb-glx0-dev  libxcb-dri2-0-dev 
    sudo apt-get install libxcb-xfixes0-dev libxcb-dri3-dev libxcb-present-dev libxcb-sync-dev libxshmfence-dev 
    sudo apt-get install llvm libelf-dev libxi-dev
    sudo apt install mesa-common-dev
    sudo apt install mesa-utils-extra
    sudo apt install libgl1-mesa-dev
    sudo apt install libglapi-mesa
    sudo apt-get install glew-utils libglew-dev
}

install_all
