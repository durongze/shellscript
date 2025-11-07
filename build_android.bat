
call :MainStart

pause
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

:BuildAndroidProj
    setlocal EnableDelayedExpansion
    set ProjDir=%~1
    call :color_text 2f " +++++++++++++++++++ FuncBuildAndroidProj +++++++++++++++++++ "

    @rem set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
    @rem set JAVA_HOME=E:\program\Java\jdk-23
    set JAVA_HOME=F:\program\Java\jdk-1.8
    set PATH=%JAVA_HOME%\bin;%PATH%;

    set PATH=E:\AndroidSdk\ndk\25.1.8937393;%PATH%;
    @rem set PATH=E:\program\android-ndk-r26b;%PATH%;
    @rem set PATH=E:\Android\sdk\ndk-bundle\android-ndk-r20;%PATH%;
    @rem set PATH=D:\Android\ndk\android-ndk-r19c;%PATH%;

    java  -version
    javac -version

    pushd %ProjDir%
        @rem must be call xxx
        call ndk-build    NDK_PROJECT_PATH=.    NDK_APPLICATION_MK=Application.mk    APP_BUILD_SCRIPT=Android.mk
    popd

    call :color_text 2f " -------------------- FuncBuildAndroidProj ----------------------- "

    endlocal
goto :eof

:MainStart
    setlocal EnableDelayedExpansion
    call :BuildAndroidProj "."
    endlocal
goto :eof
