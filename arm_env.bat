
set mac_addrs=
set lic_bak=license.bak
set lic_file=license.dat
copy /y %lic_bak% %lic_file%

set PATH=%cd%\RVCT_2.2_build_593;%PATH%
call :get_mac_addrs mac_addrs
echo mac_addrs : %mac_addrs%
call :fix_lic_by_mac "%mac_addrs%" %lic_file%
set LM_LICENSE_FILE=%cd%\%lic_file%
.\RVCT_2.2_build_593\armcc.exe

pause
goto :eof

:fix_lic_by_mac
    setlocal ENABLEDELAYEDEXPANSION
    set addrs_mac=%~1
    set lic_file=%2
    for %%a in ( %addrs_mac% ) do (
        set LOC_MAC_ADDR=%%a
        set LOC_MAC_ADDR=!LOC_MAC_ADDR:-=!
    )
    sed ":a;N;s#\\\n##g;ta" -i %lic_file%
    @rem sed -e ":a" -e "N" -e "$!ba" -e "s/\\\n//g" -i %lic_file%
    sed "s/31-dec-2020/31-dec-2070/g" -i %lic_file%
    sed "s/31-dec-2020/31-dec-2070/g" -i %lic_file%
    grep HOSTID %lic_file% | awk -F= "{print $3}"
    FOR /F "usebackq" %%i IN (` grep HOSTID %lic_file% ^| awk -F"=" "{print $3}" ^| awk -F" " "{print $1}" `) DO (
        set DST_MAC_ADDR=%%i
    )
    echo "{DST_MAC_ADDR} ---- %DST_MAC_ADDR%"
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


