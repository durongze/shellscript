@echo off
:: 关闭命令回显
echo Checking if "Add to Context Menu" option exists...
 
:: 检查是否存在右键菜单项
REG QUERY "HKCU\Software\Classes\*\shell\AddToContextMenu" >nul 2>&1
if %errorlevel%==0 (
    echo "Add to Context Menu" option already exists.
) else (
    echo Adding "Add to Context Menu" option...
 
    :: 添加右键菜单项
    REG ADD "HKCU\Software\Classes\*\shell\AddToContextMenu" /ve /d "Add to Context Menu" /f
    REG ADD "HKCU\Software\Classes\*\shell\AddToContextMenu\command" /ve /d "\"%~dp0handle_add_to_context_menu.bat\" \"%%1\"" /f
 
    echo "Add to Context Menu" option added successfully.
)
 
pause
