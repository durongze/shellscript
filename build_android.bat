@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectProgramDir ProgramDir
call :DetectAndroidDir AndroidDir   AndroidNdkVerDir

echo ProgramDir=%ProgramDir%
echo AndroidDir=%AndroidDir%

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
set software_dir="%ProjDir%\thirdparty"
set HomeDir=%ProjDir%\out\windows

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set TclshPath=%ProgramDir%\tcl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set SDCCPath=%ProgramDir%\SDCC\bin
set MakePath=%ProgramDir%\make-3.81-bin\bin
set PythonHome=%ProgramDir%\python\Python312
set PYTHONPATH=%PYTHONHOME%\lib;%PythonHome%;
set SwigHome=%ProgramDir%\swigwin\bin
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%SDCCPath%;%MakePath%;%PYTHONHOME%;%PYTHONHOME%\Scripts;%SwigHome%;%AndroidNdkVerDir%;%PATH%

set MakeProgram=%MakePath%\make.exe

pause
chcp 65001

@rem x86  or x64
call "%VisualStudioCmd%" x64

call "%QtEnvBat%"

pushd %CurDir%

@rem Win32  or x64
set ArchType=x64

set BuildDir=BuildLib
set BuildType=Debug

set ProjName=CppCallJni
@rem call :get_suf_sub_str %ProjDir% \ ProjName

@rem call :BuildJavaProj     "%CurDir%"

@rem call :BuildAndroidProj  "%CurDir%"

call :thirdparty_lib_install  "%CurDir%"  "%CurDir%"  

pause
goto :eof

:thirdparty_lib_install
    setlocal EnableDelayedExpansion
    set lib_dir=%~1
    set home_dir=%~2
    set ArchType=^-A  %ArchType%
    set ArchType=
    call :color_text 2f "++++++++++++++ thirdparty_lib_install ++++++++++++++"
    pushd %lib_dir%
        @rem call %auto_install_func% install_package libintl-0.14.4-src.zip  "%home_dir%"
        @rem call %auto_install_func% auto_install    "libintl-0.14.4-src"    "%home_dir%"  "-DCMAKE_BUILD_TYPE=%build_type%"
        @rem call %auto_install_func% install_package pcre-8.42.zip           "%home_dir%"
        @rem call %auto_install_func% auto_install    "pcre-8.42"             "%home_dir%"  "-DCMAKE_BUILD_TYPE=%BuildType%  %ArchType%   -DBUILD_SHARED_LIBS=OFF -DPCRE_STATIC_RUNTIME=OFF -DPCRE_BUILD_TESTS=OFF "
        call :BuildAndroidProj    "libusb\android\jni"                "%home_dir%"
    popd
    call :color_text 2f " -------------- thirdparty_lib_install --------------- "
    endlocal
goto :eof

:DetectJavaPath
    setlocal EnableDelayedExpansion

    call :color_text 2f " ++++++++++++++++++ DetectJavaPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set JavaPathSet=%JavaPathSet%;"Java\jdk-1.8"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-1.8.0_60"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-12.0.2"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-23"

    set idx_a=0
    for %%A in (!VSDiskSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%C in (!JavaPathSet!) do (
                set /a idx_c+=1
                set CurJavaDirName=%%A:\%%~B\%%~C\
                echo [!idx_a!][!idx_b!][!idx_c!] !CurJavaDirName!
                if exist !CurJavaDirName! (
                    set JavaDirName=!CurJavaDirName!
                    goto :DetectJavaPathBreak
                )
            )
        )
    )
    :DetectJavaPathBreak
    echo Use:%JavaDirName%
    set PATH=%PATH%;%JavaDirName%\bin;
    java -version
    call :color_text 2f " -------------------- DetectJavaPath ----------------------- "
    endlocal & set "%~1=%JavaDirName%"
goto :eof

:BuildJavaProj
    setlocal EnableDelayedExpansion
    set ProjDir=%~1

    call :color_text 2f " +++++++++++++++++++ BuildJavaProj +++++++++++++++++++ "

    call :DetectJavaPath   JAVA_HOME
    set PATH=%JAVA_HOME%\bin;%PATH%;

    pushd %ProjDir%
        javac -encoding utf-8 -d . callc.java
        javap -s com.durongze.jni.CallC
        rem javah -jni com.durongze.jni.CallC
        javac -encoding utf-8 -h . callc.java
    popd

    call :color_text 2f " ------------------- BuildJavaProj ------------------- "

    endlocal
goto :eof

:BuildAndroidProj
    setlocal EnableDelayedExpansion
    set LibAndroidJniDir=%~1
    set HomeDir=%~2

    set ProgramDir=%ProgramDir%
    set AndroidDir=%AndroidDir%
    call :color_text 2f " +++++++++++++++++++ BuildAndroidProj +++++++++++++++++++ "

    call :DetectJavaPath     JAVA_HOME
    set PATH=%JAVA_HOME%\bin;%PATH%;

    call :DetectAndroidDir   AndroidDir   AndroidNdkVerDir
    set PATH=%AndroidNdkVerDir%;%PATH%;

    java  -version
    javac -version

    echo %cd%

    pushd %LibAndroidJniDir%
        @rem must be call xxx
        call ndk-build    NDK_PROJECT_PATH=.    NDK_APPLICATION_MK=Application.mk    APP_BUILD_SCRIPT=Android.mk    NDK_MODULE_PATH=%HomeDir%
    popd

    call :color_text 2f " ------------------- BuildAndroidProj ------------------- "

    endlocal
goto :eof

:MainStart
    setlocal EnableDelayedExpansion
    call :color_text 2f " +++++++++++++++++++ MainStart +++++++++++++++++++ "
    call :BuildAndroidProj "."
    call :color_text 2f " ------------------- MainStart ------------------- "
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
                set ProgramDir=!CurProgramDir!
                goto :DetectProgramDirBreak
            )
            set CurProgramDir=%%i:\%%C
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                set ProgramDir=!CurProgramDir!
                goto :DetectProgramDirBreak
            )
        )
    )
    :DetectProgramDirBreak
    echo Use:%ProgramDir%
    call :color_text 2f " ------------------- DetectProgramDir ----------------------- "
    endlocal & set %~1=%ProgramDir%
goto :eof

:DetectAndroidDir
    setlocal EnableDelayedExpansion
    @rem 
    set DiskSet=C;D;E;F;G;

    set ProgramDirSet="Program"
    set ProgramDirSet=%ProgramDirSet%;"Programs"

    set AndroidDirSet="AndroidSdk\sdk"
    set AndroidDirSet=%AndroidDirSet%;"Android\sdk"

    set NdkRootDirSet="ndk-bundle"
    set NdkRootDirSet=%NdkRootDirSet%;"ndk"

    set d_idx=0
    call :color_text 2f " +++++++++++++++++++ DetectAndroidDir +++++++++++++++++++++++ "
    for %%d in (!DiskSet!) do (
        set /a d_idx+=1
        set p_idx=0
        for %%p in (!ProgramDirSet!) do (
            set /a p_idx+=1
            set a_idx=0
            for %%a in (!AndroidDirSet!) do (
                set /a a_idx+=1
                set n_idx=0
                for %%n in (!NdkRootDirSet!) do (
                    set /a n_idx+=1
                    set CurAndroidSdkDir=%%d:\%%~p\%%~a
                    set CurNdkRootDir=!CurAndroidSdkDir!\%%~n
                    echo [!d_idx!][!p_idx!][!a_idx!][!n_idx!] !CurNdkRootDir!
                    if exist !CurNdkRootDir! (
                        set AndroidSdkDir=!CurAndroidSdkDir!
                        for /f %%v in (' dir !CurNdkRootDir! /b /ad ') do (
                            set NdkVerDir=!CurNdkRootDir!\%%~v
                        )
                        goto :DetectAndroidDirBreak
                    )
                )
            )
        )
    )
    :DetectAndroidDirBreak
    echo Use:%AndroidSdkDir%
    echo Use:%NdkVerDir%
    call :color_text 2f " ------------------- DetectAndroidDir ----------------------- "
    endlocal & set %~1=%AndroidSdkDir%& set %~2=%NdkVerDir%
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
