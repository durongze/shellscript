@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd

call %VisualStudioCmd% x86 

set VS2022RootDir=C:\Program Files\Microsoft Visual Studio\2022\Community

echo VCTargetsPath=%VCTargetsPath%
echo Configuration^|Platform=%Configuration%^|%Platform%
echo UserRootDir=%UserRootDir%

call :ShowVS2022DirTree            "%VS2022RootDir%"
call :ShowVS2022EnvMsvcToolset     "%VS2022RootDir%"
call :ShowVS2022EnvCppBuild        "%VS2022RootDir%"
pause
goto :eof

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1

    call :color_text 2f " +++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;
    set AllProgramsPathSet=program
    set AllProgramsPathSet=%AllProgramsPathSet%;programs
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;SkySdk\VS2005\VC
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"

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

:ShowVS2022DirTree
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set V170ToolSetsDir=%V170Dir%\Platforms\x64\PlatformToolsets\v143
    set V160Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v160
    set V160ToolSetsDir=%V170Dir%\Platforms\x64\PlatformToolsets\v142
    set V150Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v150
    set V150ToolSetsDir=%V170Dir%\Platforms\x64\PlatformToolsets\v141
    call :color_text 2f "+++++++++++++++++ShowVS2022DirTree+++++++++++++++++"
    echo "VS2022RootDir  =%VS2022RootDir%"
    echo VS2022 
    echo "V170Dir        =%V170Dir%"
    echo "V170ToolSetsDir=%V170ToolSetsDir%"
    echo VS2019 
    echo "V160Dir        =%V160Dir%"
    echo "V160ToolSetsDir=%V160ToolSetsDir%"
    echo VS2017 
    echo "V150Dir        =%V150Dir%"
    echo "V150ToolSetsDir=%V150ToolSetsDir%"
    call :color_text 9f "-----------------ShowVS2022DirTree-----------------"
    endlocal
goto :eof


:ShowVS2022EnvMsvcToolset
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppBuildCfg=%V170Dir%\Microsoft.Cpp.MSVC.Toolset.x64.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvMsvcToolset+++++++++++++++++"
    echo "%CppBuildCfg%"
    echo ExecutablePath
    echo ReferencePath
    echo LibraryPath
    echo ExcludePath
    call :ShowVS2022EnvMsvcToolsetCommon     "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvMsvcToolset-----------------"
    endlocal
goto :eof

:ShowVS2022EnvMsvcToolsetCommon
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppBuildCfg=%V170Dir%\Microsoft.Cpp.MSVC.Toolset.Common.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvMsvcToolsetCommon+++++++++++++++++"
    echo "%CppBuildCfg%"
    echo IncludePath
    echo ExternalIncludePath
    echo LibraryWPath
    echo SourcePath
    call :ShowVS2022EnvWindowsSDK     "%VS2022RootDir%"
    call :ShowVS2022EnvCppCommonCfg   "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvMsvcToolsetCommon-----------------"
    endlocal
goto :eof

:ShowVS2022EnvWindowsSDK
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppBuildCfg=%V170Dir%\Microsoft.Cpp.WindowsSDK.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvWindowsSDK+++++++++++++++++"
    echo "%CppBuildCfg%"
    echo WindowsSdkDir
    echo WindowsSdkDir_71A
    echo WindowsSdkDir_81A
    echo WindowsSdkDir_81
    echo WindowsSdkDir_10
    echo FrameworkSdkDir_71A
    echo FrameworkDir_110
    call :color_text 9f "-----------------ShowVS2022EnvWindowsSDK-----------------"
    endlocal
goto :eof

:ShowVS2022EnvCppCommonCfg
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppCommonCfg=%V170Dir%\Microsoft.Cpp.Common.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCppCommonCfg+++++++++++++++++"
    echo "%CppCommonCfg%"
    echo VSInstallDir=%VSInstallDir%
    echo VCIDEInstallDir=%VCIDEInstallDir%
    call :ShowVS2022EnvCppVCToolsCfg     "%VS2022RootDir%"
    call :ShowVS2022EnvCppCLCommonCfg    "%VS2022RootDir%"
    call :ShowVS2022EnvCppLinkCommonCfg  "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvCppCommonCfg-----------------"
    endlocal
goto :eof

:ShowVS2022EnvCppVCToolsCfg
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppVCToolsCfg=%V170Dir%\Microsoft.Cpp.VCTools.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCppVCToolsCfg+++++++++++++++++"
    echo "%CppVCToolsCfg%"
    if "%VCInstallDir_170%" == "" ( 
        call :color_text 4f "+++++++++++++++++ShowVS2022EnvCppVCToolsCfg+++++++++++++++++"
        echo  VCInstallDir_170=%VCInstallDir_170%
        set VCInstallDir_170=%VS2022RootDir%\VC
    )
    echo _VCToolsVersionProps=%VCInstallDir_170%\Auxiliary\Build\Microsoft.VCToolsVersion.v%PlatformToolsetVersion%.default.props
    echo VCInstallDir_170=%VCInstallDir_170%
    echo VCToolsInstallDir_170=%VCToolsInstallDir_170%
    echo VCToolsVersion=%VCToolsVersion%
    echo VCInstallDir=%VCInstallDir%
    echo VCToolsInstallDir=%VCToolsInstallDir%
    echo VCToolsetsDir=%VCToolsetsDir%
    echo VCToolsRedistInstallDir=%VCToolsRedistInstallDir%
    call :ShowVS2022EnvCppVCToolsContentCfg     "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvCppVCToolsCfg-----------------"
    endlocal
goto :eof


:ShowVS2022EnvCppVCToolsContentCfg
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppVCToolsCfg=%V170Dir%\Microsoft.Cpp.VCTools.Content.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCppVCToolsContentCfg+++++++++++++++++"
    echo "%CppVCToolsCfg%"
    echo VC_VS_IncludePath=%VC_VS_IncludePath%
    echo VC_VS_LibraryPath_VC_VS_x64=%VC_VS_LibraryPath_VC_VS_x64%
    call :color_text 9f "-----------------ShowVS2022EnvCppVCToolsContentCfg-----------------"
    endlocal
goto :eof

:ShowVS2022EnvCppCLCommonCfg
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppVCToolsCfg=%V170Dir%\Microsoft.Cl.Common.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCppCLCommonCfg+++++++++++++++++"
    echo "%CppVCToolsCfg%"
    call :color_text 9f "-----------------ShowVS2022EnvCppCLCommonCfg-----------------"
    endlocal
goto :eof

:ShowVS2022EnvCppLinkCommonCfg
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppVCToolsCfg=%V170Dir%\Microsoft.Link.Common.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCppLinkCommonCfg+++++++++++++++++"
    echo "%CppVCToolsCfg%"
    call :color_text 9f "-----------------ShowVS2022EnvCppLinkCommonCfg-----------------"
    endlocal
goto :eof


:ShowVS2022EnvCppBuild
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppBuildCfg=%V170Dir%\Microsoft.CppBuild.targets
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCppBuild+++++++++++++++++"
    echo "%CppBuildCfg%"
    call :ShowVS2022EnvBuildSteps    "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvCppBuild-----------------"
    endlocal
goto :eof

:ShowVS2022EnvBuildSteps
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppBuildCfg=%V170Dir%\Microsoft.BuildSteps.targets
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvBuildSteps+++++++++++++++++"
    echo "%CppBuildCfg%"
    call :ShowVS2022EnvCommon    "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvBuildSteps-----------------"
    endlocal
goto :eof

:ShowVS2022EnvCommon
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppBuildCfg=%MSBuildToolsPath%\Microsoft.Common.Targets
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvCommon+++++++++++++++++"
    echo "%CppBuildCfg%"
    call :color_text 9f "-----------------ShowVS2022EnvCommon-----------------"
    endlocal
goto :eof



:ShowVS2022EnvCppDefault
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V170Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\v170
    set CppDefaultCfg=%V170Dir%\Microsoft.Cpp.Default.props
    call :color_text 2f "++++++++++++++++++ShowVS2022EnvCppDefault+++++++++++++++++"
    echo "%CppDefaultCfg%"
    echo Framework40Version=%Framework40Version%
    echo FrameworkDir=%FrameworkDir%
    echo FrameworkDIR32=%FrameworkDIR32%
    echo FrameworkVersion=%FrameworkVersion%
    echo FrameworkVersion32=%FrameworkVersion32%
    echo IFCPATH=%IFCPATH%
    echo NETFXSDKDir=%NETFXSDKDir%
    echo UCRTVersion=%UCRTVersion%
    echo UniversalCRTSdkDir=%UniversalCRTSdkDir%
    echo VCIDEInstallDir=%VCIDEInstallDir%
    echo VCINSTALLDIR=%VCINSTALLDIR%
    echo VCToolsInstallDir=%VCToolsInstallDir%
    echo VCToolsRedistDir=%VCToolsRedistDir%
    echo VCToolsVersion=%VCToolsVersion%
    echo WindowsLibPath=%WindowsLibPath%
    echo WindowsSdkBinPath=%WindowsSdkBinPath%
    echo WindowsSdkDir=%WindowsSdkDir%
    echo WindowsSDKLibVersion=%WindowsSDKLibVersion%
    echo WindowsSdkVerBinPath=%WindowsSdkVerBinPath%
    echo WindowsSDKVersion=%WindowsSDKVersion%
    echo WindowsSDK_ExecutablePath_x64=%WindowsSDK_ExecutablePath_x64%
    echo WindowsSDK_ExecutablePath_x86=%WindowsSDK_ExecutablePath_x86%
    echo MSBuildProgramFiles32=%MSBuildProgramFiles32%\MSBuild\Microsoft.Cpp\v4.0
    call :ShowVS2022EnvToolSetsV80Cfg    "%VS2022RootDir%"
    call :color_text 9f "-----------------ShowVS2022EnvCppDefault-----------------"
    endlocal
goto :eof

:ShowVS2022EnvToolSetsV80Cfg
    setlocal EnableDelayedExpansion
    set VS2022RootDir=%~1
    set V80Dir=%VS2022RootDir%\MSBuild\Microsoft\VC\Platforms\Win32\PlatformToolsets\v80
    set CppVCToolsCfg=%V80Dir%\Microsoft.Cpp.Win32.v80.props
    call :color_text 2f "+++++++++++++++++ShowVS2022EnvToolSetsV80Cfg+++++++++++++++++"
    echo "%CppVCToolsCfg%"
    echo VCTargetsPath=%VCTargetsPath%
    echo PlatformToolsetVersion=%PlatformToolsetVersion%
    echo VCInstallDir=%VCInstallDir%
    @rem %VCInstallDir%  %VSInstallDir%
    reg query   "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\8.0\Setup"
    @rem %VCInstallDir%  %VSInstallDir%
    reg query   "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\8.0\Setup"
    @rem %VCInstallDir%\PlatformSDK\
    echo WindowsSdkDir=%WindowsSdkDir%
    echo FrameworkDir=
    reg query   "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework%InstallRoot%"
    reg query   "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework%InstallRoot%"
    echo FrameworkSdkDir=
    reg query   "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SDKs\.NETFrameWork\v2.0%InstallationFolder%"
    reg query   "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\.NETFrameWork\v2.0%InstallationFolder%"
    call :color_text 9f "-----------------ShowVS2022EnvToolSetsV80Cfg-----------------"
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