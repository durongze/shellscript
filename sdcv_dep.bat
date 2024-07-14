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
set ProjDir=%cur_dir:~0,-1%\..
echo ProjDir %ProjDir%

set software_dir=%cur_dir%\
set tools_dir=%cur_dir%\tools_dir
set home_dir=%ProjDir%\out\windows
set auto_install_func=%cur_dir%\auto_func.bat
call %auto_install_func% gen_all_env_by_dir %software_dir% %home_dir% all_inc all_lib all_bin CMAKE_INCLUDE_PATH CMAKE_LIBRARY_PATH CMAKE_MODULE_PATH

@rem set Iconv_LIBRARY=%tools_dir%\bin\libiconv.lib

@rem call %auto_install_func% install_all_package "%tools_addr%" "%tools_dir%"
@rem call %auto_install_func% install_all_package "%software_urls%" "%software_dir%"
call :thirdparty_lib_install "%software_dir%" %home_dir%
pause
goto :eof

@rem objdump -S E:\program\xz-5.2.6\lib\liblzma.lib | grep -C 5 "lzma_auto_decoder"

:thirdparty_lib_install
    set lib_dir="%~1"
    set home_dir="%~2"
    call :color_text 2f "++++++++++++++thirdparty_lib_install++++++++++++++"
    pushd %lib_dir%
        @rem call %auto_install_func% install_package libintl-0.14.4-src.zip  "%home_dir%"
        @rem call %auto_install_func% install_package pcre-8.42.zip           "%home_dir%"
        @rem call %auto_install_func% auto_install    "libintl-0.14.4-src"    "%home_dir%"  "-DCMAKE_BUILD_TYPE=Release"
        call %auto_install_func% auto_install    "gettext-master"        "%home_dir%"  "-DCMAKE_BUILD_TYPE=Release"
        call %auto_install_func% auto_install    "libffi-master"         "%home_dir%"  "-DCMAKE_BUILD_TYPE=Release"
        call %auto_install_func% auto_install    "pcre-8.42"             "%home_dir%"  "-DCMAKE_BUILD_TYPE=Release"
        call %auto_install_func% auto_install    "readline-win32-master" "%home_dir%"  "-DCMAKE_BUILD_TYPE=Release"
    popd
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

