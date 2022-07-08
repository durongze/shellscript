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

#TarXFFile "xz-5.2.5.tar.gz" "${HOME}/opt"
#TarXFFile "libxml2-2.9.14.tar.xz" "${HOME}/opt" "" "$(GetInstallMethod "libxml2-2.9.14.tar.xz")"
#CopyPcFile "libxml2-2.9.14.tar.xz" "${HOME}/opt"
#TarXFFile "sqlite-autoconf-3390000.tar.gz" "${HOME}/opt"
#TarXFFile "curl-7.84.0.tar.gz" "${HOME}/opt"
#TarXFFile "lua-5.4.4.tar.gz" "${HOME}/opt"  #INSTALL_TOP=${HOME}/opt/lua54
#TarXFFile "apr-1.7.0.tar.gz" "${HOME}/opt"  "" "$(GetInstallMethod "apr-1.7.0.tar.gz")"
#TarXFFile "expat-2.4.8.tar.gz" "${HOME}/opt"  "" "$(GetInstallMethod "expat-2.4.8.tar.gz")"
#TarXFFile "apr-util-1.6.1.tar.gz" "${HOME}/opt"  "--with-apr=${HOME}/opt/apr-1_7_0" "$(GetInstallMethod "apr-util-1.6.1.tar.gz")"
#FixApachePkg
#TarXFFile "apache_1.3.42.tar.gz" "${HOME}/opt"  "" "$(GetInstallMethod "apache_1.3.42.tar.gz")"
#TarXFFile "httpd-2.4.54.tar.gz" "${HOME}/opt" "--with-apr=${HOME}/opt/apr-1_7_0 --enable-module=most --enable-mods-shared=all --enable-so --enable-include --enable-headers" "$(GetInstallMethod "httpd-2.4.54.tar.gz")" 
TarXFFile "php-8.1.7.tar.gz" "${HOME}/opt" "--with-apxs2=/home/du/opt/httpd-2_4_54/bin/apxs" ""
