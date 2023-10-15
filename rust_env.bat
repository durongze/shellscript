
call :RustEnvInfo RUST_HOME_DIR
set PATH=%RUST_HOME_DIR%
rustc.exe
pause

:RustEnvInfo
    setlocal EnableDelayedExpansion
    set RUST_HOME=%~1
    set USER_HOME=%USERPROFILE%
    set USER_HOME=F:\program\rust
    set RUSTUP_HOME=%USER_HOME%\.rustup
    set PATH=%PATH%;%RUSTUP_HOME%\toolchains\stable-x86_64-pc-windows-msvc\bin

    set CARGO_HOME=%USER_HOME%\.cargo
    set PATH=%PATH%;%CARGO_HOME%\bin

    reg query HKEY_CURRENT_USER\Environment /v path
    call :color_text 2f "+++++++++++++++++++++PATH+++++++++++++++++++++++"
    echo %path%
    call :color_text 2f "---------------------PATH-----------------------"
    endlocal & set %~1=%path%
goto :eof

:ShowUserInfo
    echo %date:~6,4%_%date:~0,2%_%date:~3,2%
    echo %time:~0,2%_%time:~3,2%
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