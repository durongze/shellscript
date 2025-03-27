#!/bin/bash

function StEnv()
{
    export SYSROOT=/opt/st/stm32mp1/3.1-snapshot/sysroots/cortexa7t2hf-neon-vfpv4-ostl-linux-gnueabi
    export CC="arm-ostl-linux-gnueabi-gcc"
    export CXX="arm-ostl-linux-gnueabi-g++"
    export CFLAGS="-mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7 --sysroot=$SYSROOT"
    export CXXFLAGS="$CFLAGS"
}

function ArmEnv()
{
    ARM_GCC_HOME=/opt/st/armv7-eabihf--glibc--stable-2022.08-1/
    ARM_SYS_HOME=${ARM_GCC_HOME}/arm-buildroot-linux-gnueabihf/
    ARM_SYS_ROOT=${ARM_SYS_HOME}/sysroot
    
    ARM_COMPILER_PREFIX=arm-buildroot-linux-gnueabihf-
    export CC=${ARM_COMPILER_PREFIX}gcc
    export CXX=${ARM_COMPILER_PREFIX}g++
    export CPP=${ARM_COMPILER_PREFIX}g++
    
    SYSROOT=$ARM_SYS_ROOT
    
    export CFLAGS="-mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7 --sysroot=$SYSROOT  -D_GNU_SOURCE"
    export CXXFLAGS="$CFLAGS"
    export LDFLAGS="$CFLAGS"

    echo "ARM_GCC_HOME=${ARM_GCC_HOME}"
    echo "ARM_SYS_HOME=${ARM_SYS_HOME}"
    echo "ARM_SYS_ROOT=${ARM_SYS_ROOT}"
    echo "CC=${CC}"
    export PATH=${ARM_GCC_HOME}/bin:$PATH
    whereis ${CC}
}

ArmEnv


export ac_cv_type_size_t=yes
export ac_cv_type_off_t=yes
export ac_cv_type_mode_t=yes
export ac_cv_type_size_t=yes
export ac_cv_type_off_t=yes
export ac_cv_header_termios_h=yes
export ac_cv_header_syslog_h=yes

./configure --host=arm-ostl-linux-gnueabi --build=$(uname -m)-linux-gnu --prefix=$(pwd)/output --enable-static --disable-shared
make 

