set OBJECTS=%OBJECTS% x.o y.o z.o

echo OBJECTS=%OBJECTS%

call :MoveFileToDir "%OBJECTS%" dst
pause

:MoveFileToDir
    setlocal EnableDelayedExpansion
    set AllSrcFile=%~1
    set DstDir=%~2

    if not exist %DstDir% (
        mkdir %DstDir%
    ) 
    set FileIdx=0
    for %%F in (%AllSrcFile%) do (
        set /a FileIdx+=1
        set ObjFile=%%F
        set filename=%%~nF
        set extension=%%~xF
        echo FileIdx[!FileIdx!]:!filename!
        echo copy %%~nF.cpp %DstDir%\
        copy %%~nF.hpp %DstDir%\
        copy %%~nF.cpp %DstDir%\
    )

    endlocal
goto :eof
