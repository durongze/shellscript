@echo off
set SrcDir=%cd%

set DstDir=ssh
set FileFilter="clientloop   readconf   ssh   sshconnect   sshconnect1   sshconnect2   sshtty "
call :MoveFileToDir %SrcDir% %FileFilter% %DstDir%

set DstDir=libssh
set FileFilter="acss atomicio authfd authfile bufaux bufbn buffer canohost channels cipher-3des1 cipher-acss cipher-aes cipher-bf1 cipher-ctr cipher cleanup compat compress crc32 deattack dh dispatch dns entropy fatal gss-genr hostfile kex kexdh kexdhc kexgex kexgexc key log mac match md-sha256 misc moduli monitor_fdpass msg nchan packet progressmeter readpass rijndael rsa scard-opensc scard ssh-dss ssh-rsa ttymodes uidswap umac uuencode xmalloc "
call :MoveFileToDir %SrcDir% %FileFilter% %DstDir%

set DstDir=sshd
set FileFilter="audit-bsm  audit  auth-bsdauth  auth-chall  auth-krb5  auth-options  auth-pam  auth-passwd  auth-rh-rsa  auth-rhosts  auth-rsa  auth-shadow  auth-sia  auth-skey  auth  auth1  auth2-chall  auth2-gss  auth2-hostbased  auth2-kbdint  auth2-none  auth2-passwd  auth2-pubkey  auth2  groupaccess  gss-serv-krb5  gss-serv  kexdhs  kexgexs  loginrec  md5crypt  monitor  monitor_mm  monitor_wrap  platform  servconf  serverloop  session  sshd  sshlogin  sshpty "
call :MoveFileToDir %SrcDir% %FileFilter% %DstDir%
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


:MoveFileToDir
    SetLocal EnableDelayedExpansion
    set srcDir=%~1
    set fileFilter=%~2
    set dstDir=%~3
    set /a sum=0
    if not exist %dstDir% (
        mkdir %dstDir%
    )
    Set "Num=000"&Set "Num=!Num:~-3!"
    echo Num:%Num% srcDir:%srcDir% dstDir:%dstDir% Filter:%fileFilter%
    for %%c in (%fileFilter%) do (
        for  /f "delims=" %%b in ('dir /a:-d /b %%~c.*') do (
            if exist %%~b (
                call:color_text 2f "++++++++++++++MoveFileToDir++++++++++++++"
                move %%~b %dstDir%\
            ) else (
                call:color_text 4f "++++++++++++++MoveFileToDir++++++++++++++"
                echo %%~b or %dstDir% not found. %%~c
                pause
                break
            )
        )
    )
    endlocal
goto :eof