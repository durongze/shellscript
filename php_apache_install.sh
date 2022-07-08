#!/bin/bash

. auto_install_func.sh


GenFileNameVar "$(ls *.tar.* )"
GenEnvVar

mysql_url="https://dev.mysql.com/downloads/mysql/"
software_urls="$software_urls https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-8.0.29.tar.gz"
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


declare -A sermap=(["leptonica-1.82.0.tar.gz"]="AutoGenInstall"
                   ["icu-release-70-1.tar.gz"]="CfgInstall"
                   ["libxml2-2.9.14.tar.xz"]="CfgInstall"
                   ["apr-1.7.0.tar.gz"]="AutoGenInstall"
                   ["httpd-2.4.54.tar.gz"]="AutoGenInstall"
                   ["apr-util-1.6.1.tar.gz"]="AutoGenInstall"
				  )

function GetInstallMethod()
{
	PkgFile=$1
    Method=""
    for k in ${!sermap[@]}
    do
        if [[ "$k" == "$PkgFile" ]];then
            v=${sermap[$k]}
            Method="$v"
            break
        fi
    done
	echo $Method
}

function FixApachePkg()
{
	ApacheDir="apache_1.3.42"

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
	#+--------------------------------------------------------+
	#| You now have successfully built and installed the      |
	#| Apache 1.3 HTTP server. To verify that Apache actually |
	#| works correctly you now should first check the         |
	#| (initially created or preserved) configuration files   |
	#|                                                        |
	#|   /home/du/opt/apache_1_3_42/conf/httpd.conf
	#|                                                        |
	#| and then you should be able to immediately fire up     |
	#| Apache the first time by running:                      |
	#|                                                        |
	#|   /home/du/opt/apache_1_3_42/bin/apachectl start
	#|                                                        |
	#| Thanks for using Apache.       The Apache Group        |
	#|                                http://www.apache.org/  |
	#+--------------------------------------------------------+
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
}

function UsageComposer()
{
	ComposerFile="composer"
	echo "$ComposerFile config -g repo.packagist composer https://mirrors.aliyun.com/composer/"
	echo "$ComposerFile require jaeger/querylist"
}

function PhpSslModule()
{
	PhpSrcDir="php-8.1.7"
	PhpHomeDir=${HOME}/opt/php-8_1_7
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
	echo -e "\033[31m cp $PhpSrcDir/php.ini-development $PhpHomeDir/lib/php.ini \033[0m"
	cp $PhpSrcDir/php.ini-development $PhpHomeDir/lib/php.ini
	#sed 's#;extension_dir = ""#extension_dir = "'"${PhpHomeDir}"'/lib/php/extensions/no-debug-zts-20210902/"#g' -i $PhpHomeDir/lib/php.ini
	#sed 's#;extension=openssl#extension=openssl#g' -i $PhpHomeDir/lib/php.ini
	php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
	if [ -f composer-setup.php ];then
		mv composer-setup.php ${PhpHomeDir}/lib/php/build/composer-setup.php
		ComposerInstallerFile="composer_installer.sh"
		GenComposerInstaller "$ComposerInstallerFile"
		mv $ComposerInstallerFile ${PhpHomeDir}/bin/${ComposerInstallerFile%.*}
		echo "run ${ComposerInstallerFile%.*}, please!!!!"
		UsageComposer
	fi
}

#TarXFFile "xz-5.2.5.tar.gz" "${HOME}/opt"
#TarXFFile "libxml2-2.9.14.tar.xz" "${HOME}/opt" "" "$(GetInstallMethod "libxml2-2.9.14.tar.xz")"
#CopyPcFile "libxml2-2.9.14.tar.xz" "${HOME}/opt"
#TarXFFile "sqlite-autoconf-3390000.tar.gz" "${HOME}/opt"
#TarXFFile "openssl-3.0.5.tar.gz" "${HOME}/opt"
#TarXFFile "curl-7.84.0.tar.gz" "${HOME}/opt"
#TarXFFile "lua-5.4.4.tar.gz" "${HOME}/opt"  #INSTALL_TOP=${HOME}/opt/lua54
#TarXFFile "apr-1.7.0.tar.gz" "${HOME}/opt"  "" "$(GetInstallMethod "apr-1.7.0.tar.gz")"
#TarXFFile "expat-2.4.8.tar.gz" "${HOME}/opt"  "" "$(GetInstallMethod "expat-2.4.8.tar.gz")"
#TarXFFile "apr-util-1.6.1.tar.gz" "${HOME}/opt"  "--with-apr=${HOME}/opt/apr-1_7_0" "$(GetInstallMethod "apr-util-1.6.1.tar.gz")"
#FixApachePkg
#TarXFFile "apache_1.3.42.tar.gz" "${HOME}/opt"  "" "$(GetInstallMethod "apache_1.3.42.tar.gz")"
#TarXFFile "httpd-2.4.54.tar.gz" "${HOME}/opt" "--with-apr=${HOME}/opt/apr-1_7_0 --enable-module=most --enable-mods-shared=all --enable-so --enable-include --enable-headers" "$(GetInstallMethod "httpd-2.4.54.tar.gz")" 
#TarXFFile "php-8.1.7.tar.gz" "${HOME}/opt" "--with-apxs2=/home/du/opt/httpd-2_4_54/bin/apxs --with-openssl-dir=/opt/openssl-3_0_5" ""
#PhpSslModule #<?php phpinfo() ?>
#GenComposerInstaller
