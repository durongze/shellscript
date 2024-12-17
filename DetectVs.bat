call :DetectVsPath VisualStudioCmd

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

set VCInstallDir=F:\Program Files (x86)\Microsoft Visual Studio 8\VC
set VscLib=msvcmrtd.lib;msvcrtd.lib;
set VscDir=%VCInstallDir%\lib
set VsAtlmfcLib=mfcs80d.lib atlsd.lib mfc80d.lib
set VsAtlmfcDir=%VCInstallDir%\atlmfc\lib
set FrameworkLib=kernel32.lib;user32.lib;gdi32.lib;winspool.lib;shell32.lib;ole32.lib;oleaut32.lib;uuid.lib;comdlg32.lib;advapi32.lib;WS2_32.lib;winmm.lib;vfw32.lib;
set FrameworkDir=%VCInstallDir%\PlatformSDK\lib
set SkySdkLib=dsound.lib;dxguid.lib;simulator.lib;simlib.lib;jpeg_sim.lib;SIM_mr_helperexb.lib;data_codec_sim.lib;SIM_mr_helperexbnp.lib;

call %VisualStudioCmd%

call :ShowVS2022InfoOnWin10

@rem call :CheckLibInDir         "%VscLib%"        "%WindowsSdkDir%"
call :CheckLibInDir         "%VscLib%"             "%VscDir%"
call :CheckLibInDir         "%VsAtlmfcLib%"        "%VsAtlmfcDir%"
call :CheckLibInDir         "%FrameworkLib%"       "%FrameworkDir%"

@rem call :CheckLibInDir         "%SkySdkLib%"     "%SkySdkDir%\Simulator\lib"
pause
goto :eof

:CheckLibInDir
    setlocal EnableDelayedExpansion
    set Libs=%~1
    set LibDir="%~2"
    set MyPlatformSDK=%ProjDir%\lib
    if not exist "%MyPlatformSDK%" (
        mkdir %MyPlatformSDK%
    )
    call :color_text 2f " +++++++++++++++++++ CheckLibInDir +++++++++++++++++++++++ "
    echo LibDir %LibDir%
    if not exist %LibDir% (
        call :color_text 4f " -------------------- CheckLibInDir ----------------------- "
        goto :eof
    )

    pushd %LibDir%
    set idx=0
    for %%i in (%Libs%) do (
        set /a idx+=1
        set CurLib=%%i
        echo [!idx!] !LibDir!\!CurLib!
        if not exist !LibDir!\!CurLib! (
            echo !LibDir!\!CurLib!
        ) else (
            copy !LibDir!\!CurLib! %MyPlatformSDK%
        )
    )
    popd
    call :color_text 2f " -------------------- CheckLibInDir ----------------------- "
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
    call :color_text 2f " ++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet=program
    set AllProgramsPathSet=%AllProgramsPathSet%;programs
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;SkySdk\VS2005\VC
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"

    set idx_a=0
    for %%C in (%VCPathSet%) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurBatFile=%%A:\%%B\%%C\vcvarsall.bat
                echo [!idx_a!][!idx_b!][!idx_c!] !CurBatFile!
                if exist !CurBatFile! (
                    goto DetectVsPathBreak
                )
            )
        )
    )
    :DetectVsPathBreak
    echo Use:%CurBatFile%
    call :color_text 2f " -------------------- DetectVsPath ----------------------- "
    endlocal & set "%~1=%CurBatFile%"
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



