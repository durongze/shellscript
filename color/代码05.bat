@echo off
::http://blogs.technet.com/b/heyscriptingguy/archive/2012/10/11/powertip-write-powershell-output-in-color-without-using-write-host.aspx
cls

echo.
call :ccr ����'\"'��ɫ'\"'�ַ���
call :ccg ����'\"'��ɫ'\"'�ַ���

::Ҳ�����������ļ�д�﷨��
::powershell write-host -fore Cyan This is Cyan text
::powershell write-host -back Red This is Red background

:ccr
powershell -Command Write-Host "%*" -foreground "Red"
goto :eof

:ccg
powershell -Command Write-Host "%*" -foreground "Green"
echo.
pause

::Color ��ɫRed ��ɫBlack ��ɫGreen ��ɫYellow ��ɫBlue ���Magenta ��ɫCyan ��ɫWhite