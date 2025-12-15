#!/bin/bash

#u-boot-2020.01/arch/arm/dts/BOARD_NAME.dts
make BOARD_NAME_defconfig
make DEVICE_TREE=BOARD_NAME all -j8

#linux-5.4.31/arch/arm/configs/BOARD_NAME_defconfig
make BOARD_NAME_defconfig
make uImage dtbs LOADADDR=0XC2000040 -j8

#busybox-1.32.0/configs/BOARD_NAME_defconfig
make BOARD_NAME_defconfig

function InstallCompileTools()
{
    sudo apt install python-is-python3
    sudo apt install lbzip2
    sudo apt install bison
    sudo apt install flex 
    sudo apt install libncurses-dev
    sudo apt install libssl-dev
    sudo apt install mkimage
    sudo apt install u-boot-tools
}
