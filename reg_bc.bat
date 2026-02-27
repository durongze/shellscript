call :BcAppDataClean    ""

call :BcRegReset        ""

set  CurDir=%~dp0
set  ProjDir=%CurDir:~0,-1%
echo ProjDir=%ProjDir%

set  BC_DIR=%ProjDir%
call "%BC_DIR%\BComp.exe"

pause
goto :eof

:BcAppDataClean
    setlocal ENABLEDELAYEDEXPANSION
    set WifiFile=%~1
    call :color_text 2f " +++++++++++++ BcAppDataClean ++++++++++++++ "
    @rem set BC_REG_DIR="C:\Users\%UserName%\AppData\Roaming\Scooter Software\Beyond Compare 4"
    set BC_REG_DIR="%USERPROFILE%\AppData\Roaming\Scooter Software\Beyond Compare 4"
    if not exist %BC_REG_DIR% (
        echo BC_REG_DIR=%BC_REG_DIR% does not exist.
        pause
        goto :eof
    ) else (
        pushd %BC_REG_DIR%
            del *  /q
        popd
    )
    call :color_text 9f " -------------- BcAppDataClean -------------- "
    endlocal
goto :eof

:BcRegReset
    setlocal ENABLEDELAYEDEXPANSION
    set WifiFile=%~1
    call :color_text 2f " +++++++++++++ BcRegReset ++++++++++++++ "
    set  BC_REG_PATH="HKEY_CURRENT_USER\SOFTWARE\Scooter Software\Beyond Compare 4"
    echo BC_REG_PATH=%BC_REG_PATH%

    reg  query  %BC_REG_PATH% /v CacheID
    reg  delete %BC_REG_PATH% /v CacheID /f
    reg  add    %BC_REG_PATH% /v CacheID /f /t REG_BINARY /d 0 
    call :color_text 9f " -------------- BcRegReset -------------- "
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