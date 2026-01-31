@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

@rem x86  or x64
call %VisualStudioCmd% x64

@rem Win32  or x64
set ArchType=Win32
call :DetectWinSdk   WinSdkDirHome   WinSdkDirBin   WinSdkDirInc   WinSdkDirLib

echo WinSdkDirBin=%WinSdkDirBin%
echo WinSdkDirInc=%WinSdkDirInc%
echo WinSdkDirLib=%WinSdkDirLib%

set PATH=%WinSdkDirBin%;%PATH%
set INCLUDE=%WinSdkDirInc%;%INCLUDE%
set LIB=%WinSdkDirLib%;%LIB%

set OpenSslDir=openssl-1.0.2d
set InstallDir=%ProgramDir%

call :CompileOpenSsl %OpenSslDir% %InstallDir%

pause
goto :eof

@rem openssl-1.0.2d
:CompileOpenSsl
    setlocal ENABLEDELAYEDEXPANSION
    set OpenSslDir=%~1
    set InstallDir=%~2
    pushd %OpenSslDir%
        perl Configure VC-WIN32 no-asm --prefix=%InstallDir%/openssl/
        call ms\do_ms
        nmake -f ms\ntdll.mak
        nmake -f ms\ntdll.mak install
        popd
    endlocal
goto :eof


:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1
    call :color_text 2f " ++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
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
    for %%C in (!VCPathSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurBatFile=%%A:\%%~B\%%~C\vcvarsall.bat
                echo [!idx_a!][!idx_b!][!idx_c!] !CurBatFile!
                if exist !CurBatFile! (
                    goto :DetectVsPathBreak
                )
            )
        )
    )
    :DetectVsPathBreak
    echo Use:%CurBatFile%
    call :color_text 2f " -------------------- DetectVsPath ----------------------- "
    endlocal & set "%~1=%CurBatFile%"
goto :eof

:DetectWinSdk
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1
    set VS_ARCH=x64

    call :color_text 2f " ++++++++++++++++++ DetectWinSdk +++++++++++++++++++++++ "

    set WindowsSdkVersion=10.0.22621.0

    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet=program
    set AllProgramsPathSet=%AllProgramsPathSet%;programs

    set VCPathSet=%VCPathSet%;"VS2022\Windows Kits\10"
    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\SDK\v2.0"

    set idx_a=0
    for %%C in (!VCPathSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurDirName=%%A:\%%B\%%~C
                echo [!idx_a!][!idx_b!][!idx_c!] !CurDirName!
                if exist !CurDirName! (
                    set WindowsSdkDir=!CurDirName!
                    set WIN_SDK_BIN=!WindowsSdkDir!\bin\!WindowsSdkVersion!\!VS_ARCH!;
                    set WIN_SDK_INC=!WIN_SDK_INC!;!WindowsSdkDir!\Include\!WindowsSdkVersion!\um;
                    set WIN_SDK_INC=!WIN_SDK_INC!;!WindowsSdkDir!\Include\!WindowsSdkVersion!\ucrt;
                    set WIN_SDK_INC=!WIN_SDK_INC!;!WindowsSdkDir!\Include\!WindowsSdkVersion!\shared;
                    set WIN_SDK_LIB=!WIN_SDK_LIB!;!WindowsSdkDir!\Lib\!WindowsSdkVersion!\um\!VS_ARCH!;
                    set WIN_SDK_LIB=!WIN_SDK_LIB!;!WindowsSdkDir!\Lib\!WindowsSdkVersion!\ucrt\!VS_ARCH!;
                    goto :DetectWinSdkBreak
                )
            )
        )
    )
    :DetectWinSdkBreak
    echo Use:%CurDirName%
    call :color_text 2f " ------------------ DetectWinSdk ----------------------- "
    endlocal & set "%~1=%CurDirName%" & set %~2=%WIN_SDK_BIN% & set %~3=%WIN_SDK_INC% & set %~4=%WIN_SDK_LIB%
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
