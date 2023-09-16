set OpenSslDir=openssl-1.0.2d
set InstallDir=F:/Programs

call :CompileOpenSsl %OpenSslDir% %InstallDir%

pause
goto :eof

@rem openssl-1.0.2d
:CompileOpenSsl
	setlocal ENABLEDELAYEDEXPANSION
	set OpenSslDir=%~1
	set InstallDir=%~2
	pushd %OpenSslDir%
		perl Configure VC-WIN32 no-asm --prefix=%InstallDir%/openssl/
		call ms\do_ms
		nmake -f ms\ntdll.mak
		nmake -f ms\ntdll.mak install
		popd
	endlocal
goto :eof
