::这是曾经写的，又稍微改进了一下。
@echo off
set str=青天有月来几时 我今停杯一问之 人攀明月不可得 月行却与人相随
setlocal enabledelayedexpansion
set col=CAD9B
for /f "tokens=1-4 delims= " %%1 in ("%str%") do (echo.
for %%m in (%%1 %%2 %%3 %%4) do (set s=%%m
for /l %%a in (0,1,6) do (
call set b=0%%col:~!x!,1%%
set /a x+=1&if !x!==5 (set x=0)
set c=!s:~%%a,1!
set/p= <nul>!c! 
findstr /a:!b! .* "!c!*"
del !c!
ping /n 1 /w 500 127.1>nul&ping /n 1 /w 500 127.1>nul&ping /n 1 /w 500 127.1>nul)
echo.&echo.))
pause>nul&exit