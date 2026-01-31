@rem set VSCMD_DEBUG=2

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

@rem copy compiler\mr_helper.mrp compiler\mr_helpere.mrp

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

set old_sys_include="%include%"
set old_sys_lib="%lib%"
set old_sys_path="%path%"

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python\Python312
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PythonHome%\Scripts;%PATH%

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%
set software_dir="%ProjDir%\thirdparty"
set HomeDir=%ProjDir%\out\windows
@rem set HomeDir=%ProgramDir%

call :SetProjEnv %software_dir% %CurDir% include lib path CMAKE_INCLUDE_PATH CMAKE_LIBRARY_PATH CMAKE_MODULE_PATH
call :ShowProjEnv

set SystemBinDir=.\

@rem x86  or x64
call %VisualStudioCmd% x64
@rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
@rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"
pushd %CurDir%

@rem Win32  or x64
set ArchType=x64

set BuildType=Release
set ProjName=

set all_srcs=src\main.c
set objs_dir=out
set lib_root_dir=out\windows\pcre-8.42
set lib_dir=%lib_root_dir%\lib
set inc_dir=%lib_root_dir%\include
set lib_name=%lib_dir%\pcred.lib
call :CompileAllSrcs     "%all_srcs%"     "%objs_dir%"
call :search_func_in_lib %lib_name%   "pcre_config"
call :search_func_in_lib main.obj   "pcre_config"

set AllQtUis= E:/code/MagicKey/src/aboutdialog.ui
set AllQtUis=%AllQtUis% E:/code/MagicKey/src/helpdialog.ui
set AllQtUis=%AllQtUis% E:/code/MagicKey/src/mainwindow.ui
call :ProcQtUis       "%AllQtUis%"

set AllQtRcs=E:/code/MagicKey/src/mainwindow.qrc
call :ProcQtRcs   "%AllQtRcs%"

set ProjDepDefs= -DWIN32 -DUNICODE -D_UNICODE -D_WIN64 -DWIN64 -D_ENABLE_EXTENDED_ALIGNED_STORAGE   -DLUA_STATIC 

set QtDepDefs= -DQT_CONCURRENT_LIB    -DQT_CORE5COMPAT_LIB    -DQT_CORE_LIB      -DQT_GUI_LIB         -DQT_NETWORK_LIB -DQT_OPENGL_LIB      
set QtDepDefs=%QtDepDefs% -DQT_PRINTSUPPORT_LIB  -DQT_QMLINTEGRATION_LIB -DQT_QMLMODELS_LIB -DQT_QML_LIB         -DQT_QUICK_LIB   -DQT_WEBCHANNEL_LIB 
set QtDepDefs=%QtDepDefs% -DQT_WEBENGINECORE_LIB -DQT_WIDGETS_LIB        -DQT_XML_LIB       -DQT_POSITIONING_LIB

set ProjIncDirs=-IE:/code/MagicKey/src 
set ProjIncDirs=%ProjIncDirs% -IE:/code/MagicKey/thirdparty/lua-5.4.4 
set ProjIncDirs=%ProjIncDirs% -IE:/code/MagicKey/thirdparty/lua-5.4.4/include 
set ProjIncDirs=%ProjIncDirs% -IE:/code/MagicKey/thirdparty/lua-5.4.4/src 
set ProjIncDirs=%ProjIncDirs% -IE:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4 
set ProjIncDirs=%ProjIncDirs% -IE:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4/include 

set QtIncFlag=1

call :GenQtIncDirOpts     "%QtMsvcPath%"   "%QtIncFlag%"   QtIncDirs

set AllQtHdrs=E:/code/MagicKey/src/aboutdialog.h
set AllQtHdrs=%AllQtHdrs% E:/code/MagicKey/src/helpdialog.h
set AllQtHdrs=%AllQtHdrs% E:/code/MagicKey/src/mainwindow.h
set AllQtHdrs=%AllQtHdrs% E:/code/MagicKey/src/networkmanager.h
call :ProcQtHdrs      "%ProjDepDefs%"   "%QtDepDefs%"    "%ProjIncDirs%"  "%QtIncDirs%"  "%AllQtHdrs%"

set ProjIncDirs=/I"E:\code\MagicKey\BuildSrc\MagicKey_autogen\include_Debug"
set ProjIncDirs=%ProjIncDirs% /I"E:\code\MagicKey\.\src"
set ProjIncDirs=%ProjIncDirs% /I"E:\code\MagicKey\cmake\..\thirdparty\lua-5.4.4" 
set ProjIncDirs=%ProjIncDirs% /I"E:\code\MagicKey\cmake\..\thirdparty\lua-5.4.4\include" 
set ProjIncDirs=%ProjIncDirs% /I"E:\code\MagicKey\cmake\..\thirdparty\lua-5.4.4\src" 
set ProjIncDirs=%ProjIncDirs% /I"E:\code\MagicKey\BuildSrc\thirdparty\lua-5.4.4" 
set ProjIncDirs=%ProjIncDirs% /I"E:\code\MagicKey\BuildSrc\thirdparty\lua-5.4.4\include" 

set ProjDepDefs= /D WIN64 /D _WIN64 /D UNICODE /D _UNICODE /D WIN32 /D _WINDOWS  
set ProjDepDefs=%ProjDepDefs% /D _ENABLE_EXTENDED_ALIGNED_STORAGE   /D LUA_STATIC

set QtDepDefs= /D QT_CORE_LIB /D QT_CORE5COMPAT_LIB /D QT_PRINTSUPPORT_LIB /D QT_POSITIONING_LIB 
set QtDepDefs=%QtDepDefs% /D QT_GUI_LIB  /D QT_WIDGETS_LIB       /D QT_CONCURRENT_LIB   /D QT_NETWORK_LIB 
set QtDepDefs=%QtDepDefs% /D QT_XML_LIB  /D QT_WEBENGINECORE_LIB /D QT_QUICK_LIB        /D QT_QMLINTEGRATION_LIB 
set QtDepDefs=%QtDepDefs% /D QT_QML_LIB  /D QT_QMLMODELS_LIB     /D QT_OPENGL_LIB       /D QT_WEBCHANNEL_LIB 
@rem set QtDepDefs=%QtDepDefs% /D "CMAKE_INTDIR=\"Debug\"" 

set QtIncFlag=2

call :GenQtIncDirOpts     "%QtMsvcPath%"   "%QtIncFlag%"   QtExtIncDirs

@rem set ProjAllSrcs=E:\code\MagicKey\out\Debug\qrc_mainwindow.cpp 
set ProjAllSrcs=%ProjAllSrcs% out\Debug\*.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\aboutdialog.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\helpdialog.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\key_interface.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\lua_interface.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\main.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\mainwindow.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\net_interface.cpp 
set ProjAllSrcs=%ProjAllSrcs% E:\code\MagicKey\src\networkmanager.cpp
@rem set ProjAllSrcs=%ProjAllSrcs% qrc_mainwindow.cpp
call :CompileQtSrcs   "%ProjIncDirs%"   "%ProjDepDefs%"  "%QtDepDefs%"    "%QtExtIncDirs%"    "%ProjAllSrcs%"

set ProjLibDirs=/LIBPATH:"E:/code/MagicKey/./lib" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/./lib/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/thirdparty/lua-5.4.4" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/thirdparty/lua-5.4.4/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/thirdparty/lua-5.4.4/lib" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/thirdparty/lua-5.4.4/lib/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/thirdparty/lua-5.4.4/src" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/thirdparty/lua-5.4.4/src/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4/lib" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4/lib/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4/Debug" 
set ProjLibDirs=%ProjLibDirs% /LIBPATH:"E:/code/MagicKey/BuildSrc/thirdparty/lua-5.4.4/Debug/Debug" 

set QtLibDirs=C:\Qt\6.5.2\msvc2019_64\lib\Qt6Core5Compatd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Concurrentd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6PrintSupportd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Xmld.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6WebEngineCored.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Widgetsd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Quickd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6QmlModelsd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6OpenGLd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Guid.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6WebChanneld.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Qmld.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Networkd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Positioningd.lib 
set QtLibDirs=%QtLibDirs% C:\Qt\6.5.2\msvc2019_64\lib\Qt6Cored.lib 

call :GenQtDepLibs        "%QtMsvcPath%"   QtDepLibs

set DepSysLibs=comdlg32.lib winspool.lib d3d11.lib dxgi.lib dxguid.lib dcomp.lib user32.lib 
set DepSysLibs=%DepSysLibs% ws2_32.lib shell32.lib mpr.lib userenv.lib kernel32.lib user32.lib gdi32.lib 
set DepSysLibs=%DepSysLibs% winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib 

set ProjAllObjs=out\Debug\*.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\aboutdialog.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\helpdialog.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\key_interface.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\lua_interface.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\main.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\mainwindow.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\net_interface.obj
set ProjAllObjs=%ProjAllObjs% out\Debug\networkmanager.obj
@rem set ProjAllObjs=%ProjAllObjs% out\Debug\qrc_mainwindow.obj
call :LinkQtObjs      "%ProjLibDirs%"   "%QtDepLibs%"    "%DepSysLibs%"   "%ProjAllObjs%" 

pause
goto :eof

:DetectQtDir
    setlocal EnableDelayedExpansion
    @rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
    @rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"
    @rem call "D:\Qt\Qt5.14.2\5.14.2\msvc2017_64\bin\qtenv2.bat"

    set VsBatFileVar=%~1
    call :color_text 2f " ++++++++++++++++++ DetectQtDir +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set QtPathSet="Qt"

    set QtVerSet=%QtVerSet%;"6.5.2"
    set QtVerSet=%QtVerSet%;"Qt5.12.0\5.12.0"
    set QtVerSet=%QtVerSet%;"Qt5.14.2\5.14.2"

    set QtMsvcSet=%QtMsvcSet%;"msvc2017_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2019_64"

    set idx_a=0
    for %%A in (!VSDiskSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!QtPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%C in (!QtVerSet!) do (
                set /a idx_c+=1
                for %%D in (!QtMsvcSet!) do (
                    set /a idx_d+=1
                    set QtEnvBatFile=%%A:\%%~B\%%~C\%%~D\bin\qtenv2.bat
                    set QtMsvcPath=%%A:\%%~B\%%~C\%%~D
                    echo [!idx_a!][!idx_b!][!idx_c!][!idx_d!] !QtEnvBatFile!
                    if exist !QtEnvBatFile! (
                        goto :DetectQtEnvPathBreak
                    )
                )
            )
        )
    )
    :DetectQtEnvPathBreak
    echo Use:%QtEnvBatFile%
    call :color_text 2f " ------------------ DetectQtDir ----------------------- "
    endlocal & set "%~1=%QtEnvBatFile%"& set "%~2=%QtMsvcPath%"
goto :eof

:GenQtIncDirOpts
    setlocal EnableDelayedExpansion
    @rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
    @rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"
    @rem call "D:\Qt\Qt5.14.2\5.14.2\msvc2017_64\bin\qtenv2.bat"

    set QtMsvcPath=%~1
    set OptIncFlag=%~2

    call :color_text 2f " ++++++++++++++++++ GenQtIncDirOpts +++++++++++++++++++++++ "

    set QtMsvcSet=%QtMsvcSet%;"msvc2017_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2019_64"

    if "%OptIncFlag%"=="1" (
        set OptIncFlag=-I
    ) else (
        set OptIncFlag=/external:I 
    )

    set QtMsvcIncDirs=%QtMsvcIncDirs%  %OptIncFlag%  %QtMsvcPath%/include 
    set QtMsvcIncDirs=%QtMsvcIncDirs%  %OptIncFlag%  %QtMsvcPath%/mkspecs/win32-msvc 

    set QtModDirs=%QtModDirs% QtCore 
    set QtModDirs=%QtModDirs% QtCore5Compat 
    set QtModDirs=%QtModDirs% QtGui 
    set QtModDirs=%QtModDirs% QtWidgets 
    set QtModDirs=%QtModDirs% QtConcurrent 
    set QtModDirs=%QtModDirs% QtNetwork 
    set QtModDirs=%QtModDirs% QtPrintSupport 
    set QtModDirs=%QtModDirs% QtXml 
    set QtModDirs=%QtModDirs% QtWebEngineCore 
    set QtModDirs=%QtModDirs% QtQuick 
    set QtModDirs=%QtModDirs% QtQml 
    set QtModDirs=%QtModDirs% QtQmlIntegration 
    set QtModDirs=%QtModDirs% QtQmlModels 
    set QtModDirs=%QtModDirs% QtOpenGL 
    set QtModDirs=%QtModDirs% QtWebChannel 
    set QtModDirs=%QtModDirs% QtPositioning 

    set idx_a=0
    for %%A in (!QtMsvcPath!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!QtModDirs!) do (
            set /a idx_b+=1

            set CurQtMsvcModIncDirs=!OptIncFlag! %%A\include\%%~B
            set QtMsvcIncDirs=!QtMsvcIncDirs! !CurQtMsvcModIncDirs!
            echo [!idx_a!][!idx_b!] !CurQtMsvcModIncDirs!

        )
    )

    call :color_text 2f " ------------------ GenQtIncDirOpts ----------------------- "
    endlocal & set "%~3=%QtMsvcIncDirs%"
goto :eof

:GenQtDepLibs
    setlocal EnableDelayedExpansion
    @rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
    @rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"
    @rem call "D:\Qt\Qt5.14.2\5.14.2\msvc2017_64\bin\qtenv2.bat"

    set QtMsvcPath=%~1
    set OptLinkFlag=

    call :color_text 2f " ++++++++++++++++++ GenQtDepLibs +++++++++++++++++++++++ "

    set QtMsvcSet=%QtMsvcSet%;"msvc2017_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2019_64"

    set QtMsvcDepLibs=

    set QtModLibs=%QtModLibs% QtCore 
    set QtModLibs=%QtModLibs% QtCore5Compat 
    set QtModLibs=%QtModLibs% QtGui 
    set QtModLibs=%QtModLibs% QtWidgets 
    set QtModLibs=%QtModLibs% QtConcurrent 
    set QtModLibs=%QtModLibs% QtNetwork 
    set QtModLibs=%QtModLibs% QtPrintSupport 
    set QtModLibs=%QtModLibs% QtXml 
    set QtModLibs=%QtModLibs% QtWebEngineCore 
    set QtModLibs=%QtModLibs% QtQuick 
    set QtModLibs=%QtModLibs% QtQml 
    set QtModLibs=%QtModLibs% QtQmlIntegration 
    set QtModLibs=%QtModLibs% QtQmlModels 
    set QtModLibs=%QtModLibs% QtOpenGL 
    set QtModLibs=%QtModLibs% QtWebChannel 
    set QtModLibs=%QtModLibs% QtPositioning 

    set idx_a=0
    for %%A in (!QtMsvcPath!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!QtModLibs!) do (
            set /a idx_b+=1

            set CurQtMsvcModLib=!OptLinkFlag! %%A\lib\%%~B.lib
            set QtMsvcDepLibs=!QtMsvcDepLibs! !CurQtMsvcModLib!
            echo [!idx_a!][!idx_b!] !CurQtMsvcModLib!

        )
    )

    call :color_text 2f " ------------------ GenQtDepLibs ----------------------- "
    endlocal & set "%~2=%QtMsvcDepLibs%"
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

@rem call :ProcQtUis   "%AllQtUis%"
:ProcQtUis
    setlocal EnableDelayedExpansion
    set AllQtUis=%~1
    call :color_text 2f " +++++++++++++++++ ProcQtUis ++++++++++++++++ "
    set OutDir=out\Debug
    if not exist %OutDir% (
        mkdir %OutDir%
    )
    set idx=0
    set AllUiHdrs=
    for %%i in (%AllQtUis%) do (
        set /a idx+=1
        set QtUiFile=%%i
        set QtUiHdr=!OutDir!\ui_%%~ni.h
        set ext=%%~xi
        echo [!idx!] !QtUiFile!  !QtUiHdr!
        set AllUiHdrs=!AllUiHdrs! !QtUiHdr!
        uic.exe -o  !QtUiHdr!  !QtUiFile!
    )
    call :color_text 2f " ----------------- ProcQtUis ---------------- "
    endlocal
goto :eof

@rem call :ProcQtRcs   "%AllQtRcs%"
:ProcQtRcs
    setlocal EnableDelayedExpansion
    set AllQtRcs=%~1

    call :color_text 2f " +++++++++++++++++ ProcQtRcs ++++++++++++++++ "
    set OutDir=out\Debug
    if not exist %OutDir% (
        mkdir %OutDir%
    )
    set idx=0
    set AllQtCpps=
    for %%i in (%AllQtRcs%) do (
        set /a idx+=1
        set QrcFile=%%i
        set FileName=%%~ni
        set CppFile=!OutDir!\qrc_!FileName!_CMKE_.cpp
        set ext=%%~xi
        echo [!idx!] !QrcFile!  !CppFile!
        set AllQtCpps=!AllQtCpps! !CppFile!
        rcc.exe -name !FileName! -o !CppFile! !QrcFile!
    )

    call :color_text 2f " ----------------- ProcQtRcs ---------------- "
    endlocal
goto :eof

@rem call :ProcQtHdrs   "%ProjDepDefs%"   "%QtDepDefs%"   "%ProjIncDirs%"   "%QtIncDirs%"   "%AllQtHdrs%"
:ProcQtHdrs
    setlocal EnableDelayedExpansion
    set ProjDepDefs=%~1
    set QtDepDefs=%~2
    set ProjIncDirs=%~3
    set QtIncDirs=%~4
    set AllQtHdrs=%~5

    call :color_text 2f " +++++++++++++++++ ProcQtHdrs ++++++++++++++++ "

    echo ProjDepDefs=%ProjDepDefs%
    echo QtDepDefs=%QtDepDefs%
    echo ProjIncDirs=%ProjIncDirs%
    echo QtIncDirs=%QtIncDirs%
    echo AllQtHdrs=%AllQtHdrs%

    set OutDir=out\Debug
    if not exist %OutDir% (
        mkdir %OutDir%
    )
    set idx=0
    set AllMocCpps=
    for %%i in (%AllQtHdrs%) do (
        set /a idx+=1
        set QtHdrFile=%%i
        set QtMocCpp=!OutDir!\moc_%%~ni.cpp
        set ext=%%~xi
        echo [!idx!] !QtHdrFile!  !QtMocCpp!
        set AllMocCpps=!AllMocCpps! !QtMocCpp!
        moc.exe !ProjDepDefs!   !QtDepDefs!   !ProjIncDirs!   !QtIncDirs! --output-dep-file -o   !QtMocCpp!   !QtHdrFile!
    )
    call :color_text 2f " ----------------- ProcQtHdrs ---------------- "
    endlocal
goto :eof



@rem call :CompileQtSrcs   "%ProjIncDirs%"   "%ProjDepDefs%"   "%QtDepDefs%"   "%QtIncDirs%"    "%ProjAllSrcs%"
:CompileQtSrcs
    setlocal EnableDelayedExpansion
    set ProjIncDirs=%~1
    set ProjDepDefs=%~2
    set QtDepDefs=%~3
    set QtIncDirs=%~4
    set ProjAllSrcs=%~5

    call :color_text 2f " +++++++++++++++++ CompileQtSrcs ++++++++++++++++ "

    echo ProjIncDirs=%ProjIncDirs%
    echo ProjDepDefs=%ProjDepDefs%
    echo QtDepDefs=%QtDepDefs%
    echo QtIncDirs=%QtIncDirs%
    echo ProjAllSrcs=%ProjAllSrcs%

    set OutDir=out\Debug
    set ZcOpts=/Zc:wchar_t /Zc:forScope /Zc:inline

    set idx=0
    set AllMocCpps=
    for %%i in (%ProjAllSrcs%) do (
        set /a idx+=1
        set QtCppFile=%%i
        set ObjFile=!OutDir!\%%~ni.obj
        set ext=%%~xi
        echo [!idx!] !QtCppFile!  !ObjFile!
        set AllObjFiles=!AllObjFiles! !ObjFile!
        CL.exe /c  /I"!OutDir!" !ProjIncDirs! /Z7 /nologo /W4 /WX- /diagnostics:column /Od /Ob0 !ProjDepDefs! !QtDepDefs! /Gm- /EHsc /RTC1 /MDd /GS /fp:precise !ZcOpts! /GR /std:c++17 /permissive- /Fo"!OutDir!\\" /Fd"!OutDir!\vc143.pdb" /external:W0 /Gd /TP /errorReport:queue  !QtIncDirs! -Zc:__cplusplus -utf-8 !QtCppFile!
    )
    call :color_text 2f " ----------------- CompileQtSrcs ---------------- "
    endlocal
goto :eof



@rem call :LinkQtObjs   "%ProjLibDirs%"   "%QtLibDirs%"   "%DepSysLibs%"   "%ProjAllObjs%"    
:LinkQtObjs
    setlocal EnableDelayedExpansion
    set ProjLibDirs=%~1
    set QtLibDirs=%~2
    set DepSysLibs=%~3
    set ProjAllObjs=%~4

    call :color_text 2f " +++++++++++++++++ LinkQtObjs ++++++++++++++++ "

    echo ProjLibDirs=%ProjLibDirs%
    echo QtLibDirs=%QtLibDirs%
    echo DepSysLibs=%DepSysLibs%
    echo ProjAllObjs=%ProjAllObjs%

    set OutDir=out\Debug

    link.exe /ERRORREPORT:QUEUE /OUT:"%OutDir%\MagicKey.exe" /INCREMENTAL /ILK:"%OutDir%\MagicKey.ilk" /NOLOGO %ProjLibDirs% %QtLibDirs% %DepSysLibs% /MANIFEST /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /manifest:embed /DEBUG /PDB:"%OutDir%/MagicKey.pdb" /SUBSYSTEM:CONSOLE /TLBID:1 /DYNAMICBASE /NXCOMPAT /IMPLIB:"%OutDir%/MagicKey.lib" /MACHINE:X64 %ProjAllObjs%

    call :color_text 2f " ----------------- LinkQtObjs ---------------- "
    endlocal
goto :eof

:CompileQtSln
    setlocal EnableDelayedExpansion
    set QtSln=%~1
    call :color_text 2f " +++++++++++++++++ CompileQtSln ++++++++++++++++ "
    set OutDir=out\Debug

    call :color_text 2f " ----------------- CompileQtSln ---------------- "
    endlocal
goto :eof

:CompileAllSrcs
    setlocal EnableDelayedExpansion
    set AllSrcs=%~1
    set ObjsDir="%~2"
    set PcreDir=%HomeDir%\pcre-8.42
    call :color_text 2f " ++++++++++++++++++ CompileAllSrcs ++++++++++++++++++++++++ "
    set IncDir=/I .\inc    /I .\src    /I  .\    /I  %PcreDir%\include
    set PcreDefs=/D PCRE_STATIC
    set WinDefs=/D _WINDOWS  /D WIN32  /D _NDEBUG  /D NDEBUG  
    set AllDefs=%PcreDefs%  /TC  /MD
    set OutDir=out
    if not exist %OutDir% (
        mkdir %OutDir%
    )
    set idx=0
    set AllObjs=
    for %%i in (%AllSrcs%) do (
        set /a idx+=1
        set srcFile=%%i
        set objFile=%OutDir%\%%~ni.obj
        set ext=%%~xi
        echo [!idx!] !srcFile!  !objFile!
        set AllObjs=!AllObjs! !objFile!
        echo cl  %IncDir%  %AllDefs%  /Fo"!objFile!"  /c  !srcFile!
        cl  %IncDir%  %AllDefs%  /Fo"!objFile!"  /c  !srcFile!
    )

    set LibDir=/LIBPATH:.\    /LIBPATH:.\lib    /LIBPATH:%PcreDir%\lib
    set PcreOpts=pcred.lib 
    set WinOpts=/subsystem:windows    /entry:WinMainCRTStartup
    set ArmOpts=/SAFESEH:NO    /NODEFAULTLIB:LIBCD.lib    /NODEFAULTLIB:LIBC.lib    /NODEFAULTLIB:LIBCMT.lib    /NODEFAULTLIB:LIBCMTD.lib    /INCLUDE:_sim_dummy    MSCOREE.lib
    set AllOpts=%PcreOpts%
    echo     link    /link    %LibDir%    %AllOpts%    %AllObjs% /OUT:%OutDir%\app.exe
    link    /link    %LibDir%    %AllOpts%    %AllObjs% /OUT:%OutDir%\app.exe
    call :color_text 2f " ----------------- CompileAllSrcs ----------------- "
    endlocal
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
