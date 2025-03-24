#!/bin/bash

#u-boot-stm32mp-2020.01/arch/arm/dts/stm32mp157d-atk.dts
#linux-5.4.31/arch/arm/configs/stm32mp1_atk_defconfig
#busybox-1.32.0/configs/stm32mp1_atk_defconfig

ARM_GCC_HOME=/opt/st/armv7-eabihf--glibc--stable-2022.08-1/
ARM_SYS_HOME=${ARM_GCC_HOME}/arm-buildroot-linux-gnueabihf/
ARM_SYS_ROOT=${ARM_SYS_HOME}/sysroot

ARM_COMPILER_PREFIX=arm-buildroot-linux-gnueabihf- 
CC=${ARM_COMPILER_PREFIX}gcc 

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

function CompileKernel()
{
    make stm32mp1_atk_defconfig
    make menuconfig
    make uImage dtbs LOADADDR=0XC2000040 -j8
}

function CompileKernelMod()
{
	ROOT_FS=/mnt/rootfs
    make ARCH=arm CROSS_COMPILE=${ARM_COMPILER_PREFIX} modules
    make ARCH=arm CROSS_COMPILE=${ARM_COMPILER_PREFIX} modules_install INSTALL_MOD_PATH=$ROOT_FS
    depmod -b $ROOT_FS 5.4.31
}

function CreateBootFs()
{
    dd if=/dev/zero of=bootfs.ext4 bs=1M count=10  
    mkfs.ext4 -L bootfs bootfs.ext4  

	BOOT_FS=/mnt/bootfs
    mount   bootfs.ext4                $BOOT_FS                             
    sudo cp uImage stm32mp157d-atk.dtb $BOOT_FS
    umount                             $BOOT_FS
}

function CompileBusybox()
{
    make stm32mp1_atk_defconfig
}

function CreateRootFS()
{
    dd if=/dev/zero of=rootfs.ext4 bs=1M count=1024 
    mkfs.ext4 -L rootfs rootfs.ext4   

	ROOT_FS=/mnt/rootfs
    mount   rootfs.ext4                $ROOT_FS 
                            
	#make INSTALL_PATH=$ROOT_FS
    make install CONFIG_PREFIX=$ROOT_FS

    ARM_COMPILER_HOME_DIR=/usr/local/arm/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf/arm-none-linux-gnueabihf 

    mkdir  $ROOT_FS/lib
    LIBC_LIB_DIR=${ARM_COMPILER_HOME_DIR}/libc/lib 
    cp     $LIBC_LIB_DIR/*.so*                       $ROOT_FS/lib/        -d 
    rm                                               $ROOT_FS/lib/ld-linux-armhf.so.3 
    cp     $LIBC_LIB_DIR/ld-linux-armhf.so.3         $ROOT_FS/lib/ 

    LIB_DIR=${ARM_COMPILER_HOME_DIR}/lib 
    cp     $LIB_DIR/*.so*                            $ROOT_FS/lib/       -d 
    cp     $LIB_DIR/*.a                              $ROOT_FS/lib/       -d 

    mkdir  $ROOT_FS/usr/lib  -p
    LIBC_USR_DIR=${ARM_COMPILER_HOME_DIR}/usr/lib 
    cp     $LIBC_USR_DIR/*.so*                       $ROOT_FS/usr/lib/   -d 
    cp     $LIBC_USR_DIR/*.a                         $ROOT_FS/usr/lib/   -d 

    for cur_dir in dev proc mnt sys tmp etc root
    do
        mkdir $ROOT_FS/$cur_dir
    done

    umount                             $BOOT_FS
}

function CreateRootFS_rcS()
{
    local FilercS="rcS"
    echo "#!/bin/sh "                                        >$FilercS
    echo ""                                                 >>$FilercS
    echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin:$""PATH"       >>$FilercS
    echo "LD_LIBRARY_PATH=$""LD_LIBRARY_PATH:/lib:/usr/lib" >>$FilercS
    echo "export PATH LD_LIBRARY_PATH  "                    >>$FilercS
    echo " "                                              >>$FilercS
    echo "mount -a "                                      >>$FilercS
    echo "mkdir /dev/pts "                                >>$FilercS
    echo "mount -t devpts devpts /dev/pts "               >>$FilercS
    echo ""                                               >>$FilercS
    echo "echo /sbin/mdev > /proc/sys/kernel/hotplug "    >>$FilercS
    echo "mdev -s "                                       >>$FilercS
}

function CreateRootFS_fstab()
{
    local Filefstab="fstab"
    echo "#<file system> <mount point>      <type>      <options>   <dump>  <pass> "  >$Filefstab 
    echo "proc              /proc            proc        defaults    0        0 "    >>$Filefstab
    echo "tmpfs             /tmp             tmpfs       defaults    0        0 "    >>$Filefstab
    echo "sysfs             /sys             sysfs       defaults    0        0 "    >>$Filefstab
}

function CreateRootFS_inittab()
{
    local Fileinittab="inittab"
    echo "#etc/inittab "                   >$Fileinittab
    echo "::sysinit:/etc/init.d/rcS "     >>$Fileinittab
    echo "console::askfirst:-/bin/sh "    >>$Fileinittab
    echo "::restart:/sbin/init "          >>$Fileinittab
    echo "::ctrlaltdel:/sbin/reboot "     >>$Fileinittab
    echo "::shutdown:/bin/umount -a -r "  >>$Fileinittab
    echo "::shutdown:/sbin/swapoff -a "   >>$Fileinittab
}

function ReCfgKernel()
{
	echo "-> Device Drivers -> Generic Driver Options ->Support for uevent helper"
    echo "CONFIG_UEVENT_HELPER=y "
}

function CreateRootFS_network()
{
    echo "nameserver 114.114.114.114"    > "resolv.conf"
    echo "nameserver 192.168.1.1"       >> "resolv.conf"
}

CompileBusybox
CreateRootFS
