set ToolsDir=%cd%

@rem https://www.cnblogs.com/coolfan/p/15822057.html

@rem echo step 1 ....
@rem put Daffodil into C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\Platforms\Win32\PlatformToolsets\v60
@rem put Daffodil into C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\Platforms\Win32\PlatformToolsets\v70
@rem put Daffodil into C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\Platforms\Win32\PlatformToolsets\v71
@rem put Daffodil into C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\Platforms\Win32\PlatformToolsets\v80

@rem put Daffodil into C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Microsoft\VC\v150\Platforms\Win32\PlatformToolsets\v141
@rem put Daffodil into C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Microsoft\VC\v160\Platforms\Win32\PlatformToolsets\v142
@rem please install Visual Studio 2015 - Windows XP (v140_xp)
@rem put Daffodil into C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\v140\Platforms\x64\PlatformToolsets
@rem put Daffodil into C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\v140\Platforms\Win32\PlatformToolsets
@rem echo check step 1, see project attribute-> general -> platform toolset

@rem echo step 2 ...
@rem put Windows.zip into C:\Program Files (x86)\Microsoft SDKs\Windows

@rem echo step 3 ...
@rem put WindowsKits.zip into C:\Program Files (x86)\Windows Kits

@rem echo step 4 ...
@rem put Microsoft Visual Studio 8 into C:\Program Files (x86)\
@rem fix C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\v140\Microsoft.Cpp.Common.props --> DisableRegistryUse
@rem fix C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\v140\Platforms\Win32\PlatformToolsets\v140\Toolset.props --> PropertyGroup : IncludePath,LibraryPath 

set MicrosoftCppDir="C:\Program Files (x86)\MSBuild\Microsoft.Cpp"
set WindowsSdkDir="C:\Program Files (x86)\Microsoft SDKs\Windows"
set WindowsKitsDir="C:\Program Files (x86)\Windows Kits"
