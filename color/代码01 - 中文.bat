@echo off
::ANSI Colors in standard Windows 10 shell
::https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011
::代码页：
::chcp 65001  UTF-8
::chcp 936     GBK
::chcp 437     美国英语

chcp 65001
setlocal
call :setESC

cls
echo %ESC%[101;93m          样  式          %ESC%[0m
echo ^<ESC^>[0m %ESC%[0m 复位 %ESC%[0m
echo ^<ESC^>[1m %ESC%[1m 黑体 %ESC%[0m
echo ^<ESC^>[7m %ESC%[7m 反向 %ESC%[0m
echo ^<ESC^>[4m %ESC%[4m 下划线 %ESC%[0m
echo.
echo %ESC%[101;93m        标准前景色        %ESC%[0m
echo ^<ESC^>[30m %ESC%[30m黑色%ESC%[0m (黑色)
echo ^<ESC^>[31m %ESC%[31m红色%ESC%[0m
echo ^<ESC^>[32m %ESC%[32m绿色%ESC%[0m
echo ^<ESC^>[33m %ESC%[33m黄色%ESC%[0m
echo ^<ESC^>[34m %ESC%[34m蓝色%ESC%[0m
echo ^<ESC^>[35m %ESC%[35m洋红%ESC%[0m
echo ^<ESC^>[36m %ESC%[36m青色%ESC%[0m
echo ^<ESC^>[37m %ESC%[37m白色%ESC%[0m
echo.
echo %ESC%[101;93m        标准背景色        %ESC%[0m
echo ^<ESC^>[40m %ESC%[40m黑色%ESC%[0m
echo ^<ESC^>[41m %ESC%[41m红色%ESC%[0m
echo ^<ESC^>[42m %ESC%[42m绿色%ESC%[0m
echo ^<ESC^>[43m %ESC%[43m黄色%ESC%[0m
echo ^<ESC^>[44m %ESC%[44m蓝色%ESC%[0m
echo ^<ESC^>[45m %ESC%[45m洋红%ESC%[0m
echo ^<ESC^>[46m %ESC%[46m青色%ESC%[0m
echo ^<ESC^>[47m %ESC%[47m白色%ESC%[0m (白色)
echo.
echo %ESC%[101;93m       高强度前景色       %ESC%[0m
echo ^<ESC^>[90m %ESC%[90m灰色（高强度黑）%ESC%[0m
echo ^<ESC^>[91m %ESC%[91m红色%ESC%[0m
echo ^<ESC^>[92m %ESC%[92m绿色%ESC%[0m
echo ^<ESC^>[93m %ESC%[93m黄色%ESC%[0m
echo ^<ESC^>[94m %ESC%[94m蓝色%ESC%[0m
echo ^<ESC^>[95m %ESC%[95m洋红%ESC%[0m
echo ^<ESC^>[96m %ESC%[96m青色%ESC%[0m
echo ^<ESC^>[97m %ESC%[97m白色%ESC%[0m
echo.
echo %ESC%[101;93m       高强度背景色       %ESC%[0m
echo ^<ESC^>[100m %ESC%[100m灰色（高强度黑）%ESC%[0m
echo ^<ESC^>[101m %ESC%[101m红色%ESC%[0m
echo ^<ESC^>[102m %ESC%[102m绿色%ESC%[0m
echo ^<ESC^>[103m %ESC%[103m黄色%ESC%[0m
echo ^<ESC^>[104m %ESC%[104m蓝色%ESC%[0m
echo ^<ESC^>[105m %ESC%[105m洋红%ESC%[0m
echo ^<ESC^>[106m %ESC%[106m青色%ESC%[0m
echo ^<ESC^>[107m %ESC%[107m白色%ESC%[0m
echo.
echo %ESC%[101;93m        颜色组合          %ESC%[0m
echo ^<ESC^>[31m                     %ESC%[31m红色前景色%ESC%[0m
echo ^<ESC^>[7m                      %ESC%[7m反转前景色 ^<-^> 背景色%ESC%[0m
echo ^<ESC^>[7;31m                   %ESC%[7;31m反转31m红色，也就是黑底红字变为红底黑字%ESC%[0m
echo ^<ESC^>[7m   和嵌套   ^<ESC^>[31m %ESC%[7m前半部分定义了反转显示 %ESC%[31m所以后半部分的31m红色也跟着反转显示%ESC%[0m
echo ^<ESC^>[31m  和嵌套   ^<ESC^>[7m %ESC%[31m 前半部分是31m红色%ESC%[7m后半部分因为定义了7m，所以在前半部分的基础上反转显示%ESC%[0m
pause

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)
exit /B 0