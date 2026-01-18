@echo off

set CurDir=%~dp0
set CurDir=%CurDir:~0,-1%
echo CurDir %CurDir%

set mac_addrs=


set quartus_root_dir=%CurDir%
set quartus_bin_dir=%quartus_root_dir%\quartus\bin
set quartus_exec=%quartus_bin_dir%\quartus.exe
set PATH=%quartus_bin_dir%;%PATH%

call :get_mac_addrs mac_addrs
echo mac_addrs : %mac_addrs%

set quartus_lic_file=%CurDir%\license32.dat
set LM_LICENSE_FILE=%quartus_lic_file%
call :fix_lic_by_mac "%mac_addrs%" %quartus_lic_file%

set quartus_lic_file=%CurDir%\license64.dat
set LM_LICENSE_FILE=%quartus_lic_file%
call :fix_lic_by_mac "%mac_addrs%" %quartus_lic_file%

if exist %quartus_exec% (
    echo %quartus_exec%
)

pause
goto :eof

:fix_lic_by_mac
    setlocal ENABLEDELAYEDEXPANSION
    set addrs_mac=%~1
    set lic_file=%~2
    set bak_file=%~2.bak

    if not exist %lic_file% (
        call:color_text 2f "++++++++++++++fix_lic_by_mac++++++++++++++"
        echo LicFile %lic_file% doesn't exist!
        goto :eof
    )

    if not exist %bak_file% (
        copy /y %lic_file% %bak_file%
    ) else (
        call:color_text 2f "++++++++++++++fix_lic_by_mac++++++++++++++"
        echo LicFile %bak_file% does exist!
    )

    for %%a in ( %addrs_mac% ) do (
        set LOC_MAC_ADDR=%%a
        set LOC_MAC_ADDR=!LOC_MAC_ADDR:-=!
    )
    @rem sed ":a;N;s#\\\n##g;ta" -i %lic_file%
    @rem sed -e ":a" -e "N" -e "$!ba" -e "s/\\\n//g" -i %lic_file%
    @rem sed "s/31-dec-2020/31-dec-2070/g" -i %lic_file%
    @rem sed "s/31-dec-2020/31-dec-2070/g" -i %lic_file%
    grep HOSTID %lic_file% | awk -F= "{print $2}"
    FOR /F "usebackq" %%i IN (` grep HOSTID %lic_file% ^| awk -F"=" "{print $2}" ^| awk -F" " "{print $1}" `) DO (
        set DST_MAC_ADDR=%%i
    )
    call:color_text 2f "++++++++++++++fix_lic_by_mac++++++++++++++"
    echo {%LOC_MAC_ADDR%} ----+ {%DST_MAC_ADDR%}
    sed -e "s/%DST_MAC_ADDR%/%LOC_MAC_ADDR%/g" -i %lic_file%
    endlocal
goto :eof

:get_mac_addrs
    setlocal ENABLEDELAYEDEXPANSION
    set addrs_mac=%1
    set addrs_lst=
    for /f %%a in (' ipconfig /all ^| findstr Phy ^| awk -F":" "{print $2}" ') do (
        @rem echo addr:%%a
        set addrs_lst=!addrs_lst!;%%a
    )
    endlocal & set %~1=%addrs_lst%
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
