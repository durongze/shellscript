#!/bin/bash

libev_url=https://github.com/shadowsocks/shadowsocks-libev.git
libev_dir=shadowsocks-libev

function PreCompilerEnv()
{
  sudo apt install asciidoc
  sudo apt install libmbedtls-dev
  sudo apt install libsodium-dev
  sudo apt install libc-ares-dev
  sudo apt install libev-dev
}

function DownloadCode()
{
	url=$1
  git clone --recurse-submodules $url
}

function CompileCode()
{
  dir=$1
  pushd $dir
    git submodule update --init --recursive
    ./autogen.sh
    ./configure --prefix=${HOME}/opt/libev
    make -j8
    make install
  popd
}

function Run()
{
  json_cfg=$1
  sudo ss-redir -c $json_cfg  -v -u
}

#PREROUTING Table
function ShareToWifi()
{
  LocalPort=1080 # json "local_port"
  WifiClientIp="${1}/16"
  iptables -t nat -A PREROUTING -d 127.0.0.0/24 -j RETURN
  iptables -t nat -A PREROUTING -d 192.168.0.0/16 -j RETURN
  iptables -t nat -A PREROUTING -d 10.42.0.0/16 -j RETURN
  iptables -t nat -A PREROUTING -d 0.0.0.0/8 -j RETURN
  iptables -t nat -A PREROUTING -d 10.0.0.0/8 -j RETURN
  iptables -t nat -A PREROUTING -d 172.16.0.0/12 -j RETURN
  iptables -t nat -A PREROUTING -d 224.0.0.0/4 -j RETURN
  iptables -t nat -A PREROUTING -d 240.0.0.0/4 -j RETURN
  iptables -t nat -A PREROUTING -d 169.254.0.0/16 -j RETURN
  
  iptables -t nat -A PREROUTING -p tcp -s $WifiClientIp -j REDIRECT --to-ports $LocalPort
}

#OUTPUT Table
function SharedToSelf()
{
  LocalPort=1080 #json "local_port"
  SsrServerIp="${1}"
  iptables -t nat -A OUTPUT -d 127.0.0.0/24 -j RETURN
  iptables -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN
  iptables -t nat -A OUTPUT -d 10.42.0.0/16 -j RETURN
  iptables -t nat -A OUTPUT -d 0.0.0.0/8 -j RETURN
  iptables -t nat -A OUTPUT -d 10.0.0.0/8 -j RETURN
  iptables -t nat -A OUTPUT -d 172.16.0.0/12 -j RETURN
  iptables -t nat -A OUTPUT -d 224.0.0.0/4 -j RETURN
  iptables -t nat -A OUTPUT -d 240.0.0.0/4 -j RETURN
  iptables -t nat -A OUTPUT -d 169.254.0.0/16 -j RETURN
  
  iptables -t nat -A OUTPUT -d $SsrServerIp -j RETURN
  
  iptables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports $LocalPort
}

function FixDns()
{

} 
#DownloadCode "$libev_url"
CompileCode "$libev_dir"
Run "$libev_dir/debian/config.json"
ShareToWifi "192.168.137.11"
SharedToSelf "serverip"
