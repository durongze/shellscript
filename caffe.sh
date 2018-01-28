#!/bin/bash
sudo rpm -i cuda-repo-rhel7-9.1.85-1.x86_64.rpm 
sudo yum clean all
sudo yum install cuda
rpm -Va --nofiles --nodigest
sudo yum install cuda
sudo yum install nvidia-kmod-387.26-2.el7.x86_64 
sudo yum update
sudo yum install nvidia-kmod-387.26-2.el7.x86_64 
cd stardict-3.0.6/
sudo yum install gettext-devel.i686 
sudo yum install am-utils.x86_64 
sudo yum install nvidia-kmod-387.26-2.el7.x86_64 
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum install nvidia-detect
nvidia-detect -v
sudo yum --enablerepo=linuxtech-testing install libvdpau
sudo yum -y install epel-release
sudo yum install nvidia-kmod-387.26-2.el7.x86_64 
sudo yum install gnome-doc-utilsc
sudo yum install gnome-doc-utils.noarch 
sudo yum install enchant-aspell.x86_64 
sudo yum install enchant-devel.x86_64 
sudo yum install gucharmap-devel.x86_64 
sudo yum install gucharmap-libs.i686 
sudo yum install gucharmap-devel.i686 
sudo yum install gucharmap.i686 
sudo yum install festival-devel.x86_64 
sudo yum install espeak-devel.x86_64 
sudo yum install libgnome-devel.x86_64 libbonobo-devel.x86_64 gconf-editor.x86_64 
sudo yum install autogen-libopts-devel.x86_64 autogen.x86_64 
sudo yum install autoconf213.noarch 
./configure  --disable-gucharmap --disable-schemas-install
sudo yum install yum-cron.noarch 
./configure  --disable-gucharmap --disable-schemas-install
sudo yum install swig-doc.noarch 
sudo yum install libstdc++-devel.i686 libstdc++-docs.x86_64 
./configure  --disable-gucharmap --disable-schemas-install
sudo ldconfig 
pkg-config --modversion gucharmap
sudo find ./ -iname "gucharmap.pc"
cd /usr/lib64/
sudo vi /etc/ld.so.conf.d/dyninst-x86_64.conf 
cd /etc/ld.so.conf.d/
grep -rsn "/usr/lib64" *
sudo ldconfig 
./configure 
sudo yum install gucharmap

ldconfig -p | grep "gucharmap"
sudo yum install gnome-session
sudo yum install gnome-desktop.x86_64 
sudo yum install gnome-desktop-devel.x86_64 
./configure --enable-compile-warnings  --disable-gucharmap 
sudo yum groups install "GNOME Desktop" "Graphical Administration Tools"
sudo vi /etc/sysconfig/network-scripts/ifcfg-enp0s3 
sudo service network restart 
sudo yum reinstall gnome-desktop
systemctl get-default 
sudo upgraded
sudo yum remove 
ls /etc/systemd/system/default.target -l
sudo vi /lib/systemd/system/runlevel5.target
sudo yum groups install "GNOME Desktop" "Graphical Administration Tools"
systemctl get-default 
sudo vi /etc/modprobe.d/blacklist-nouveau.conf 
sudo yum install linux-user-chroot.x86_64 
sudo yum install linux_logo.x86_64 
sudo yum install linuxdoc-tools.x86_64 
sudo yum install leveldb-devel.x86_64 
sudo yum install snappy-devel.x86_64 
sudo yum install opencv-devel.x86_64 
sudo yum install boost-devel.i686 
sudo yum install hdf5-devel.x86_64 
sudo yum install gflags-devel.x86_64 
sudo yum install glog-devel.x86_64 
sudo yum install lmdb-devel.x86_64 
cp caffe-master.zip ~/code/
unzip caffe-master.zip 
cd caffe-master/
cp Makefile.config.example Makefile.config
cp /media/sf_E_DRIVE/OpenBLAS\ 0.2.20\ version.tar.gz  ~/code/
tar xf OpenBLAS\ 0.2.20\ version.tar.gz 
cd xianyi-OpenBLAS-6d2da63/
make
make PREFIX=/usr/local/openlabs install
sudo make PREFIX=/usr/local/openlabs install
cd /usr/local/openlabs/
cd caffe-master/
make
cd /usr/local/openlabs/
find ./ -iname "cublas_v2.h"
cd 
cp /media/sf_E_DRIVE/cub-1.7.4.zip  ~/code/
cd code/
ls
unzip cub-1.7.4.zip 
cd cub-1.7.4/
cp /media/sf_E_DRIVE/cuda-repo-rhel7-8.0.61-1.x86_64.rpm  ~/code/
sudo rpm -i cuda-repo-rhel7-8.0.61-1.x86_64.rpm 
sudo yum clean all
sudo yum install cuda-repo-rhel7-8.0.61-1.x86_64.rpm 
cp /media/sf_E_DRIVE/nsight-sources-8.0.61.tar.gz  ~/code/
tar xf nsight-sources-8.0.61.tar.gz 
cp /media/sf_E_DRIVE/cuda-repo-rhel7-7.5-18.x86_64.rpm  ~/code/
sudo rpm -i cuda-repo-rhel7-7.5-18.x86_64.rpm 
sudo yum clean all
sudo yum install cuda
cd /usr/
find ./ -iname "cublas_v2.h"
vi Makefile.config
make
sudo yum install boost-build.noarch 
make
cd ../
cp /media/sf_E_DRIVE/boost_1_53_0.tar.gz  ~/code/
tar xf boost_1_53_0.tar.gz 
cd boost_1_53_0/
./bootstrap.sh 
./b2
./b2 install --prefix=/usr/local/boost
sudo ./b2 install --prefix=/usr/local/boost
cd caffe-master/
sudo ldconfig 
make
. ~/.bashrc 
make
cd ../boost_1_53_0/
./bjam --build-type=complete --layout=tagged
cd stage/lib/
cd caffe-master/
make
cd ../
cd code/caffe-master/
make
sudo ldconfig 
make
cd ..
cp /media/sf_E_DRIVE/cblas.tgz .
cp /media/sf_E_DRIVE/blas-3.8.0.tgz .
tar xf cblas.tgz 
tar xf blas-3.8.0.tgz 
cd BLAS-3.8.0/
cd caffe-master/
cd CBLAS/
make
ls
make
cd BLAS-3.8.0/
vi Makefile.in 
make
vi Makefile
vi ~/.bashrc 
cd caffe-master/
make
vi Makefile.in 
make clean
make
cp /media/sf_E_DRIVE/atlas3.6.0.tgz .
tar xf atlas3.6.0.tgz 
cd ATLAS/
make
sudo yum install atlas-devel.x86_64 
sudo yum install atlas-static.x86_64 
sudo yum install atlas-devel.i686 
sudo yum install openblas-devel.x86_64 
sudo yum install openblas-static.x86_64 
sudo yum install openblas-Rblas.x86_64 
make
vi Makefile.config
cd ../BLAS-3.8.0/
vi ../caffe-master/Makefile.config
make
sudo make runtest 
vi Makefile.config
make clean
make
sudo make runtest 
cp /media/sf_E_DRIVE/project_duyongze.tar.gz ../..
cd 
ls
mkdir project
cd project/
mv ../project_duyongze.tar.gz .
ls
tar xf project_duyongze.tar.gz 
ls
rm project_duyongze.tar.gz 
ls
cd project_duyongze/
ls
cd tmp/
ls
cd ..
rm tmp/ -rf
ls
cd sdk_lock_tool/
ls
cd ..
ls
cd sdk_src/
ls
cd ..
ls
cd sdk_src/
ls
vi Makefile
ls
vi Makefile
sudo ifconfig enp0s3 192.168.9.190 netmask 255.255.255.0 
ping 192.168.9.1
ifconfig
ls
make
ping 192.168.9.1
sudo ifconfig enp0s3 192.168.9.190 netmask 255.255.255.0 
ifconfig
ping 192.168.9.1
ifconfig
ping 192.168.9.1
ifconfig
sudo ifconfig enp0s3 192.168.9.190 netmask 255.255.255.0 
ping 192.168.9.1
sudo /etc/init.d/network restart
ping 192.168.9.1
sudo ifconfig enp0s3 192.168.9.190 netmask 255.255.255.0 
ping 192.168.9.1
ifconfig
sudo ifconfig enp0s8 192.168.9.19 netmask 255.255.255.0 
ping 192.168.9.1
sudo ifconfig enp0s8 192.168.9.19 netmask 255.255.255.0 
ping 192.168.9.1
sudo ifconfig enp0s8 192.168.9.19 netmask 255.255.255.0 
ping 192.168.9.1
ifconfig
sudo ifconfig enp0s3 192.168.9.119 netmask 255.255.255.0 
ping 192.168.9.1
sudo /etc/init.d/network restart
ping 192.168.9.1
sudo /etc/init.d/network restart
ping 192.168.9.1
sudo ifconfig enp0s3 192.168.9.119 netmask 255.255.255.0 
ping 192.168.9.1
sudo reboot
ls
cd code/
ls
cd ..
ls
cd project/
ls
clear
ls
cd project_duyongze/
ls
cd sdk_src/
ls
ping 192.168.9.1
sudo ifconfig enp0s3 192.168.9.119 netmask 255.255.255.0 
ping 192.168.9.1
sudo /etc/init.d/network restart 
ping 192.168.9.1
sudo /etc/init.d/network restart 
ping 192.168.9.1
sudo /etc/init.d/network restart 
ping 192.168.9.1
sudo ifconfig enp0s3 192.168.9.119 netmask 255.255.255.0 
ifconfig
ping 192.168.9.1
sudo /etc/init.d/network restart
ping 192.168.9.1
sudo /etc/init.d/network restart
ifconfig
sudo ifconfig enp0s3 192.168.9.119 netmask 255.255.255.0 
ifconfig
sudo reboot
ifconfig
sudo ifconfig enp0s8 192.168.9.190 netmask 255.255.255.0
ifconfig
ping 192.168.9.1
cp /media/sf_D_DRIVE/Makefile .
ls
mv Makefile project/
ls
cd p
cd project/project_duyongze/
ls
mv ../Makefile sdk_src/
cd sdk_src/
ls
make
vi Makefile 
ls
mv Makefile ../
cd ..
ls
vi Makefile 
make
ls
vi Makefile 
make
vi Makefile 
make
ls
cd out/
ls
cd linux/sdk_src/
cd ../
cd ..
ls
make clean
make
vi Makefile 
make
lss
ls
vi Makefile 
make
vi Makefile 
make
vi Makefile 
make
vi sdk_src/include/facesdk_api.h +11
vi Makefile 
cd ~/code/caffe-master/
ls
make install
vi Makefile
ls
cd models/
ls
find ./ -iname "*.a"
cd ..
find ./ -iname "*.a"
cd .build_release/
ls
ls cuda/
ls lib
du lib/libcaffe.a -csh
ls
ls src/
ls src/caffe/
pwd >>../../../project/project_duyongze/Makefile 
cd ../../../project/
ls
cd project_duyongze/
ls
vi Makefile 
cd ../../code/caffe-master/include/
pwd >>../../../project/project_duyongze/Makefile 
cd
cd project/project_duyongze/
ls
vi Makefile 
make
vi Makefile 
make
find  /usr/ -iname "cublas_v2.h"
cd /usr/local/cuda-9.1/targets/x86_64-linux/include/
pwd >> ~/project/project_duyongze/Makefile 
cd
cd project/project_duyongze/
ls
vi Makefile 
make
find ../../code/caffe-master/ -iname "caffe.pb.h"
vi Makefile 
make
find ../../code/caffe-master/ -iname "caffe.pb.h"
vi Makefile 
make
vi sdk_src/facesdk_api_intergrate.cpp +583
make
ls
yum install ctags
sudo yum install ctags
ls
cd sdk_src/
ctags * -R
vi sdk_src/facesdk_api_intergrate.cpp +583
cd ..
vi sdk_src/facesdk_api_intergrate.cpp +583
make
vi sdk_src/facesdk_api_intergrate.cpp +611
make
sudo yum install gcc-c++-x86_64-linux-gnu.x86_64 
g++ -v
ls
make
vi Makefile 
make
vi Makefile 
make
make | more
make >&2
make &>2
make &>1
ifconfig
sudo poweroff 
ls
cd code/
ls
cd 
cd project/
ls
cd project_duyongze/
clear
ls
rm 1 2
ls
make
vi sdk_src/include/unpack.hpp +99
make
ls
cd
cd code/
ls
cp /media/sf_E_DRIVE/opencv-3.4.0.tar.gz .
tar xf opencv-3.4.0.tar.gz 
cd open
cd opencv-3.4.0/
ls
cd cmake/
ls
cd ..
ls
vi README.md 
ls
cmake .
ls
rm CMakeCache.txt 
rm CMakeFiles/ -rf
mkdir release
cd release/
cmake ../
sudo yum install java
sudo yum install java-1.8.0-openjdk
java
javac
cp /media/sf_E_DRIVE/ffmpeg-3.4.1.tar.xz ~/code/
cd ../../
tar xf ffmpeg-3.4.1.tar.xz 
cd ffmpeg-3.4.1/
ls
./configure --prefix=/usr/local/ffmpeg341
sudo yum install nasm.x86_64 
./configure --prefix=/usr/local/ffmpeg341
ls
make
sudo make install
cd /usr/local/ffmpeg341/
pwd >> ~/.bashrc 
cd
vi .bashrc 
. .bashrc 
cd project/project_duyongze/
vi sdk_src/include/unpack.hpp +84
vi sdk_src/facesdk_api_core.cpp +304
cp /media/sf_E_DRIVE/opencv-2.4.12.zip code/
unzip opencv-2.4.12.zip 
cd opencv-2.4.12/
