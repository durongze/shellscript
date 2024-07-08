
@echo off
@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

call :QueryPadsFonts
@rem call :ModifyPadsFonts
@rem call :QueryPadsFonts
pause
goto :eof



:ModifyPadsFonts
    setlocal EnableDelayedExpansion

    call :color_text 2f "+++++++++++++ModifyPadsFonts+++++++++++++++"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /V "Microsoft YaHei & Microsoft YaHei UI (TrueType)"
    if %errorlevel%==0 (
        call :color_text 6f "-------------'Fonts' option already exists---------------"
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"   /V   "Microsoft YaHei & Microsoft YaHei UI (TrueType)"             /f  /t  REG_SZ  /d simsun.ttc
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"   /V   "Microsoft YaHei Bold & Microsoft YaHei UI Bold (TrueType)"   /f  /t  REG_SZ  /d simsun.ttc
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"   /V   "Microsoft YaHei Light & Microsoft YaHei UI Light (TrueType)"   /f  /t  REG_SZ  /d simsun.ttc
        call :color_text 2f "-------------'Fonts' option added succ.---------------"
    ) else (
        call :color_text 4f "-------------'Fonts' option doesn't exists.---------------"
    )
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"  >nul 2>&1
    if %errorlevel%==0 (
        call :color_text 6f "-------------'FontSubstitutes' option already exists---------------"
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"   /V   "Microsoft YaHei"      /f  /t  REG_SZ  /d SimSun
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"   /V   "Microsoft YaHei UI"   /f  /t  REG_SZ  /d SimSun
        call :color_text 2f "-------------'FontSubstitutes' option added succ.---------------"
    ) else (
        call :color_text 4f "-------------'FontSubstitutes' option doesn't exists.---------------"
    )
    endlocal
goto :eof

:QueryPadsFonts
    setlocal EnableDelayedExpansion

    call :color_text 2f "+++++++++++++QueryPadsFonts+++++++++++++++"
    echo Key:Fonts, StringValue:Microsoft YaHei ^& Microsoft YaHei UI (TrueType)
    @rem msyh.ttc -> simsun.ttc
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /V "Microsoft YaHei & Microsoft YaHei UI (TrueType)"
    @rem msyhbd.ttc -> simsun.ttc
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /V "Microsoft YaHei Bold & Microsoft YaHei UI Bold (TrueType)"
    @rem msyhl.ttc -> simsun.ttc
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /V "Microsoft YaHei Light & Microsoft YaHei UI Light (TrueType)"

    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"  >nul 2>&1
    if %errorlevel%==0 (
        call :color_text 6f "-------------'FontSubstitutes' option already exists---------------"
        reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"   /V   "Microsoft YaHei"
        reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"   /V   "Microsoft YaHei UI"
    ) else (
        call :color_text 2f "-------------'FontSubstitutes' option doesn't exists---------------"
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