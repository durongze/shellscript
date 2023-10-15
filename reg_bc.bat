
@rem pushd "C:\Users\%UserName%\AppData\Roaming\Scooter Software\Beyond Compare 4"
pushd "%USERPROFILE%\AppData\Roaming\Scooter Software\Beyond Compare 4"
del *  /q
popd

echo "reg query start...."

reg query HKEY_CURRENT_USER\SOFTWARE\Scooter" "Software\Beyond" "Compare" "4 /v CacheID

reg delete HKEY_CURRENT_USER\SOFTWARE\Scooter" "Software\Beyond" "Compare" "4 /v CacheID /f

reg add HKEY_CURRENT_USER\SOFTWARE\Scooter" "Software\Beyond" "Compare" "4 /v CacheID /f /t REG_BINARY /d 0 

set CurDir=%~dp0

set ProjDir=%CurDir:~0,-1%
echo ProjDir %ProjDir%

set BC_DIR=%ProjDir%
call "%BC_DIR%\BComp.exe"
