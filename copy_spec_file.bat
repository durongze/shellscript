
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

set spec_file=allcodecs.c
set spec_dir=%ProjDir%

@rem call :copy_spec_file      "%spec_file%"    "%spec_dir%"

set spec_file_list=./ffmpeg/libavdevice/alldevices.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavdevice/alldevices.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavformat/allformats.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavformat/allformats.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavcodec/allcodecs.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavcodec/allcodecs.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavcodec/parsers.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavcodec/bitstream_filter.c
set spec_file_list=%spec_file_list%;./ffmpeg/libavcodec/hwaccels.h
set spec_file_list=%spec_file_list%;./ffmpeg/libavformat/protocols.c
call :create_spec_file    "%spec_file%"    "%spec_file_list%"
pause
goto :eof

:copy_spec_file
    setlocal EnableDelayedExpansion
    set spec_file="%~1"
    set spec_dir="%~2"
    call :color_text 2f " ++++++++++++++ copy_spec_file ++++++++++++++ "
    if not exist %spec_dir% (
        echo Dir '%spec_dir%' doesn't exist!
        goto :eof
    )
    pushd %spec_dir%
        set idx=0
        for /f %%i in ( 'dir /s /b *.* ' ) do (
            set /a idx+=1
            set dst_file=%%i
            set dst_file_name=
            set dst_file_dir=
            set dst_file_ext=
            call :get_path_by_file   "!dst_file!"    dst_file_name    dst_file_dir    dst_file_ext
            echo File[!idx!]: !dst_file!    !dst_file_name!    !dst_file_dir!    !dst_file_ext!
            if "!spec_file!" == "!dst_file_name!!dst_file_ext!" (
                echo copy    "!spec_file!"    "!dst_file!"
            )
            pause
        )
    popd
    call :color_text 9f " --------------- copy_spec_file --------------- "
    endlocal
goto :eof

:create_spec_file
    setlocal EnableDelayedExpansion
    set spec_file="%~1"
    set spec_file_list=%~2
    call :color_text 2f " ++++++++++++++ create_spec_file ++++++++++++++ "

    set idx=0
    for %%i in ( %spec_file_list% ) do (
        set /a idx+=1
        set dst_file=%%i
        set dst_file_name=
        set dst_file_dir=
        set dst_file_ext=
        call :get_path_by_file   "!dst_file!"    dst_file_name    dst_file_dir    dst_file_ext
        echo File[!idx!]: dst_file=!dst_file!    dst_file_name=!dst_file_name!    dst_file_dir=!dst_file_dir!    dst_file_ext=!dst_file_ext!
        if "!spec_file!" == "!dst_file_name!!dst_file_ext!" (
            echo md      "!dst_file_dir!"
            echo copy    "!spec_file!"      "!dst_file!"
        )
        pause
    )

    call :color_text 9f " --------------- create_spec_file --------------- "
    endlocal
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

:get_path_by_file
    setlocal EnableDelayedExpansion
    set myfile=%~1
    set mypath=%~dp1
    set myname=%~n1
    set myext=%~x1
    call :color_text 2f "++++++++++++++++++ get_path_by_file ++++++++++++++++++++++++"
    echo mypath=!mypath!     myname=!myname!     myext=!myext!
    call :color_text 2f "-------------------- get_path_by_file -----------------------"
    endlocal & set %~2=%mypath%&set %~3=%myname%&set %~4=%myext%
goto :eof
