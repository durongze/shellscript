pushd "C:\Users\%UserName%\AppData\Roaming\Scooter Software\Beyond Compare 4"
del *  /q
popd

echo "reg query start...."

reg query HKEY_CURRENT_USER\SOFTWARE\Scooter" "Software\Beyond" "Compare" "4 /v CacheID

reg delete HKEY_CURRENT_USER\SOFTWARE\Scooter" "Software\Beyond" "Compare" "4 /v CacheID /f

@rem reg add HKEY_CURRENT_USER\SOFTWARE\Scooter" "Software\Beyond" "Compare" "4 /v CacheID /f /t REG_BINARY /d 0 

pause
