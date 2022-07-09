#!/bin/bash

. auto_install_func.sh

mysql_url="https://dev.mysql.com/downloads/mysql/"
#software_urls="$software_urls https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-8.0.29.tar.gz"
software_urls="$software_urls https://www.php.net/distributions/php-8.1.7.tar.gz"
software_urls="$software_urls https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.gz"
software_urls="$software_urls https://fossies.org/linux/www/libxml2-2.9.14.tar.xz"
software_urls="$software_urls https://tukaani.org/xz/xz-5.2.5.tar.gz"
software_urls="$software_urls https://www.sqlite.org/2022/sqlite-autoconf-3390000.tar.gz"
software_urls="$software_urls https://curl.se/download/curl-7.84.0.tar.gz" 
software_urls="$software_urls https://www.lua.org/ftp/lua-5.4.4.tar.gz" 
software_urls="$software_urls http://archive.apache.org/dist/apr/apr-1.7.0.tar.gz"
software_urls="$software_urls http://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz"
software_urls="$software_urls https://udomain.dl.sourceforge.net/project/expat/expat/2.4.8/expat-2.4.8.tar.gz"
software_urls="$software_urls https://archive.apache.org/dist/httpd/apache_1.3.42.tar.gz"
software_urls="$software_urls https://www.openssl.org/source/openssl-3.0.5.tar.gz"

function FixLuaPkg()
{
	LuaDir="lua-5.4.4"
	LuaDir="./"
	echo "sed 's#INSTALL_TOP= /usr/local#INSTALL_TOP ?= /usr/local#g' -i ${LuaDir}/Makefile"
	sed 's#INSTALL_TOP= /usr/local#INSTALL_TOP ?= /usr/local#g' -i ${LuaDir}/Makefile
}

function FixApachePkg()
{
	ApacheDir="apache_1.3.42"
	ApacheDir="./"
	ShellName=$(grep "#!/bin/sh" ${ApacheDir}/configure)
	if [ "$ShellName" != "" ];then
		echo "sed 's#!/bin/sh#!/bin/bash#g' -i ${ApacheDir}/configure"
		sed 's#!/bin/sh#!/bin/bash#g' -i ${ApacheDir}/configure
	fi
	
	HeaderFile=$(grep "#include <dlfcn.h>" ${ApacheDir}/src/os/unix/os.c)
	if [ "$HeaderFile" == "" ];then
		echo "sed '23a#include <dlfcn.h>' -i ${ApacheDir}/src/os/unix/os.c"
		sed '23a#include <dlfcn.h>' -i ${ApacheDir}/src/os/unix/os.c
	fi
    #src/os/unix/os-inline.c  #inline
    #src/os/unix/os.h         #inline
    #src/support/htpasswd.c   #getline
    #src/support/logresolve.c #getline
}

function GenComposerInstaller()
{
	ComposerInstallerFile=$1
	if [ "$1" == "" ];then
		ComposerInstallerFile="composer_installer.sh"
	fi
	echo "#!/bin/bash" > $ComposerInstallerFile
    echo "PHP_EXEC=\$(echo \$(whereis php) | cut -d':' -f2)" >> $ComposerInstallerFile
    echo "PHP_HOME_DIR=\$(dirname \${PHP_EXEC})/.." >> $ComposerInstallerFile
    echo "echo \"PHP_EXEC:\${PHP_EXEC}\"" >> $ComposerInstallerFile
    echo "echo \"PHP_HOME_DIR:\${PHP_HOME_DIR}\"" >> $ComposerInstallerFile
    echo "echo \"php \${PHP_HOME_DIR}/lib/php/build/composer.php starting...\"" >> $ComposerInstallerFile
	echo "php \${PHP_HOME_DIR}/lib/php/build/composer.php" >> $ComposerInstallerFile
	chmod +x $ComposerInstallerFile
}

function UsageComposer()
{
	HTTPD_HOME_DIR=$1
	ComposerFile="composer"
	echo "cd ${HTTPD_HOME_DIR}/htdocs"
	echo "$ComposerFile config -g repo.packagist composer https://mirrors.aliyun.com/composer/"
	echo "$ComposerFile require jaeger/querylist"
}

function ComposerInstall()
{
	PhpHomeDir=$1
	php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
	if [ -f composer-setup.php ];then
		mv composer-setup.php ${PhpHomeDir}/lib/php/build/composer-setup.php
		ComposerInstallerFile="composer_installer.sh"
		GenComposerInstaller "$ComposerInstallerFile"
		mv $ComposerInstallerFile ${PhpHomeDir}/bin/${ComposerInstallerFile%.*}
		echo "run ${ComposerInstallerFile%.*}, please!!!!"
		UsageComposer
		return 0
	else
		return 1
	fi
}

function PhpSslCfg()
{
	PhpSrcDir=$1
	PhpHomeDir=$2
	PhpIniFile="$PhpHomeDir/lib/php.ini"
	echo -e "\033[31m cp $PhpSrcDir/php.ini-development ${PhpIniFile} \033[0m"
	cp $PhpSrcDir/php.ini-development ${PhpIniFile}
	sed 's#;extension_dir = "./"#extension_dir = "'"${PhpHomeDir}"'/lib/php/extensions/no-debug-zts-20210902/"#g' -i ${PhpIniFile}
	sed 's#;extension=openssl#extension=openssl#g' -i ${PhpIniFile}
}

function PhpSslCompile()
{
	PhpSrcDir=$1
	pushd ${PhpSrcDir}/ext/openssl
		phpize
		if [ ! -f config.m4 ];then
			cp config0.m4 config.m4
		fi
		phpize
		./configure --with-openssl
		make
		make install
	popd
}

function PhpSslModule()
{
	PhpSrcDir="php-8.1.7"
	PhpHomeDir=${HOME}/opt/$(echo $PhpSrcDir | tr -s "." "_")

	PhpSslCompile "$PhpSrcDir"
	PhpSslCfg "$PhpSrcDir" "$PhpHomeDir"
	ComposerInstall "$PhpHomeDir"
	if [ $? -ne 0 ];then
		PhpIniFile="$PhpHomeDir/lib/php.ini"
		echo -e "\033[31m PhpIniFile : ${PhpIniFile} \033[0m"
	fi
}

function TarXFFile()
{
	PkgFile=$1
    CurFlags="$2"

    DstDirPrefix="${HOME}/opt"
	Method=$(GetInstallMethod "$PkgFile")

	InstallPkgFile "$PkgFile" "$DstDirPrefix" "$CurFlags" "$Method"
}

function ManInstall()
{
	#TarXFFile "xz-5.2.5.tar.gz"  ""
	#TarXFFile "libxml2-2.9.14.tar.xz" "" 
	#CopyPcFile "libxml2-2.9.14.tar.xz" ""
	#TarXFFile "sqlite-autoconf-3390000.tar.gz" ""

	OPENSSL_HOME_DIR="${HOME}/opt/openssl-3_0_5"
	#TarXFFile "openssl-3.0.5.tar.gz" ""
	#TarXFFile "curl-7.84.0.tar.gz" ""
	#TarXFFile "lua-5.4.4.tar.gz" "export INSTALL_TOP=${HOME}/opt/lua-5_4_4" #

	APR_HOME_DIR="${HOME}/opt/apr-1_7_0"
	#TarXFFile "apr-1.7.0.tar.gz"  "" 
	#TarXFFile "expat-2.4.8.tar.gz"  "" 
	#TarXFFile "apr-util-1.6.1.tar.gz"  "--with-apr=${APR_HOME_DIR}" 
	#FixApachePkg
	#TarXFFile "apache_1.3.42.tar.gz"  "" 

	HTTPD_HOME_DIR="${HOME}/opt/httpd-2_4_54"
	#TarXFFile "httpd-2.4.54.tar.gz" "--with-apr=${APR_HOME_DIR} --enable-module=most --enable-mods-shared=all --enable-so --enable-include --enable-headers"
	
	#TarXFFile "php-8.1.7.tar.gz" "--with-apxs2=${HTTPD_HOME_DIR}/bin/apxs --with-openssl-dir=${OPENSSL_HOME_DIR}" 

	PhpSslModule #<?php phpinfo() ?>
	GenComposerInstaller	
}

SoftwareDir="Download"
DownloadSoftware "$SoftwareDir" "$software_urls"
#GenEnvVarByPkgDir "$SoftwareDir"

pushd $SoftwareDir
	ManInstall
popd
