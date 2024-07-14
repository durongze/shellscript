@echo off
@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER

if "%1"=="" (
    echo No file specified.
    pause
    exit /b
)

set filePath=%1
set fileName=%~nx1
set "fileDir=%~dp1"

call :HandleAddToContextMenuOnFlie %filePath% 
call :HandleFileName %filePath%
pause
goto :eof

:HandleAddToContextMenuOnFlie
    setlocal EnableDelayedExpansion
    :: add filepath to regedit.
    set FilePath=%~1
    set FileName=%~n1
    call :color_text 2f "+++++++++++++HandleAddToContextMenuOnFlie+++++++++++++++"
    echo FilePath:%FilePath%
    echo FileName:%FileName%
    REG QUERY "HKCR\*\shell\%FileName%" >nul 2>&1
    if %errorlevel%==0 (
        call :color_text 6f "-------------'Current Menu' option already exists---------------"
    ) else (
        REG ADD "HKCR\*\shell\%FileName%" /ve /d "%FileName%" /f
        echo REG ADD "HKCR\*\shell\%FileName%" /ve /d "%FileName%" /f
        REG ADD "HKCR\*\shell\%FileName%" /v "icon" /t REG_SZ /d  "%FilePath%" /f
        echo REG ADD "HKCR\*\shell\%FileName%" /v "icon" /t REG_SZ /d  "%FilePath%" /f
        REG ADD "HKCR\*\shell\%FileName%\command" /ve /d  "\"%FilePath%\" \"%%1\"" /f
        echo REG ADD "HKCR\*\shell\%FileName%\command" /ve /d  "\"%FilePath%\" \"%%1\"" /f
        call :color_text 2f "-------------'Current Menu' option added succ.---------------"
    )
    echo REG QUERY "HKCR\*\shell\%FileName%"
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

:HandleFileName
    setlocal EnableDelayedExpansion
    set FilePath=%~1
    set FileName=%~n1
    set ExtName=%~x1
    call :color_text 2f "+++++++++++++HandleFileName+++++++++++++++"
    echo FilePath:%FilePath%
    echo FileName:%FileName%
    echo ExtName:%ExtName%
    endlocal
goto :eof
