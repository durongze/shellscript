@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

@rem copy compiler\mr_helper.mrp compiler\mr_helpere.mrp

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
set MrpHomeDir=d:\code\mrp

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

set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%PerlPath%;%NASMPath%;%CMakePath%;%PythonHome%;%PATH%

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

call %VisualStudioCmd%

@rem call :CheckLibInDir         "%FrameworkLib%"  "%FrameworkDir%"
call :CheckLibInDir         "%FrameworkLib%"  "%VCInstallDir%\PlatformSDK\lib"
@rem call :CheckLibInDir         "%VscLib%"        "%WindowsSdkDir%"
call :CheckLibInDir         "%VscLib%"        "%VCInstallDir%\PlatformSDK\Lib"
call :CheckLibInDir         "%SkySdkLib%"     "%SkySdkDir%\Simulator\lib"

call :find_lib_by_func "%SkySdkLibDir%"  "mrc_startBrowser"
@rem call:show_lib_info simulator.lib ".\Debug\mrporting.obj"
@rem call:show_obj_info ".\Debug\mrporting.obj"

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
    call :color_text 2f "++++++++++++++++++DetectVsPath++++++++++++++++++++++++"
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
    call :color_text 2f "--------------------DetectVsPath-----------------------"
    endlocal & set "%~1=%CurBat%"
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

:find_lib_by_func
    setlocal ENABLEDELAYEDEXPANSION
    set lib_dir=%1
    set func_name=%~2
    call:color_text 2f "++++++++++++++find_lib_by_func++++++++++++++"
    set idx=0
    pushd %lib_dir%
        for /f %%i in (' dir /b  ') do (
            set /a idx+=1
            set lib_file=%%i
            echo [!idx!]lib_file:!lib_file! 
            call :search_func_in_lib "!lib_file!"  "%func_name%"
        )
    popd
    call:color_text 9f "--------------find_lib_by_func--------------"
    endlocal
goto :eof

:search_func_in_lib
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set func_name=%~2
    dumpbin /SYMBOLS %lib_name%  | grep %func_name%
    endlocal
goto :eof

:show_lib_info
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set spec_obj=%~2
    set sym_text=%lib_name%_sym.txt
    call:color_text 2f "++++++++++++++show_lib_info++++++++++++++"
    echo %0 %lib_name%
    @rem objdump -S %lib_name% | grep -C 5 "_open"
    lib /list %lib_name% > %sym_text%
    lib /list:%sym_text% %lib_name%
    echo %0 %lib_name%  %sym_text%
    set idx=0
    @rem for /f "tokens=4 delims=," %%i in ( %sym_text% ) do (
    for /f %%i in ( %sym_text% ) do (
        set /a idx+=1
        set obj_file=%%i
        echo [!idx!]obj_file:!obj_file!  lib_name:!lib_name!  spec_obj: !spec_obj!
        if "!obj_file!" == "!spec_obj!" (
            lib !lib_name! /extract:!obj_file!
        )
    )
    call:color_text 9f "--------------show_lib_info--------------"
    endlocal
goto :eof

:show_obj_info
    setlocal ENABLEDELAYEDEXPANSION
    set spec_obj=%~1

    call:color_text 2f "++++++++++++++show_obj_info++++++++++++++"
    echo %0 %spec_obj%
    set idx=0
    :GOON
    for /f "delims=\, tokens=1,*" %%i in ("%spec_obj%") do (
        set /a idx+=1
        echo [!idx!]%%i %%j
        set spec_obj=%%j
        set file_name=%%i
        echo [!idx!]file_name:!file_name! spec_obj: !spec_obj!
        if exist !spec_obj! (
            dumpbin /all !spec_obj! > !spec_obj!_sym.txt
            dumpbin /disasm !spec_obj! > !spec_obj!_asm.txt 
            goto :GOON_END
        )
        goto GOON
    )
    :GOON_END
    call:color_text 9f "--------------show_obj_info--------------"
    endlocal
goto :eof

:append_obj_to_lib
    setlocal ENABLEDELAYEDEXPANSION
    lib simulator.lib os_adapter.obj
    lib /out:simulator_new.lib simulator.lib os_adapter.obj
    @rem lib simulator.lib /remove os_adapter.obj
    endlocal
goto :eof

:HandleFileName
    setlocal EnableDelayedExpansion
    set FilePath=%~1
    set FileName=%~n1
    set ExtName=%~x1
    call :color_text 2f "+++++++++++++HandleFileName+++++++++++++++"
    echo FilePath:%FilePath%
    echo FileName:%FileName%
    echo ExtName:%ExtName%
    endlocal & set %~2=%FileName%& set %~3=%ExtName%
goto :eof

:QuerySystemEnv
    setlocal EnableDelayedExpansion
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    reg query "HKEY_CURRENT_USER\Environment"
    endlocal
goto :eof
