#!/bin/bash

CPU_DIR=THREAD_SDK_CPU
GPU_DIR=THREAD_SDK_GPU

LIB_DIR=/home/duyongze/code/project_duyongze/

CAFFE_CPU_LIB=/opt/caffe_cpu
CAFFE_GPU_LIB=/opt/caffe_gpu
CAFFE_LN_LIB=/opt/caffe

#############################################################################
pushd "$LIB_DIR/bin"
rm "$CAFFE_LN_LIB" 
ln -sf "$CAFFE_CPU_LIB" "$CAFFE_LN_LIB"
sed -i 's#add_definitions(.*)#add_definitions(-DCPU_ONLY)#g'  "$LIB_DIR/CMakeList.txt"
./rebuild.sh
cp "$LIB_DIR/lib" "$CPU_DIR" -a
popd

pushd "$CPU_DIR/build"
rm -rf CMakeCache.txt CMakeFiles cmake_install.cmake Makefile demo
cmake ..
make
popd 

tar caf $CPU_DIR.tar.gz $CPU_DIR
#############################################################################
pushd "$LIB_DIR/bin"
rm "$CAFFE_LN_LIB" 
ln -sf "$CAFFE_GPU_LIB" "$CAFFE_LN_LIB"
sed -i 's#add_definitions(.*)#add_definitions( )#g'  "$LIB_DIR/CMakeList.txt"
./rebuild.sh
cp "$LIB_DIR/lib" "$GPU_DIR" -a
popd

pushd "$GPU_DIR/build"
rm -rf CMakeCache.txt CMakeFiles cmake_install.cmake Makefile demo
cmake ..
make
popd

tar caf $GPU_DIR.tar.gz $GPU_DIR
#############################################################################
