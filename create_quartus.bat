@echo off
set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

call :get_suf_sub_str %ProjDir% \ ProjName
echo ProjName %ProjName%

@rem call :CreateQuartusDir "%ProjDir%"
call :CleanAllQuartusDir "%ProjDir%"
@rem call :QuartusProjFile "%ProjDir%"
@rem call :QuartusSetFile "%ProjDir%"
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

:CleanAllSubQuartusDir
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1

	for /f %%j in (' dir /ad /b %CodeRootDir% ') do (
		call :CleanAllQuartusDir "%CodeRootDir%\%%j"
	)

    endlocal
goto :eof

:CleanAllQuartusDir
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1

	for /f %%j in (' dir /ad /b %CodeRootDir% ') do (
		call :CleanQuartusDir "%CodeRootDir%\%%j"
	)

    endlocal
goto :eof

:CleanQuartusProjDir
    setlocal ENABLEDELAYEDEXPANSION
    set CodeProjDir=%~1

    if not exist %CodeProjDir% (
        call :color_text 4f "++++++++++++++CleanQuartusProjDir++++++++++++++"
        echo Dir '%CodeProjDir%' does not exist!
        goto :eof
    )
    pushd %CodeProjDir%
        for %%j in ( tdb tdf bpm ddb qmsg smsg summary hsd idb kpt rpt db_info hb_info cdb hdb logdb rdb ammdb dfp dpi rcfdb sig sof pin sft vho sdo wlf vo do ) do (
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

:CleanQuartusDir
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1

    call :CleanQuartusProjDir "%CodeRootDir%\q_prj"
    call :CleanQuartusProjDir "%CodeRootDir%\prj"

    endlocal
goto :eof

:QuartusProjFile
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1
    Set CodeProjDir=%CodeRootDir%\prj
    set CodeProjName=%ProjName%

    if "%CodeProjName%" == "" (
        call :color_text 4f "++++++++++++++QuartusProjFile++++++++++++++"
        echo Dir '%CodeProjName%' does not exist!
        goto :eof
    )
    if not exist %CodeProjDir% (
        call :color_text 4f "++++++++++++++QuartusProjFile++++++++++++++"
        echo Dir '%CodeProjDir%' does not exist!
        goto :eof
    ) else (
        call :color_text 2f "++++++++++++++QuartusProjFile++++++++++++++"
    )
    pushd %CodeProjDir%
        echo QUARTUS_VERSION = "13.1"                   > %CodeProjName%.qpf
        echo DATE = "14:08:42  November 13, 2023"      >> %CodeProjName%.qpf

        echo # Revisions                               >> %CodeProjName%.qpf

        echo PROJECT_REVISION = %CodeProjName%       >> %CodeProjName%.qpf
    popd

    endlocal
goto :eof

:QuartusSetFile
    setlocal ENABLEDELAYEDEXPANSION
    set CodeRootDir=%~1
    Set CodeProjDir=%CodeRootDir%\prj
    set CodeRtlDir=%CodeRootDir%\rtl
    set CodeProjName=%ProjName%

    if "%CodeProjName%" == "" (
        call :color_text 4f "++++++++++++++QuartusSetFile++++++++++++++"
        echo Dir '%CodeProjName%' does not exist!
        goto :eof
    )
    if not exist %CodeProjDir% (
        call :color_text 4f "++++++++++++++QuartusSetFile++++++++++++++"
        echo Dir '%CodeProjDir%' does not exist!
        goto :eof
    ) else (
        call :color_text 2f "++++++++++++++QuartusSetFile++++++++++++++"
        echo CodeRtlDir %CodeRtlDir%
    )
    pushd %CodeProjDir%
        echo ###################################             > %CodeProjName%.qsf
        for /f %%i in ( 'dir /b %CodeRtlDir%\*.v' ) do (
            echo set_global_assignment -name VERILOG_FILE ../rtl/%%i >> %CodeProjName%.qsf
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

:get_str_len
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set mystrlen="%~2"
    set count=0
    call :color_text 2f "++++++++++++++get_str_len++++++++++++++"
    :intercept_str_len
    set /a count+=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="" (
            goto :intercept_str_len
        )
    )
    echo %0 %mystr% %count%
    endlocal & set %~2=%count%
goto :eof

:get_first_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set char_pos="%~3"
    call :get_str_len %mystr% mystrlen
    set count=0
    call :color_text 2f "++++++++++++++get_first_char_pos++++++++++++++"
    :intercept_first_char_pos
    for /f %%i in ("%count%") do (
        set /a count+=1	
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            goto :intercept_first_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_last_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set char_pos="%~3"
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_last_char_pos++++++++++++++"
    @rem set /a count-=1	
    :intercept_last_char_pos
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a count-=1			
            goto :intercept_last_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_pre_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set mysubstr="%~3"
    call :get_str_len %mystr% mystrlen
    set count=0
    call :color_text 2f "++++++++++++++get_pre_sub_str++++++++++++++"
    set substr=
    :intercept_pre_sub_str
    for /f %%i in ("%count%") do (
        set /a count+=1
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=%%i
            set substr=!mystr:~0,%%i!
            if "%count%" == "%mystrlen%" (
                goto :pre_sub_str_break
            )
            goto :intercept_pre_sub_str
        ) else (
            set /a mysubstr_len=%%i
            set substr=!mystr:~0,%%i!
            goto :pre_sub_str_break
        )
    )
    :pre_sub_str_break
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof

:get_suf_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set mysubstr="%~3"
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_suf_sub_str++++++++++++++"
    set substr=
    :intercept_suf_sub_str
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=!mystrlen! - %%i
            set substr=!mystr:~%%i!
            set /a count-=1	
            goto :intercept_suf_sub_str
        )
    )
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof
