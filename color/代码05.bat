@echo off
::http://blogs.technet.com/b/heyscriptingguy/archive/2012/10/11/powertip-write-powershell-output-in-color-without-using-write-host.aspx
cls

echo.
call :ccr 我是'\"'红色'\"'字符！
call :ccg 我是'\"'绿色'\"'字符！

::也可以是这样的简写语法：
::powershell write-host -fore Cyan This is Cyan text
::powershell write-host -back Red This is Red background

:ccr
powershell -Command Write-Host "%*" -foreground "Red"
goto :eof

:ccg
powershell -Command Write-Host "%*" -foreground "Green"
echo.
pause

::Color 红色Red 黑色Black 绿色Green 黄色Yellow 蓝色Blue 洋红Magenta 青色Cyan 白色White