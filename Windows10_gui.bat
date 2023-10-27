set dep_file=dep.txt

TASKKILL /IM explorer.exe
explorer.exe | tasklist /M /FI "ImageName eq explorer.exe" /FO LIST > %dep_file%
echo ------------------------ >> %dep_file%
tasklist /M /FI "ImageName eq explorer.exe" /FO LIST >> %dep_file%

findstr ".dll" %dep_file% >%dep_file%.txt