set CurDir=%~dp0

set JAVA_DIR=F:\program\jdk1.8.0_60
call :SetJavaEnv "%JAVA_DIR%" JAVA_HOME CLASSPATH PATH
call :ShowJavaEnv

goto :eof

:SetJavaEnv
    setlocal ENABLEDELAYEDEXPANSION
    set JavaLocDir=%~1
    set EnvJavaHome=%~2
    set EnvClassPath=%~3
    set EnvPath=%~4

    set JAVA_HOME=%JavaLocDir%
    set CLASSPATH=.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar;
    set PATH=%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;%PATH%;

    endlocal & set %~2=%JAVA_HOME% & set %~3=%CLASSPATH% & set %~4=%PATH%
goto :eof

:ShowJavaEnv
    setlocal ENABLEDELAYEDEXPANSION
    where javac
    javac -version
    where java
    java -version
    @rem java -Dfile.encoding=utf-8 -jar xxxx.jar
    endlocal
goto :eof
