@rem set VSCMD_DEBUG=2

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%


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


set software_urls=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz

set build_type=Release
set BuildType=Release

set include=%all_inc%;%include%;%tools_dir%\include;
set lib=%all_lib%;%lib%;%tools_dir%\lib;%tools_dir%\bin;
set path=%all_bin%;%path%;%tools_dir%\bin;

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set TclshPath=%ProgramDir%\tcl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set SDCCPath=%ProgramDir%\SDCC\bin
set MakePath=%ProgramDir%\make-3.81-bin\bin
set PythonHome=%ProgramDir%\python\Python312
set PYTHONPATH=%PYTHONHOME%\lib;%PythonHome%;
set SwigHome=%ProgramDir%\swigwin\bin
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%SDCCPath%;%MakePath%;%PYTHONHOME%;%PYTHONHOME%\Scripts;%SwigHome%;%PATH%

set cur_dir=%~dp0
set ProjDir=%cur_dir:~0,-1%\..
echo ProjDir %ProjDir%

set software_dir=%cur_dir%\
set tools_dir=%cur_dir%\tools_dir
set home_dir=%ProjDir%\out\windows
set auto_install_func=%cur_dir%\auto_func.bat

@rem x86  or x64
call %VisualStudioCmd% x86

call %auto_install_func% gen_all_env_by_dir %software_dir% %home_dir% all_inc all_lib all_bin CMAKE_INCLUDE_PATH CMAKE_LIBRARY_PATH CMAKE_MODULE_PATH
set include=%all_inc%;%include%
set lib=%all_lib%;%lib%
set path=%all_bin%;%path%
call %auto_install_func% show_all_env

set HomeDir=%home_dir%
@rem Win32  or x64
set ArchType=x64

@rem set Iconv_LIBRARY=%tools_dir%\bin\libiconv.lib

@rem call %auto_install_func% install_all_package "%tools_addr%"    "%tools_dir%"
@rem call %auto_install_func% install_all_package "%software_urls%" "%software_dir%"
@rem call :upgrade_python_pip
call :thirdparty_lib_install "%software_dir%" %home_dir%
@rem call :del_lib_cacke_dir      "%software_dir%"

@rem call :Copy3rdLibCMakeList    %cur_dir%
pause
goto :eof

@rem objdump -S E:\program\xz-5.2.6\lib\liblzma.lib | grep -C 5 "lzma_auto_decoder"

:CopyThirdpartyLib
    setlocal ENABLEDELAYEDEXPANSION
    set thirdparty_dir=%1
    set BuildType=%~2
    set PaddleDir=%~3
    call:color_text 2f " ++++++++++++++ CopyThirdpartyLib ++++++++++++++ "
    echo PaddleDir=%PaddleDir%
    pause
    set idx=0
    pushd %thirdparty_dir%
        for /f %%i in (' dir /s /b *.lib ') do (
            set /a idx+=1
            set lib_dir=%%i
            echo [!idx!] BuildType=!BuildType!    lib_dir:!lib_dir!
            echo "!lib_dir!" | findstr /C:!BuildType! >nul
            if !errorlevel! equ 0 (
                copy  !lib_dir!    !PaddleDir!\lib\
                if !errorlevel! equ 0 (
                    echo "copy succ"
                ) else (
                    echo "copy  !lib_dir!    !PaddleDir!\lib\"
                )
            ) else (
                echo "!BuildType!---!lib_dir!" 
                pause
            )
        )
    popd
    call:color_text 9f " -------------- CopyThirdpartyLib -------------- "
    endlocal
goto :eof

:CheckDepTypeByDir
    setlocal EnableDelayedExpansion
    set LibTopDir=%~1
    call :color_text 2f " +++++++++++++++++++ CheckDepTypeByDir +++++++++++++++++++ "
    echo LibTopDir:%LibTopDir%
    set idx=0
    for /f %%i in ('dir /s /b "%LibTopDir%\*.lib"') do (
        set /a idx+=1
        set lib_file=%%i
        echo [!idx!]lib_file:!lib_file! 
        dumpbin /DIRECTIVES   !lib_file!  | findstr "DEFAULTLIB"
        echo dumpbin /DIRECTIVES   !lib_file!
        pause
    )
    call :color_text 2f " -------------------- CheckDepTypeByDir ----------------------- "
    endlocal
goto :eof

:CheckDepTypeMTorMD
    setlocal EnableDelayedExpansion
    set LibFile=%~1
    call :color_text 2f " +++++++++++++++++++ CheckDepTypeMTorMD +++++++++++++++++++ "
    echo LibFile:%LibFile%
    dumpbin /DIRECTIVES   %LibFile%
    call :color_text 2f " -------------------- CheckDepTypeMTorMD ----------------------- "
    endlocal
goto :eof

:CheckLibType
    setlocal EnableDelayedExpansion
    set LibFile=%~1
    call :color_text 2f " +++++++++++++++++++ CheckLibType +++++++++++++++++++ "
    echo LibFile:%LibFile%
    lib /list %LibFile%
    call :color_text 2f " -------------------- CheckLibType ----------------------- "
    endlocal
goto :eof

:Copy3rdLibCMakeList
    setlocal EnableDelayedExpansion
    set lib_dir="%~1"

    call :color_text 2f "++++++++++++++ Copy3rdLibCMakeList ++++++++++++++"
    @rem pushd %lib_dir%
        set idx=0
        for /f %%i in ( 'dir /b /ad %lib_dir%' ) do (
            set /a idx+=1
            set cur_lib_name=%%i
            set cur_lib_dir=!lib_dir!\%%i
            set cur_lib_cmake=!cur_lib_dir!\CMakeLists.txt
            set dst_lib_cmake=!cur_lib_name!CMakeLists.txt

            echo [!idx!] !cur_lib_dir!, cur_cmake:!cur_lib_cmake!, dst_cmake:!dst_lib_cmake!

            if exist "!cur_lib_cmake!" (
                copy    !cur_lib_cmake!    !dst_lib_cmake!
            ) else (
                echo file    !cur_lib_cmake!    does not exist.
            )
        )
    @rem popd
    call :color_text 2f " -------------- Copy3rdLibCMakeList --------------- "
    endlocal
goto :eof

:del_lib_cacke_dir
    setlocal EnableDelayedExpansion
    set lib_dir="%~1"
    set home_dir="%~2"
    call :color_text 2f "++++++++++++++ del_lib_cacke_dir ++++++++++++++"
    pushd %lib_dir%
        set idx=0
        for /f %%i in ( 'dir /b /ad ' ) do (
            set /a idx+=1
            set cur_lib_name=%%i
            echo [!idx!] !cur_lib_name!
            if exist !cur_lib_name!\dyzbuild (
                echo !cur_lib_name!\dyzbuild does exist
                pause
            )
            if exist !cur_lib_name!\SMP\.vs (
                echo !cur_lib_name!\SMP\.vs does exist
                pause
            )
            if exist !cur_lib_name!\SMP\obj (
                echo !cur_lib_name!\SMP\obj does exist
                pause
            )
            tar -caf !cur_lib_name!.tar.gz !cur_lib_name!
        )
    popd
    call :color_text 2f " -------------- del_lib_cacke_dir --------------- "
    endlocal
goto :eof

:TaskKillSpecProcess
    setlocal EnableDelayedExpansion
    set ProcName=%~1
    call :color_text 2f " +++++++++++++++++++ TaskKillSpecProcess +++++++++++++++++++ "
    tasklist | grep  "%ProcName%"
    taskkill /f /im  "%ProcName%"
    call :color_text 2f " -------------------- TaskKillSpecProcess ----------------------- "
    endlocal
goto :eof

:upgrade_python_pip
    setlocal EnableDelayedExpansion
    python -m ensurepip
    python -m pip install --upgrade pip
    pip3 install Jinja2
    call :color_text 2f " -------------------- upgrade_python_pip ----------------------- "
    endlocal
goto :eof

:thirdparty_lib_install
    setlocal EnableDelayedExpansion
    set lib_dir="%~1"
    set home_dir="%~2"
    call :color_text 2f "++++++++++++++ thirdparty_lib_install ++++++++++++++"
    pushd %lib_dir%
        @rem call %auto_install_func% install_package pthread-win32.zip       "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% install_package zlib-1.2.12.tar.gz      "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% install_package capstone-master.zip     "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% install_package SDL-release-2.24.0.zip  "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% install_package unicorn-master.zip      "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% install_package iconv-master.zip        "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% auto_install    "pthread-win32"       "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        call %auto_install_func% auto_install    "freetype-2.9"        "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% auto_install    "zlib-1.2.12"         "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% auto_install    "capstone-master"     "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% auto_install    "SDL-release-2.24.0"  "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% auto_install    "unicorn-master"      "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -DPROJECT_IS_TOP_LEVEL=ON  -A Win32"
        @rem call %auto_install_func% auto_install    "iconv-master"        "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
        @rem call %auto_install_func% auto_install    "libiconv-master"     "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%  -A Win32"
    popd
    call :color_text 2f " -------------- thirdparty_lib_install --------------- "
    endlocal
goto :eof

:DetectProgramDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;
    set CurProgramDir=
    set idx=0
    call :color_text 2f " +++++++++++++++++++ DetectProgramDir +++++++++++++++++++++++ "
    for %%i in (%SkySdkDiskSet%) do (
        set /a idx+=1
        for /f "tokens=1-2 delims=|" %%B in ("programs|program") do (
            set CurProgramDir=%%i:\%%B
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                goto :DetectProgramDirBreak
            )
            set CurProgramDir=%%i:\%%C
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                goto :DetectProgramDirBreak
            )
        )
    )
    :DetectProgramDirBreak
    set ProgramDir=!CurProgramDir!
    call :color_text 2f " ------------------- DetectProgramDir ----------------------- "
    endlocal & set %~1=%ProgramDir%
goto :eof

:CheckLibInDir
    setlocal EnableDelayedExpansion
    set Libs=%~1
    set LibDir="%~2"
    set ProjDir=%~3
    set MyPlatformSDK=%ProjDir%\lib
    if not exist "%MyPlatformSDK%" (
        mkdir %MyPlatformSDK%
    )
    call :color_text 2f " +++++++++++++++++++ CheckLibInDir +++++++++++++++++++++++ "
    echo LibDir %LibDir%
    if not exist %LibDir% (
        call :color_text 4f " -------------------- CheckLibInDir ----------------------- "
        echo '%LibDir%' does not exist... 
        goto :eof
    )

    pushd %LibDir%
    set idx=0
    for %%i in (%Libs%) do (
        set /a idx+=1
        set CurLib=%%i
        echo [!idx!] !LibDir!\!CurLib!
        if not exist !LibDir!\!CurLib! (
            echo !LibDir!\!CurLib!
        ) else (
            copy !LibDir!\!CurLib! %MyPlatformSDK%
        )
    )
    popd
    call :color_text 2f " -------------------- CheckLibInDir ----------------------- "
    endlocal
goto :eof

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1
    call :color_text 2f " ++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"VS2022\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"

    set idx_a=0
    for %%C in (!VCPathSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurBatFile=%%A:\%%~B\%%~C\vcvarsall.bat
                echo [!idx_a!][!idx_b!][!idx_c!] !CurBatFile!
                if exist !CurBatFile! (
                    goto :DetectVsPathBreak
                )
            )
        )
    )
    :DetectVsPathBreak
    echo Use:%CurBatFile%
    call :color_text 2f " -------------------- DetectVsPath ----------------------- "
    endlocal & set "%~1=%CurBatFile%"
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
    set myfile=%1
    set mypath=%~dp1
    set myname=%~n1
    set myext=%~x1
    call :color_text 2f "++++++++++++++++++ get_path_by_file ++++++++++++++++++++++++"
    echo !mypath! !myname! !myext!
    call :color_text 2f "-------------------- get_path_by_file -----------------------"
    endlocal & set %~2=%mypath%&set %~3=%myname%&set %~4=%myext%
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
    call :color_text 9f "--------------get_suf_sub_str--------------"
    endlocal & set %~3=%substr%
goto :eof

