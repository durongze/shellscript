@echo off

set /p page_no=input page number:
echo page_no:%page_no%
set start_page=%page_no%
setlocal enabledelayedexpansion
    for /f "delims=" %%F in ('dir /b *.pdf') do (
        set filename=%%~nF
        set extension=%%~xF
        echo page_no:!page_no!
        echo filename:!filename!
        echo extension:!extension!
        echo add_bookmark %%F !start_page!
        c:\windows\system32\add_bookmark "%%F" !start_page!
        pause
    )
endlocal