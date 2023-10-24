@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set PerlPath=F:\program\Perl\bin
set NASMPath=F:\program\nasm
set CMakePath=F:\program\cmake\bin
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PATH%

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%
set software_dir="%ProjDir%\thirdparty"
set HomeDir=%ProjDir%

set VisualStudioCmd="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"

set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set auto_install_func=%software_dir%\auto_func.bat

call %auto_install_func% gen_all_env %software_dir% %HomeDir% all_inc all_lib all_bin
echo all_inc:%all_inc%
echo all_lib:%all_lib%
echo all_bin:%all_bin%
set include=%all_inc%;%include%;%tools_dir%\include;
set lib=%all_lib%;%lib%;%tools_dir%\lib;%tools_dir%\bin;
set path=%all_bin%;%path%;%tools_dir%\bin;

set SystemBinDir=.\
set BuildDir=dyzbuild
set BuildType=Release
set ProjName=

call :get_suf_sub_str %ProjDir% \ ProjName

echo ProjName %ProjName%
CALL %VisualStudioCmd%
call :CompileProject %BuildDir% %BuildType% %ProjName%
call :CopyTarget %BuildDir% %BuildType% %SystemBinDir%

pause
goto :eof

:CompileProject
    setlocal ENABLEDELAYEDEXPANSION
    set BuildDir="%~1"
    set BuildType="%~2"
    set ProjName=%~3

    if not exist %BuildDir% (
        mkdir %BuildDir%
    )
    pushd %BuildDir%
        @rem del * /q /s
        @rem cmake .. -G"Visual Studio 16 2019" -A Win64
        @rem cmake --build . --target clean
        cmake .. -DCMAKE_BUILD_TYPE=%BuildType% -DCMAKE_INSTALL_PREFIX=F:\program\%ProjName%
        cmake --build . -j16  --config %BuildType% --target INSTALL
    popd
    endlocal
goto :eof

:CopyTarget
    setlocal ENABLEDELAYEDEXPANSION
    set BuildDir=%~1
    set BuildType=%2
    set SystemBinDir=%3
    for /f %%i in ('dir /s /b "%BuildDir%\bin\%BuildType%\*.exe"') do (   copy %%i %SystemBinDir%\ )
    endlocal
goto :eof

:RunWinSvr
    setlocal ENABLEDELAYEDEXPANSION
    set ProjName=%~1
    set BuildDir="%~2"
    set BuildType=%3
    set BinPath="%~4"
    @rem 
    if not exist %BinPath% (
        call :color_text 4f "++++++++++++++RunWinSvr file does not exist++++++++++++++"
        echo BinPath %BinPath% .
    ) else (
        sc create %ProjName% binPath= %BinPath%
        sc config %ProjName% start=auto
        @rem sc start %ProjName%
        net start %ProjName%
        if !errorlevel! equ 0 (
            sc stop %ProjName%
        ) else (
            call :color_text 4f "++++++++++++++RunWinSvr net start error ++++++++++++++"
            %BinPath%
        )
        @rem sc delete %ProjName%
    )
    endlocal
goto :eof

:SetProjEnv
    setlocal ENABLEDELAYEDEXPANSION
    set loc_dir=%~1
    set loc_inc=%2
    set loc_lib=%3
    set loc_bin=%4
    set auto_install_func=%software_dir%\auto_func.bat

    call %auto_install_func% gen_all_env %software_dir% %HomeDir% loc_inc loc_lib loc_bin
    set all_inc=%loc_inc%;%include%;%loc_dir%\include;
    set all_lib=%loc_lib%;%lib%;%loc_dir%\lib;%loc_dir%\bin;
    set all_bin=%loc_bin%;%path%;%loc_dir%\bin;
    endlocal & set %~2=%all_inc% & set %~3=%all_lib% & set %~4=%all_bin%
goto :eof

:ShowProjEnv
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f "++++++++++++++ShowProjEnv++++++++++++++"
    echo include:%include%
    echo lib:%lib%
    echo path:%path%
    call :color_text 9f "--------------ShowProjEnv--------------"
    endlocal
goto :eof

:ResetSystemEnv
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f "++++++++++++++ResetSystemEnv++++++++++++++"
    @rem set include=%old_sys_include%
    @rem set lib=%old_sys_lib%
    @rem set path=%old_sys_path%
    call :color_text 9f "--------------ResetSystemEnv--------------"
    endlocal
goto :eof

:ShowUserInfo
    echo %date:~6,4%_%date:~0,2%_%date:~3,2%
    echo %time:~0,2%_%time:~3,2%
goto :eof

:ShowVS2022InfoOnWin10
    @rem HKCU\SOFTWARE  or  HKCU\SOFTWARE\Wow6432Node
    @rem see winsdk.bat -> GetWin10SdkDir -> GetWin10SdkDirHelper -> reg query "%1\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"
    @rem see winsdk.bat -> GetUniversalCRTSdkDir -> GetUniversalCRTSdkDirHelper -> reg query "%1\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"

    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"
    @rem reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v10.0" /v InstallationFolder
    @rem reg add    "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v10.0" /v InstallationFolder /f /t REG_SZ /d "D:\Program Files (x86)\Windows Kits\10\"

    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"
    @rem reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v KitsRoot10 
    @rem reg add    "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v KitsRoot10         /f /t REG_SZ /d "D:\Program Files (x86)\Windows Kits\10\"
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

:GetCurSysTime
    setlocal EnableDelayedExpansion
    set dateStr=
    set timeStr=
    set year=%date:~6,4%
    set month=%date:~4,2%
    set day=%date:~0,2%
    set dateStr=%year%_%month%_%day%
    set dateStr=%dateStr:/=%
    set timeStr=%time::=%
    endlocal & set %~1=%dateStr%_%timeStr%
goto :eof
