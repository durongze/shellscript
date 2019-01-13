



sudo  yum install glibc-2.17-55.el7.i686.rpm  
sudo  yum install libstdc++-4.8.2-16.el7.i686.rpm 
sudo  yum install zlib-1.2.7-13.el7.i686.rpm 
sudo yum install bc-1.06.95-13.el7.x86_64.rpm 
cp  arch/arm/configs/hi3536c_full_defconfig .config 


yum groupinstall "Development Tools"

yum install gcc make ncurses ncurses-devel perl  kernel-devel

sudo  apt-get source linux-image-$(uname -r)

git clone git://kernel.ubuntu.com/ubuntu/ubuntu-$(lsb_release --codename | cut -f2).git
sudo apt-get build-dep linux-image-$(uname -r) 


#rhel7安装图形界面
yum groupinstall "Server with GUI"  
#rhel6安装图形界面
yum groupinstall "X Window System"  
