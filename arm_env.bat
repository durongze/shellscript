set CurDir=%~dp0

call :ArmEnvSet  "%CurDir%"  ARMHOME ARMCONF    ARMDLL ARMINC ARMLIB    ARMLMD_LICENSE_FILE

set path=%ARMHOME%\bin;%path%
call :ArmEnvShow

call :ArmEnvCmd  "%CurDir%"

pause
goto :eof

:RvctEnvSet
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ RvctEnvSet ++++++++++++++ "
    set CurDir=%~1
    set RvctDir=%~2

    set lic_bak=%CurDir%\license.bak
    set lic_dat=%RvctDir%\license.dat

    set RVCT_HOME=%RvctDir%
    set RVCT_BIN=%RVCT_HOME%\RVCT_2.2_build_593
    set PATH=%RVCT_BIN%;%PATH%

    set LM_LICENSE_FILE=%lic_dat%

    set mac_addrs=

    copy /y %lic_bak% %lic_dat%

    call :get_mac_addrs mac_addrs
    echo mac_addrs : %mac_addrs%

    call :fix_lic_by_mac "%mac_addrs%" %lic_dat%

    %RVCT_BIN%\armcc.exe

    call :color_text 2f " -------------- RvctEnvSet -------------- "
    endlocal
goto :eof

:ArmEnvSet
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ ArmEnvSet ++++++++++++++ "
    set CurDir=%~1

    set ARM_HOME=%CurDir%
    set ARM_CONF=%ARM_HOME%\bin

    set ARM_DLL=%ARM_HOME%\bin
    set ARM_INC=%ARM_HOME%\include
    set ARM_LIB=%ARM_HOME%\lib

    set ARM_LMD_LICENSE_FILE=%ARM_HOME%\license.dat

    set path=%ARM_HOME%\bin;%path%
    call :color_text 2f " -------------- ArmEnvSet -------------- "
    endlocal & set "%~2=%ARM_HOME%"& set "%~3=%ARM_CONF%"& set "%~4=%ARM_DLL%"& set "%~5=%ARM_INC%"& set "%~6=%ARM_LIB%"& set "%~7=%ARM_LMD_LICENSE_FILE%"
goto :eof

:ArmEnvCmd
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ ArmEnvCmd ++++++++++++++ "
    set CurDir=%~1
    @echo set SkySdkDir=%CurDir%\..\
    @echo set ARMHOME=%CurDir%\
    @echo set ARMCONF=%CurDir%\bin
    @echo set ARMDLL=%CurDir%\bin
    @echo set ARMINC=%CurDir%\include
    @echo set ARMLIB=%CurDir%\lib
    @echo set ARMLMD_LICENSE_FILE=%CurDir%\license.dat
    call :color_text 2f " -------------- ArmEnvCmd --------------- "
    endlocal
goto :eof

:ArmEnvShow
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2f " ++++++++++++++ ArmEnvShow ++++++++++++++ "
    @echo SkySdkDir=%SkySdkDir%
    @echo ARMHOME=%ARMHOME%
    @echo ARMCONF=%ARMCONF%
    @echo ARMDLL=%ARMDLL%
    @echo ARMINC=%ARMINC%
    @echo ARMLIB=%ARMLIB%

    where armcc
    armcc

    call :color_text 2f " -------------- ArmEnvShow --------------- "
    endlocal
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
