@echo off

set /p page_no=input page number:
echo page_no:%page_no%
set start_page=%page_no%

call :add_bookmark_for_dir "."  "%start_page%"
pause
goto :eof

:add_bookmark_for_dir
    setlocal EnableDelayedExpansion
    set BookDir=%~1
    set StartPageNo=%~2
    set idx=0
    for /f "delims=" %%F in ('dir /b %BookDir%\*.pdf') do (
        set /a idx+=1
        set filename=%%~nF
        set extension=%%~xF
        echo [!idx!] filename:!filename! extension:!extension! StartPageNo:!StartPageNo!
        echo add_bookmark %%F !StartPageNo!
        c:\windows\system32\add_bookmark "%%F" !StartPageNo!
        pause
    )
endlocal

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