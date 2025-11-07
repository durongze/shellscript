
@echo off
@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER
set CurDir=%~dp0
set CurDir=%CurDir:~0,-1%
set ProjDir=%CurDir%\example
echo ProjDir %ProjDir%

call :GoEnvSet      "%CurDir%"  "%ProjDir%"  GOROOT  GOPATH
call :GoEnvShow
call :GoCompileProj "%ProjDir%" 

pause
goto :eof

:GoCompileProj
    setlocal EnableDelayedExpansion
    call :color_text 2f "+++++++++++++GoCompileProj+++++++++++++++"
    set ProjDir=%~1
    pushd  %ProjDir%
        go build main\hello.go
        .\hello.exe
        go run main\hello.go
    popd
    endlocal
goto :eof

:GoEnvShow
    setlocal EnableDelayedExpansion
    call :color_text 2f "+++++++++++++GoEnvShow+++++++++++++++"
    echo GOROOT=%GOROOT%
    echo GOPATH=%GOPATH%
    go env
    endlocal
goto :eof

:GoEnvSet
    setlocal EnableDelayedExpansion
    set go_root_dir=%~1
    set go_path_dir=%~2
    @rem assign without space
    endlocal & set %~3=%go_root_dir%& set %~4=%go_path_dir%
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