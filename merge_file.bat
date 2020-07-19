@echo off
setlocal enabledelayedexpansion
@rem for /f "delims=" %i in ('dir *.ts ^| findstr "个文件"') do (set ss=%i))
set /a sum=0
for %%x in (*.ts) do (
  set /a sum=sum+1
)
echo sum=%sum%

call :merge_ts_file 0,800,a.mp4
call :merge_ts_file 801,1600,b.mp4
call :merge_ts_file 1601,2400,c.mp4
call :merge_ts_file 2401,%sum%,d.mp4

copy /b "*.mp4" xxx.rmvb
echo !files!
pause

:merge_ts_file
setlocal
rem 参数是 %0,%1,%2,%3
set files=
for /l %%a in (%1,1,%2) do (
    if not defined files (
        set files="%%~a.ts"
    ) else (
        set files=!files!+"%%~a.ts"
    )
)
copy /b !files! "%3"
endlocal&goto :eof
