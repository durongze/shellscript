
@rem HKEY_CLASSES_ROOT\CLSID\

@echo off
@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%
set TargetGUID=450D8FBA-AD25-11D0-98A8-0800361B1103
call :GetGeneralComponentList VcRuntimeList
call :CheckVcRuntimeEnv "%VcRuntimeList%"
call :GetComponentName "%TargetGUID%"
pause
goto :eof

:CheckVcRuntimeEnv
    setlocal EnableDelayedExpansion
    set VcRuntimeList=%~1
    set idx=0
    call :color_text 2f "+++++++++++++CheckVcRuntimeEnv+++++++++++++++"
    echo VcRuntimeList:%VcRuntimeList%
    for %%i in (%VcRuntimeList%) do (
        set /a idx+=1
        set GUID=%%i
        echo [!idx!]GUID: !GUID!
        echo HKEY_CLASSES_ROOT\CLSID\{!GUID!}
        REG QUERY "HKEY_CLASSES_ROOT\CLSID\{!GUID!}" >nul 2>&1
        if !errorlevel!==0 (
            call :color_text 2f "-------------'HKEY_CLASSES_ROOT CLSID {GUID}' already exists---------------"
        ) else (
            call :color_text 4f "-------------'HKEY_CLASSES_ROOT CLSID {GUID}' doesn't exists.--------------"
        )
    )
    endlocal
goto :eof

:GetGeneralComponentList
    setlocal EnableDelayedExpansion
    call :color_text 2f "+++++++++++++GetGeneralComponentList+++++++++++++++"
    set My_Documents=450D8FBA-AD25-11D0-98A8-0800361B1103
    set My_Computer=20D04FE0-3AEA-1069-A2D8-08002B30309D
    set Network_Neighborhood=208D2C60-3AEA-1069-A2D7-08002B30309D
    set Recycle_Bin=645FF040-5081-101B-9F08-00AA002F954E
    set Internet_Explorer=871C5380-42A0-1069-A2EA-08002B30309D
    set Control_Panel=21EC2020-3AEA-1069-A2DD-08002B30309D
    set Network_Connections=992CFFA0-F557-101A-88EC-00DD010CCC48
    @rem  cmd:schtasks  msc:taskschd.msc
    set Task_Scheduler=D6277990-4C6A-11CF-8D87-00AA0060F5BF
    set Printer=2227A280-3AEA-1069-A2DE-08002B30309D
    set History_Folder=7BD29E00-76C1-11CF-9DD0-00A0C9034933
    call :color_text 9f "+++++++++++++GetGeneralComponentList+++++++++++++++"
    endlocal & set %~1=%My_Documents% %My_Computer% %Network_Neighborhood% %Recycle_Bin% %Internet_Explorer% %Control_Panel% %Network_Connections% %Task_Scheduler% %Printer% %History_Folder%
goto :eof


:GetComponentName
    setlocal EnableDelayedExpansion
    set ComponentGUID=%~1
    set ComponentName=
    call :color_text 2f "+++++++++++++GetComponentName+++++++++++++++"
    call :GetGeneralComponentList ComponentList
    set idx=0
    echo ComponentList:%ComponentList%
    for %%i in (%ComponentList%) do (
        set /a idx+=1
        set GUID=%%i

        if "!ComponentGUID!"=="!GUID!" (
            call :color_text 2f "-------------'HKEY_CLASSES_ROOT CLSID {GUID}' already exists---------------"
            echo [!idx!]GUID: !GUID!
        )
    )
    call :color_text 9f "+++++++++++++GetComponentName+++++++++++++++"
    endlocal & set %~1=%ComponentName%
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