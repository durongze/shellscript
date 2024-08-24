set SDCC_HOME=F:\programs\sdcc
set PATH=%SDCC_HOME%\bin;%PATH%;
set c_file=led01.c

set ProgramDir=F:\program
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

call :SDCC_CompilerSrcFile %c_file%
call :SDCC_DelCacheFile %c_file%
call :SDCC_ShowVersion
pause
goto :eof

:SDCC_CompilerSrcFile
    setlocal ENABLEDELAYEDEXPANSION
    set c_file=%~1
    call :color_text 2f "++++++++++SDCC_CompilerSrcFile++++++++++++"
    if not exist %c_file%  (
        echo %c_file% doesn't_exist.
    ) else (
        sdcc        --std-sdcc89 -mmcs51    %c_file%
        packihx  led01.ihx  >  led01.hex
    )
    endlocal
goto :eof

:SDCC_ShowVersion
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f "++++++++++SDCC_ShowVersion++++++++++++"
    where sdcc
    sdcc --version
    endlocal
goto :eof

:SDCC_DelCacheFile
    setlocal ENABLEDELAYEDEXPANSION
    set c_file=led01
    call :color_text 2f "++++++++++SDCC_DelCacheFile++++++++++++"
    del %c_file%.rst  %c_file%.mem  %c_file%.lk   
    del %c_file%.map  %c_file%.rel  %c_file%.sym
    del %c_file%.ihx  %c_file%.lst
    endlocal
goto :eof

:QuerySystemEnv
    setlocal EnableDelayedExpansion
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    reg query "HKEY_CURRENT_USER\Environment"
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