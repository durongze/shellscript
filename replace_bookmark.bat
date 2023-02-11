@echo off
set WorkDir=%cd%
call :replace_text_by_dir %WorkDir%
pause
goto :eof

:replace_text_by_dir
    setlocal EnableDelayedExpansion
    set work_dir=%1
    pushd %work_dir%
        for /f "delims=" %%i in ( 'dir /b ARM*.txt' ) do (
            set bookmark_file=%%i
            if not exist !bookmark_file! (
                echo %0 bookmark_file : !bookmark_file!
                goto :eof
            )
            call :replace_all_line   !bookmark_file!
        )
        del sed*
    popd
    endlocal
goto :eof

:replace_line_ctx
    setlocal EnableDelayedExpansion
    set prefix=%~1
    set subfix=%~2
    set bookmark_file=%3
    if not exist %bookmark_file% (
        echo %0 bookmark_file : %bookmark_file%
        goto :eof
    )
    if "%prefix%" == "" (
        goto :eof
    ) else (
        echo sed "s#%prefix% 1 %subfix%#%prefix% 1 %subfix%#g" -i %bookmark_file%
    )
    for /L %%i in (1,1,20) do (
        sed "s#%prefix%%%i%subfix%#\n%prefix%%%i%subfix%#g" -i %bookmark_file%
        sed "s#%prefix%%%i %subfix%#\n%prefix%%%i%subfix%#g" -i %bookmark_file%
        sed "s#%prefix% %%i%subfix%#\n%prefix%%%i%subfix%#g" -i %bookmark_file%
        sed "s#%prefix% %%i %subfix%#\n%prefix%%%i%subfix%#g" -i %bookmark_file%

        @rem sed "s#%%i\.#\n%%i\.#g" -i %bookmark_file%
        sed "s# %%i\.#\n%%i\.#g" -i %bookmark_file%
    )
    endlocal
goto :eof

:replace_all_line
    setlocal EnableDelayedExpansion
    set bookmark_file=%1
    call :replace_line_ctx "ตฺ" "ีย" %bookmark_file%
    endlocal    
goto :eof