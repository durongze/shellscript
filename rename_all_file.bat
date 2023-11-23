@echo off
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%
call :rename_all_file %ProjDir%
pause
goto :eof

:rename_all_file
    setlocal ENABLEDELAYEDEXPANSION
    rem 参数是 %0,%1,%2,%3
    set file_dir=%~1
    set ext_name=mp4
    set target_str="电视剧"
    set count=0
    for /f %%i in (' dir /b *.%ext_name% ') do (
        set /a count+=1
        set cur_file=%%i
        echo cur_file[!count!] : !cur_file!
        call ::is_contain !cur_file! !target_str! ret
        if "!ret!" == "true" (
            call :color_text 2f "++++++++++++++get_str_len++++++++++++++"
            set target_name=!cur_file:电视剧=_!
            echo move !cur_file! !target_name!
            move !cur_file! !target_name!
            pause
        )
    )
    endlocal
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

:is_contain
    setlocal ENABLEDELAYEDEXPANSION
    set mystr="%~1"
    set mysubstr="%~2"
    set ret=false
    call :color_text 2f "++++++++++++++is_contain++++++++++++++"
    @rem echo " echo %mystr% | findstr %mysubstr% > nul && set ret=true "
    echo %mystr% | findstr %mysubstr% > nul && set ret=true
    echo %0 %mystr% %mysubstr% %ret%
    endlocal & set %~3=%ret%
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