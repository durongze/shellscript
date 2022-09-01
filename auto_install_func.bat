
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
@rem call:bat_start "%tools_addr%" "%tools_dir%"
@rem call:bat_start "%software_urls%" "%software_dir%"
call:gen_all_env %software_dir% %home_dir% all_inc all_lib all_bin
echo all_inc:%all_inc%
echo all_lib:%all_lib%
echo all_bin:%all_bin%
set include=%all_inc%;%include%
set lib=%all_lib%;%lib%
set path=%all_bin%;%path%
@rem call:php_server_install "%software_dir%" E:\program

goto :eof

@rem YellowBackground    6f  ef
@rem BlueBackground      9f  bf   3f
@rem GreenBackground     af  2f
@rem RedBackground       4f  cf
@rem GreyBackground      7f  8f
@rem PurpleBackground    5f

:color_text
    setlocal EnableDelayedExpansion
    for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
        set "DEL=%%a"
    )
    echo off
    <nul set /p ".=%DEL%" > "%~2"
    findstr /v /a:%1 /R "^$" "%~2" nul
    del "%~2" > nul 2>&1
    endlocal
    echo .
goto :eof

:cmake_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%dst_dir%/%src_dir%
    if not exist dyzbuild (
        md dyzbuild
    )
    call:color_text 2f "++++++++++++++cmake_install++++++++++++++"
    echo %0 %src_dir% %dst_dir% %cur_flags% %install_dir%
    pushd dyzbuild
        echo cmake .. -DCMAKE_INSTALL_PREFIX=%install_dir%  %cur_flags%
        cmake .. -DCMAKE_INSTALL_PREFIX=%install_dir%  %cur_flags%
        cmake --build .
        cmake --install .
    popd
    endlocal
goto :eof

:auto_gen_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%dst_dir%\%src_dir%
    if not exist dyzbuild (
        md dyzbuild
    )
    call:color_text 2f "++++++++++++++auto_gen_install++++++++++++++"
    pushd dyzbuild
        ..\autogen.sh
        ..\configure --prefix=%install_dir%  %cur_flags%
    popd
    endlocal
goto :eof

:cfg_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%dst_dir%\%src_dir%
    if not exist dyzbuild (
        md dyzbuild
    )
    call:color_text 2f "++++++++++++++cfg_install++++++++++++++"
    pushd dyzbuild
        ..\configure --prefix=%install_dir%  %cur_flags%
    popd
    endlocal
goto :eof

:auto_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3

    if not exist %src_dir% (
        echo %0 path '%src_dir%' does not exist.
        goto :eof
    )
    call:color_text 2f "++++++++++++++auto_install++++++++++++++"
    echo %0 %src_dir% %dst_dir% %cur_flags%
    pushd %src_dir%
        if exist CMakeLists.txt (
            call :cmake_install %src_dir% %dst_dir% %cur_flags%
        ) else (
            call:color_text 6f "++++++++++++++auto_install++++++++++++++"
            echo skip %src_dir% %dst_dir% %cur_flags%
        )
goto :to_skip
        else if exist autogen.sh (
            call :auto_gen_install %src_dir% %dst_dir% %cur_flags%
        ) else if exist configure (
            call :cfg_install %src_dir% %dst_dir% %cur_flags%
        ) else if exist config (
            copy config configure /Y
            call :cfg_install %src_dir% %dst_dir% %cur_flags%
        )
:to_skip
    popd
    endlocal
goto :eof

:spec_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3

    if not exist %src_dir% (
        echo %0 path '%src_dir%' does not exist.
        goto :eof
    )
    call:color_text 2f "++++++++++++++spec_install++++++++++++++"
    echo %0 %src_dir% %dst_dir% %cur_flags%
    pushd %src_dir%
        if exist CMakeLists.txt (
            call :cmake_install %src_dir% %dst_dir% %cur_flags%
        ) else if exist autogen.sh (
            call :auto_gen_install %src_dir% %dst_dir% %cur_flags%
        ) else if exist configure (
            call :cfg_install %src_dir% %dst_dir% %cur_flags%
        ) else (
            echo %src_dir% %dst_dir% %cur_flags%
        )
    popd
    endlocal
goto :eof

:zip_file_install
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    set DstDir=%2
    set CurFlags=%3
    set Spec=%4
    set FileDir=
    call :get_dir_by_zip %zip_file% FileDir

    call :color_text 2f "++++++++++++++zip_file_install++++++++++++++"
    echo %0 %FileDir% %DstDir% %CurFlags% %Spec%
    if not exist %zip_file% (
        echo %zip_file% does not exist!
    )
    unzip -q -o %zip_file%
    if %Spec% == "" (
        call :auto_install %FileDir% %DstDir% %CurFlags%
    ) else (
        call :spec_install %FileDir% %DstDir% %CurFlags% %Spec%
    )
    endlocal
goto :eof

:tar_file_install
    setlocal ENABLEDELAYEDEXPANSION
    set tar_file=%1
    set DstDir=%2
    set CurFlags=%3
    set Spec=%4
    set FileDir=
    call :get_dir_by_tar %tar_file% FileDir

    call :color_text 2f "++++++++++++++tar_file_install++++++++++++++"
    echo %0 %FileDir% %DstDir% %CurFlags% %Spec%
    if not exist %tar_file% (
        echo %tar_file% does not exist!
    )
    tar -xf %tar_file%
    if %Spec% == "" (
        call :auto_install %FileDir% %DstDir% %CurFlags%
    ) else (
        call :spec_install %FileDir% %DstDir% %CurFlags% %Spec%
    )
    endlocal
goto :eof

:get_dir_by_tar
    setlocal ENABLEDELAYEDEXPANSION
    set tar_file=%1
    call :color_text 2f "++++++++++++++get_dir_by_tar++++++++++++++"
    @rem for /f "tokens=8 delims= " %%i in ('tar -tf %tar_file%') do ( echo %%~i )
    set FileDir=
    set file_name=
    echo "    tar -tf %tar_file% | grep "/$" | gawk -F"/" "{ print $1 }" | sed -n "1p"    "
    FOR /F "usebackq" %%i IN (` tar -tf %tar_file% ^| grep "/$" ^| gawk -F"/" "{print $1}" ^| sed -n "1p" `) DO (set FileDir=%%i)
    @rem echo tar_file:%tar_file% FileDir:!FileDir!
    call :is_contain %tar_file% %FileDir% file_name
    if "%file_name%" == "false" (
        call :color_text 4f "-------------get_dir_by_tar--------------"
        echo tar_file:%tar_file% FileDir:%FileDir%
    )
    endlocal & set %~2=%FileDir%
goto :eof

:get_dir_by_zip
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    call :color_text 2f "++++++++++++++get_dir_by_zip++++++++++++++"
    @rem for /f "tokens=8 delims= " %%i in ('unzip -v %zip_file%') do ( echo %%~i )
    set FileDir=
    set file_name=
    echo "    unzip -v %zip_file% | gawk -F" "  "{ print $8 } " | gawk  -F"/" "{ print $1 }"    "
    FOR /F "usebackq" %%i IN (` unzip -v %zip_file% ^| gawk -F" "  "{ print $8 } " ^| gawk  -F"/" "{ print $1 }" ^| sed -n "5p" `) DO ( set FileDir=%%i )
    @rem echo zip_file:%zip_file% FileDir:!FileDir!
    call :is_contain "%zip_file%" "%FileDir%" file_name
    if "%file_name%" == "false" (
        call :color_text 4f "-------------get_dir_by_zip--------------"
        echo zip_file:%zip_file% FileDir:%FileDir%
    )
    endlocal & set %~2=%FileDir%
goto :eof

:gen_env_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    set HomeDir=%2
    set FileDir=
    
    call :get_suf_sub_str !zip_file! . ext_name
    echo ext_name:!ext_name!
    if "%ext_name%" == "zip" (
        call :get_dir_by_zip %zip_file% FileDir
    ) else if "%ext_name%" == "gz" (
        call :get_dir_by_tar %zip_file% FileDir
    ) else if "%ext_name%" == "xz" (
        call :get_dir_by_tar %zip_file% FileDir
    ) else (
        echo "%ext_name%"
    )
    call :color_text 9f "++++++++++++++gen_env_by_file++++++++++++++"
    set DstDirWithHome=%HomeDir%\%FileDir%
    echo %0 %zip_file% %DstDirWithHome%
    endlocal & set %~3=%DstDirWithHome%
goto :eof

:gen_all_env
    setlocal ENABLEDELAYEDEXPANSION
    set tools_dir=%1
    set home_dir=%2
    set DstDirWithHome=
    call :color_text 2f "++++++++++++++gen_all_env++++++++++++++"
    pushd %tools_dir%
        for /f %%i in ( 'dir /b *.tar.* *.zip' ) do (
            set tar_file=%%i
            call :gen_env_by_file !tar_file! !home_dir! DstDirWithHome
            set inc=!DstDirWithHome!/include;!inc!
            set lib=!DstDirWithHome!/lib;!lib!
            set bin=!DstDirWithHome!/bin;!bin!
        )
    popd
    call :color_text 9f "++++++++++++++gen_all_env++++++++++++++"
    echo inc:%inc%
    echo lib:%lib%
    echo bin:%bin%
    endlocal & set %~3=%inc% & set %~4=%lib% & set %~5=%bin%
goto :eof

:get_str_len
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set mystrlen=%2
    set count=0
    call :color_text 2f "++++++++++++++get_str_len++++++++++++++"
    :intercept_str_len
    set /a count+=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="" (
            goto :intercept_str_len
        )
    )
    echo %0 %mystr% %count%
    endlocal & set %~2=%count%
goto :eof

:get_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set char_sym=%2
    set char_pos=%3
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_char_pos++++++++++++++"
    :intercept_char_pos
    set /a count-=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            goto :intercept_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_suf_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set char_sym=%2
    set mysubstr=%3
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_suf_sub_str++++++++++++++"
    set substr=
    :intercept_sub_str
    set /a count-=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=!mystrlen! - %%i
            set substr=!mystr:~%%i!
            goto :intercept_sub_str
        )
    )
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof

:is_contain
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set mysubstr=%2
    set ret=false
    call :color_text 2f "++++++++++++++is_contain++++++++++++++"
    @rem echo " echo %mystr% | findstr %mysubstr% > nul && set ret=true "
    echo %mystr% | findstr %mysubstr% > nul && set ret=true
    echo %0 %mystr% %mysubstr% %ret%
    endlocal & set %~3=%ret%
goto :eof

:download_package
    setlocal ENABLEDELAYEDEXPANSION
    set tools_addr="%1"
    set tools_dir="%2"
    call :color_text 2f "++++++++++++++download_package++++++++++++++"
    echo %tools_addr%    %tools_dir%
    if not exist %tools_dir% (
        md %tools_dir%
    )
    pushd %tools_dir%
    for %%i in ( %tools_addr% ) do (
        set tool_file=%%i
        call :get_char_pos !tool_file! / char_pos
        echo tool_file:!char_pos!:!tool_file!
        call :get_suf_sub_str !tool_file! / file_name
        echo file_name:!file_name!
        if not exist !file_name! (
            wget %%i
        )
        @rem unzip -q -o !file_name!
    )
    popd
    endlocal
goto :eof

:install_package
    setlocal ENABLEDELAYEDEXPANSION
    set package_name=%1
    set home_dir=%2
    call :color_text 2f "++++++++++++++install_package++++++++++++++"
    echo %package_name% 
    call :get_suf_sub_str !package_name! . ext_name
    echo ext_name:!ext_name!
    if "%ext_name%" == "zip" (
        call :zip_file_install  !package_name!  !home_dir!  "-DCMAKE_BUILD_TYPE=%build_type%"  ""
    ) else if "%ext_name%" == "gz" (
        call :tar_file_install  !package_name!  !home_dir!  "-DCMAKE_BUILD_TYPE=%build_type%"  ""
    ) else if "%ext_name%" == "xz" (
        call :tar_file_install  !package_name!  !home_dir!  "-DCMAKE_BUILD_TYPE=%build_type%"  ""
    ) else (
        echo "%ext_name%"
    )
    endlocal
goto :eof

:bat_start
    setlocal ENABLEDELAYEDEXPANSION
    set tools_addr="%1"
    set tools_dir="%2"
    set home_dir=%3
    call :color_text 2f "++++++++++++++bat_start++++++++++++++"
    echo %tools_addr%    %tools_dir%
    @rem call :download_package "%tools_addr%" "%tools_dir%"
    if not exist %tools_dir% (
        md %tools_dir%
    )
    pushd %tools_dir%
    for /f %%i in ( 'dir /b *.zip' ) do (
        set zip_file=%%i
        call :zip_file_install  !zip_file!  %home_dir%  "-DCMAKE_BUILD_TYPE=%build_type%"  ""
    )
    for /f %%i in ( 'dir /b *.tar.*' ) do (
        set tar_file=%%i
        call :tar_file_install  !tar_file!  %home_dir%  "-DCMAKE_BUILD_TYPE=%build_type%"  ""
    )
    popd
    endlocal
goto :eof

:php_server_install
    set tools_dir=%1
    set home_dir=%2
    pushd %tools_dir%
        call:install_package xz-5.2.5.tar.gz       "%home_dir%"
        call:install_package libiconv-1.17.tar.gz  "%home_dir%" 
        call:install_package libxml2-2.9.14.tar.gz "%home_dir%" "" "$(GetInstallMethod "libxml2-2.9.14.tar.xz")"
        @rem CopyPcFile "libxml2-2.9.14.tar.gz"    "%home_dir%"
        call:install_package sqlite-autoconf-3390000.tar.gz "%home_dir%"
        call:install_package openssl-3.0.5.tar.gz           "%home_dir%"
        call:install_package curl-7.84.0.tar.gz             "%home_dir%"
        call:install_package lua-5.4.4.tar.gz               "%home_dir%"  #INSTALL_TOP=%home_dir%/lua54
        call:install_package apr-1.7.0.tar.gz               "%home_dir%"  "" "$(GetInstallMethod "apr-1.7.0.tar.gz")"
        call:install_package expat-2.4.8.tar.gz             "%home_dir%"  "" "$(GetInstallMethod "expat-2.4.8.tar.gz")"
        call:install_package apr-util-1.6.1.tar.gz          "%home_dir%"  "--with-apr=%home_dir%/apr-1_7_0" "$(GetInstallMethod "apr-util-1.6.1.tar.gz")"
        @rem FixApachePkg
        call:install_package apache_1.3.42.tar.gz           "%home_dir%"  "" "$(GetInstallMethod "apache_1.3.42.tar.gz")"
        call:install_package httpd-2.4.54.tar.gz            "%home_dir%"  "--with-apr=%home_dir%/apr-1_7_0 --enable-module=most --enable-mods-shared=all --enable-so --enable-include --enable-headers" "$(GetInstallMethod "httpd-2.4.54.tar.gz")" 
        call:install_package php-8.1.7.tar.gz               "%home_dir%"  "--with-apxs2=%home_dir%/httpd-2_4_54/bin/apxs --with-openssl-dir=%home_dir%/openssl-3_0_5 --with-curl=%home_dir%/curl-7_84_0" ""
        @rem PhpSslModule #<?php phpinfo() ?>
        @rem PhpCurlModule
        @rem GenComposerInstaller
        call:install_package xdebug-3.1.5.tar.gz "%home_dir%" "--enable-xdebug --enable-xdebug-dev"
    popd
goto :eof

