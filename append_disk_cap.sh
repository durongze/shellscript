#!/bin/bash
#先修改物理磁盘大小

sudo vgdisplay
sudo df -h
sudo lvextend -l+5892 /dev/mapper/rhel-root
sudo xfs_growfs /dev/mapper/rhel-root
