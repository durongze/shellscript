set workdir=%cd%
set src_target=test_args.exe
set dst_dir=dst

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat"
cl.exe test_args.cc
if exist test_args.exe (
call :replace_all_cmd %workdir% %src_target%  %dst_dir%
) else (
echo "cl test_args.cc"
)
pause

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

:get_path_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set myfile=%1
    set mypath=%~dp1
    set myname=%~n1
    set myext=%~x1
    echo !mypath! !myname! !myext!
    endlocal & set %~2=%mypath%&set %~3=%myname%&set %~4=%myext%
goto :eof

:replace_all_cmd
    setlocal ENABLEDELAYEDEXPANSION
    set workdir=%1
    set src_target=%2
    set dst_dir=%3
    set mypath=
    set myname=
    set myext=
    set src_dir=srcdir
    if not exist %dst_dir% (
        mkdir %dst_dir%
    )
    if not exist %src_dir% (
        mkdir %src_dir%
    )
    pushd %workdir%
    for /f "delims=" %%i in ('dir /b "*.exe"') do (
        call :color_text af "++++++++++++++++++++++++++++++++++++++++++"
        echo %%i
        call :get_path_by_file %%i mypath myname myext
        copy %%i !src_dir!\origin_!myname!!myext!
        copy  !src_target!  !dst_dir!\!myname!!myext!
    )
    popd
    endlocal
goto :eof
