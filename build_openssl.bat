set OPENSSL_VERSION=1.0.2d
set PerlPath=F:\program\Perl\bin
set NASMPath=F:\program\nasm
set CMakePath=F:\program\cmake\bin

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%\..
echo ProjDir %ProjDir%

set OpenSslSrcDir=%CurDir%\openssl-1.0.2d
set InstallDir=%ProjDir%\out
set OpenSslBinDir=%InstallDir%\openssl_102d

set VS2005_WIN32="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VS2013_WIN32="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VS2013_AMD64="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

set VS2015_WIN32="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VS2015_AMD64="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

set VS2019_WIN32="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VS2019_WIN32="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VS2022_WIN32="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
set VS2022_AMD64="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set VS2022_WIN32="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
set VS2022_AMD64="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set path=%NASMPath%;%PerlPath%;%path%


@rem CALL %VS2015_WIN32%
@rem CALL %VS2015_AMD64%
CALL %VS2022_AMD64%
call :CompileProjectWin64 
pause
goto :eof

:CompileProjectWin32
    setlocal ENABLEDELAYEDEXPANSION
	pushd %OpenSslSrcDir%
	perl Configure VC-WIN32 --prefix=%OpenSslSrcDir%
	call ms\do_ms.bat
	call ms\do_nasm.bat
	nmake -f ms\nt.mak clean
	nmake -f ms\nt.mak
	nmake -f ms\nt.mak install
	popd
    endlocal
goto :eof

:CompileProjectWin32Dbg
    setlocal ENABLEDELAYEDEXPANSION
	pushd %OpenSslSrcDir%
	perl Configure debug-VC-WIN32 --prefix=%OpenSslBinDir%
	call ms\do_ms.bat
	call ms\do_nasm.bat
	nmake -f ms\nt.mak clean
	nmake -f ms\nt.mak
	nmake -f ms\nt.mak install
	popd
    endlocal
goto :eof

:CompileProjectWin64
    setlocal ENABLEDELAYEDEXPANSION
	pushd %OpenSslSrcDir%
	perl Configure VC-WIN64A --prefix=%OpenSslBinDir%
	call ms\do_win64a.bat
	nmake -f ms\nt.mak clean
	nmake -f ms\nt.mak
	nmake -f ms\nt.mak install
	popd
    endlocal
goto :eof

:CompileProjectWin64Dbg
    setlocal ENABLEDELAYEDEXPANSION
	pushd %OpenSslSrcDir%
	perl Configure debug-VC-WIN64A --prefix=%OpenSslBinDir%
	call ms\do_win64a.bat
	nmake -f ms\nt.mak clean
	nmake -f ms\nt.mak
	nmake -f ms\nt.mak install
	popd
    endlocal
goto :eof
