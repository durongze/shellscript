@echo off
set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

call :CreateQuartusDir "%ProjDir%"
@rem call :CleanQuartusDir "%ProjDir%"
pause
goto :eof

:CreateQuartusDir
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1
    set dir_list=doc prj rtl sim

    if not exist %CodeRootDir% (
        call :color_text 4f "++++++++++++++CreateQuartusDir++++++++++++++"
        echo Dir '%CodeRootDir%' does not exist!
        goto :eof
    )
    pushd %CodeRootDir%
        for %%i in (%dir_list%) do (
            if not exist %%i (
                mkdir %%i
            ) else (
                echo dir %%i exist!
            )
        )
    popd

    endlocal
goto :eof


pause
goto :eof

:CleanQuartusDir
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1
    Set CodeProjDir=%CodeRootDir%\prj

    if not exist %CodeProjDir% (
        call :color_text 4f "++++++++++++++CleanQuartusDir++++++++++++++"
        echo Dir '%CodeProjDir%' does not exist!
        goto :eof
    )
    pushd %CodeProjDir%
        for %%j in (bpm ddb qmsg smsg summary hsd idb kpt rpt db_info hb_info cdb hdb logdb rdb ammdb dfp dpi rcfdb sig sof pin sft vho sdo) do (
            set extName=%%j
            echo file type !extName!
            for /f %%i in ('dir /s /b "%CodeProjDir%\*.!extName!"') do ( 
                @rem echo del %%i ...
                @del %%i 
            )
        )
    popd

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