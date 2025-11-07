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
set PythonHome=%ProgramDir%\python
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

set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtCore 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/mkspecs/win32-msvc 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtCore5Compat 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtGui 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtWidgets 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtConcurrent 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtNetwork 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtPrintSupport 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtXml 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtWebEngineCore 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtQuick 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtQml 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtQmlIntegration 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtQmlModels 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtOpenGL 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtWebChannel 
set QtIncDirs=%QtIncDirs% -IC:/Qt/6.5.2/msvc2019_64/include/QtPositioning 

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

set QtIncDirs=/external:I "C:/Qt/6.5.2/msvc2019_64/include/QtCore" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include"
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/mkspecs/win32-msvc" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtCore5Compat"
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtGui" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtWidgets" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtConcurrent" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtNetwork" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtPrintSupport" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtXml" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtWebEngineCore" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtQuick" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtQml" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtQmlIntegration" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtQmlModels" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtOpenGL" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtWebChannel" 
set QtIncDirs=%QtIncDirs% /external:I "C:/Qt/6.5.2/msvc2019_64/include/QtPositioning" 

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
call :CompileQtSrcs   "%ProjIncDirs%"   "%ProjDepDefs%"  "%QtDepDefs%"    "%QtIncDirs%"    "%ProjAllSrcs%"

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
call :LinkQtObjs      "%ProjLibDirs%"   "%QtLibDirs%"    "%DepSysLibs%"   "%ProjAllObjs%" 

pause
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
    set VCPathSet=%VCPathSet%;SkySdk\VS2005\VC
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"

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
