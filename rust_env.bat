set ProgramDir=F:\program
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python

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

call :RustEnvCfg
where cargo
cargo --version
cargo run -- search sample.rs
rustc sample.rs
sample.exe

pause
goto :eof

:RustEnvCfg
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 9f "++++++++++++++RustEnvCfg++++++++++++++"
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
    call :color_text 9f "--------------RustEnvCfg--------------"
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