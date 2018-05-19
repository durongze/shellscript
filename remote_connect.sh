####################################方法一###########################################
sudo apt-get install xterm
#xstart 
#命令填写如下：/usr/bin/xterm -ls -display $DISPLAY

####################################方法二###########################################
su  #切换到root
vi /etc/ssh/sshd_config  
#修改其中的 X11Forwarding yes
apt-fast install vnc4server
vncserver
#ip为window的ip，第一个0 代表 0+6000 = 6000 端口 ，第二个0 一般总为0
export DISPLAY=192.168.179.1:0.0 
xhost +  #好像会报错，重启后又换成其他错误提示

#重启成功后  securecrt 中开启 Forward X11 packets
export DISPLAY=192.168.179.1:0.0 
xclock #测试程序

 
############################################### rhel7  桌面安装 #####################################################
yum group list
yum -y groupinstall "Server with GUI"
show-installed
systemctl get-default
systemctl set-default graphical.target
reboot  #远程连接时不要使用startx， 使用reboot重启


