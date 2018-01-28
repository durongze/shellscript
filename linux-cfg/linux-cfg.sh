#!/bin/bash

sudo apt-fast install stardict  qt-sdk  mysql-workbench  wireshark  vim  smbd  ckermit  lrzsz  xmlto  
sudo apt-fast install build-essential  gawk  zlib1g-dev  uuid-dev  tree  libblkid-dev  libattr1-dev                           
sudo apt-fast install smbc  smbclient  ssh  nfs-kernel-server  tftpd-hpa  tftp  pxelinux  uget  vlc   
sudo apt-fast install unrar  rar  7z  smb4k  iptux  svn-workbench  git  wine swig
sudo apt-fast install sunpinyin-utils  sunpinyin-data  ibus-sunpinyin  ibus-googlepinyin  fcitx-googlepinyin   
sudo apt-fast install libfuse-dev  libdevmapper-dev  libglib2.0-dev   libglib2.0-doc  glibc-source  
sudo apt-fast install bison bison-doc flex flex-doc zfs-fuse unifont liblzma-dev  liblzma-doc
sudo apt-fast install manpages*  
sudo apt-get source linux-image-$(uname -r)

#Desktop=桌面
Desktop=Desktop
sudo cp /usr/share/applications/stardict.desktop ~/$Desktop/
sudo cp /usr/share/applications/firefox.desktop ~/$Desktop/
sudo cp /usr/share/applications/qtcreator.desktop ~/$Desktop/
sudo cp /usr/share/applications/assistant-qt4.desktop ~/$Desktop/
sudo cp /usr/share/applications/wireshark.desktop ~/$Desktop/
sudo cp /usr/share/applications/vlc.desktop ~/$Desktop/
sudo cp /usr/share/applications/iptux.desktop ~/$Desktop/
sudo chmod 777  ~/$Desktop/*.desktop

sudo add-apt-repository ppa:aitjcize/manpages-cpp
sudo apt-get update
sudo apt-get install manpages-cpp
sudo apt-get update
sudo apt-get install cppman
sudo cppman -c
