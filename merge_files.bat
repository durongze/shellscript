set path=D:\code\ffmpeg-my\msvc;%path%
@rem copy /y NUL 1.txt >NUL
set /a fileName=

:merge_files
    setlocal ENABLEDELAYEDEXPANSION
    @rem for /r %%i in (dir /b *.mp4) do (
    for /f %%i in ('dir /b "*.avi" ') do (
    @rem for %%i in (*.avi) do (
        set fileName=%%i
        set fileName=!fileName:(=_!
        set fileName=!fileName:^)=_!
        move %%i !fileName!
        @echo file '!fileName!' >> 1.txt
    )
    pause
    ffmpegd.exe -f concat -safe 0 -i ./1.txt -c copy concat.mp4
    pause
    endlocal
goto:eof
