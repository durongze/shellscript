
@rem HKEY_LOCAL_MACHINE\Software\Microsoft\.NETFramework\policy\v1.0

@echo off
@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

call :CheckCSharpEnv

pause
goto :eof

:CheckCSharpEnv
    setlocal EnableDelayedExpansion
    set src_file_name=%~1

    call :color_text 2f "+++++++++++++CheckCSharpEnv+++++++++++++++"
    set start=1
    set step=1
    set end=10
    for /l %%i in (%start%,%step%,%end%) do (
        set version=%%i
        echo version: !version!
        echo REG QUERY "HKEY_LOCAL_MACHINE\Software\Microsoft\.NETFramework\policy\v!version!.0"
        REG QUERY "HKEY_LOCAL_MACHINE\Software\Microsoft\.NETFramework\policy\v!version!.0" >nul 2>&1
        if !errorlevel!==0 (
            call :color_text 2f "-------------'NETFramework' already exists---------------"
        ) else (
            call :color_text 4f "-------------'NETFramework' doesn't exists.--------------"
        )
    )
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