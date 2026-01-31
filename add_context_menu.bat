%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
CD /D "%~dp0"

@echo off
@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

call :AddToContextMenuOnFlie
@rem call :AddToContextMenuOnSpace

pause
goto :eof

:AddToContextMenuOnFlie
    setlocal EnableDelayedExpansion
    set src_file_name=%~1

    call :color_text 2f " +++++++++++++ AddToContextMenuOnFlie +++++++++++++++ "
    REG QUERY "HKCU\Software\Classes\*\shell\AddToContextMenu" >nul 2>&1
    if %errorlevel%==0 (
        call :color_text 6f " =========== 'Add to Context Menu' option already exists =========== "
        REG DELETE "HKCU\Software\Classes\*\shell\AddToContextMenu" 
    ) else (
        REG ADD    "HKCU\Software\Classes\*\shell\AddToContextMenu"         /ve /d "Add to Context Menu" /f
        REG ADD    "HKCU\Software\Classes\*\shell\AddToContextMenu\command" /ve /d "\"%~dp0\handle_add_to_context_menu.bat\" \"%%1\"" /f
        echo "Add to Context Menu" option added successfully.
        call :color_text 2f " =========== 'Add to Context Menu' option added succ. =========== "
    )
    call :color_text 2f " ------------- HandleAddToContextMenuOnFlie ------------- "
    endlocal
goto :eof

:AddToContextMenuOnSpace
    setlocal EnableDelayedExpansion
    set src_file_name=%~1

    call :color_text 2f " +++++++++++++ AddToContextMenuOnSpace +++++++++++++++ "
    REG QUERY "HKEY_CLASSES_ROOT\Directory\Background\shell\add_bookmark" >nul 2>&1
    if %errorlevel%==0 (
        call :color_text 6f " =========== 'Add to Context Menu' option already exists =========== "
        REG DELETE "HKEY_CLASSES_ROOT\Directory\Background\shell\add_bookmark"
    ) else (
        REG ADD "HKEY_CLASSES_ROOT\Directory\Background\shell\add_bookmark" /ve /d "add bookmark" /f
        REG ADD "HKEY_CLASSES_ROOT\Directory\Background\shell\add_bookmark\command" /ve /d "\"C:\Windows\System32\proc_bookmark.bat\" \"%%1\"" /f
        call :color_text 2f " =========== 'Add to Context Menu' option added succ. =========== "
    )
    call :color_text 2f " ------------- AddToContextMenuOnSpace ------------- "
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
