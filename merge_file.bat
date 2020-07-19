for /l %%a in (0,1,2914) do (
    if not defined files (
        set files="%%~a.ts"
    ) else (
        set files=!files!+"%%~a.ts"
    )
)
copy /b !files! "q.mp4"
echo !files!
pause
