#!/bin/bash

1. 安装增强功能包
2. cd /media/cdom0
   sudo ./VboxLinuxAdditions.run
3. 设置共享文件夹
4. sudo mkdir /mnt/shared
   sudo mount -t vboxsf gongxiang /mnt/shared
   可以在/etc/fstab中添加一项 
   gongxiang /mnt/shared vboxsf rw,gid=100,uid=1000,auto 0 0
