

@rem copy compiler\mr_helper.mrp compiler\mr_helpere.mrp

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
set MrpHomeDir=%ProjDir%\..\..\

set ProgramDir=F:\program

set MythSdkDir=%MrpHomeDir%\mythsdk
set MythSdkVmDir=%MrpHomeDir%\vmrp\BuildLib\Debug
set MythSdkDemoDir=%ProjDir%

set SkySdkDir=%ProgramDir%\SkySdk
set SkySdkVmDir=%SkySdkDir%\MrpSimulator\
set SkySdkDemoDir=%SkySdkDir%\SkyGuide\Templates\2052

set MySdkDir=%cd%\..\..\..\..\
set MySdkVmDir=%MySdkDir%\MrpSimulator
set MySdkDemoDir=%cd%\mrp

set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set HomeDir=%MrpHomeDir%\vmrp\out\windows

set ARMHOME=%SkySdkDir%\ADSv1_2
set ARMCONF=%ARMHOME%\bin
set ARMDLL=%ARMHOME%\bin
set ARMINC=%ARMHOME%\include
set ARMLIB=%ARMHOME%\lib
set path=%ArmHome%\bin;%path%

set FrameworkLib=WS2_32.lib;winmm.lib;vfw32.lib;
set SkySdkLib=dsound.lib;dxguid.lib;simulator.lib;simlib.lib;jpeg_sim.lib;SIM_mr_helperexb.lib;data_codec_sim.lib;SIM_mr_helperexbnp.lib;
set VscLib=kernel32.lib;user32.lib;gdi32.lib;winspool.lib;shell32.lib;ole32.lib;oleaut32.lib;uuid.lib;comdlg32.lib;advapi32.lib;

call :DetectVsPath VisualStudioCmd

call %VisualStudioCmd%

call :ShowVS2022InfoOnWin10

set VCInstallDir=F:\Program Files (x86)\Microsoft Visual Studio 8\VC
@rem call :CheckLibInDir         "%FrameworkLib%"  "%FrameworkDir%"
call :CheckLibInDir         "%FrameworkLib%"  "%VCInstallDir%\PlatformSDK\lib"
@rem call :CheckLibInDir         "%VscLib%"        "%WindowsSdkDir%"
call :CheckLibInDir         "%VscLib%"        "%VCInstallDir%\PlatformSDK\Lib"
call :CheckLibInDir         "%SkySdkLib%"     "%SkySdkDir%\Simulator\lib"
pause
goto :eof

:CheckLibInDir
    setlocal EnableDelayedExpansion
    set Libs=%~1
    set LibDir="%~2"

    call :color_text 2f "+++++++++++++++++++CheckLibInDir+++++++++++++++++++++++"
    echo LibDir %LibDir%
    if not exist %LibDir% (
        call :color_text 4f "--------------------CheckLibInDir-----------------------"
        goto :eof
    )

    pushd %LibDir%
    set idx=0
    for %%i in (%Libs%) do (
        set /a idx+=1
        set CurLib=%%i
        echo [!idx!] !LibDir!\!CurLib!
        if not exist !LibDir!\!CurLib! (echo !LibDir!\!CurLib!)
    )
    popd
    call :color_text 2f "--------------------CheckLibInDir-----------------------"
    endlocal
goto :eof

:ShowVS2022InfoOnWin10
    setlocal EnableDelayedExpansion
    call :color_text 2f "+++++++++++++++++++ShowVS2022InfoOnWin10+++++++++++++++++++++++"
    @rem HKCU\SOFTWARE  or  HKCU\SOFTWARE\Wow6432Node
    @rem see winsdk.bat -> GetWin10SdkDir -> GetWin10SdkDirHelper -> reg query "%1\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"
    @rem see winsdk.bat -> GetUniversalCRTSdkDir -> GetUniversalCRTSdkDirHelper -> reg query "%1\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"

    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"
    @rem reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v10.0" /v InstallationFolder
    @rem reg add    "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v10.0" /v InstallationFolder /f /t REG_SZ /d "D:\Program Files (x86)\Windows Kits\10\"

    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"
    @rem reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v KitsRoot10 
    @rem reg add    "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v KitsRoot10         /f /t REG_SZ /d "D:\Program Files (x86)\Windows Kits\10\"
    call :color_text 2f "--------------------ShowVS2022InfoOnWin10-----------------------"
    endlocal
goto :eof

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1

    set VisualStudioCmdSet="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
    
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    call :color_text 2f "+++++++++++++++++++DetectVsPath+++++++++++++++++++++++"
    set CurBat=
    set idx=0
    for %%i in (%VisualStudioCmdSet%) do (
        set /a idx+=1
        set CurBat=%%i
        echo [!idx!] !CurBat!
        if exist !CurBat! (
            goto DetectVsPathBreak
        )
    )
    :DetectVsPathBreak
    echo Use:%CurBat%
    call :color_text 2f "--------------------DetectVsPath-----------------------"
    endlocal & set "%~1=%CurBat%"
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



