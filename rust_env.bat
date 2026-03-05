call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%YASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

set RUST_ROOT=%ProgramDir%\rust
set CARGO_HOME=%RUST_ROOT%\.cargo
set CARGO_PATH=%CARGO_HOME%\bin
set RUSTUP_HOME=%RUST_ROOT%\.rustup
set RUSTUP_PATH=%RUSTUP_HOME%\toolchains\stable-x86_64-pc-windows-msvc\bin

set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%CARGO_PATH%;%RUSTUP_PATH%;%PATH%

set RUSTUP_DIST_SERVER=https://static.rust-lang.org
set RUSTUP_UPDATE_ROOT=https://static.rust-lang.org/rustup

set RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
set RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

call :RustCargoVersion
@rem call :RustEnvCfg
@rem call :RustCargoRun
@rem call :RustCompile

pause
goto :eof

:RustCargoVersion
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ RustCargoVersion ++++++++++++++ "
    where cargo
    cargo --version
    where rustc
    rustc --version
    rustup toolchain list
    rustup default
    rustup default 1.73.0
    rustup toolchain stable-x86_64-pc-windows-msvc
    call :color_text 9f " -------------- RustCargoVersion -------------- "
    endlocal
goto :eof

:RustCargoRun
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ RustCargoRun ++++++++++++++ "
    cargo run -- search sample.rs
    call :color_text 9f " -------------- RustCargoRun -------------- "
    endlocal
goto :eof

:RustCompile
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ RustCompile ++++++++++++++ "
    rustc src\sample.rs
    call :color_text 9f " ============== RustCompile ============== "
    sample.exe
    call :color_text 9f " -------------- RustCompile -------------- "
    endlocal
goto :eof

:RustEnvCfg
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f " ++++++++++++++ RustEnvCfg ++++++++++++++ "
    echo [source.crates-io]
    echo registry = "https://github.com/rust-lang/crates.io-index"
    
    echo # 
    echo replace-with = 'sjtu'
    
    echo # 
    echo [source.tuna]
    echo registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
    
    echo # 
    echo [source.ustc]
    echo registry = "git://mirrors.ustc.edu.cn/crates.io-index"
    
    echo # 
    echo [source.sjtu]
    echo registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index"
    
    echo # rustcc
    echo [source.rustcc]
    echo registry = "git://crates.rustcc.cn/crates.io-index"
    call :color_text 9f " -------------- RustEnvCfg -------------- "
    endlocal
goto :eof

:DetectProgramDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;
    set CurProgramDir=
    set idx=0
    call :color_text 2f " +++++++++++++++++++ DetectProgramDir +++++++++++++++++++++++ "
    for %%i in (%SkySdkDiskSet%) do (
        set /a idx+=1
        for /f "tokens=1-2 delims=|" %%B in ("programs|program") do (
            set CurProgramDir=%%i:\%%B
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                goto :DetectProgramDirBreak
            )
            set CurProgramDir=%%i:\%%C
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                goto :DetectProgramDirBreak
            )
        )
    )
    :DetectProgramDirBreak
    set ProgramDir=!CurProgramDir!
    call :color_text 2f " ------------------- DetectProgramDir ----------------------- "
    endlocal & set %~1=%ProgramDir%
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