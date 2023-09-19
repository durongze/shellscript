@echo off
set work_dir=c:\temp\mype

set dll_dir=C:\Windows\System32
set dll_lst=find.txt
set out_file=sys.txt
call :copy_dep_to_dir "%dll_dir%" "%work_dir%" "%dll_lst%" "%out_file%"

set dll_dir=C:\Windows\SysWOW64
set dll_lst=find.txt
set out_file=sys64.txt
call :copy_dep_to_dir "%dll_dir%" "%work_dir%" "%dll_lst%" "%out_file%"

pause
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

:copy_dep_to_dir
    setlocal ENABLEDELAYEDEXPANSION

    set dllDir=%~1
    set workDir=%~2
    set dllLst=%~3
    set outFile=%~4
    set count=0

    mkdir %workDir%\out
    pushd %dllDir%
    for /f %%i in (' findstr ".dll" %workDir%\%dllLst% ') do (
        set /a count+=1
        echo file[!count!] %%i
        if not exist %%i (
            echo %%i doesn't exist
            echo %%i >> %workDir%\%outFile%
        ) else (
            echo %%i exist
            copy %%i %workDir%\out
        )
    )
    popd
    endlocal
goto :eof

