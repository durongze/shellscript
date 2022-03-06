#!/bin/bash
#apt-get install alsa-utils  #alsamixer
#apt-get install pulseaudio  #pulseaudio --system

function AddRootPem()
{
    sudo usermod -a -G pulse-access root
    sudo gpasswd -a root pulse
    sudo gpasswd -a root pulse-access
}

function GenPulseSvrFile()
{
    SvrFile="pulseaudio.service"
    echo "[Unit]"                    >$SvrFile
    echo "Description=Pulseaudio"    >>$SvrFile
    echo "After=default.target"      >>$SvrFile
    echo ""                          >>$SvrFile
    echo "[Service]"                 >>$SvrFile
    echo "ExecStart=/usr/bin/bash -c \"/usr/bin/pulseaudio --system\""  >>$SvrFile
    echo ""                          >>$SvrFile
    echo "[Install]"                 >>$SvrFile
    echo "WantedBy=default.target"   >>$SvrFile
    echo -e "\033[32m cp $SvrFile /etc/systemd/system/ \033[0m"
}

function EnablePulseSvr()
{
    systemctl enable pulseaudio.service
    systemctl status pulseaudio
}

GenPulseSvrFile
