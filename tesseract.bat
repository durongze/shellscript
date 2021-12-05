@echo off
goto:bat_start

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
    call:color_text 4e "++++++++++++++cmake_install++++++++++++++"
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
    call:color_text 4e "++++++++++++++auto_gen_install++++++++++++++"
    pushd dyzbuild
        echo ./autogen.sh
        ../configure --prefix=%install_dir%  %cur_flags%
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
    call:color_text 4e "++++++++++++++cfg_install++++++++++++++"
    pushd dyzbuild
        ../configure --prefix=%install_dir%  %cur_flags%
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
    call:color_text 4e "++++++++++++++auto_install++++++++++++++"
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

:spec_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3

    if not exist %src_dir% (
        echo %0 path '%src_dir%' does not exist.
        goto :eof
    )
    call:color_text 4e "++++++++++++++spec_install++++++++++++++"
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

    call :color_text 4e "++++++++++++++zip_file_install++++++++++++++"
    echo %0 %FileDir% %DstDir% %CurFlags% %Spec%
    unzip -q -o %zip_file%
    if %Spec% == "" (
        call :auto_install %FileDir% %DstDir% %CurFlags%
    ) else (
        call :spec_install %FileDir% %DstDir% %CurFlags% %Spec%
    )
    endlocal
goto :eof

:get_dir_by_zip
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    call :color_text 4e "++++++++++++++get_dir_by_zip++++++++++++++"
    @rem for /f "tokens=8 delims= " %%i in ('unzip -v %zip_file%') do ( echo %%~i )
    set FileDir=
    @rem unzip -v %zip_file% | gawk -F" "  "{ print $8 } " | gawk  -F"/" "{ print $1 }" | sed -n "4p"
    echo zip_file:%zip_file%
    FOR /F "usebackq" %%i IN (` unzip -v %zip_file% ^| gawk -F" "  "{ print $8 } " ^| gawk  -F"/" "{ print $1 }" ^| sed -n "4p" `) DO ( set FileDir=%%i )
    echo FileDir:!FileDir!
    echo FileDir:%FileDir%
    endlocal  & set %~2=%FileDir%
goto :eof

:gen_env_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    set DstDir=%2
    set FileDir=
    call :get_dir_by_zip %zip_file% FileDir
    call :color_text 4e "++++++++++++++gen_env_by_file++++++++++++++"
    echo %0 %zip_file% %DstDir% %FileDir%
    set include=%DstDir%/%FileDir%/include;%include%
    set lib=%DstDir%/%FileDir%/lib;%lib%
    endlocal
goto :eof

:gen_all_env
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 4e "++++++++++++++gen_all_env++++++++++++++"
    for /f %%i in ( 'dir /b z*.zip' ) do (
        set zip_file=%%i
        call :gen_env_by_file "!zip_file!" "F:/program/"
    )
    endlocal
goto :eof

:bat_start
    setlocal ENABLEDELAYEDEXPANSION
    call :gen_all_env
    call :color_text 4e "++++++++++++++bat_start++++++++++++++"
    for /f %%i in ( 'dir /b z*.zip' ) do (
        set zip_file=%%i
        call :zip_file_install  !zip_file!  F:/program  "-DCMAKE_BUILD_TYPE=Debug"  ""
    )
    endlocal
goto :eof

@rem https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-bin.zip
@rem https://udomain.dl.sourceforge.net/project/gnuwin32/tar/1.13-1/tar-1.13-1-bin.zip
@rem https://udomain.dl.sourceforge.net/project/gnuwin32/unrar/3.4.3/unrar-3.4.3-bin.zip
@rem https://udomain.dl.sourceforge.net/project/gnuwin32/unzip/5.51-1/unzip-5.51-1-bin.zip
@rem https://udomain.dl.sourceforge.net/project/gnuwin32/gawk/3.1.6-1/gawk-3.1.6-1-bin.zip
@rem https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-bin.zip
@rem https://udomain.dl.sourceforge.net/project/gnuwin32/grep/2.5.4/grep-2.5.4-bin.zip








