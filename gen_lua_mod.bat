set CurDir=%~dp0
set TOOLS_DIR=%CurDir%\tools
set LUAC=%TOOLS_DIR%\luac
set XXD=%TOOLS_DIR%\bin2source

call :GenLuaModC "src\modules"
call :GenLuaModC "src\device"
pause
goto :eof

:GenLuaModC
    setlocal EnableDelayedExpansion
    set LuaSrcDir="%~1"

    if exist %LuaSrcDir% ( 
        pushd %LuaSrcDir%
        set idx=0
        for /f %%i in ('dir /s /b "*.lua"') do (
            set /a idx+=1
            call :color_text 2f "++++++++++++++GenLuaModC++++++++++++++"
            set lua_file=%%i
            set mod_file=!lua_file:~0,-4!.mod
            echo [!idx!] lua:%%i, mod:!mod_file!
            %LUAC% -s -o !mod_file! %%i
            %XXD% !mod_file! > !mod_file!.c
        )
        popd
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

