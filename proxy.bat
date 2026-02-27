@rem #创建流量转发，其中listenaddress为内网ip（也就是ipconfig中所显示的IP），listenport为监听的本机对外端口，后两个分别是需转发的目标主机IP和端口。
set local_svr=
set phone_ip=
netsh interface portproxy add v4tov4 listenaddress=%local_svr% connectaddress=%phone_ip%
@rem netsh interface portproxy add v4tov4 listenport=3340 listenaddress=%local_svr% connectport=3389 connectaddress=%phone_ip%
 
@rem #查看有什么转发
netsh interface portproxy show v4tov4
 
@rem #删除刚才那个转发
netsh interface portproxy delete v4tov4 listenaddress=%local_svr%

@rem 
netsh interface portproxy show all

@rem
netsh interface portproxy reset


call :color_text "   "
pause
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