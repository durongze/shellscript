#!/bin/bash

######################################################################
allow booting; #定义能够PXE启动
allow bootp; #定义支持bootp

default-lease-time 1800;
max-lease-time 7200;
ping-check true;
#option domain-name-servers 192.168.9.1;

subnet 192.168.9.0 netmask 255.255.255.0
{
    range 192.168.9.128 192.168.9.210;
    filename "pxelinux.0";              #bootstrap 文件(NBP)
    next-server 192.168.9.90;          #TFTP Server的IP地址
    option routers 192.168.9.90;
    option broadcast-address 192.168.9.255;
}
######################################################################
mount -o loop CentOS-7-x86_64-DVD-1708.iso          /var/www/centos7/
cp /var/www/html/centos7/images/pxeboot/initrd.img  /var/lib/tftpboot/centos7/
cp /var/www/html/centos7/images/pxeboot/vmlinuz     /var/lib/tftpboot/centos7/

cp  /usr/share/syslinux/menu.c32     /var/lib/tftpboot
cp  /usr/share/syslinux/pxelinux.0   /var/lib/tftpboot
mkdir /var/lib/tftpboot/pxelinux.cfg
vim   /var/lib/tftpboot/pxelinux.cfg/default
#####################################################################
default menu.c32
prompt 0
timeout 300
ONTIMEOUT local
 
menu title ########## PXE Boot Menu ##########
 
label 1
menu label ^1 Install CentOS 7 x64 with HTTP
kernel centos7/vmlinuz
append initrd=centos7/initrd.img method=http://192.168.9.94/centos7 devfs=nomount
#####################################################################
