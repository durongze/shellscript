@rem set VSCMD_DEBUG=2

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

echo ProgramDir=%ProgramDir%

set PerlPath=%ProgramDir%\python\Python312
set PythonHome=%ProgramDir%\python\Python312
set PowerShellHome=C:\Windows\System32\WindowsPowerShell\v1.0
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PythonHome%\Scripts;%PowerShellHome%;%PATH%

@rem x86  or x64
call %VisualStudioCmd% x64
pause

call D:\Program\Intel\oneAPI\setvars.bat
pause

call :CheckTorchEnv
pause
goto :eof


@rem rm -rf .git/modules/third_party/ideep

@rem git submodule deinit -f third_party/ideep
@rem git submodule update --init --force --recursive third_party/ideep

:CheckTorchEnv
    setlocal EnableDelayedExpansion
    call :color_text 2f " +++++++++++++++++++ CheckTorchEnv +++++++++++++++++++++++ "
    set TORCH_DEVICE_BACKEND_AUTOLOAD=0
    python -c "import torch; import intel_extension_for_pytorch as ipex; print(f'Torch device: {torch.device(\"xpu\" if torch.xpu.is_available() else \"cpu\")}'); print(f'IPEX available: {ipex.is_available()}')"
    call :color_text 2f " ------------------- CheckTorchEnv ----------------------- "
    endlocal
goto :eof

:InstallTorchEnv
    setlocal EnableDelayedExpansion
    call :color_text 2f " +++++++++++++++++++ InstallTorchEnv +++++++++++++++++++++++ "
    python3.exe -m pip cache dir
    python3.exe -m pip install --upgrade pip 
    python3.exe -m pip install torch      torchvision    torchaudio    
    python3.exe -m pip install intel-extension-for-pytorch==2.6.10 --extra-index-url https://mirrors.aliyun.com/pytorch-wheels/cu121/
    python3.exe -m pip install intel-extension-for-pytorch==2.6.10 --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/
    python3.exe -m pip cache dir
    echo PIP_CACHE_DIR=%PIP_CACHE_DIR%
    python3.exe -m pip install intel-extension-for-pytorch==2.6.10 -f https://developer.intel.com/ipex-whl-stable
    call :color_text 2f " ------------------- InstallTorchEnv ----------------------- "
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

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1
    call :color_text 2f " ++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet=program
    set AllProgramsPathSet=%AllProgramsPathSet%;programs
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
    @rem set VCPathSet=%VCPathSet%;"VS2022\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"

    set idx_a=0
    for %%C in (%VCPathSet%) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurBatFile=%%A:\%%B\%%C\vcvarsall.bat
                echo [!idx_a!][!idx_b!][!idx_c!] !CurBatFile!
                if exist !CurBatFile! (
                    goto DetectVsPathBreak
                )
            )
        )
    )
    :DetectVsPathBreak
    echo Use:%CurBatFile%
    call :color_text 2f " -------------------- DetectVsPath ----------------------- "
    endlocal & set "%~1=%CurBatFile%"
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