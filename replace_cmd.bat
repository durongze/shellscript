@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set SDCCPath=%ProgramDir%\SDCC\bin
set MakePath=%ProgramDir%\make-3.81-bin\bin
set PythonHome=%ProgramDir%\python\Python312
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%SDCCPath%;%MakePath%;%PythonHome%;%PythonHome%\Scripts;%PATH%

set MakeProgram=%MakePath%\make.exe

set HomeDir=%ProjDir%\out\windows

set software_dir="%ProjDir%\thirdparty"

@rem x86  or x64
call %VisualStudioCmd% x64

set workdir=%CurDir:~0,-1%
set src_target=test_args.exe
set dst_dir=dst
set bak_dir=bak

cl.exe test_args.cc
call :replace_all_cmd %workdir% %src_target%  %dst_dir%  %bak_dir%

pause
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
    call :color_text 2f " -------------------- DetectWinSdk ----------------------- "
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

:get_path_by_file
    setlocal EnableDelayedExpansion
    set myfile=%1
    set mypath=%~dp1
    set myname=%~n1
    set myext=%~x1
    call :color_text 2f " ++++++++++++++++++ get_path_by_file ++++++++++++++++++++++++ "

    echo 0    =%0
    echo f0   =%~f0
    echo d0   =%~d0
    echo p0   =%~p0
    echo n0   =%~n0
    echo x0   =%~x0
    echo dp0  =%~dp0
    echo nx0  =%~nx0
    echo dpnx0=%~dpnx0

    echo !mypath! !myname! !myext!
    call :color_text 2f " -------------------- get_path_by_file ----------------------- "
    endlocal & set %~2=%mypath%&set %~3=%myname%&set %~4=%myext%
goto :eof

:replace_all_cmd
    setlocal ENABLEDELAYEDEXPANSION
    set workdir=%1
    set src_target=%2
    set dst_dir=%3
    set bak_dir=%4
    set mypath=
    set myname=
    set myext=

    if not exist %dst_dir% (
        mkdir %dst_dir%
    )
    if not exist %bak_dir% (
        mkdir %bak_dir%
    )
    pushd %workdir%
    for /f "delims=" %%i in ('dir /s /b "*.exe"') do (
        call :color_text af "+++++++++++++++++replace_all_cmd+++++++++++++++++++++++++"
        echo %%i
        call :get_path_by_file %%i mypath myname myext
        copy  %%i           %bak_dir%\
        copy  !src_target!  !dst_dir!\!myname!!myext!
    )
    popd
    endlocal
goto :eof
