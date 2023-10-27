reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery\ /v MRUListEx
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery\ /v MRUListEx /f 

pushd C:\Windows\servicing\LCU
     del /f /s /q *
     rd  /s /q *
popd

pushd C:\Windows\SoftwareDistribution
     del /f /s /q *
     rd  /s /q *
popd
