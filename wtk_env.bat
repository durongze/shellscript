call :DetectProgramDir ProgramDir
call :DetectJavaPath   JavaDir
call :DetectWtkPath    WtkDir

echo ProgramDir=%ProgramDir%
echo JavaDir=%JavaDir%
echo WtkDir=%WtkDir%

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%


@rem jdk1.8.0_60.exe
@rem sun_java_me_sdk-3_0-win.exe
@rem sun_java_wireless_toolkit-2.5.2_01-win.exe

set JAVA_DIR=%JavaDir%
call :SetJavaEnv  "%JAVA_DIR%" JAVA_HOME CLASSPATH PATH
call :ShowJavaEnv

set WTK_DIR=%WtkDir%
call :SetWtkEnv  "%WTK_DIR%" PATH
call :ShowWtkEnv "%WTK_DIR%" "%WtkDir%\apps\Demos\bin\Demos.jad"

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

:DetectJavaPath
    setlocal EnableDelayedExpansion

    call :color_text 2f " ++++++++++++++++++ DetectJavaPath +++++++++++++++++++++++ "
    set JavaDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set JavaPathSet=%JavaPathSet%;"Java\jdk-1.8"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-1.8.0_60"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-12.0.2"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-23"

    set idx_a=0
    for %%A in (!JavaDiskSet!) do (
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

:DetectWtkPath
    setlocal EnableDelayedExpansion

    call :color_text 2f " ++++++++++++++++++ DetectWtkPath +++++++++++++++++++++++ "
    set WtkDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set WtkPathSet=%JavaPathSet%;"WTK2.5.2_01"


    set idx_a=0
    for %%A in (!WtkDiskSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%C in (!WtkPathSet!) do (
                set /a idx_c+=1
                set CurWtkDirName=%%A:\%%~B\%%~C\
                echo [!idx_a!][!idx_b!][!idx_c!] !CurWtkDirName!
                if exist !CurWtkDirName! (
                    set WtkDirName=!CurWtkDirName!
                    goto :DetectWtkPathBreak
                )
            )
        )
    )
    :DetectWtkPathBreak
    echo Use:%WtkDirName%
    set PATH=%PATH%;%WtkDirName%\bin;
    call :color_text 2f " -------------------- DetectWtkPath ----------------------- "
    endlocal & set "%~1=%WtkDirName%"
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

:SetJavaEnv
    setlocal ENABLEDELAYEDEXPANSION
    set JavaLocDir=%~1
    set EnvJavaHome=%~2
    set EnvClassPath=%~3
    set EnvPath=%~4
    call :color_text 2f " +++++++++++++++++++ SetJavaEnv +++++++++++++++++++ "

    set JAVA_HOME=%JavaLocDir%
    set CLASSPATH=.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar;
    set PATH=%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;%PATH%;

    call :color_text 2f " ------------------- SetJavaEnv ------------------- "

    endlocal & set %~2=%JAVA_HOME% & set %~3=%CLASSPATH% & set %~4=%PATH%
goto :eof

:ShowJavaEnv
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " +++++++++++++++++++ ShowJavaEnv +++++++++++++++++++ "
    echo JAVA_HOME=%JAVA_HOME%
    echo CLASSPATH=%CLASSPATH%
    echo PATH=%PATH%
    where javac
    javac -version
    where java
    java -version
    @rem java -Dfile.encoding=utf-8 -jar xxxx.jar
    call :color_text 2f " ------------------- ShowJavaEnv ------------------- "
    endlocal
goto :eof

:SetWtkEnv
    setlocal ENABLEDELAYEDEXPANSION
    set WtkLocDir=%~1
    set EnvPath=%~2

    set PATH=%WtkLocDir%\bin;%PATH%;

    endlocal & set %~2=%PATH%
goto :eof

:ShowWtkEnv
    setlocal ENABLEDELAYEDEXPANSION
    set WtkLocDir=%~1
    set Demo=%~2
    call :color_text 2f " ++++++++++++++ ShowWtkEnv ++++++++++++++ "
    pushd %WtkLocDir%\bin
        if exist %Demo% (
            echo emulator.exe -Xdescriptor:%Demo%
            emulator.exe -Xdescriptor:%Demo%
            emulator.exe -version
        ) else (
            emulator.exe -version
        )
    popd
    call :color_text 2f " -------------- ShowWtkEnv -------------- "
    endlocal
goto :eof

:ShowWtkCfg
    setlocal ENABLEDELAYEDEXPANSION
    set WtkLocDir=%~1
    call :color_text 2f " ++++++++++++++ ShowWtkCfg ++++++++++++++ "
    echo %WtkLocDir%\wtklib\Windows\ktools.properties
    echo %WtkLocDir%\wtklib\Windows\emulator.properties
    echo %WtkLocDir%\bin\*.vm
    echo kvem.java.home=
    echo wtk.java.home=
    call :color_text 2f " -------------- ShowWtkCfg -------------- "
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