@echo off

@rem set VSCMD_DEBUG=2

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%YASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set HomeDir=%ProjDir%\out\windows


call %VisualStudioCmd% x86

set BuildType=Release

call :install_boost1830  "debug"  "64"  "%HomeDir%"

pause
goto :eof

:MidlProcFile
    setlocal EnableDelayedExpansion
    set IdlFileList=%~1
    set idx=0
    call :color_text 2f " +++++++++++++++++++ MidlProcFile +++++++++++++++++++++++ "
    for %%i in (%IdlFileList%) do (
        set /a idx+=1
        set IdlFile=%%i
        echo [!idx!] !IdlFile!
        if exist !IdlFile! (
            
        )
    )
    call :color_text 2f " -------------------- MidlProcFile ----------------------- "
    endlocal
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

:DetectVS2005VcDir
    setlocal EnableDelayedExpansion
    set OutVCInstallDir=%~1
    set VisualStudioDiskSet=C;D;E;F;G;
    set CurVcDir=
    set idx=0
    call :color_text 2f "+++++++++++++++++++DetectVS2005VcDir+++++++++++++++++++++++"
    for %%i in (%VisualStudioDiskSet%) do (
        set /a idx+=1
        set CurVcDir="%%i:\Program Files (x86)\Microsoft Visual Studio 8\VC"
        echo [!idx!] !VS80COMNTOOLS!
        echo [!idx!] !CurVcDir!
        if exist !CurVcDir! (
            goto :DetectVS2005VcDirBreak
        )
    )
    :DetectVS2005VcDirBreak
    set VCInstallDir="!CurVcDir!"
    call :color_text 2f "--------------------DetectVS2005VcDir-----------------------"
    endlocal & set "%~1=%VCInstallDir%"
goto :eof

:CopyVS2005Libs
    setlocal EnableDelayedExpansion
    set ProjDir=%~1
    call :color_text 2f "+++++++++++++++++++CopyVS2005Libs+++++++++++++++++++++++"
    @rem call :DetectVS2005VcDir   VCInstallDir
    call :DetectProgramDir    ProgramDir
    set VCInstallDir=%ProgramDir%\SkySdk\VS2005\VC
    set VscLib=msvcmrtd.lib;msvcrtd.lib;
    set VscDir=%VCInstallDir%\lib
    set VsAtlmfcLib=mfcs80d.lib atlsd.lib mfc80d.lib
    set VsAtlmfcDir=%VCInstallDir%\atlmfc\lib
    set FrameworkLib=kernel32.lib;user32.lib;gdi32.lib;winspool.lib;shell32.lib;ole32.lib;oleaut32.lib;uuid.lib;comdlg32.lib;advapi32.lib;WS2_32.lib;winmm.lib;vfw32.lib;
    set FrameworkDir=%VCInstallDir%\PlatformSDK\lib
    set SkySdkLib=dsound.lib;dxguid.lib;simulator.lib;simlib.lib;jpeg_sim.lib;SIM_mr_helperexb.lib;data_codec_sim.lib;SIM_mr_helperexbnp.lib;
    @rem call :CheckLibInDir         "%VscLib%"             "%WindowsSdkDir%"                "%ProjDir%"
    call :CheckLibInDir         "%VscLib%"             "%VscDir%"         "%ProjDir%"
    call :CheckLibInDir         "%VsAtlmfcLib%"        "%VsAtlmfcDir%"    "%ProjDir%"
    @rem call :CheckLibInDir         "%FrameworkLib%"       "%FrameworkDir%"                 "%ProjDir%"
    @rem call :CheckLibInDir         "%SkySdkLib%"          "%SkySdkDir%\Simulator\lib"      "%ProjDir%"
    call :color_text 2f "--------------------CopyVS2005Libs-----------------------"
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

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1

    call :color_text 2f " +++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;
    set AllProgramsPathSet=program
    set AllProgramsPathSet=%AllProgramsPathSet%;programs
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;SkySdk\VS2005\VC
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"

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

:install_boost
    setlocal ENABLEDELAYEDEXPANSION
    set BuildType="%~1"
    set BitNum="%~2"
    set HomeDir="%~3"
    call :color_text 2f "++++++++++++++install_boost++++++++++++++"
    @rem unzip  -q  boost_1_74_0.zip
    @rem vs2008 <-> toolset=msvc-9.0
    @rem vs2010 <-> toolset=msvc-10.0
    @rem vs2013 <-> toolset=msvc-12.0
    @rem vs2015 <-> toolset=msvc-14.0
    @rem vs2017 <-> toolset=msvc-15.0
    @rem vs2019 <-> toolset=msvc-16.0
    @rem vs2022 <-> toolset=msvc-17.0
    pushd boost_1_74_0
        if exist .\b2.exe (
            .\b2.exe install --prefix="%HomeDir%/boost_1_74_0/" --build-type=complete --toolset=msvc-17.0 variant=%BuildType%  link=shared threading=multi runtime-link=shared address-model=%BitNum%
        ) else (
            echo .\b2.exe doesn't exist!
        )
        if exist .\bootstrap.bat (
            .\bootstrap.bat vc142
        ) else (
            echo .\bootstrap.bat doesn't exist!
        )
        if exist .\b2.exe (
            .\b2.exe install --prefix="%HomeDir%/boost_1_74_0/" --build-type=complete --toolset=msvc-17.0 variant=%BuildType%  link=shared threading=multi runtime-link=shared address-model=%BitNum%
        ) else (
            echo .\b2.exe doesn't exist!
        )
        echo BuildType=%BuildType%, BitNum=%BitNum%
        set BuildDir=%BuildType%_win%BitNum%
    popd
    endlocal
goto :eof

:install_boost1830
    setlocal ENABLEDELAYEDEXPANSION
    set BuildType="%~1"
    set BitNum="%~2"
    set HomeDir="%~3"
    call :color_text 2f "++++++++++++++install_boost++++++++++++++"
    @rem unzip  -q  boost_1_83_0.zip
    @rem vs2008 <-> toolset=msvc-9.0
    @rem vs2010 <-> toolset=msvc-10.0
    @rem vs2013 <-> toolset=msvc-12.0
    @rem vs2015 <-> toolset=msvc-14.0
    @rem vs2017 <-> toolset=msvc-15.0
    @rem vs2019 <-> toolset=msvc-16.0
    @rem vs2022 <-> toolset=msvc-17.0  @rem 143
    pushd boost_1_83_0
        if exist .\b2.exe (
            .\b2.exe install --prefix="%HomeDir%/boost_1_83_0/" --build-type=complete --toolset=msvc-14.3 variant=%BuildType%  link=shared threading=multi runtime-link=shared address-model=%BitNum%
        ) else (
            echo .\b2.exe doesn't exist!
        )
        if exist .\bootstrap.bat (
            .\bootstrap.bat vc143
        ) else (
            echo .\bootstrap.bat doesn't exist!
        )
        echo BuildType=%BuildType%, BitNum=%BitNum%
        set BuildDir=%BuildType%_win%BitNum%
    popd
    endlocal
goto :eof

:GetCurSysTime
    setlocal EnableDelayedExpansion
    set dateStr=
    set timeStr=
    set year=%date:~6,4%
    set month=%date:~4,2%
    set day=%date:~0,2%
    set dateStr=%date: =_%
    set dateStr=%dateStr:/=x%
    set timeStr=%time::=x%
    set timeStr=%time: =%
    endlocal & set %~1=%dateStr%__%timeStr%
goto :eof
