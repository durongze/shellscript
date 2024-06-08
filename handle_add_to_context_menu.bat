@echo off
:: 关闭命令回显
if "%1"=="" (
    echo No file specified.
    pause
    exit /b
)
 
:: 获取传递的文件路径
set "filePath=%1"
:: 获取文件名（不含路径）
set "fileName=%~nx1"
:: 获取文件的目录路径
set "fileDir=%~dp1"
 
:: 输出将要添加到注册表的信息
echo Adding file information to the registry: %filePath%
 
:: 添加文件路径到注册表
REG ADD "HKCR\*\shell\%fileName%" /ve /d "%fileName%" /f
REG ADD "HKCR\*\shell\%fileName%" /v "icon" /t REG_SZ /d  "%filePath%" /f
REG ADD "HKCR\*\shell\%fileName%\command" /ve /d  "\"%filePath%\" \"%%1\"" /f
 
echo File information added successfully
:: 输出提示信息，告知用户文件信息已成功添加到注册表
pause
