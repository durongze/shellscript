@rem set VSCMD_DEBUG=2

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

@rem copy compiler\mr_helper.mrp compiler\mr_helpere.mrp

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
set MrpHomeDir=%ProjDir%\..\..\

set MythSdkDir=%MrpHomeDir%\mythsdk
set MythSdkVmDir=%MrpHomeDir%\vmrp\BuildLib\Debug
set MythSdkDemoDir=%ProjDir%

set SkySdkDir=%ProgramDir%\SkySdk
set SkySdkIncDir=%SkySdkDir%\include
set SkySdkLibDir=%SkySdkDir%\Simulator\lib
set SkySdkVmDir=%SkySdkDir%\MrpSimulator\
set SkySdkDemoDir=%SkySdkDir%\SkyGuide\Templates\2052

set MySdkDir=%cd%\..\..\..\..\
set MySdkVmDir=%MySdkDir%\MrpSimulator
set MySdkDemoDir=%cd%\mrp

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set MakePath=%ProgramDir%\make-3.81-bin\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%SDCCPath%;%MakePath%;%PythonHome%;%PythonHome%\Scripts;%PATH%

set HomeDir=%MrpHomeDir%\vmrp\out\windows

set ARMHOME=%SkySdkDir%\ADSv1_2
set ARMCONF=%ARMHOME%\bin
set ARMDLL=%ARMHOME%\bin
set ARMINC=%ARMHOME%\include
set ARMLIB=%ARMHOME%\lib
set path=%ArmHome%\bin;%path%

@rem x86  or x64
call %VisualStudioCmd% x86
pause

@rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
@rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"
pushd %CurDir%

@rem Win32  or x64
set ArchType=Win32

call :CopyVS2005Libs         "%ProjDir%"
@rem call :ShowVS2022InfoOnWin10

pause
goto :eof

:DetectProgramDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;
    set CurProgramDir=
    set idx=0
    call :color_text 2f " +++++++++++++++++++ DetectProgramDir +++++++++++++++++++++++ "
    for %%i in (%SkySdkDiskSet%) do (
        set /a idx+=1
        for /f "tokens=1-2 delims=|" %%B in ("programs|program") do (
            set CurProgramDir=%%i:\%%B
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                goto :DetectProgramDirBreak
            )
            set CurProgramDir=%%i:\%%C
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                goto :DetectProgramDirBreak
            )
        )
    )
    :DetectProgramDirBreak
    set ProgramDir=!CurProgramDir!
    call :color_text 2f " ------------------- DetectProgramDir ----------------------- "
    endlocal & set %~1=%ProgramDir%
goto :eof

:GenSkySdkEnvVars
    setlocal EnableDelayedExpansion
    set SkySdkDiskSet=C;D;E;F;G;
    call :color_text 2f " +++++++++++++++++++ GenSkySdkEnvVars +++++++++++++++++++++++ "
    call :DetectProgramDir ProgramDir
    call :color_text 2f " ------------------- GenSkySdkEnvVars ---------------------- "
    set SkySdkDir=%ProgramDir%\SkySdk
    set SkySdkIncDir=%SkySdkDir%\include\
    set SkySdkLibDir=%SkySdkDir%\Simulator\lib\
    set SkySdkLibFiles=dsound.lib dxguid.lib simulator.lib simlib.lib jpeg_sim.lib SIM_mr_helperexb.lib data_codec_sim.lib SIM_mr_helperexbnp.lib 
    endlocal & set %~1=%SkySdkIncDir%& set %~2=%SkySdkLibDir%& set %~3=%SkySdkLibFiles%
goto :eof

:GenVsIdeEnvVars
    setlocal EnableDelayedExpansion
    call :color_text 2f " +++++++++++++++++++ GenVsIdeEnvVars +++++++++++++++++++++++ "
    call :DetectVS2005VcDir   VCInstallDir
    set VsCppLib=msvcmrtd.lib msvcrtd.lib
    set VsCppDir=%VCInstallDir%\lib
    set VsAtlmfcLib=mfcs80d.lib atlsd.lib mfc80d.lib
    set VsAtlmfcDir=%VCInstallDir%\atlmfc\lib
    set FrameworkLib=kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib WS2_32.lib winmm.lib vfw32.lib 
    set FrameworkDir=%VCInstallDir%\PlatformSDK\lib
    call :color_text 2f " -------------------- GenVsIdeEnvVars ----------------------- "
    endlocal & set "%~1=%VsCppLib%"& set "%~2=%VsAtlmfcLib%"& set "%~3=%FrameworkLib%"& set "%~4=%VsCppDir%"& set "%~5=%VsAtlmfcDir%"& set "%~6=%FrameworkDir%"
goto :eof

:DetectVS2005VcDir
    setlocal EnableDelayedExpansion
    set OutVCInstallDir=%~1

    set CurVcDir=
    set idx=0
    call :color_text 2f " +++++++++++++++++++ DetectVS2005VcDir +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"

    set idx_a=0
    for %%C in (%VCPathSet%) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurVcDir=%%A:\%%~B\%%~C
                echo [!idx!] VS80COMNTOOLS=!VS80COMNTOOLS!
                echo [!idx!] CurVcDir=!CurVcDir!
                if exist !CurVcDir! (
                    goto :DetectVS2005VcDirBreak
                )
            )
        )
    )
    :DetectVS2005VcDirBreak
    set  VCInstallDir=!CurVcDir!
    echo VCInstallDir=!CurVcDir!
    call :color_text 2f " -------------------- DetectVS2005VcDir ----------------------- "
    endlocal & set "%~1=%VCInstallDir%"
goto :eof

:CopyVS2005Libs
    setlocal EnableDelayedExpansion
    set ProjDir=%~1
    call :color_text 2f " +++++++++++++++++++ CopyVS2005Libs +++++++++++++++++++++++ "
    @rem call :DetectVS2005VcDir   VCInstallDir
    call :DetectProgramDir    ProgramDir
    set VCInstallDir=%ProgramDir%\SkySdk\VS2005\VC

    set VscLib=msvcmrtd.lib;msvcrtd.lib;
    set VscDir=%VCInstallDir%\lib

    set VsAtlmfcLib=mfcs80d.lib atlsd.lib mfc80d.lib
    set VsAtlmfcDir=%VCInstallDir%\atlmfc\lib

    set FrameworkLib=kernel32.lib;user32.lib;gdi32.lib;winspool.lib;shell32.lib;ole32.lib;oleaut32.lib;uuid.lib;comdlg32.lib;advapi32.lib;WS2_32.lib;winmm.lib;vfw32.lib;
    set FrameworkDir=%VCInstallDir%\PlatformSDK\lib

    set RedistDir=%VCInstallDir%\redist\Debug_NonRedist\x86

    set SkySdkLib=dsound.lib;dxguid.lib;simulator.lib;simlib.lib;jpeg_sim.lib;SIM_mr_helperexb.lib;data_codec_sim.lib;SIM_mr_helperexbnp.lib;

    call :CheckLibInDir         "%VscLib%"             "%VscDir%"         "%ProjDir%"
    call :CheckLibInDir         "%VsAtlmfcLib%"        "%VsAtlmfcDir%"    "%ProjDir%"
    @rem call :CheckLibInDir         "%FrameworkLib%"       "%FrameworkDir%"                 "%ProjDir%"

    mkdir %ProjDir%\out\lib
    xcopy %RedistDir%         "%ProjDir%\out\"         /y /s /e   
    xcopy %RedistDir%         "%ProjDir%\out\lib\"     /y /s /e   

    @rem call :CheckLibInDir         "%SkySdkLib%"          "%SkySdkDir%\Simulator\lib"      "%ProjDir%"

    call :color_text 2f " -------------------- CopyVS2005Libs ----------------------- "
    endlocal
goto :eof

:CheckLibInDir
    setlocal EnableDelayedExpansion
    set Libs=%~1
    set LibDir="%~2"
    set ProjDir=%~3
    set MyPlatformSDK=%ProjDir%\lib
    if not exist "%MyPlatformSDK%" (
        mkdir %MyPlatformSDK%
    )
    call :color_text 2f " +++++++++++++++++++ CheckLibInDir +++++++++++++++++++++++ "
    echo LibDir %LibDir%
    if not exist %LibDir% (
        call :color_text 4f " -------------------- CheckLibInDir ----------------------- "
        echo '%LibDir%' does not exist... 
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
    set VCPathSet=%VCPathSet%;"VS2022\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\VC"
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



