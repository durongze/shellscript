set ProgramDir=F:\program

set KEIL_HOME=%ProgramDir%\KeilC51
SET C251HOME=%KEIL_HOME%\C251
SET C251INC=%C251HOME%\INC;.\;
SET C251LIB=%C251HOME%\LIB;.\;
SET C251BIN=%C251HOME%\BIN;.\;
set PATH=%C251BIN%;%PATH%;

set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%\example
set file_name=led01
echo ProjDir %ProjDir%

call :C251_CompilerSrcFile "%ProjDir%" "%file_name%"
call :C251_DelCacheFile    "%ProjDir%" "%file_name%"
call :C251_ShowVersion
pause
goto :eof

:C251_CompilerSrcFile
    setlocal ENABLEDELAYEDEXPANSION
    set proj_dir=%~1
    set file_name=%~2
    set c_file=%file_name%.c
    set obj_file=%file_name%.obj
    call :color_text 2f "++++++++++C251_CompilerSrcFile++++++++++++"
    pushd %proj_dir%
        if not exist "%c_file%"  (
            echo %c_file% doesn't_exist.
        ) else (
            C251                      %c_file%
            L251                      %obj_file%
            OH251 file_name hex
        )
    popd
    call :color_text 9f "----------C251_CompilerSrcFile-------------"
    endlocal
goto :eof

:C251_ShowVersion
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f "++++++++++C251_ShowVersion++++++++++++"
    echo C251HOME=%C251HOME%
    echo C251INC=%C251INC%
    echo C251LIB=%C251LIB%
    echo C251BIN=%C251BIN%
    echo PATH=%PATH%
    where C251.exe
    where L251.exe
    where OH251.exe
    call :color_text 9f "----------C251_ShowVersion-------------"
    endlocal
goto :eof

:C251_DelCacheFile
    setlocal ENABLEDELAYEDEXPANSION
    set proj_dir=%~1
    set file_name=%~2
    call :color_text 2f "++++++++++C251_DelCacheFile++++++++++++"
    pushd %proj_dir%
        del %file_name%.rst  %file_name%.mem  %file_name%.lk   
        del %file_name%.map  %file_name%.rel  %file_name%.sym
        del %file_name%.ihx  %file_name%.lst
    popd
    call :color_text 9f "----------C251_DelCacheFile-------------"
    endlocal
goto :eof

:QuerySystemEnv
    setlocal EnableDelayedExpansion
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    reg query "HKEY_CURRENT_USER\Environment"
    endlocal
goto :eof

:get_path_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set myfile=%1
    call :color_text 2f "++++++++++get_path_by_file++++++++++++"
    set mypath=%~dp1
    set myname=%~n1
    set myext=%~x1
    echo !mypath! !myname! !myext!
    call :color_text 9f "----------get_path_by_file-------------"
    endlocal & set %~2=%mypath%&set %~3=%myname%&set %~4=%myext%
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