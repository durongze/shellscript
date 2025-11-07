set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

set CMAKE_CURRENT_SOURCE_DIR=%ProjDir%
set CMAKE_BINARY_DIR=%ProjDir%\dyzbuild

set NASM_TOP_DIR=%CMAKE_CURRENT_SOURCE_DIR%
set PERL5LIB=%CMAKE_CURRENT_SOURCE_DIR%;%CMAKE_CURRENT_SOURCE_DIR%/perllib;%CMAKE_CURRENT_SOURCE_DIR%/x86;%CMAKE_CURRENT_SOURCE_DIR%/asm;%CMAKE_BINARY_DIR%;
set PERL=perl   -I %CMAKE_CURRENT_SOURCE_DIR%   -I %CMAKE_CURRENT_SOURCE_DIR%/perllib   -I %CMAKE_CURRENT_SOURCE_DIR%/x86   -I %CMAKE_CURRENT_SOURCE_DIR%/asm   -I %CMAKE_BINARY_DIR%
set pl_file=%NASM_TOP_DIR%/macros/macros.pl

pushd %CMAKE_BINARY_DIR%
%PERL%    %pl_file%   %CMAKE_BINARY_DIR%/version.mac    %CMAKE_CURRENT_SOURCE_DIR%/macros/*.mac    %CMAKE_CURRENT_SOURCE_DIR%/output/*.mac  
popd

pause