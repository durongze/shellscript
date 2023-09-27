@echo off
REM #--------------------------------------------------------------------------
REM #	File:		BUILD.BAT
REM #	Contents:	Batch file to build firmware
REM #
REM # $Archive: /USB/Examples/Fx2lp/bulkloop/build.bat $
REM # $Date: 9/01/03 8:53p $
REM # $Revision: 3 $
REM #
REM #
REM #-----------------------------------------------------------------------------
REM # Copyright 2011, Cypress Semiconductor Corporation
REM #-----------------------------------------------------------------------------

REM # command line switches
REM # ---------------------
REM # -clean delete temporary files

set CYUSB=C:\Cypress\USB
set C51_HOME=C:\Cypress\USB\uV2_4k\keil\C51
set C51_HOME=F:\program\KeilC51\C51

set C51_INC=%C51_HOME%\Inc
set C51_LIB=%C51_HOME%\Lib
set C51_BIN=%C51_HOME%\Bin

set USB_INC=%CYUSB%\Target\Inc
set USB_LIB=%CYUSB%\Target\Lib
set USB_BIN=%CYUSB%\Bin

@rem set C51LIB=%C51LIB%;%USB_LIB%;%C51_LIB%;
set C51INC=%C51INC%;%USB_INC%;%C51_INC%;
set C51LIB=%C51_LIB%

set PATH=%C51_BIN%;%USB_BIN%;%PATH%
set BINPath=%BINPath%;%USB_BIN%;%C51_BIN%;

if "%1" == "-clean" (
    call :clean_proj 
) else (
    call :build_proj 
)

pause
goto :eof

:compile_proj
    setlocal EnableDelayedExpansion
    call :color_text 2f "++++++++++++++compile_proj++++++++++++++"
    REM ### Compile FrameWorks code ###
    c51 fw.c debug objectextend code small moddp2

    REM ### Compile user peripheral code ###
    REM ### Note: This code does not generate interrupt vectors ###
    c51 bulkloop.c db oe code small moddp2 noiv

    REM ### Assemble descriptor table ###
    a51 dscr.a51 errorprint debug
    endlocal
goto :eof

:link_proj
    setlocal EnableDelayedExpansion
    call :color_text 2f "++++++++++++++link_proj++++++++++++++"
    REM ### Link object code (includes debug info) ###
    REM ### Note: XDATA and CODE must not overlap ###
    REM ### Note: using a response file here for line longer than 128 chars
    echo fw.obj, dscr.obj, bulkloop.obj, > tmp.rsp
    echo ..\lib\USBJmpTb.obj, >> tmp.rsp
    echo ..\lib\EZUSB.lib  >> tmp.rsp
    echo TO bulkloop RAMSIZE(256) PL(68) PW(78) CODE(80h) XDATA(1000h)  >> tmp.rsp
    bl51 @tmp.rsp
    endlocal
goto :eof

:gen_hex_file
    setlocal EnableDelayedExpansion
    call :color_text 2f "++++++++++++++gen_hex_file++++++++++++++"
    REM ### Generate intel hex image of binary (no debug info) ###
    oh51 bulkloop HEXFILE(bulkloop.hex)

    REM ### Generate serial eeprom image for C2 (EZ-USB FX2)bootload ###
    hex2bix -i -f 0xC2 -o bulkloop.iic bulkloop.hex
    endlocal
goto :eof

:build_proj
    setlocal EnableDelayedExpansion
    call :compile_proj
    call :link_proj
    call :gen_hex_file
    endlocal
goto :eof

REM ### usage: build -clean to remove intermediate files after build
:clean_proj
    setlocal EnableDelayedExpansion
    set idx=0
    call :color_text 2f "++++++++++++++clean_proj++++++++++++++"
    for /f %%i in ('dir tmp.rsp *.lst *.obj *.m51 /b ') do (
        set /a idx+=1
        if exist %%i (
            echo file[!idx!]:%%i
            del %%i
        )
    )
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
