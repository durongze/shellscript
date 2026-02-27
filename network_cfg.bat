set WifiFile=WifiFile.xml
set WifiName=WifiName
set WifiPass=adg123adg

@rem call :WifiGenCfg     "%WifiName%"     "%WifiPass%"      "%WifiFile%"

@rem call :CreateAp       "%WifiName%"     "%WifiPass%"
call :WifiShow
@rem call :WifiConnect    "%WifiFile%"     "%WifiName%"

pause
goto :eof

:WifiGenCfg
    setlocal ENABLEDELAYEDEXPANSION
    set WifiName=%~1
    set WifiPass=%~2
    set WifiFile=%~3
    call :color_text 2f " +++++++++++++ WifiGenCfg ++++++++++++++ "
    echo    ^<?xml version="1.0"?^>                                                                           >>  "%WifiFile%"
    echo    ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>            >>  "%WifiFile%"
    echo        ^<name^>%WifiName%^</name^>                                                                  >>  "%WifiFile%"
    echo        ^<SSIDConfig^>                                                                                >>  "%WifiFile%"
    echo            ^<SSID^>                                                                                  >>  "%WifiFile%"
    echo                ^<name^>%WifiName%^</name^>                                                          >>  "%WifiFile%"
    echo            ^</SSID^>                                                                                 >>  "%WifiFile%"
    echo        ^</SSIDConfig^>                                                                               >>  "%WifiFile%"
    echo        ^<connectionType^>ESS^</connectionType^>                                                      >>  "%WifiFile%"
    echo        ^<connectionMode^>manual^</connectionMode^>                                                   >>  "%WifiFile%"
    echo        ^<MSM^>                                                                                       >>  "%WifiFile%"
    echo            ^<security^>                                                                              >>  "%WifiFile%"
    echo                ^<authEncryption^>                                                                    >>  "%WifiFile%"
    echo                    ^<authentication^>WPA2PSK^</authentication^>                                      >>  "%WifiFile%"
    echo                    ^<encryption^>AES^</encryption^>                                                  >>  "%WifiFile%"
    echo                    ^<useOneX^>false^</useOneX^>                                                      >>  "%WifiFile%"
    echo                ^</authEncryption^>                                                                   >>  "%WifiFile%"
    echo                ^<sharedKey^>                                                                         >>  "%WifiFile%"
    echo                    ^<keyType^>passPhrase^</keyType^>                                                 >>  "%WifiFile%"
    echo                    ^<protected^>false^</protected^>                                                  >>  "%WifiFile%"
    echo                    ^<keyMaterial^>%WifiPass%^</keyMaterial^>                                        >>  "%WifiFile%"
    echo                ^</sharedKey^>                                                                        >>  "%WifiFile%"
    echo            ^</security^>                                                                             >>  "%WifiFile%"
    echo        ^</MSM^>                                                                                      >>  "%WifiFile%"
    echo    ^</WLANProfile^>                                                                                  >>  "%WifiFile%"
    call :color_text 9f " -------------- WifiGenCfg -------------- "
    endlocal
goto :eof

:WifiConnect
    setlocal ENABLEDELAYEDEXPANSION
    set WifiFile=%~1
    set WifiName=%~2
    call :color_text 2f " +++++++++++++ WifiConnect ++++++++++++++ "
    netsh wlan   show     interfaces
    netsh wlan   show     networks
    net   start WlanSvc
    netsh wlan   add      profile     filename="%WifiFile%"
    netsh wlan   connect              name="%WifiName%"
    call :color_text 9f " -------------- WifiConnect -------------- "
    endlocal
goto :eof

:WifiShow
    setlocal ENABLEDELAYEDEXPANSION
    set WifiRegItemNet="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles"
    set WifiRegItemIp="HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    set WifiRegItemDev="HKLM\SYSTEM\CurrentControlSet\Control\Class"
    set WifiCfgDir="C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces\"

    call :color_text 2f " +++++++++++++ WifiShow ++++++++++++++ "
    netsh wlan show    interfaces
    netsh wlan show    networks
    call :color_text 2f " ============= WifiShow WifiRegItemNet ============= "
    reg   query  %WifiRegItemNet%
    call :color_text 2f " ============= WifiShow WifiRegItemIp ============= "
    reg   query  %WifiRegItemIp%
    call :color_text 2f " ============= WifiShow WifiRegItemDev ============= "
    reg   query  %WifiRegItemDev%
    call :color_text 2f " ============= WifiShow WifiCfgDir ============= "
    pushd %WifiCfgDir%
        set idx=0
        for /f %%i in ( 'dir /b /ad ' ) do (
            set /a idx+=1
            set cur_wifi_dir=%%i
            echo [!idx!] cur_wifi_dir=!cur_wifi_dir!
        )
    popd
    call :color_text 9f " -------------- WifiShow -------------- "
    endlocal
goto :eof


:ResetNetwork
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ ResetNetwork ++++++++++++++ "

    netsh wlan    show  drivers
    netsh wlan    set   hostednetwork mode=disallow
    netsh winsock reset
    netsh int     ip    reset

    @rem shutdown /r /t 0

    call :color_text 9f " -------------- ResetNetwork -------------- "
    endlocal
goto :eof

:CreateAp
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ CreateAp ++++++++++++++ "
    set MySsid=%~1
    set MyPass=%~2

    netsh wlan    show  drivers
    netsh wlan    set   hostednetwork mode=allow ssid=%MySsid% key=%MyPass%
    netsh wlan    start hostednetwork
    ncpa.cpl

    call :color_text 9f " -------------- CreateAp -------------- "
    endlocal
goto :eof

:DisableAp
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ DisableAp ++++++++++++++ "
    set MySsid=KeyWifi
    set MyPass=adg123adg

    netsh wlan stop hostednetwork
    netsh wlan set  hostednetwork mode=disallow
    ncpa.cpl
    @rem netsh wlan set  hostednetwork mode=allow
    wmic nic get Name, PNPDeviceID | findstr "Microsoft"
    @rem devcon remove *MS_HostedNetwork*
    devcon find   *
    devcon remove "@{5D624F94-8850-40C3-A3FA-A4FD2080BAF3}\VWIFIMP_SAP\6&1704CC16&1&14"


    call :color_text 9f " -------------- DisableAp -------------- "
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