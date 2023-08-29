@rem shift F10

@rem diskpart
diskpart
list disk
select disk 0
clean
convert gpt
@rem System
create partition efi size=300
format quick fs=fat32 label="System"
assign letter="S"
@rem Msr
create partition msr size=128
@rem Work
create partition primary size=104800
format quick fs=ntfs label="Win10"
assign letter="C"

@rem install win10
dism /apply-image /imagefile:d:\sources\install.wim /index:1 /applydir:c:

@rem fixboot
bcdboot C:Windows /s S: /f uefi /l zh-cn

bootsect/nt60 all /force 
bootrec /fixboot
bootrec /rebuildbcd
bootrec /scanos

@rem user
net user administrator /active:yes

shtudown -r -t 0