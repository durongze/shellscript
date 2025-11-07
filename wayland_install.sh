#!/bin/bash

. auto_install_func.sh

#InstallPkgFile "wayland-protocols.tar.gz" "${HOME}/opt" " --disable-documentation " "CfgInstall"
#InstallPkgFile "wayland.tar.gz" "${HOME}/opt" " --disable-documentation " "CfgInstall"
InstallPkgFile "weston.tar.gz" "${HOME}/opt"
