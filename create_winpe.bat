@rem Version Info 
@rem 1. (Settings->System->About->Windows specifications)
@rem 2. cmd->winver->About Windows
@rem 3. WIN->System Information
@rem 4. reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
@rem 4.1 reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseId
@rem 4.2 reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber

@rem download 
adk_url="https://download.microsoft.com/download/B/E/6/BE63E3A5-5D1C-43E7-9875-DFA2B301EC70/adk/adksetup.exe"
adkwinpe_url="https://download.microsoft.com/download/E/F/A/EFA17CF0-7140-4E92-AC0A-D89366EBD79E/adkwinpeaddons/adkwinpesetup.exe"

set adk_dir="C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit"
set work_dir=c:\temp\mype
set winpe_dir="%adk_dir:~1,-1%\Windows Preinstallation Environment\amd64"
call "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat"

call :create_winpe "%work_dir%" %winpe_dir%

pause
goto :eof

@rem reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe" /f

:create_winpe
    setlocal ENABLEDELAYEDEXPANSION
    set work_dir=%~1
    set winpe_dir=%~2
    call :color_text 2f "++++++++++++++create_winpe++++++++++++++"
    echo work_dir %work_dir%
    echo winpe_dir %winpe_dir%

    pushd "%winpe_dir%\"
        echo call copype amd64 "%work_dir%"
             call copype amd64 "%work_dir%"
        echo Dism /Mount-Image /ImageFile:"en-us\winpe.wim" /index:1 /MountDir:"%work_dir%\mount"
             Dism /Mount-Image /ImageFile:"en-us\winpe.wim" /index:1 /MountDir:"%work_dir%\mount"
        echo Xcopy  "%work_dir%\mount\Windows\Boot\EFI\bootmgr.efi"  "Media\bootmgr.efi"           /Y
             Xcopy  "%work_dir%\mount\Windows\Boot\EFI\bootmgr.efi"  "Media\bootmgr.efi"           /Y
        echo Xcopy  "%work_dir%\mount\Windows\Boot\EFI\bootmgfw.efi"  "Media\EFI\Boot\bootx64.efi"  /Y
             Xcopy  "%work_dir%\mount\Windows\Boot\EFI\bootmgfw.efi"  "Media\EFI\Boot\bootx64.efi"  /Y

        @rem install.wim
        @rem mkdir %work_dir%\install
        @rem      Dism /Export-Image /SourceImageFile:install.wim /SourceIndex:1 /DestinationImageFile:en-us\install.wim 
        @rem echo Dism /Mount-Image /ImageFile:en-us\install.wim /index:2 /MountDir:"%work_dir%\install"
        @rem      Dism /Mount-Image /ImageFile:en-us\install.wim /index:2 /MountDir:"%work_dir%\install"

        Dism /Add-Package /Image:"%work_dir%\mount" /PackagePath:"WinPE_OCs\WinPE-FMAPI.cab"  
        Dism /Add-Package /Image:"%work_dir%\mount" /PackagePath:"WinPE_OCs\WinPE-PPPoE.cab"
        Dism /Add-Package /Image:"%work_dir%\mount" /PackagePath:"WinPE_OCs\WinPE-Dot3Svc.cab"
        Dism /Add-Package /Image:"%work_dir%\mount" /PackagePath:"WinPE_OCs\WinPE-RNDIS.cab"
        Dism /Add-Package /Image:"%work_dir%\mount" /PackagePath:"WinPE_OCs\WinPE-WDS-Tools.cab"
        Dism /Add-Package /Image:"%work_dir%\mount" /PackagePath:"WinPE_OCs\WinPE-WiFi-Package.cab"

        Dism /Image:%work_dir%\mount /Add-Driver /Driver:C:\Windows\SysWOW64\drivers /Recurse

        @rem Dism /Unmount-Image /MountDir:"%work_dir%\install" /commit

        echo Dism /Unmount-Image /MountDir:"%work_dir%\mount" /commit
             Dism /Unmount-Image /MountDir:"%work_dir%\mount" /commit
        echo call MakeWinPEMedia /ISO "%work_dir%" "%work_dir%\WinPE_amd64.iso"
             call MakeWinPEMedia /ISO "%work_dir%" "%work_dir%\WinPE_amd64.iso"
        echo "%work_dir%\WinPE_amd64.iso"
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
    set mystr=%1
    set mystrlen=%2
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

:get_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set char_sym=%2
    set char_pos=%3
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_char_pos++++++++++++++"
    :intercept_char_pos
    set /a count-=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            goto :intercept_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_pre_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set char_sym=%2
    set mysubstr=%3
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
    set mystr=%1
    set char_sym=%2
    set mysubstr=%3
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_suf_sub_str++++++++++++++"
    set substr=
    :intercept_suf_sub_str
    set /a count-=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=!mystrlen! - %%i
            set substr=!mystr:~%%i!
            goto :intercept_suf_sub_str
        )
    )
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof

:is_contain
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%1
    set mysubstr=%2
    set ret=false
    call :color_text 2f "++++++++++++++is_contain++++++++++++++"
    @rem echo " echo %mystr% | findstr %mysubstr% > nul && set ret=true "
    echo %mystr% | findstr %mysubstr% > nul && set ret=true
    echo %0 %mystr% %mysubstr% %ret%
    endlocal & set %~3=%ret%
goto :eof

:tools_download
    setlocal ENABLEDELAYEDEXPANSION
    set tools_addr="%1"
    set tools_dir="%2"
    call :color_text 2f "++++++++++++++tools_install++++++++++++++"
    echo %tools_addr%    %tools_dir%
    if not exist %tools_dir% (
        md %tools_dir%
    )
    pushd %tools_dir%
    for %%i in ( %tools_addr% ) do (
        set tool_file=%%i
        call :get_char_pos !tool_file! / char_pos
        echo tool_file:!char_pos!:!tool_file!
        call :get_suf_sub_str !tool_file! / file_name
        echo file_name:!file_name!
        if not exist !file_name! (
            wget %%i
        )
        @rem unzip -q -o !file_name!

        @rem adksetup /quiet /layout c:\temp\ADKoffline
        @rem adksetup /quiet /installpath c:\ADK /features OptionId.DeploymentTools
        @rem adksetup /quiet /installpath c:\ADK

    )
    popd
    endlocal
goto :eof



:adk_download
    setlocal ENABLEDELAYEDEXPANSION
    set tools_addr="%1"
    set tools_dir="%2"
    set home_dir=%3
    call :color_text 2f "++++++++++++++bat_start++++++++++++++"
    echo "%tools_addr%" "%tools_dir%" %home_dir%
    call :tools_download "%tools_addr%" "%tools_dir%"
    endlocal
goto :eof