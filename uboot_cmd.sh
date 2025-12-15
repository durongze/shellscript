#!/bin/bash

function BootSD()
{
    mmc dev 0
    mmc part
    ext4load mmc 0:5 ${loadaddr} /etc/os-release
    setenv bootargs 'root=/dev/mmcblk1p5 rootfstype=ext4 rw console=ttySTM0,115200'
    setenv bootcmd 'mmc dev 0; ext4load mmc 0:4 ${kernel_addr_r} uImage; ext4load mmc 0:4 ${fdt_addr_r} stm32mp157d-atk.dtb; bootm ${kernel_addr_r} - ${fdt_addr_r}'
    saveenv
}

function BootEMMC()
{
    
}

function BootAuto()
{
    setenv mmcdev 0
    setenv bootcmd 'if mmc dev 0; then run bootcmd_sd; else run bootcmd_emmc; fi'
    setenv bootcmd_sd 'ext4load mmc 0:4 ${kernel_addr_r} uImage; ext4load mmc 0:4 ${fdt_addr_r} stm32mp157d-atk.dtb; bootm ${kernel_addr_r} - ${fdt_addr_r}'
    setenv bootcmd_emmc 'ext4load mmc 1:2 ${kernel_addr_r} uImage; ext4load mmc 1:2 ${fdt_addr_r} stm32mp157d-atk.dtb; bootm ${kernel_addr_r} - ${fdt_addr_r}'
    saveenv
}
