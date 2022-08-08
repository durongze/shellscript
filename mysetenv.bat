@echo off
set include=%include%
set lib=%lib%
set prefix_home=e:\programs
call :start_cfg_env
pause

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

:set_env_by_prefix
	setlocal ENABLEDELAYEDEXPANSION
	set spec_dir=%1
	set out_spec_dirs=.
	pushd %prefix_home%
		for /f %%i in ( 'dir /b' ) do (
			set cur_lib_name=%%i
			set cur_lib_dir=%prefix_home%\!cur_lib_name!
			set out_spec_dirs=!out_spec_dirs!;!cur_lib_dir!\%spec_dir%
		)
	popd
	echo out_spec_dirs = !out_spec_dirs!
    endlocal & set %~2=%out_spec_dirs%
goto :eof

:start_cfg_env
	setlocal ENABLEDELAYEDEXPANSION
	call :set_env_by_prefix include all_inc_dir
	call :color_text 4f  all_inc_dir
	echo include = %all_inc_dir%
	
	call :set_env_by_prefix lib all_lib_dir
	call :color_text 4f  all_lib_dir
	echo lib = %all_lib_dir%
	endlocal
goto :eof


