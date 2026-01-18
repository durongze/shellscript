@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

@rem copy compiler\mr_helper.mrp compiler\mr_helpere.mrp

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

set MrpCodeDir=d:\code\mrp
set MythSdkDir=%MrpCodeDir%\mythsdk
set MythSdkVmDir=%MrpCodeDir%\vmrp\BuildLib\Debug
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
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PythonHome%\Scripts;%PATH%

set HomeDir=%MrpCodeDir%\out\windows

call :ArmEnvSet  "%SkySdkDir%"  ARMHOME ARMCONF    ARMDLL ARMINC ARMLIB    ARMLMD_LICENSE_FILE

set path=%ARMHOME%\bin;%path%

set FrameworkLib=WS2_32.lib;winmm.lib;vfw32.lib;
set SkySdkLib=dsound.lib;dxguid.lib;simulator.lib;simlib.lib;jpeg_sim.lib;SIM_mr_helperexb.lib;data_codec_sim.lib;SIM_mr_helperexbnp.lib;
set VscLib=kernel32.lib;user32.lib;gdi32.lib;winspool.lib;shell32.lib;ole32.lib;oleaut32.lib;uuid.lib;comdlg32.lib;advapi32.lib;

@rem x86  or x64
call %VisualStudioCmd% x86
pause

set skysdk_dir=%ProgramDir%\SkySdk
set skysdk_lib_inc="%skysdk_dir%\include"
set skysdk_lib_dir="%skysdk_dir%\Simulator\lib"
set skysdk_lib_file="%skysdk_dir%\Simulator\lib\simulator.lib"
set skysdk_lib_name="simulator.lib"
set skysdk_obj_file=".\Debug\mrporting.obj"
set skysdk_func_name="mrc_startBrowser"

call :check_vs_lib_in_spec_dir   "Simulator\lib"
pause

call :CheckLibInDir         "%FrameworkLib%"                "%FrameworkDir%"
call :CheckLibInDir         "%FrameworkLib%"                "%VCInstallDir%\PlatformSDK\lib"
call :CheckLibInDir         "%VscLib%"                      "%WindowsSdkDir%"
call :CheckLibInDir         "%VscLib%"                      "%VCInstallDir%\PlatformSDK\Lib"
call :CheckLibInDir         "%SkySdkLib%"                   "%SkySdkDir%\Simulator\lib"
call :search_func_in_lib    "%SkySdkLibDir%\simulator.lib"  "mrc_startBrowser"
call :find_lib_by_func      "%SkySdkLibDir%"                "mrc_startBrowser"
@rem call:show_lib_info         "simulator.lib"                 ".\Debug\mrporting.obj"
@rem call:show_obj_info         ".\Debug\mrporting.obj"

pause
goto :eof


:ArmEnvSet
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ ArmEnvSet ++++++++++++++ "
    set CurDir=%~1

    set ARM_HOME=%CurDir%
    set ARM_CONF=%ARM_HOME%\bin

    set ARM_DLL=%ARM_HOME%\bin
    set ARM_INC=%ARM_HOME%\include
    set ARM_LIB=%ARM_HOME%\lib

    set ARM_LMD_LICENSE_FILE=%ARM_HOME%\license.dat

    set path=%ARM_HOME%\bin;%path%
    call :color_text 2f " -------------- ArmEnvSet -------------- "
    endlocal & set "%~2=%ARM_HOME%"& set "%~3=%ARM_CONF%"& set "%~4=%ARM_DLL%"& set "%~5=%ARM_INC%"& set "%~6=%ARM_LIB%"& set "%~7=%ARM_LMD_LICENSE_FILE%"
goto :eof

:ArmEnvCmd
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ ArmEnvCmd ++++++++++++++ "
    set CurDir=%~1
    @echo set SkySdkDir=%CurDir%\..\
    @echo set ARMHOME=%CurDir%\
    @echo set ARMCONF=%CurDir%\bin
    @echo set ARMDLL=%CurDir%\bin
    @echo set ARMINC=%CurDir%\include
    @echo set ARMLIB=%CurDir%\lib
    @echo set ARMLMD_LICENSE_FILE=%CurDir%\license.dat
    call :color_text 2f " -------------- ArmEnvCmd --------------- "
    endlocal
goto :eof

:ArmEnvShow
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ ArmEnvShow ++++++++++++++ "
    @echo SkySdkDir=%SkySdkDir%
    @echo ARMHOME=%ARMHOME%
    @echo ARMCONF=%ARMCONF%
    @echo ARMDLL=%ARMDLL%
    @echo ARMINC=%ARMINC%
    @echo ARMLIB=%ARMLIB%

    where armcc
    armcc

    call :color_text 2f " -------------- ArmEnvShow --------------- "
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
    set SkySdkLibFiles=mrpverify_dbg_win32.lib netpay_win32.lib platreq_win32.lib verdload_win32.lib browser_win32.lib %SkySdkLibFiles%
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
    for %%C in (!VCPathSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurVcDir=%%A:\%%~B\%%~C
                echo [!idx_a!] [!idx_b!] [!idx_c!] VS80COMNTOOLS=!VS80COMNTOOLS!
                echo [!idx_a!] [!idx_b!] [!idx_c!] CurVcDir=!CurVcDir!
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

:CopyDynamicLibsForVS2005
    setlocal EnableDelayedExpansion
    set SpecLibDir=%~1
    call :color_text 2f " +++++++++++++++++++ CopyDynamicLibsForVS2005 +++++++++++++++++++++++ "
    call :DetectProgramDir    ProgramDir
    set VCInstallDir=%ProgramDir%\SkySdk\VS2005\VC
    set RedistDir=%VCInstallDir%\redist\Debug_NonRedist\x86
    mkdir %SpecLibDir%\lib
    xcopy %RedistDir%         "%SpecLibDir%\"         /y /s /e   
    xcopy %RedistDir%         "%SpecLibDir%\lib\"     /y /s /e   
    call :color_text 2f " -------------------- CopyDynamicLibsForVS2005 ----------------------- "
    endlocal
goto :eof

:CopyStaticLibsForVS2005
    setlocal EnableDelayedExpansion
    set ProjDir=%~1
    call :color_text 2f " +++++++++++++++++++ CopyStaticLibsForVS2005 +++++++++++++++++++++++ "
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
    set SkySdkLib=mrpverify_dbg_win32.lib;netpay_win32.lib;platreq_win32.lib;verdload_win32.lib;browser_win32.lib;%SkySdkLib%

    call :CopyStaticLibToSpecDir         "%VscLib%"             "%VscDir%"         "%ProjDir%"
    call :CopyStaticLibToSpecDir         "%VsAtlmfcLib%"        "%VsAtlmfcDir%"    "%ProjDir%"
    @rem call :CopyStaticLibToSpecDir         "%FrameworkLib%"       "%FrameworkDir%"                 "%ProjDir%"

    @rem call :CopyStaticLibToSpecDir         "%SkySdkLib%"          "%SkySdkDir%\Simulator\lib"      "%ProjDir%"

    call :color_text 2f " -------------------- CopyStaticLibsForVS2005 ----------------------- "
    endlocal
goto :eof

:CopyStaticLibToSpecDir
    setlocal EnableDelayedExpansion
    set Libs=%~1
    set LibDir="%~2"
    set ProjDir=%~3
    set MyPlatformSDK=%ProjDir%\lib
    if not exist "%MyPlatformSDK%" (
        mkdir %MyPlatformSDK%
    )
    call :color_text 2f " +++++++++++++++++++ CopyStaticLibToSpecDir +++++++++++++++++++++++ "
    echo LibDir %LibDir%
    if not exist %LibDir% (
        call :color_text 4f " -------------------- CopyStaticLibToSpecDir ----------------------- "
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
    call :color_text 2f " -------------------- CopyStaticLibToSpecDir ----------------------- "
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
    for %%C in (!VCPathSet!) do (
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

    echo "C:\Program Files (x86)\Microsoft SDKs\Windows"
    echo "C:\Program Files (x86)\Windows Kits"
    echo "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\Platforms\Win32\PlatformToolsets\v80\Microsoft.Cpp.Win32.v80.props"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\8.0\Setup\VC" /v "ProductDir"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\8.0\Setup\VS" /v "ProductDir"
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

:search_func_in_lib
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set func_name=%~2
    call:color_text 2f "++++++++++++++++++dumpbin SYMBOLS lib_name++++++++++++++++++"
    @rem dumpbin /?
    @rem dumpbin /ARCHIVEMEMBERS  %lib_name%
    @rem dumpbin /HEADERS %lib_name%  /SECTION:.drectve
    dumpbin /HEADERS %lib_name%  | grep "machine"
    dumpbin /SYMBOLS %lib_name%  | grep "%func_name%"
    call:color_text 2f "------------------dumpbin SYMBOLS lib_name------------------"
    endlocal
goto :eof

:find_lib_by_func
    setlocal ENABLEDELAYEDEXPANSION
    set lib_dir=%1
    set func_name=%~2
    call:color_text 2f " ++++++++++++++ find_lib_by_func ++++++++++++++ "
    set idx=0
    pushd %lib_dir%
        for /f %%i in (' dir /b  ') do (
            set /a idx+=1
            set lib_file=%%i
            echo [!idx!]lib_file:!lib_file! 
            call :search_func_in_lib "!lib_file!"  "%func_name%"
        )
    popd
    call:color_text 2f " -------------- find_lib_by_func -------------- "
    endlocal
goto :eof

:check_vs_lib_in_spec_dir
    setlocal ENABLEDELAYEDEXPANSION
    set lib_dir=%1
    set spec_vc_ver=VC80

    call:color_text 2f " ++++++++++++++ check_vs_lib_in_spec_dir ++++++++++++++ "
    echo %0 %lib_dir%

    set idx=0
    for /f %%i in ('dir /s /b "%lib_dir%\*.lib" ') do (
        set /a idx+=1
        set lib_file=%%i
        echo [!idx!] dumpbin /all !lib_file! ^| findstr !spec_vc_ver!
        dumpbin /all !lib_file! | findstr !spec_vc_ver!
    )
    call:color_text 9f " -------------- check_vs_lib_in_spec_dir -------------- "
    endlocal
goto :eof

:search_func_in_dll
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set func_name=%~2
    call:color_text 2f "--------------dumpbin exports lib_name--------------"
    dumpbin /exports %lib_name%  | grep "%func_name%"
    endlocal
goto :eof

:search_func_in_lib
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set func_name=%~2
    call:color_text 2f " ++++++++++++++++++ search_func_in_lib ++++++++++++++++++ "
    if "%func_name%" == "" (
        @rem dumpbin /ARCHIVEMEMBERS  %lib_name%
        @rem dumpbin /HEADERS %lib_name%  /SECTION:.drectve
        @rem dumpbin /HEADERS %lib_name%  | grep "machine"
        dumpbin /EXPORTS %lib_name%
        dumpbin /SYMBOLS %lib_name%
        strings %lib_name%
    ) else (
        dumpbin /SYMBOLS %lib_name%  | grep %func_name%
        strings %lib_name% |  findstr /i "%func_name%"
    )
    call:color_text 2f " ------------------ search_func_in_lib ------------------ "
    endlocal
goto :eof

:show_lib_info
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set spec_obj=%~2
    set sym_text=%lib_name%_sym.txt
    call:color_text 2f " ++++++++++++++ show_lib_info ++++++++++++++ "
    echo %0 %lib_name%
    dumpbin /HEADERS %lib_name%
    @rem objdump -S %lib_name% | grep -C 5 "_open"
    lib /list %lib_name% > %sym_text%
    lib /list:%sym_text% %lib_name%
    echo %0 lib_name:%lib_name%  sym_text:%sym_text%
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
    call:color_text 2f " -------------- show_lib_info -------------- "
    endlocal
goto :eof

:show_obj_info
    setlocal ENABLEDELAYEDEXPANSION
    set spec_obj=%~1

    call:color_text 2f " ++++++++++++++ show_obj_info ++++++++++++++ "
    echo %0 %spec_obj%
    set idx=0
    :GOON
    for /f "delims=\, tokens=1,*" %%i in ("%spec_obj%") do (
        set /a idx+=1
        echo [!idx!]%%i %%j
        set spec_obj=%%j
        set file_name=%%i
        call:get_path_by_file !file_name! FilePath FileName ExtName
        echo [!idx!]file_name:!file_name! spec_obj: !spec_obj! FileName:!FileName! ExtName: !ExtName!
        if exist !spec_obj! (
            dumpbin /all !spec_obj! > !spec_obj!_sym.txt
            dumpbin /disasm !spec_obj! > !spec_obj!_asm.txt 
            goto :GOON_END
        )
        goto GOON
    )
    :GOON_END
    call:color_text 2f " -------------- show_obj_info -------------- "
    endlocal
goto :eof

:append_obj_to_lib
    setlocal ENABLEDELAYEDEXPANSION
    lib simulator.lib os_adapter.obj
    lib /out:simulator_new.lib simulator.lib os_adapter.obj
    @rem lib simulator.lib /remove os_adapter.obj
    endlocal
goto :eof

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

:QuerySystemEnv
    setlocal EnableDelayedExpansion
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    reg query "HKEY_CURRENT_USER\Environment"
    endlocal
goto :eof
