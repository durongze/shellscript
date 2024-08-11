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

call %VisualStudioCmd%

@rem { VC-WIN64A | VC-WIN64I | VC-CE }
set BuildType=VC-WIN32 

perl Configure %BuildType%
nmake
nmake test
nmake install
pause
goto :eof

:DetectProgramDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;
    set CurProgramDir=
    set idx=0
    call :color_text 2f "+++++++++++++++++++DetectProgramDir+++++++++++++++++++++++"
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
    call :color_text 2f "--------------------DetectProgramDir-----------------------"
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
        if not exist !LibDir!\!CurLib! (
            echo !LibDir!\!CurLib!
        ) else (
            copy !LibDir!\!CurLib! %MyPlatformSDK%
        )
    )
    popd
    call :color_text 2f "--------------------CheckLibInDir-----------------------"
    endlocal
goto :eof

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1

    set VisualStudioCmdSet="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
    
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

    set VisualStudioCmdSet=%VisualStudioCmdSet%;"C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall.bat"

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