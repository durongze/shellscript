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
    echo "echo \"php \${PHP_HOME_DIR}/lib/php/build/composer-setup.php starting...\"" >> $ComposerInstallerFile
    echo "php \${PHP_HOME_DIR}/lib/php/build/composer-setup.php" >> $ComposerInstallerFile
    echo "mv $(pwd)/composer.phar ${PHP_HOME_DIR}/bin/" >> $ComposerInstallerFile
    chmod +x $ComposerInstallerFile
}

function UsageComposer()
{
    HTTPD_HOME_DIR=$1
    ComposerFile="composer.phar"
    echo "cd ${HTTPD_HOME_DIR}/htdocs"
    echo "$ComposerFile config -g repo.packagist composer https://mirrors.aliyun.com/composer/"
    echo "$ComposerFile require jaeger/querylist"
    echo "$ComposerFile require jaeger/querylist-curl-multi"
}

function PhpComposerInstall()
{
    PhpHomeDir=$1
    if [ ! -f composer-setup.php ];then
        php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
    fi

    if [ -f composer-setup.php ];then
        cp composer-setup.php ${PhpHomeDir}/lib/php/build/composer-setup.php
        ComposerInstallerFile="composer_installer.sh"
        GenComposerInstaller "$ComposerInstallerFile"
        mv $ComposerInstallerFile ${PhpHomeDir}/bin/${ComposerInstallerFile%.*}
        echo -e "\033[31m run ${ComposerInstallerFile%.*}, please!!!! \033[0m"
    else
        PhpIniFile="$PhpHomeDir/lib/php.ini"
        echo -e "\033[31m PhpIniFile : ${PhpIniFile} \033[0m"
    fi
}

function PhpSslCfg()
{
    PhpSrcDir=$1
    PhpHomeDir=$2
    PhpCaFile="$PhpHomeDir/ext/cacert.pem"  
    PhpIniFile="$PhpHomeDir/lib/php.ini"

    echo -e "\033[31m cp $PhpSrcDir/php.ini-development ${PhpIniFile} \033[0m"
    cp $PhpSrcDir/php.ini-development ${PhpIniFile}
    sed 's#;extension_dir = "./"#extension_dir = "'"${PhpHomeDir}"'/lib/php/extensions/no-debug-zts-20210902/"#g' -i ${PhpIniFile}
    grep -n "extension_dir = \"" ${PhpIniFile}
    sed 's#;extension=openssl#extension=openssl#g' -i ${PhpIniFile}
    grep -n "extension=openssl" ${PhpIniFile}
    if [ ! -f $PhpCaFile ];then
        wget https://curl.se/ca/cacert.pem
        mv cacert.pem $PhpCaFile
    fi
    sed 's#;openssl.cafile=#openssl.cafile='"${PhpCaFile}"'#g' -i ${PhpIniFile}
    grep -n "openssl.cafile=" ${PhpIniFile}
    #grep -n "127.0.0.1" /etc/hosts
    #grep -n "nameserver" /etc/resolv.conf
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
    PhpComposerInstall "$PhpHomeDir"
}

function PhpCurlModule()
{
    PhpSrcDir="php-8.1.7"
    PhpHomeDir=${HOME}/opt/php-8_1_7
    PhpMod=curl
    pushd ${PhpSrcDir}/ext/$PhpMod
        if [ ! -f config.m4 ];then
            cp config0.m4 config.m4
        fi
        phpize
        ./configure --with-$PhpMod
        make
        make install
    popd
}

function InsertCtx()
{
    Filter="$1"
    CtxFile=$2
    LineX=$3
    IsPhp=$(grep "$Filter" ${CtxFile})
    if [ "$IsPhp" == "" ] && [ "$LineX" != "" ] ;then
        echo "sed -e \"${LineX}a${Filter}\" -i ${CtxFile}"
        sed -e ''"${LineX}"'a'"${Filter}"'' -i ${CtxFile}
    else
        echo " CtxFile <$Filter> <$LineX> : ${CtxFile}"
        grep -n "$Filter" ${CtxFile}
    fi
}

function GenPhpPage()
{
    HTTPD_HOME_DIR=$1
    HTTPD_PHP_PAGE=${HTTPD_HOME_DIR}/htdocs/index.php 
    echo "<?php phpinfo(); ?>" > ${HTTPD_PHP_PAGE}
    echo "<?php " >> ${HTTPD_PHP_PAGE}
    echo "    require \"vendor/autoload.php\";" >> ${HTTPD_PHP_PAGE}
    echo "    use QL\\QueryList;" >> ${HTTPD_PHP_PAGE}
    echo "    use QL\\Ext\\CurlMulti;" >> ${HTTPD_PHP_PAGE}
    echo "?>" >> ${HTTPD_PHP_PAGE}
}

function HttpdCfg()
{
    HTTPD_HOME_DIR=${HOME}/opt/httpd-2_4_54
    HTTPD_CFG=${HTTPD_HOME_DIR}/conf/httpd.conf

    sed 's#    DirectoryIndex index.html#    DirectoryIndex index.php#g' -i ${HTTPD_CFG}
    LineX=$(grep -n "AddType application" ${HTTPD_CFG} | cut -d':' -f1 | awk '{ printf $NR }')
    PhpFilter="AddType application/x-httpd-php .php"
    InsertCtx "${PhpFilter}" "${HTTPD_CFG}" "$LineX"
    PhpsFilter="AddType application/x-httpd-php-source .phps"
    InsertCtx "${PhpsFilter}" "${HTTPD_CFG}" "$LineX"

    GenPhpPage "$HTTPD_HOME_DIR"
    UsageComposer "$HTTPD_HOME_DIR"
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
    
    PHP_HOME_DIR="${HOME}/opt/php-8_1_7"
    #TarXFFile "php-8.1.7.tar.gz" "--with-apxs2=${HTTPD_HOME_DIR}/bin/apxs --with-openssl-dir=${OPENSSL_HOME_DIR}" 

    PhpSslModule #<?php phpinfo() ?>
    HttpdCfg
}

SoftwareDir="Download"
DownloadSoftware "$SoftwareDir" "$software_urls"
#GenEnvVarByPkgDir "$SoftwareDir"

pushd $SoftwareDir
    ManInstall
popd
#https://blog.p2hp.com/archives/8224
#http://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2
