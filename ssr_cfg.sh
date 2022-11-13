
#!/bin/bash

#https://ssr.tools/252

libev_url=https://github.com/shadowsocks/shadowsocks-libev.git 
libev_dir=shadowsocks-libev 

function PreCompilerEnv() {
  sudo apt install asciidoc
  sudo apt install libmbedtls-dev
  sudo apt install libsodium-dev
  sudo apt install libc-ares-dev
  sudo apt install libev-dev
}

function DownloadCode() {
  url=$1
  git clone --recurse-submodules $url
}

function CompileCode() {
  dir=$1
  pushd $dir
    # git submodule foreach git pull
    git submodule update --init --recursive
    ./autogen.sh
    ./configure --prefix=${HOME}/opt/libev
    make -j8
    make install
  popd
}

function Run() {
  json_cfg=$1
  echo "sudo ss-redir -c $json_cfg -v -u"
}

#PREROUTING Table
function ShareToWifi() {
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
function SharedToSelf() {
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

function FixDns() {
  echo "$FUNCNAME"
} 

#https://www.cnblogs.com/l-uz/p/15743040.html
function SsrCfg() {
  #DownloadCode "$libev_url"
  #CompileCode "$libev_dir"
  Run "$libev_dir/debian/config.json"
  echo ShareToWifi "192.168.137.11"
  echo SharedToSelf "serverip"
}

function ThirdParty()
{
  wget https://udomain.dl.sourceforge.net/project/asciidoc/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz --no-check-certificate
  wget https://download.libsodium.org/libsodium/releases/old/libsodium-1.0.16.tar.gz --no-check-certificate
  wget http://dist.schmorp.de/libev/libev-4.23.tar.gz
  echo "asciidoc-8.6.9.tar.gz  c-ares-1.12.0.tar.gz  libev-4.22.tar.gz  libsodium-1.0.16.tar.gz  mbedtls-2.16.2-apache-1.tgz"
}
SsrCfg
