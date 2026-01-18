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

call :SetProjEnv %software_dir% %CurDir% include lib path CMAKE_INCLUDE_PATH CMAKE_LIBRARY_PATH CMAKE_MODULE_PATH
call :ShowProjEnv

set SystemBinDir=.\

@rem x86  or x64
call %VisualStudioCmd% x64

@rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
@rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"

@rem Win32  or x64
set ArchType=Win32

set BuildDir=BuildLib
set BuildType=Debug
set BuildType=Release
set ProjName=
set build_mrp_ext=%CurDir%\mythroad\build_mrp_ext.bat

@rem sxstrace trace -logfile:%~dp0\sxstrace.etl
@rem sxstrace parse -logfile:%~dp0\sxstrace.etl -outfile:%~dp0\sxstrace.txt

call :get_suf_sub_str %ProjDir% \ ProjName

echo ProjName %ProjName%

call :TaskKillSpecProcess  "cl.exe"
call :TaskKillSpecProcess  "MSBuild.exe"

call :DetectWinSdk   WinSdkDirHome   WinSdkDirBin   WinSdkDirInc   WinSdkDirLib

echo WinSdkDirBin=%WinSdkDirBin%
echo WinSdkDirInc=%WinSdkDirInc%
echo WinSdkDirLib=%WinSdkDirLib%

set PATH=%WinSdkDirBin%;%PATH%
set INCLUDE=%WinSdkDirInc%;%INCLUDE%
set LIB=%WinSdkDirLib%;%LIB%

call :ShowVS2022InfoOnWin10

call :CompileProject "%BuildDir%" "%BuildType%" "%ProjName%"     "%HomeDir%"
call :CopyTarget     "%BuildDir%" "%BuildType%" "%SystemBinDir%"
pause
goto :eof

:del_lib_cacke_dir
    setlocal EnableDelayedExpansion
    set lib_dir="%~1"
    set home_dir="%~2"
    call :color_text 2f " ++++++++++++++ del_lib_cacke_dir ++++++++++++++ "
    pushd %lib_dir%
        set idx=0
        for /f %%i in ( 'dir /b /ad ' ) do (
            set /a idx+=1
            set cur_lib_name=%%i
            echo [!idx!] !cur_lib_name!
            if exist !cur_lib_name!\dyzbuild (
                echo !cur_lib_name!\dyzbuild does exist
                pause
            )
            if exist !cur_lib_name!\SMP\.vs (
                echo !cur_lib_name!\SMP\.vs does exist
                pause
            )
            if exist !cur_lib_name!\SMP\obj (
                echo !cur_lib_name!\SMP\obj does exist
                pause
            )
            tar -caf !cur_lib_name!.tar.gz !cur_lib_name!
        )
    popd
    call :color_text 2f " -------------- del_lib_cacke_dir --------------- "
    endlocal
goto :eof

:TaskKillSpecProcess
    setlocal EnableDelayedExpansion
    set ProcName=%~1
    call :color_text 2f " +++++++++++++++++++ TaskKillSpecProcess +++++++++++++++++++ "
    tasklist | grep  "%ProcName%"
    taskkill /f /im  "%ProcName%"
    call :color_text 2f " -------------------- TaskKillSpecProcess ----------------------- "
    endlocal
goto :eof

:upgrade_python_pip
    setlocal EnableDelayedExpansion
    python -m ensurepip
    python -m pip install --upgrade pip
    pip3 install Jinja2
    call :color_text 2f " -------------------- upgrade_python_pip ----------------------- "
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
            copy !LibDir!\!CurLib! !MyPlatformSDK!
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

:SdccCompileProj
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    set SrcDir=%~2

    call :color_text 2f " ++++++++++++++ SdccCompileProj ++++++++++++++ "
    if not exist %BuildDir% (
        mkdir %BuildDir%
    ) 

    set sdcc_flags= --model-small --less-pedantic --opt-code-size
    set sdcc_flags= --model-large --less-pedantic --opt-code-size
    set all_rel_file=
    set idx=0
    pushd %SrcDir%
    for /f %%i in ('dir /s /b *.c ') do (
        set /a idx+=1
        set cur_src=%%i
        call :get_path_by_file  !cur_src!   cur_dir   cur_name   cur_ext
        echo [!idx!] cur_dir=!cur_dir!    cur_name=!cur_name!    cur_ext=!cur_ext!
        pushd !BuildDir!
            echo sdcc.exe  -I!cur_dir!\ -I!cur_dir!\driver -I!cur_dir!\common -I!cur_dir!\tasks  !sdcc_flags!   -o !cur_name!.rel -c !cur_src!
            sdcc.exe  -I!cur_dir!\ -I!cur_dir!\driver -I!cur_dir!\common -I!cur_dir!\tasks  !sdcc_flags!   -o !cur_name!.rel -c !cur_src!
        popd
        set all_rel_file=!all_rel_file!  !cur_name!.rel 
    )
    popd

    pushd !BuildDir!
        echo sdcc.exe  !sdcc_flags!    -o demo.ihx !all_rel_file!
        sdcc.exe  !sdcc_flags!    -o demo.ihx !all_rel_file!
        packihx demo.ihx > demo.hex
    popd

    call :color_text 2f " -------------- SdccCompileProj -------------- "
    endlocal
goto :eof

:CompileProject
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    set BuildType=%~2
    set ProjName=%~3
    set LibHomeDir=%~4
    call :color_text 2f " +++++++++++++++++++ CompileProject +++++++++++++++++++++++ "
    if not exist CMakeLists.txt (
        echo CMakeLists.txt doesn't exist!
        goto :eof
    )
    if not exist %BuildDir% (
        mkdir %BuildDir%
    )
    if not exist %BuildDir%\%BuildType% (
        mkdir %BuildDir%\%BuildType%\
    )
    if exist "%LibHomeDir%" (
        echo search dll ....
        for /f %%i in ('dir /s /b "%LibHomeDir%\*.dll"') do (
            copy %%i %BuildDir%\%BuildType%\ 
            copy %%i %BuildDir%\%BuildType%\..
        )
    )
    pushd %BuildDir%
        set ALL_DEFS=            -D CMAKE_TOOLCHAIN_FILE="../toolchain.cmake" -D CMAKE_MAKE_PROGRAM="%MakeProgram%"            -D CMAKE_C_COMPILER_WORKS=ON
        set ALL_DEFS=            -D CMAKE_BUILD_TYPE=%BuildType%              -D CMAKE_INSTALL_PREFIX=%LibHomeDir%\%ProjName% 
        @rem del * /q /s
        @rem cmake .. -G "Visual Studio 16 2019" -A  %ArchType%
        @rem cmake .. -G "Visual Studio 17 2022" -A  %ArchType%
        @rem cmake    -G "Visual Studio 8  2005"     ..
        @rem cmake --build . --target clean
        @rem cmake ..  %ALL_DEFS%  -A %ArchType%
        cmake      ..  %ALL_DEFS%  -G "NMake Makefiles" 
        cmake      --build .       --config %BuildType%  --target %ProjName%
    popd
    call :color_text 2f " -------------------- CompileProject ----------------------- "
    endlocal
goto :eof

:CopyTarget
    setlocal ENABLEDELAYEDEXPANSION
    set BuildDir=%~1
    set BuildType=%2
    set SystemBinDir=%3
    for /f %%i in ('dir /s /b "%BuildDir%\bin\%BuildType%\*.exe"') do (   copy %%i %SystemBinDir%\ )
    endlocal
goto :eof

:RunWinSvr
    setlocal ENABLEDELAYEDEXPANSION
    set ProjName=%~1
    set BuildDir="%~2"
    set BuildType=%3
    set BinPath="%~4"
    @rem 
    if not exist %BinPath% (
        call :color_text 4f "++++++++++++++RunWinSvr file does not exist++++++++++++++"
        echo BinPath %BinPath% .
    ) else (
        sc create %ProjName% binPath= %BinPath%
        sc config %ProjName% start=auto
        @rem sc start %ProjName%
        net start %ProjName%
        if !errorlevel! equ 0 (
            sc stop %ProjName%
        ) else (
            call :color_text 4f " -------------- RunWinSvr net start error -------------- "
            %BinPath%
        )
        @rem sc delete %ProjName%
    )
    endlocal
goto :eof

:SetProjEnv
    setlocal ENABLEDELAYEDEXPANSION
    set software_dir=%~1
    set loc_dir=%~2
    set loc_inc=%3
    set loc_lib=%4
    set loc_bin=%5
    call :color_text 9f " ++++++++++++++ SetProjEnv ++++++++++++++ "
    if not exist %software_dir% (
        echo software_dir '%software_dir%' doesn't exist!
        goto :eof
    )
    if not exist %HomeDir% (
        echo HomeDir '%HomeDir%' doesn't exist!
        goto :eof
    )
    call :gen_all_env_by_dir %software_dir% %HomeDir% loc_inc loc_lib loc_bin cmake_inc cmake_lib cmake_path
    set all_inc=%loc_inc%;%include%;%loc_dir%\include;
    set all_lib=%loc_lib%;%lib%;%loc_dir%\lib;%loc_dir%\bin;
    set all_bin=%loc_bin%;%path%;%loc_dir%\bin;
    call :color_text 9f " -------------- SetProjEnv -------------- "
    endlocal & set %~3=%all_inc% & set %~4=%all_lib% & set %~5=%all_bin% & set %~6=%cmake_inc% & set %~7=%cmake_lib% & set %~8=%cmake_path%
goto :eof

:ShowProjEnv
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ ShowProjEnv ++++++++++++++ "
    echo include           :%include%
    echo lib               :%lib%
    echo path              :%path%
    echo CMAKE_INCLUDE_PATH:%CMAKE_INCLUDE_PATH%
    echo CMAKE_LIBRARY_PATH:%CMAKE_LIBRARY_PATH%
    echo CMAKE_MODULE_PATH :%CMAKE_MODULE_PATH%
    call :color_text 9f " -------------- ShowProjEnv -------------- "
    endlocal
goto :eof

:ResetSystemEnv
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ ResetSystemEnv ++++++++++++++ "
    @rem set include=%old_sys_include%
    @rem set lib=%old_sys_lib%
    @rem set path=%old_sys_path%
    call :color_text 9f " -------------- ResetSystemEnv -------------- "
    endlocal
goto :eof

:ShowVS2022InfoOnWin10
    setlocal EnableDelayedExpansion
    call :color_text 2f "+++++++++++++++++++ShowVS2022InfoOnWin10+++++++++++++++++++++++"
    @rem Error HKCU\SOFTWARE  or  HKCU\SOFTWARE\Wow6432Node
    set SoftwareRoot=HKLM\SOFTWARE\Wow6432Node
    echo SoftwareRoot=%SoftwareRoot%

    @rem see winsdk.bat -> GetWin10SdkDir -> GetWin10SdkDirHelper ->
    reg query "%SoftwareRoot%\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"

    @rem see winsdk.bat -> GetUniversalCRTSdkDir -> GetUniversalCRTSdkDirHelper -> 
    reg query "%SoftwareRoot%\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"

    set SoftwareRoot=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node
    set OldVerKey=Microsoft\Microsoft SDKs\Windows\v10.0
    echo OldVerKey=%OldVerKey%

    @rem reg delete "%SoftwareRoot%\%OldVerKey%" /v InstallationFolder
    @rem reg add    "%SoftwareRoot%\%OldVerKey%" /v InstallationFolder /f /t REG_SZ /d "D:\Program Files (x86)\Windows Kits\10\"
    @rem reg add    "%SoftwareRoot%\%OldVerKey%" /v InstallationFolder /f /t REG_SZ /d "E:\Program\VS2022\Windows Kits\10"
    reg query       "%SoftwareRoot%\%OldVerKey%" /v InstallationFolder

    set SoftwareRoot=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node
    set NewVerKey=Microsoft\Windows Kits\Installed Roots
    echo NewVerKey=%NewVerKey%

    @rem reg delete "%SoftwareRoot%\%NewVerKey%"  /v KitsRoot10 
    @rem reg add    "%SoftwareRoot%\%NewVerKey%"  /v KitsRoot10         /f /t REG_SZ /d "D:\Program Files (x86)\Windows Kits\10\"
    @rem reg add    "%SoftwareRoot%\%NewVerKey%"  /v KitsRoot10         /f /t REG_SZ /d "E:\Program\VS2022\Windows Kits\10"
    reg query       "%SoftwareRoot%\%NewVerKey%"  /v KitsRoot10

    echo "C:\Program Files (x86)\Microsoft SDKs\Windows"
    echo "C:\Program Files (x86)\Windows Kits"
    echo "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\Platforms\Win32\PlatformToolsets\v80\Microsoft.Cpp.Win32.v80.props"

    set SoftwareRoot=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node
    set VC2005_Key=Microsoft\VisualStudio\8.0
    echo VC2005_Key=%VC2005_Key%

    reg query "%SoftwareRoot%\%VC2005_Key%\Setup\VC" /v "ProductDir"
    reg query "%SoftwareRoot%\%VC2005_Key%\Setup\VS" /v "ProductDir"

    set VC2022_Key=Microsoft\VisualStudio\Setup\Instances\ManualVS2022
    echo VC2022_Key=%VC2022_Key%

    reg query "%SoftwareRoot%\%VC2022_Key%"
    reg query "%SoftwareRoot%\%VC2022_Key%\Catalog\Components"

    where cl
    where nmake
    where rc

    where msbuild
    where devenv
    where mt

    @rem where vswhere

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
        echo [!idx!]file_name:!file_name! spec_obj: !spec_obj!
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

:MakeDir
    setlocal EnableDelayedExpansion
    set DirName="%~1"
    if not exist %DirName% (
        mkdir %DirName%
    )
    endlocal
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

:get_dir_by_tar
    setlocal ENABLEDELAYEDEXPANSION
    set tar_file="%~1"
    call :color_text 2f "++++++++++++++get_dir_by_tar++++++++++++++"
    @rem for /f "tokens=8 delims= " %%i in ('tar -tf %tar_file%') do ( echo %%~i )
    set FileDir=
    set file_name=
    echo "    tar -tf %tar_file% | grep "/$" | gawk -F"/" "{ print $1 }" | sed -n "1p"    "
    FOR /F "usebackq" %%i IN (` tar -tf %tar_file% ^| grep "/$" ^| gawk -F"/" "{print $1}" ^| sed -n "1p" `) DO (set FileDir=%%i)
    @rem echo tar_file:%tar_file% FileDir:!FileDir!
    call :is_contain %tar_file% %FileDir% file_name
    if "%file_name%" == "false" (
        call :color_text 4f "-------------get_dir_by_tar--------------"
        echo tar_file:%tar_file% FileDir:%FileDir%
    )
    endlocal & set %~2=%FileDir%
goto :eof

:get_dir_by_zip
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file="%~1"
    call :color_text 2f "++++++++++++++get_dir_by_zip++++++++++++++"
    @rem for /f "tokens=8 delims= " %%i in ('unzip -v %zip_file%') do ( echo %%~i )
    set FileDir=
    set file_name=
    @rem unzip -v %zip_file% | gawk -F" "  "{ print $8 } " | gawk  -F"/" "{ print $1 }" | sed -n "5p"
    echo zip_file:%zip_file%
    FOR /F "usebackq" %%i IN (` unzip -v %zip_file% ^| gawk -F" "  "{ print $8 } " ^| gawk  -F"/" "{ print $1 }" ^| sed -n "5p" `) DO (set FileDir=%%i)
    FOR /F "usebackq" %%i IN (` unzip -v %zip_file% ^| gawk -F" "  "{print $8}" ^| grep -v "/[^$]" ^| gawk  -F"/" "{ print $1 }" ^| sed -n "5p" `) DO (set FileDir=%%i)
    @rem echo zip_file:%zip_file% FileDir:!FileDir!
    call :is_contain %zip_file% %FileDir% file_name
    if "%file_name%" == "false" (
        call :color_text 4f "-------------get_dir_by_zip--------------"
        echo zip_file:%zip_file% FileDir:%FileDir%
        pause
    )
    endlocal & set %~2=%FileDir%
goto :eof

:gen_env_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set zip_file="%~1"
    set HomeDir=%~2
    set FileDir=
    call :color_text 9f " ++++++++++++++ gen_env_by_file ++++++++++++++ "
    call :get_pre_sub_str !zip_file! . file_name
    call :get_last_char_pos !zip_file! . ext_name_pos
    echo file_name:!file_name! ext_name_pos:!ext_name_pos!
    call :get_suf_sub_str !zip_file! . ext_name
    echo ext_name:!ext_name!
    if "%ext_name%" == "zip" (
        call :get_dir_by_zip %zip_file% FileDir
    ) else if "%ext_name%" == "gz" (
        call :get_dir_by_tar %zip_file% FileDir
    ) else if "%ext_name%" == "xz" (
        call :get_dir_by_tar %zip_file% FileDir
    ) else (
        echo "%ext_name%"
    )
    call :color_text 9f " -------------- gen_env_by_file -------------- "
    set DstDirWithHome=%HomeDir%\%FileDir%
    echo %0 %zip_file% %DstDirWithHome%
    endlocal & set %~3=%DstDirWithHome%
goto :eof

:gen_all_env_by_file
    setlocal ENABLEDELAYEDEXPANSION
    set thridparty_dir="%~1"
    set home_dir="%~2"
    set DstDirWithHome=
    call :color_text 2f " ++++++++++++++ gen_all_env_by_file ++++++++++++++ "
    if not exist %thridparty_dir% (
        echo Dir '%thridparty_dir%' doesn't exist!
        goto :eof
    )
    pushd %thridparty_dir%
        for /f %%i in ( 'dir /b *.tar.* *.zip' ) do (
            set tar_file=%%i
            call :gen_env_by_file !tar_file! !home_dir! DstDirWithHome
            set inc=!DstDirWithHome!\include;!inc!
            set lib=!DstDirWithHome!\lib;!lib!
            set bin=!DstDirWithHome!\bin;!bin!
            set CMAKE_INCLUDE_PATH=!DstDirWithHome!\include;!CMAKE_INCLUDE_PATH!
            set CMAKE_LIBRARY_PATH=!DstDirWithHome!\lib;!CMAKE_LIBRARY_PATH!
            set CMAKE_MODULE_PATH=!DstDirWithHome!\lib\cmake;!CMAKE_MODULE_PATH!
            set CMAKE_MODULE_PATH=!DstDirWithHome!\cmake;!CMAKE_MODULE_PATH!
        )
    popd
    call :color_text 9f " -------------- gen_all_env_by_file -------------- "
    echo inc:%inc%
    echo lib:%lib%
    echo bin:%bin%
    endlocal & set %~3=%inc% & set %~4=%lib% & set %~5=%bin% & set %~6=%CMAKE_INCLUDE_PATH% & set %~7=%CMAKE_LIBRARY_PATH% & set %~8=%CMAKE_MODULE_PATH%
goto :eof

:gen_env_by_dir
    setlocal ENABLEDELAYEDEXPANSION
    set FileDir=%~1
    set HomeDir=%~2
    set DstDirWithHome=%3

    call :color_text 9f " ++++++++++++++ gen_env_by_dir ++++++++++++++ "
    set DstDirWithHome=%HomeDir%\%FileDir%
    echo %0 %zip_file% %DstDirWithHome%
    endlocal & set %~3=%DstDirWithHome%
goto :eof

:gen_all_env_by_dir
    setlocal ENABLEDELAYEDEXPANSION
    set thridparty_dir="%~1"
    set home_dir="%~2"
    set DstDirWithHome=
    call :color_text 2f " ++++++++++++ gen_all_env_by_dir ++++++++++++ "
    echo thridparty_dir  :%thridparty_dir%
    echo home_dir        :%home_dir%
    echo DstDirWithHome  :%DstDirWithHome%
    if not exist %thridparty_dir% (
        echo Dir '%thridparty_dir%' doesn't exist!
        goto :eof
    )
    pushd %thridparty_dir%
        for /f %%i in ( 'dir /b /ad ' ) do (
            set soft_dir=%%i
            call :gen_env_by_dir !soft_dir! !home_dir! DstDirWithHome
            set cur_inc=!DstDirWithHome!\include;!cur_inc!
            set cur_lib=!DstDirWithHome!\lib;!cur_lib!
            set cur_bin=!DstDirWithHome!\bin;!cur_bin!
            set CMAKE_INCLUDE_PATH=!DstDirWithHome!\include;!CMAKE_INCLUDE_PATH!
            set CMAKE_LIBRARY_PATH=!DstDirWithHome!\lib;!CMAKE_LIBRARY_PATH!
            set CMAKE_MODULE_PATH=!DstDirWithHome!\lib\cmake;!CMAKE_MODULE_PATH!
            set CMAKE_MODULE_PATH=!DstDirWithHome!\cmake;!CMAKE_MODULE_PATH!
        )
    popd
    call :color_text 9f " ----------- gen_all_env_by_dir ------------ "
    echo cur_inc    :%cur_inc%
    echo cur_lib    :%cur_lib%
    echo cur_bin    :%cur_bin%
    endlocal & set %~3=%cur_inc% & set %~4=%cur_lib% & set %~5=%cur_bin% & set %~6=%CMAKE_INCLUDE_PATH% & set %~7=%CMAKE_LIBRARY_PATH% & set %~8=%CMAKE_MODULE_PATH%
goto :eof

:show_all_env
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " +++++++++++ show_all_env ++++++++++++ "
    echo include    :%include%
    echo lib        :%lib%
    echo path       :%path%
    echo CMAKE_INCLUDE_PATH     :%CMAKE_INCLUDE_PATH%
    echo CMAKE_LIBRARY_PATH     :%CMAKE_LIBRARY_PATH%
    echo CMAKE_MODULE_PATH      :%CMAKE_MODULE_PATH%
    call :color_text 2f " ----------- show_all_env ------------ "
    endlocal
goto :eof

:get_str_len
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set mystrlen="%~2"
    set count=0
    call :color_text 2f "++++++++++++++get_str_len++++++++++++++"
    :intercept_str_len
    set /a count+=1
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="" (
            goto :intercept_str_len
        )
    )
    echo %0 %mystr% %count%
    endlocal & set %~2=%count%
goto :eof

:get_first_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set char_pos="%~3"
    call :get_str_len %mystr% mystrlen
    set count=0
    call :color_text 2f "++++++++++++++get_first_char_pos++++++++++++++"
    :intercept_first_char_pos
    for /f %%i in ("%count%") do (
        set /a count+=1
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            goto :intercept_first_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_last_char_pos
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set char_pos="%~3"
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_last_char_pos++++++++++++++"
    @rem set /a count-=1
    :intercept_last_char_pos
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a count-=1
            goto :intercept_last_char_pos
        )
    )
    echo %0 %mystr% %char_sym% %count%
    endlocal & set %~3=%count%
goto :eof

:get_pre_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set mysubstr="%~3"
    call :get_str_len %mystr% mystrlen
    set count=0
    call :color_text 2f "++++++++++++++get_pre_sub_str++++++++++++++"
    set substr=
    :intercept_pre_sub_str
    for /f %%i in ("%count%") do (
        set /a count+=1
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=%%i
            set substr=!mystr:~0,%%i!
            if "%count%" == "%mystrlen%" (
                goto :pre_sub_str_break
            )
            goto :intercept_pre_sub_str
        ) else (
            set /a mysubstr_len=%%i
            set substr=!mystr:~0,%%i!
            goto :pre_sub_str_break
        )
    )
    :pre_sub_str_break
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    endlocal & set %~3=%substr%
goto :eof

:get_suf_sub_str
    setlocal ENABLEDELAYEDEXPANSION
    set mystr=%~1
    set char_sym=%~2
    set mysubstr="%~3"
    call :get_str_len %mystr% mystrlen
    set count=%mystrlen%
    call :color_text 2f "++++++++++++++get_suf_sub_str++++++++++++++"
    set substr=
    :intercept_suf_sub_str
    for /f %%i in ("%count%") do (
        if not "!mystr:~%%i,1!"=="!char_sym!" (
            set /a mysubstr_len=!mystrlen! - %%i
            set substr=!mystr:~%%i!
            set /a count-=1
            goto :intercept_suf_sub_str
        )
    )
    echo %0 %mystr% %char_sym% %count% %mysubstr_len%
    call :color_text 2f "--------------get_suf_sub_str--------------"
    endlocal & set %~3=%substr%
goto :eof

:GetCurSysTime
    setlocal EnableDelayedExpansion
    set dateStr=
    set timeStr=
    set year=%date:~6,4%
    set month=%date:~4,2%
    set day=%date:~0,2%
    set dateStr=%year%_%month%_%day%
    set dateStr=%dateStr:/=%
    set timeStr=%time::=%
    endlocal & set %~1=%dateStr%_%timeStr%
goto :eof
