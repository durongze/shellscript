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
    set install_dir=%4
    if not exist dyzbuild (
        md dyzbuild
    )
    pushd dyzbuild
        call:color_text 4e "++++++++++++++cmake_install++++++++++++++"
        echo cmake .. -DCMAKE_INSTALL_PREFIX=%dst_dir%\%install_dir%  %cur_flags%
        cmake .. -DCMAKE_INSTALL_PREFIX=%dst_dir%\%install_dir%  %cur_flags%
        cmake --build .
    popd
    endlocal
goto :eof

:auto_gen_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%4
    if not exist dyzbuild (
        md dyzbuild
    )
    pushd dyzbuild
        call:color_text 4e "++++++++++++++auto_gen_install++++++++++++++"
        echo ./autogen.sh
        ../configure --prefix=%dst_dir%\%install_dir%  %cur_flags%
    popd
    endlocal
goto :eof

:cfg_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%4
    if not exist dyzbuild (
        md dyzbuild
    )
    pushd dyzbuild
        call:color_text 4e "++++++++++++++cfg_install++++++++++++++"
        ../configure --prefix=%dst_dir%\%install_dir%  %cur_flags%
    popd
    endlocal
goto :eof

:auto_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%dst_dir%\%src_dir%

    if not exist %src_dir% (
        echo %0 path '%src_dir%' does not exist.
        goto :eof
    )
    pushd %src_dir%
        call:color_text 4e "++++++++++++++auto_install++++++++++++++"
        if exist CMakeLists.txt ( 
            call :cmake_install %src_dir% %dst_dir% %cur_flags% %install_dir% 
        ) else if exist autogen.sh ( 
            call :auto_gen_install %src_dir% %dst_dir% %cur_flags% %install_dir% 
        ) else if exist configure ( 
            call :cfg_install %src_dir% %dst_dir% %cur_flags% %install_dir% 
        ) else (
            echo %src_dir% %dst_dir% %cur_flags% %install_dir% 
        )
    popd
    endlocal
goto :eof

:spec_install
    setlocal ENABLEDELAYEDEXPANSION
    set src_dir=%1
    set dst_dir=%2
    set cur_flags=%3
    set install_dir=%4

    if not exist %src_dir% (
        echo %0 path '%src_dir%' does not exist.
        goto :eof
    )
    pushd %src_dir%
        call:color_text 4e "++++++++++++++spec_install++++++++++++++"
        if exist CMakeLists.txt ( 
            call :cmake_install %src_dir% %dst_dir% %cur_flags% %install_dir% 
        ) else if exist autogen.sh ( 
            call :auto_gen_install %src_dir% %dst_dir% %cur_flags% %install_dir% 
        ) else if exist configure ( 
            call :cfg_install %src_dir% %dst_dir% %cur_flags% %install_dir% 
        ) else (
            echo %src_dir% %dst_dir% %cur_flags% %install_dir% 
        )
    popd
    endlocal
goto :eof

:zip_file_install
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    set DstDir=%2
    set CurFlags="%3"
    set Spec=%4
    set FileDir=lpng1637
    @rem call :get_dir_by_zip %zip_file%

    call :color_text 4e "++++++++++++++zip_file_install++++++++++++++"
    unzip -q -o %zip_file%
    if "%Spec%" == "" (
        call :spec_install %FileDir% %DstDir% %CurFlags% %Spec%
    ) else (
        call :auto_install %FileDir% %DstDir% %CurFlags%
    )
    endlocal
goto :eof

:get_dir_by_zip
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file=%1
    call :color_text 4e "++++++++++++++get_dir_by_zip++++++++++++++"
    for /f "tokens=8 delims= " %%i in ('unzip -v %zip_file%') do (
         %%~i
    )
    endlocal
goto :eof

:bat_start
    setlocal ENABLEDELAYEDEXPANSION
    call :zip_file_install "lpng1637.zip" "F:\program" "" ""
    endlocal
goto :eof








