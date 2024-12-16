@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set software_dir="%ProjDir%\thirdparty"
set HomeDir=%ProjDir%\out\windows

@rem x86  or x64
call %VisualStudioCmd% x86

@rem Win32  or x64
set ArchType=x64

set IdlFileList=.\IFileTypeRegistrar.idl

call :MidlProcFile "%ArchType%" "%IdlFileList%"

pause
goto :eof

:MidlProcFile
    setlocal EnableDelayedExpansion
    set ArchType=%~1
    set IdlFileList=%~2

    call :color_text 2f " +++++++++++++++++++ MidlProcFile +++++++++++++++++++++++ "
    set BitNum=32
    set ArchX=x86
    if "!ArchType!" == "x64" (
        set BitNum=64
        set ArchX=x64
    ) else (
        set BitNum=32
        set ArchX=x86
    )
    if not exist !ArchX!_DebugPS (
        md "!ArchX!_DebugPS"
    )
    set idx=0
    for %%i in ( %IdlFileList% ) do (
        set /a idx+=1
        set IdlFile=%%i
        echo [!idx!] IdlFile=!IdlFile! 
        if exist !IdlFile! (
            call :get_path_by_file  !IdlFile! IdlPath IdlName IdlExt
            echo IdlPath=!IdlPath! IdlName=!IdlName! IdlExt=!IdlExt!
            midl /env !ArchX! /h "!IdlName!_!BitNum!.h" /W1 /char signed /tlb "ElevatorPS.tlb"  /nologo /out "!ArchX!_DebugPS"   "!IdlName!.idl"
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
    call :color_text 2f " -------------------- DetectProgramDir ----------------------- "
    endlocal & set %~1=%ProgramDir%
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
    set VCPathSet=SkySdk\VS2005\VC
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
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

:get_path_by_file
    setlocal EnableDelayedExpansion
    set myfile=%1
    set mypath=%~dp1
    set myname=%~n1
    set myext=%~x1
    call :color_text 2f "++++++++++++++++++ get_path_by_file ++++++++++++++++++++++++"
    echo !mypath! !myname! !myext!
    call :color_text 2f "-------------------- get_path_by_file -----------------------"
    endlocal & set %~2=%mypath%&set %~3=%myname%&set %~4=%myext%
goto :eof

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
nmake test
nmake install

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