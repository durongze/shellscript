@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VisualStudioCmd="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"

set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set old_sys_include="%include%"
set old_sys_lib="%lib%"
set old_sys_path="%path%"

set ProgramDir=F:\program
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

@rem HKLM=HKEY_LOCAL_MACHINE
@rem HKCU=HKEY_CURRENT_USER
set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

@rem src\libintl\0.14.4\libintl-0.14.4-src\README.woe32
set SrcDir=%ProjDir%\src\libintl\0.14.4\libintl-0.14.4-src
set InstallDir=%ProjDir%\out
set IconvDir=F:\program\libiconv-1.17
set PREFIX=%InstallDir%

CALL %VisualStudioCmd%

call :CopyDepLibrary "%IconvDir%" "%InstallDir%"
call :BuildSharedLibrary   "%SrcDir%"
call :BuildStaticLibrary   "%SrcDir%"
call :InstallSharedLibrary "%SrcDir%" "%InstallDir%"
call :CleanLibraryObjs     "%SrcDir%"
pause
goto :eof

:CopyDepLibrary
    setlocal EnableDelayedExpansion
    set DepDir=%~1
    set InstallDir=%~2
    call :color_text 2f "++++++++++++++CopyDepLibrary++++++++++++++"
    if not exist %DepDir% (
        call :color_text 4f "--------------CopyDepLibrary--------------"
        echo Dir'%DepDir%' doesn't exist.
    )
    if not exist %InstallDir% (
        mkdir %InstallDir%
    )
    xcopy /S /E /Y %DepDir% %InstallDir%\
    move  /y %InstallDir%\lib\libiconv.lib %InstallDir%\lib\iconv.lib 
    endlocal
goto :eof

:BuildSharedLibrary
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    call :color_text 2f "++++++++++++++BuildSharedLibrary++++++++++++++"
    pushd %BuildDir%
        nmake -f Makefile.msvc DLL=1 MFLAGS=-MD
    popd
    endlocal
goto :eof

:BuildStaticLibrary
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    call :color_text 2f "++++++++++++++BuildStaticLibrary++++++++++++++"
    pushd %BuildDir%
        nmake -f Makefile.msvc MFLAGS=-MD
    popd
    endlocal
goto :eof

:InstallSharedLibrary
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    set InstallDir=%~2
    call :color_text 2f "++++++++++++++InstallSharedLibrary++++++++++++++"
    pushd %BuildDir%
        nmake -f Makefile.msvc DLL=1 MFLAGS=-MD install PREFIX=%InstallDir%
        @rem nmake -f Makefile.msvc MFLAGS=-MD install PREFIX=%InstallDir%
    popd
    endlocal
goto :eof

:CleanLibraryObjs
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    set InstallDir=%~2
    call :color_text 2f "++++++++++++++CleanLibraryObjs++++++++++++++"
    pushd %BuildDir%
        nmake -f Makefile.msvc clean
    popd
    endlocal
goto :eof


:QuerySystemEnv
    setlocal EnableDelayedExpansion
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    reg query "HKEY_CURRENT_USER\Environment"
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
