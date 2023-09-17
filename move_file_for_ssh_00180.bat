@echo off

set SrcDir="%cd%\contrib\win32\openssh"
set DstDir="%cd%\proj"

@rem call :ParseSolutionBySpecDir %SrcDir% %DstDir%

set SrcDir="%cd%\contrib\win32\win32compat"
set DstDir="%cd%\proj"

@rem call :ParseSolutionBySpecDir %SrcDir% %DstDir%

@rem call :MoveNewSolutionToDir 

call :RenameFileExtName %cd%

pause
goto :eof

:ParseSolutionBySubDir
    setlocal EnableDelayedExpansion

    set srcDir="%~1"
    set dstDir="%~2"

    echo srcDir:%srcDir%
    echo dstDir:%dstDir%

    pushd %srcDir%
    FOR /F "usebackq" %%d IN (` dir /ad /b `) DO (
        echo cur_dir %SrcDir%\%%d
        call :ParseSolutionBySpecDir "%SrcDir%\%%d" "%DstDir%"
    )
    popd

    endlocal
goto :eof

:ParseSolutionBySpecDir
    setlocal EnableDelayedExpansion

    set srcDir="%~1"
    set dstDir="%~2"
    set FilterFile=
    set ProjCount=0

    echo srcDir:%srcDir%
    echo dstDir:%dstDir%
    
    if not exist %dstDir% (
        mkdir %dstDir%
    )

    pushd %srcDir%
    FOR /F "usebackq" %%i IN (` dir *.vcxproj /b `) DO (
        set /a ProjCount+=1
        set FilterFile=%%i
        echo FilterFile[!ProjCount!] !FilterFile!

        echo #!FilterFile:~0,-8!  > %dstDir%\!FilterFile!.cmake

        echo set(!FilterFile:~0,-8!_hdr_dir >> %dstDir%\!FilterFile!.cmake
        findstr "IncludePath" !FilterFile! | awk -F">" "{ print $2 }" | awk -F"<" "{ print $1 }" >> %dstDir%\!FilterFile!.cmake
        echo ^)     >> %dstDir%\!FilterFile!.cmake

        @rem echo set(!FilterFile:~0,-8!_hdrs  >> %dstDir%\!FilterFile!.cmake
        @rem findstr /C:"ClInclude Include=" !FilterFile! | awk -F""" "{ print $2 } >> %dstDir%\!FilterFile!.cmake
        @rem echo ^)     >> %dstDir%\!FilterFile!.cmake

        echo set(!FilterFile:~0,-8!_srcs  >> %dstDir%\!FilterFile!.cmake
        findstr /C:"ClCompile Include=" !FilterFile! | awk -F""" "{ print $2 } >> %dstDir%\!FilterFile!.cmake
        echo ^)     >> %dstDir%\!FilterFile!.cmake

        rem contrib/win32/openssh
        sed "s#sshTelemetry.c#${OpenSSH-Src-Path}//contrib/win32/openssh/sshTelemetry.c#g"  -i %dstDir%\!FilterFile!.cmake
        sed "s#\.\.\\\.\.\\\.\.\\\.\.\\#${OpenSSH-Src-Path}/#g"  -i %dstDir%\!FilterFile!.cmake
        sed "s#\.\.\\win32compat\\#${OpenSSH-Src-Path}/contrib/win32/win32compat/#g"  -i %dstDir%\!FilterFile!.cmake
        @rem sed "s#..\\#${OpenSSH-Src-Path}/contrib/win32/#g"  -i %dstDir%\!FilterFile!.cmake
        sed "s#$(OpenSSH-Src-Path)#${OpenSSH-Src-Path}\\#g"  -i %dstDir%\!FilterFile!.cmake
        sed "s#\\#/#g"  -i %dstDir%\!FilterFile!.cmake
        sed "s#$(VC_IncludePath);$(WindowsSDK_IncludePath);##g"  -i %dstDir%\!FilterFile!.cmake
        sed "s#../../config.h#${OpenSSH-Src-Path}/config.h#g"  -i %dstDir%\!FilterFile!.cmake
    )
        sed "s#\./#${OpenSSH-Src-Path}/contrib/win32/win32compat/#g" -i -i %dstDir%\win32compat.vcproj.cmake
    popd

    endlocal
goto :eof

:MoveNewSolutionToDir
    setlocal EnableDelayedExpansion

    set SrcDir=%cd%

    set DstDir=ssh
    set FileFilter=""
    call :MoveFileToDir %SrcDir% %FileFilter% %DstDir%

    set DstDir=libssh
    set FileFilter=""
    call :MoveFileToDir %SrcDir% %FileFilter% %DstDir%

    set DstDir=sshd
    set FileFilter=""
    call :MoveFileToDir %SrcDir% %FileFilter% %DstDir%

    endlocal
goto :eof

:MoveOldSolutionToDir
    setlocal EnableDelayedExpansion

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

    endlocal
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

:RenameFileExtName
    SetLocal EnableDelayedExpansion
    set srcDir=%~1

    set /a Num=0
    pushd %srcDir%
    for %%c in (.) do (
        for  /f "delims=" %%b in ('dir /a:-d /b %%~c\\*.c') do (
            set /a Num+=1
            if not exist %%~b (
                call:color_text 2f "++++++++++++++RenameFileExtName++++++++++++++"
                echo [%Num%] %%~b to %%~bpp
            ) else (
                move %%~b %%~bpp
            )
        )
    )
    popd
    endlocal
goto :eof
