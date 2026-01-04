@rem pushd "C:\Users\%UserName%\AppData\Roaming\Scooter Software\Beyond Compare 4"

set BC_REG_DIR="%USERPROFILE%\AppData\Roaming\Scooter Software\Beyond Compare 4"

if not exist %BC_REG_DIR% (
    echo BC_REG_DIR=%BC_REG_DIR%
    pause
    goto :eof
) else (
    pushd %BC_REG_DIR%
        del *  /q
    popd
)

set BC_REG_PATH="HKEY_CURRENT_USER\SOFTWARE\Scooter Software\Beyond Compare 4"
echo BC_REG_PATH=%BC_REG_PATH%

reg query  %BC_REG_PATH% /v CacheID
reg delete %BC_REG_PATH% /v CacheID /f
reg add    %BC_REG_PATH% /v CacheID /f /t REG_BINARY /d 0 

pause

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

set BC_DIR=%ProjDir%
call "%BC_DIR%\BComp.exe"