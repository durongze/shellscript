set CurDir=%~dp0


@rem jdk1.8.0_60.exe
@rem sun_java_me_sdk-3_0-win.exe
@rem sun_java_wireless_toolkit-2.5.2_01-win.exe

set JAVA_DIR=F:\program\jdk1.8.0_60
call :SetJavaEnv "%JAVA_DIR%" JAVA_HOME CLASSPATH PATH
call :ShowJavaEnv

set WTK_DIR=F:\program\WTK2.5.2_01
call :SetWtkEnv "%WTK_DIR%" PATH
call :ShowWtkEnv "%WTK_DIR%"
pause
goto :eof

:SetJavaEnv
    setlocal ENABLEDELAYEDEXPANSION
    set JavaLocDir=%~1
    set EnvJavaHome=%~2
    set EnvClassPath=%~3
    set EnvPath=%~4

    set JAVA_HOME=%JavaLocDir%
    set CLASSPATH=.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar;
    set PATH=%PATH%;%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;

    endlocal & set %~2=%JAVA_HOME% & set %~3=%CLASSPATH% & set %~4=%PATH%
goto :eof

:ShowJavaEnv
    setlocal ENABLEDELAYEDEXPANSION
    javac -version
    java -version
    @rem java -Dfile.encoding=utf-8 -jar xxxx.jar
    endlocal
goto :eof

:SetWtkEnv
    setlocal ENABLEDELAYEDEXPANSION
    set WtkLocDir=%~1
    set EnvPath=%~2

    set PATH=%PATH%;%WtkLocDir%\bin;

    endlocal & set %~2=%PATH%
goto :eof

:ShowWtkEnv
    setlocal ENABLEDELAYEDEXPANSION
    set WtkLocDir=%~1
    pushd %WtkLocDir%\bin
        emulator.exe
    popd
    endlocal
goto :eof