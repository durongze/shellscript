@echo off

set VisualStudioCmd="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

@rem VS140COMNTOOLS
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

@rem VS150COMNTOOLS

@rem VS160COMNTOOLS
set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

@rem VS170COMNTOOLS
set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"

set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set VS143COMNTOOLS="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

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
@rem set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-bin.zip
@rem set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-lib.zip
@rem set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-dep.zip
set tools_addr=%tools_addr%;https://www.7-zip.org/a/lzma2201.7z

set software_urls=https://udomain.dl.sourceforge.net/project/libpng/libpng16/1.6.37/lpng1637.zip
set software_urls=%software_urls%;http://www.zlib.net/zlib1212.zip
set software_urls=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz

set build_type=Release

set include=%all_inc%;%include%;%tools_dir%\include;
set lib=%all_lib%;%lib%;%tools_dir%\lib;%tools_dir%\bin;
set path=%all_bin%;%path%;%tools_dir%\bin;

set ProgramDir=F:\program
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set cur_dir=%~dp0
set cur_dir=%cur_dir:~0,-1%
set software_dir=%cur_dir%\
set tools_dir=%cur_dir%\tools_dir
set home_dir=%cur_dir%\..\out\windows

CALL %VisualStudioCmd%

call :gen_all_env %software_dir% %home_dir% all_inc all_lib all_bin
@rem call :get_suf_sub_str %cur_dir% \ proj_name
@rem call :get_last_char_pos %cur_dir% \ char_pos

call :bat_main "%tools_addr%" "%tools_dir%"  %home_dir%  "%software_urls%" "%software_dir%"
@rem call :install_boost1830  "debug"  "64"  "%home_dir%"

pause
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
    set src_dir=%~1
    set dst_dir=%~2
    set cur_flags=%~3
    set install_dir=%dst_dir%/%src_dir%
    if not exist dyzbuild (
        md dyzbuild
    ) else (
        del dyzbuild/*.* /s /q
    )
    call:color_text 2f "++++++++++++++cmake_install++++++++++++++"
    echo %0 %src_dir% %dst_dir% %cur_flags% %install_dir%
    pushd dyzbuild
        echo cmake .. -DCMAKE_INSTALL_PREFIX=%install_dir%  %cur_flags%
        cmake .. -DCMAKE_INSTALL_PREFIX=%install_dir%  %cur_flags%
        cmake --build . --config %build_type%
        cmake --install .
    popd
    endlocal
goto :eof

:auto_gen_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%~1
    set dst_dir=%~2
    set cur_flags=%~3
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
    set src_dir=%~1
    set dst_dir=%~2
    set cur_flags=%~3
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
    set src_dir="%~1"
    set dst_dir="%~2"
    set cur_flags="%~3"

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
    set src_dir="%~1"
    set dst_dir="%~2"
    set cur_flags="%~3"

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
    set zip_file="%~1"
    set DstDir="%~2"
    set CurFlags="%~3"
    set Spec="%~4"
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
    set tar_file="%~1"
    set DstDir="%~2"
    set CurFlags="%~3"
    set Spec="%~4"
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
    set tar_file="%~1"
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
    set zip_file="%~1"
    call :color_text 2f "++++++++++++++get_dir_by_zip++++++++++++++"
    @rem for /f "tokens=8 delims= " %%i in ('unzip -v %zip_file%') do ( echo %%~i )
    set FileDir=
    set file_name=
    @rem unzip -v %zip_file% | gawk -F" "  "{ print $8 } " | gawk  -F"/" "{ print $1 }" | sed -n "5p"
    echo zip_file:%zip_file%
    FOR /F "usebackq" %%i IN (` unzip -v %zip_file% ^| gawk -F" "  "{ print $8 } " ^| gawk  -F"/" "{ print $1 }" ^| sed -n "5p" `) DO (set FileDir=%%i)
    FOR /F "usebackq" %%i IN (` unzip -v %zip_file% ^| gawk -F" "  "{print $8}" ^| grep -v "/[^$]" ^| gawk  -F"/" "{ print $1 }" ^| sed -n "5p" `) DO (set FileDir=%%i)
    @rem echo zip_file:%zip_file% FileDir:!FileDir!
    call :is_contain %zip_file% %FileDir% file_name
    if "%file_name%" == "false" (
        call :color_text 4f "-------------get_dir_by_zip--------------"
        echo zip_file:%zip_file% FileDir:%FileDir%
        pause
    )
    endlocal & set %~2=%FileDir%
goto :eof

:gen_env_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file="%~1"
    set HomeDir=%~2
    set FileDir=

    call :get_pre_sub_str !zip_file! . file_name
    call :get_last_char_pos !zip_file! . ext_name_pos
    echo file_name:!file_name! ext_name_pos:!ext_name_pos!
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
    set tools_dir="%~1"
    set home_dir="%~2"
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

:show_all_env
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f "++++++++++++++show_all_env++++++++++++++"
    echo all_inc:%all_inc%
    echo all_lib:%all_lib%
    echo all_bin:%all_bin%
    endlocal
goto :eof

:get_str_len
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set mystrlen="%~2"
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

:get_first_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set char_pos="%~3"
    call :get_str_len %mystr% mystrlen
    set count=0
    call :color_text 2f "++++++++++++++get_first_char_pos++++++++++++++"
    :intercept_first_char_pos
    for /f %%i in ("%count%") do (
        set /a count+=1	
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            goto :intercept_first_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_last_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set char_pos="%~3"
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_last_char_pos++++++++++++++"
    @rem set /a count-=1	
    :intercept_last_char_pos
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a count-=1			
            goto :intercept_last_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_pre_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set mysubstr="%~3"
    call :get_str_len %mystr% mystrlen
    set count=0
    call :color_text 2f "++++++++++++++get_pre_sub_str++++++++++++++"
    set substr=
    :intercept_pre_sub_str
    for /f %%i in ("%count%") do (
        set /a count+=1
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=%%i
            set substr=!mystr:~0,%%i!
            if "%count%" == "%mystrlen%" (
                goto :pre_sub_str_break
            )
            goto :intercept_pre_sub_str
        ) else (
            set /a mysubstr_len=%%i
            set substr=!mystr:~0,%%i!
            goto :pre_sub_str_break
        )
    )
    :pre_sub_str_break
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof

:get_suf_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set mysubstr="%~3"
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_suf_sub_str++++++++++++++"
    set substr=
    :intercept_suf_sub_str
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=!mystrlen! - %%i
            set substr=!mystr:~%%i!
            set /a count-=1	
            goto :intercept_suf_sub_str
        )
    )
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof

:is_contain
    setlocal ENABLEDELAYEDEXPANSION
    set mystr="%~1"
    set mysubstr="%~2"
    set ret=false
    call :color_text 2f "++++++++++++++is_contain++++++++++++++"
    @rem echo " echo %mystr% | findstr %mysubstr% > nul && set ret=true "
    echo %mystr% | findstr %mysubstr% > nul && set ret=true
    echo %0 %mystr% %mysubstr% %ret%
    endlocal & set %~3=%ret%
goto :eof

:download_package
    setlocal ENABLEDELAYEDEXPANSION
    set tools_addr="%~1"
    set tools_dir="%~2"
    call :color_text 2f "++++++++++++++download_package++++++++++++++"
    echo %tools_addr%    %tools_dir%
    if not exist %tools_dir% (
        md %tools_dir%
    )
    pushd %tools_dir%
    for %%i in ( %tools_addr% ) do (
        set tool_file=%%i
        call :get_last_char_pos !tool_file! / char_pos
        echo tool_file:!char_pos!:!tool_file!
        call :get_suf_sub_str !tool_file! / file_name
        echo file_name:!file_name!
        if not exist !file_name! (
            wget %%i
        )
        unzip -q -o !file_name!
    )
    popd
    endlocal
goto :eof

:install_package
    setlocal ENABLEDELAYEDEXPANSION
    set package_name="%~1"
    set home_dir="%~2"
    call :color_text 2f "++++++++++++++install_package++++++++++++++"
    echo %package_name% 
    if not exist %package_name% (
        echo %package_name% does not exist!
        goto :eof
    )
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
    set tools_addr="%~1"
    set tools_dir="%~2"
    set home_dir="%~3"
    set soft_addr="%4"
    set soft_dir="%5"
    call :color_text 2f "++++++++++++++bat_start++++++++++++++"
    echo %tools_addr%    %tools_dir%
    @rem call :download_package "%tools_addr%" "%tools_dir%"
    if not exist %tools_dir% (
        md %tools_dir%
    )
    pushd %soft_dir%
    for /f %%i in ( 'dir /b *.zip' ) do (
        set zip_file=%%i
        call :zip_file_install  !zip_file!  !home_dir!  "-DCMAKE_BUILD_TYPE=!build_type!"  ""
    )
    popd
    endlocal
goto :eof

:bat_main
    setlocal ENABLEDELAYEDEXPANSION
    set tools_addr="%1"
    set tools_dir="%2"
    set home_dir=%3
    set soft_addr="%4"
    set soft_dir="%5"

    call :color_text 2f "++++++++++++++bat_main++++++++++++++"
    pushd %soft_dir%%
    call :zip_file_install  "protobuf-3.21.9.zip"  !home_dir!  " -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=!build_type!  -DBUILD_SHARED_LIBS=ON -DPROTOBUF_USE_DLLS=ON"  ""
    @rem call :zip_file_install  "gflags-2.2.2.zip"  !home_dir!  " -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=!build_type!"  ""
    @rem call :zip_file_install  "glog-0.6.0.zip"  !home_dir!  "-DCMAKE_BUILD_TYPE=!build_type!"  ""
    @rem call :zip_file_install  "snappy-1.1.10.zip"  !home_dir!  "  -DSNAPPY_BUILD_TESTS=OFF -DSNAPPY_BUILD_BENCHMARKS=OFF  -DCMAKE_BUILD_TYPE=!build_type!"  ""
    call :color_text 4f "++++++++++++++bat_main++++++++++++++"
    echo hdf5-hdf5-1_12_2   option (HDF5_BUILD_CPP_LIB  "Build HDF5 C++ Library" ON)
    @rem call :zip_file_install  "hdf5-hdf5-1_12_2.zip"  !home_dir!  " -DCMAKE_BUILD_TYPE=!build_type!  -DHDF5_BUILD_CPP_LIB=ON "  ""
    @rem call :zip_file_install  "leveldb-1.23.zip"  !home_dir!  "  -DLEVELDB_BUILD_TESTS=OFF -DLEVELDB_BUILD_BENCHMARKS=OFF  -DCMAKE_BUILD_TYPE=!build_type!"  ""
    @rem call :zip_file_install  "lmdb-LMDB_0.9.29.zip"  !home_dir!  "-DCMAKE_BUILD_TYPE=!build_type!"  ""
    @rem call :zip_file_install  "OpenBLAS-0.3.23.zip"  !home_dir!  "-DCMAKE_BUILD_TYPE=!build_type!"  ""
    @rem call :zip_file_install  "opencv-3.4.19.zip"  !home_dir!  "  -DWITH_CUDA=OFF  -DCMAKE_BUILD_TYPE=!build_type!"  ""
    popd

    endlocal
goto :eof

:install_boost
    setlocal ENABLEDELAYEDEXPANSION
    set BuildType="%~1"
    set BitNum="%~2"
    set HomeDir="%~3"
    call :color_text 2f "++++++++++++++install_boost++++++++++++++"
    @rem unzip  -q  boost_1_74_0.zip
    @rem vs2008 <-> toolset=msvc-9.0
    @rem vs2010 <-> toolset=msvc-10.0
    @rem vs2013 <-> toolset=msvc-12.0
    @rem vs2015 <-> toolset=msvc-14.0
    @rem vs2017 <-> toolset=msvc-15.0
    @rem vs2019 <-> toolset=msvc-16.0
    @rem vs2022 <-> toolset=msvc-17.0
    pushd boost_1_74_0
        if exist .\b2.exe (
            .\b2.exe install --prefix="%HomeDir%/boost_1_74_0/" --build-type=complete --toolset=msvc-17.0 variant=%BuildType%  link=shared threading=multi runtime-link=shared address-model=%BitNum%
        ) else (
            echo .\b2.exe doesn't exist!
        )
        if exist .\bootstrap.bat (
            .\bootstrap.bat vc142
        ) else (
            echo .\bootstrap.bat doesn't exist!
        )
        if exist .\b2.exe (
            .\b2.exe install --prefix="%HomeDir%/boost_1_74_0/" --build-type=complete --toolset=msvc-17.0 variant=%BuildType%  link=shared threading=multi runtime-link=shared address-model=%BitNum%
        ) else (
            echo .\b2.exe doesn't exist!
        )
        echo BuildType=%BuildType%, BitNum=%BitNum%
        set BuildDir=%BuildType%_win%BitNum%
    popd
    endlocal
goto :eof

:install_boost1830
    setlocal ENABLEDELAYEDEXPANSION
    set BuildType="%~1"
    set BitNum="%~2"
    set HomeDir="%~3"
    call :color_text 2f "++++++++++++++install_boost++++++++++++++"
    @rem unzip  -q  boost_1_83_0.zip
    @rem vs2008 <-> toolset=msvc-9.0
    @rem vs2010 <-> toolset=msvc-10.0
    @rem vs2013 <-> toolset=msvc-12.0
    @rem vs2015 <-> toolset=msvc-14.0
    @rem vs2017 <-> toolset=msvc-15.0
    @rem vs2019 <-> toolset=msvc-16.0
    @rem vs2022 <-> toolset=msvc-17.0  @rem 143
    pushd boost_1_83_0
        if exist .\b2.exe (
            .\b2.exe install --prefix="%HomeDir%/boost_1_83_0/" --build-type=complete --toolset=msvc-14.3 variant=%BuildType%  link=shared threading=multi runtime-link=shared address-model=%BitNum%
        ) else (
            echo .\b2.exe doesn't exist!
        )
        if exist .\bootstrap.bat (
            .\bootstrap.bat vc143
        ) else (
            echo .\bootstrap.bat doesn't exist!
        )
        echo BuildType=%BuildType%, BitNum=%BitNum%
        set BuildDir=%BuildType%_win%BitNum%
    popd
    endlocal
goto :eof
