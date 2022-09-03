@echo off

@rem %comspec%

set tools_addr=https://eternallybored.org/misc/wget/releases/wget-1.21.2-win64.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-dep.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/tar/1.13-1/tar-1.13-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/unrar/3.4.3/unrar-3.4.3-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/unzip/5.51-1/unzip-5.51-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/gawk/3.1.6-1/gawk-3.1.6-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-dep.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/grep/2.5.4/grep-2.5.4-bin.zip
set tools_dir=tools_dir

set software_urls=https://www.php.net/distributions/php-8.1.7.tar.gz
set software_urls=%software_urls%;https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.gz
set software_urls=%software_urls%;https://fossies.org/linux/www/libxml2-2.9.14.tar.xz
set software_urls=%software_urls%;https://tukaani.org/xz/xz-5.2.5.tar.gz
set software_urls=%software_urls%;https://www.sqlite.org/2022/sqlite-autoconf-3390000.tar.gz
set software_urls=%software_urls%;https://curl.se/download/curl-7.84.0.tar.gz
set software_urls=%software_urls%;https://www.lua.org/ftp/lua-5.4.4.tar.gz
set software_urls=%software_urls%;http://archive.apache.org/dist/apr/apr-1.7.0.tar.gz
set software_urls=%software_urls%;http://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz
set software_urls=%software_urls%;https://udomain.dl.sourceforge.net/project/expat/expat/2.4.8/expat-2.4.8.tar.gz
set software_urls=%software_urls%;https://archive.apache.org/dist/httpd/apache_1.3.42.tar.gz
set software_urls=%software_urls%;https://www.openssl.org/source/openssl-3.0.5.tar.gz
set software_dir=php_dir

set home_dir=E:\program
set build_type=Release
set auto_install_func=%cd%\auto_install_func.bat
call %auto_install_func% gen_all_env %software_dir% %home_dir% all_inc all_lib all_bin
echo all_inc:%all_inc%
echo all_lib:%all_lib%
echo all_bin:%all_bin%
set include=%all_inc%;%include%
set lib=%all_lib%;%lib%
set path=%all_bin%;%path%

@rem call %auto_install_func% install_all_package "%tools_addr%" "%tools_dir%"
@rem call %auto_install_func% install_all_package "%software_urls%" "%software_dir%"
call :php_server_install "%software_dir%" %home_dir%
goto :eof

:php_server_install
    set tools_dir=%software_dir%
    set home_dir=%2
    pushd %tools_dir%
        call %auto_install_func% install_package xz-5.2.5.tar.gz       "%home_dir%"
        call %auto_install_func% install_package libiconv-1.17.tar.gz  "%home_dir%" 
        call %auto_install_func% install_package libxml2-2.9.14.zip    "%home_dir%" "" "$(GetInstallMethod "libxml2-2.9.14.tar.xz")"
        @rem CopyPcFile "libxml2-2.9.14.tar.gz"    "%home_dir%"
        call %auto_install_func% install_package sqlite-amalgamation-3390200.zip "%home_dir%"
        call %auto_install_func% install_package openssl-3.0.5.tar.gz           "%home_dir%"
        call %auto_install_func% install_package curl-curl-7_85_0.zip           "%home_dir%"
        call %auto_install_func% install_package lua-5.4.4.tar.gz               "%home_dir%"  #INSTALL_TOP=%home_dir%/lua54
        call %auto_install_func% install_package apr-1.7.0-win32-src.zip        "%home_dir%"  "" "$(GetInstallMethod "apr-1.7.0.tar.gz")"
        call %auto_install_func% install_package expat-2.4.8.tar.gz             "%home_dir%"  "" "$(GetInstallMethod "expat-2.4.8.tar.gz")"
        call %auto_install_func% install_package apr-util-1.6.1-win32-src.zip   "%home_dir%"  "--with-apr=%home_dir%/apr-1_7_0" "$(GetInstallMethod "apr-util-1.6.1.tar.gz")"
        @rem FixApachePkg
        call %auto_install_func% install_package apache_1.3.42.tar.gz           "%home_dir%"  "" "$(GetInstallMethod "apache_1.3.42.tar.gz")"
        call %auto_install_func% install_package httpd-2.4.54.tar.gz            "%home_dir%"  "--with-apr=%home_dir%/apr-1_7_0 --enable-module=most --enable-mods-shared=all --enable-so --enable-include --enable-headers" "$(GetInstallMethod "httpd-2.4.54.tar.gz")" 
        call %auto_install_func% install_package php-8.1.10-src.zip             "%home_dir%"  "--with-apxs2=%home_dir%/httpd-2_4_54/bin/apxs --with-openssl-dir=%home_dir%/openssl-3_0_5 --with-curl=%home_dir%/curl-7_84_0" ""
        @rem PhpSslModule #<?php phpinfo() ?>
        @rem PhpCurlModule
        @rem GenComposerInstaller
        call %auto_install_func% install_package xdebug-3.1.5.tar.gz "%home_dir%" "--enable-xdebug --enable-xdebug-dev"
    popd
goto :eof
