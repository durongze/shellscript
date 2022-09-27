call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat"

call:show_lib_info simulator.lib ".\Debug\mrporting.obj"
call:show_obj_info ".\Debug\mrporting.obj"

pause
goto :eof


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

:show_lib_info
    setlocal ENABLEDELAYEDEXPANSION
    set lib_name=%1
    set spec_obj=%~2
    set sym_text=%lib_name%_sym.txt
    call:color_text 2f "++++++++++++++show_lib_info++++++++++++++"
    echo %0 %lib_name%
    @rem objdump -S %lib_name% | grep -C 5 "_open"
    lib /list %lib_name% > %sym_text%
    lib /list:%sym_text% %lib_name%
    echo %0 %lib_name%  %sym_text%
    @rem for /f "tokens=4 delims=," %%i in ( %sym_text% ) do (
    for /f %%i in ( %sym_text% ) do (
        set obj_file=%%i
        echo obj_file:!obj_file!  lib_name:!lib_name!  spec_obj: !spec_obj!
        if "!obj_file!" == "!spec_obj!" (
            lib !lib_name! /extract:!obj_file!
        )
    )
    echo "----------------------------"
    endlocal
goto :eof

:show_obj_info
    setlocal ENABLEDELAYEDEXPANSION
    set spec_obj=%~1

    call:color_text 2f "++++++++++++++show_obj_info++++++++++++++"
    echo %0 %spec_obj%

    :GOON
    for /f "delims=\, tokens=1,*" %%i in ("%spec_obj%") do (
        echo %%i %%j
        set spec_obj=%%j
        set file_name=%%i
        echo file_name:!file_name! spec_obj: !spec_obj!
        if exist !spec_obj! (
            dumpbin /all !spec_obj! > !spec_obj!_sym.txt
            dumpbin /disasm !spec_obj! > !spec_obj!_asm.txt 
            goto :GOON_END
        )
        goto GOON
    )
    :GOON_END
    echo "----------------------------"
    endlocal
goto :eof

:append_obj_to_lib
    setlocal ENABLEDELAYEDEXPANSION
    lib simulator.lib os_adapter.obj
    lib /out:simulator_new.lib simulator.lib os_adapter.obj
    @rem lib simulator.lib /remove os_adapter.obj
    endlocal
goto :eof

