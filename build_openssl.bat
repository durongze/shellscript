@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%\..
echo ProjDir %ProjDir%

set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set path=%NASMPath%;%PerlPath%;%path%

set OPENSSL_VERSION=1.0.2d
set OpenSslSrcDir=%CurDir%\openssl-1.0.2d
set InstallDir=%ProjDir%\out
set OpenSslBinDir=%InstallDir%\openssl_102d

set VS2005_WIN32="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VS2013_WIN32="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VS2013_AMD64="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

set VS2015_WIN32="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VS2015_AMD64="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

set VS2019_WIN32="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VS2019_WIN32="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VS2022_WIN32="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
set VS2022_AMD64="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

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

call :CompileProjectWin64 
pause
goto :eof

:CompileProjectWin32
    setlocal ENABLEDELAYEDEXPANSION
    pushd %OpenSslSrcDir%
    perl Configure VC-WIN32 --prefix=%OpenSslSrcDir%
    call ms\do_ms.bat
    call ms\do_nasm.bat
    nmake -f ms\nt.mak clean
    nmake -f ms\nt.mak
    nmake -f ms\nt.mak install
    popd
    endlocal
goto :eof

:CompileProjectWin32Dbg
    setlocal ENABLEDELAYEDEXPANSION
    pushd %OpenSslSrcDir%
    perl Configure debug-VC-WIN32 --prefix=%OpenSslBinDir%
    call ms\do_ms.bat
    call ms\do_nasm.bat
    nmake -f ms\nt.mak clean
    nmake -f ms\nt.mak
    nmake -f ms\nt.mak install
    popd
    endlocal
goto :eof

:CompileProjectWin64
    setlocal ENABLEDELAYEDEXPANSION
    pushd %OpenSslSrcDir%
    perl Configure VC-WIN64A --prefix=%OpenSslBinDir%
    call ms\do_win64a.bat
    nmake -f ms\nt.mak clean
    nmake -f ms\nt.mak
    nmake -f ms\nt.mak install
    popd
    endlocal
goto :eof

:CompileProjectWin64Dbg
    setlocal ENABLEDELAYEDEXPANSION
    pushd %OpenSslSrcDir%
    perl Configure debug-VC-WIN64A --prefix=%OpenSslBinDir%
    call ms\do_win64a.bat
    nmake -f ms\nt.mak clean
    nmake -f ms\nt.mak
    nmake -f ms\nt.mak install
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
