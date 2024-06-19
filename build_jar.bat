@echo off
rem
rem This batch file builds and preverifies the code for the demos.
rem it then packages them in a JAR file appropriately.
rem

set DEMO=demos
set LIB_DIR=..\..\..\lib
set CLDCAPI=%LIB_DIR%\cldcapi10.jar
set MIDPAPI=%LIB_DIR%\midpapi20.jar
set PREVERIFY=..\..\..\bin\preverify

set JAVA_FILES=
set JAVA_FILES=%JAVA_FILES% ..\src\example\*.java

set JAVAC=javac
set JAR=jar

if not "%JAVA_HOME%" == "" (
    set JAVAC=%JAVA_HOME%\bin\javac
    set JAR=%JAVA_HOME%\bin\jar
)

if not exist .\%DEMO%.jad (
  echo *** Run this batch file from its location directory only. ***
  goto end
)

call :CompilingSrcFiles ..\TmpClasses
call :PreverifyingClassFiles ..\TmpClasses ..\Classes
call :JaringMainFestFiles ..\Classes
call :JaringResFiles ..\res
call :UpdateJadFile
pause
goto :eof

:CompilingSrcFiles
    setlocal EnableDelayedExpansion
    set TmpClassesDir=%~1
    call :color_text 2f "++++++++++++++CompilingSrcFiles++++++++++++++"
    echo *** Compiling source files ***  TmpClassesDir:%TmpClassesDir%
    if not exist %TmpClassesDir% (
        md %TmpClassesDir%
    )
    %JAVAC% -bootclasspath %CLDCAPI%;%MIDPAPI% -source 1.3 -target 1.3 -d %TmpClassesDir%   -classpath %TmpClassesDir%   %JAVA_FILES%
    endlocal
goto :eof

:PreverifyingClassFiles
    setlocal EnableDelayedExpansion
    set TmpClassesDir=%~1
    set ClassesDir=%~2
    call :color_text 2f "++++++++++++++PreverifyingClassFiles++++++++++++++"
    echo *** Preverifying class files *** TmpClassesDir:%TmpClassesDir% ClassesDir:%ClassesDir% 
    rem WARNING: When running under windows 9x the JAR may be incomplete
    rem due to an error in Windows 98. Simply place a pause statement between
    rem the preverify and JAR stages and wait 5 seconds before continuing
    rem the build.
    if not exist "%ClassesDir%" (
        md "%ClassesDir%"
    )
    if not exist "%TmpClassesDir%" (
        echo DIR'%TmpClassesDir%' does not exist!
    )
    %PREVERIFY% -classpath %CLDCAPI%;%MIDPAPI%;%TmpClassesDir%  -d %ClassesDir%  %TmpClassesDir%
    endlocal
goto :eof

:JaringMainFestFiles
    setlocal EnableDelayedExpansion
    set ClassesDir=%~1
    call :color_text 2f "++++++++++++++JaringMainFestFiles++++++++++++++"
    echo *** Jaring preverified class files *** ClassesDir:%ClassesDir%
    if not exist %ClassesDir% (
        echo DIR'%ClassesDir%' does not exist!
    )
    %JAR% cmf MANIFEST.MF %DEMO%.jar -C %ClassesDir% .
    endlocal
goto :eof

:JaringResFiles
    setlocal EnableDelayedExpansion
    set ResDir=%~1
    call :color_text 2f "++++++++++++++JaringResFiles++++++++++++++"
    echo *** Jaring resource files *** ResDir:%ResDir%
    if not exist %ResDir% (
        echo DIR'%ResDir%' does not exist!
    )
    %JAR% uf %DEMO%.jar -C %ResDir% .
    endlocal
goto :eof

:UpdateJadFile
    setlocal EnableDelayedExpansion
    call :color_text 2f "++++++++++++++UpdateJadFile++++++++++++++"
    echo *** Don't forget to update the JAR file size in the JAD file!!! ***
    type %DEMO%.jad
    dir /a-d .\%DEMO%.jar
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
