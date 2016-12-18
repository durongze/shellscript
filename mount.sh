#!/bin/bash

#1.WINDOWS DOS 共享本地路径
#查看共享>net share
#增加共享>net share D=D:
#删除共享>net share D    /delete

#2.WINDOWS DOS 挂载远端路径
#查看远端共享>net view \\192.168.0.10\
#查看挂载>net use
#挂载路径>net use N: \\192.168.0.10\code 
#删除挂载>net use N: /delete

#3.LINUX 共享本地路径
net usershare list
net usershare add Download /home/du/Desktop
net usershare delete Download
#4.LINUX 挂载windows共享到本地 
sudo mount -t cifs -o nolock //192.168.99.208/d /mnt/window-pc -o username=administrator,password=password
