@echo off
echo PCI VEN_10EC DEV_8176 SUBSYS_11391A3B REV_01

echo 1 禁用 Realtek RTL8188CE 网卡驱动...
devcon disable "PCI\VEN_10EC&DEV_8176"
timeout /t 5

echo 2 启用 Realtek RTL8188CE 网卡驱动...
devcon enable "PCI\VEN_10EC&DEV_8176"
echo 3 操作完成！

pause