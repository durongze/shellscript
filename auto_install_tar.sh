#!/bin/bash

function AutoInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags=$3
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    echo "DstDir:$DstDir InstallDir:$InstallDir #####################################"
    pushd $SrcDir
        if [ -f CMakeLists.txt ];then
            mkdir dyzbuild  
            pushd dyzbuild
            export CXXFLAGS="-fPIC" && cmake  -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir ..
            make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            make install  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            popd
        elif [ -f configure ];then
            mkdir dyzbuild
            pushd dyzbuild
    	    dos2unix ../configure
            ../configure --prefix=$DstDir/$InstallDir $CurFlags  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
            popd
        else
            echo -e "\033[31m Install $InstallDir Fail !!! \033[0m"
            exit 1
        fi
    popd
}

function TarXFFile()
{
    SrcDir=$1
    DstDir=$2
    CurFlags=$3
    pushd ./
        SrcFileList=$SrcDir
        for file in $SrcFileList
        do
	   case $file in
	    *.tar.*)
            	FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq)
            	echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
            	tar xf $file
            	AutoInstall $FileDir $DstDir $CurFlags
	    ;;
	    *.zip)
	    	FileDir=$(unzip -v jpegsr6.zip |awk '{print $8}' | grep "/$" | uniq)
            	echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
		unzip $file
		AutoInstall $FileDir $DstDir $CurFlags
	    ;;
	    esac;
        done
    popd
}

function ModifyWxGTK()
{
    find wxGTK-2.8.12/ -iname "*.xbm" | xargs -I {} sed -i 's/0x/char(0x/g' {}
    find wxGTK-2.8.12/ -iname "*.xbm" | xargs -I {} sed -i 's/,/),/g' {}
    find wxGTK-2.8.12/ -iname "*.xbm" | xargs -I {} sed -i 's/}/)}/g' {}
    sed -i 's#DEFAULT_wxUSE_STL=no#DEFAULT_wxUSE_STL=yes#g' wxGTK-2.8.12/configure
    sed -i 's#DEFAULT_wxUSE_NOTEBOOK=no#DEFAULT_wxUSE_NOTEBOOK=yes#g' wxGTK-2.8.12/configure
}

function GenInputHeader()
{
    cd /usr/include/X11/extensions && sudo ln -s XI.h XInput.h
}

#TarXFFile "glib-2.56.0.tar.xz" ~/opt ""
#TarXFFile "atk-1.29.92.tar.gz" ~/opt ""
#TarXFFile "tiff-4.0.9.tar.gz" ~/opt " --shared "
#TarXFFile "libjpeg-turbo-1.5.3.tar.gz" ~/opt ""
#TarXFFile "gdk-pixbuf-2.30.8.tar.xz" ~/opt ""
#TarXFFile "gtk+-2.24.32.tar.xz" ~/opt ""
#TarXFFile "wxGTK-2.8.12.tar.gz" ~/opt " --enable-unicode --enable-stl --enable-gui --enable-shared --enable-msgdlg "
#TarXFFile "libupnp-1.6.21.tar.bz2" ~/opt ""
#"cryptopp565.zip"
#make install PREFIX=${HOME}/opt/cryptopp565
#TarXFFile "zlib-1.2.11.tar.gz" ~/opt ""
TarXFFile "aMule-2.3.2.tar.xz" ~/opt " --enable-amule-daemon --enable-amulecmd --enable-webserver --enable-amule-gui --enable-alc --enable-alcc --enable-fileview --enable-plasmamule "


#TarXFFile "xcb-proto-1.13.tar.bz2" ~/opt ""
#TarXFFile "libxcb-1.13.tar.bz2" ~/opt ""
#TarXFFile "glib-2.57.1.tar.xz" ~/opt ""
#TarXFFile "gobject-introspection-1.56.1.tar.bz2" ~/opt ""
#TarXFFile "gperf-3.1.tar.gz" ~/opt ""
#TarXFFile "udev-181.tar.gz" ~/opt " --disable-keymap "
#TarXFFile "libusb-1.0.22.tar.bz2" ~/opt ""
#TarXFFile "usbutils-007.tar.gz" ~/opt ""
#TarXFFile "graphviz.tar.gz" ~/opt ""
#TarXFFile "doxygen-1.8.14.src.tar.gz" ~/opt ""
#X11/extensions/XInput.h: No such file or directory #GenInputHeader
#TarXFFile "freeglut-3.0.0.tar.gz" ~/opt ""
