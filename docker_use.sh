#!/bin/bash

#查看所有镜像
sudo docker images
#查看运行容器
sudo docker ps
#查看所有容器
sudo docker ps -a
#根据镜像生成容器
sudo docker run -i -t vmware/photon:1.0 /bin/sh
sudo docker ps -a
#进入之前生成容器
sudo docker start -i c334b855ddeb
#提交修改过得容器生成新镜像
sudo docker commit -m="modify ps1" -a="durongze" c334b855ddeb vmware/photon:1.1
#用新修改的镜像生成容器
sudo docker run -t -i vmware/photon:1.1 /bin/bash 
#进入之前生成过得容器
sudo docker start -i 228740efcb20
