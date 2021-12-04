#!/bin/bash

function CMakeInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3 -DBUILD_SHARED_LIBS=true"
    local InstallDir=$4
    mkdir dyzbuild  
    pushd dyzbuild
        echo -e "\033[32m export CXXFLAGS=\"-fPIC\" && cmake .. -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir $CurFlags \033[0m"
        export CXXFLAGS="-fPIC" && cmake .. -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir $CurFlags
        make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        make install  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    popd
}

function AutoGenInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3 --enable-shared=yes"
    local InstallDir=$4
    ./autogen.sh
    make distclean
    mkdir dyzbuild
    pushd dyzbuild
        dos2unix ../configure && export CXXFLAGS="-fPIC"
        echo -e "\033[32m ../configure --prefix=$DstDir/$InstallDir $CurFlags \033[0m" 
        ../configure --prefix=$DstDir/$InstallDir $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
        make || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
        make install || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
    popd
}

function CfgInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3 --enable-shared=yes"
    local InstallDir=$4
    mkdir dyzbuild
    pushd dyzbuild
        dos2unix ../configure && export CXXFLAGS="-fPIC"
        echo -e "\033[32m ../configure --prefix=$DstDir/$InstallDir $CurFlags \033[0m" 
        ../configure --prefix=$DstDir/$InstallDir $CurFlags  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
        make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
        make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
    popd
}

function FindCfgInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3 "
    local InstallDir=$4
    mkdir dyzbuild
    pushd dyzbuild
        CfgFile=$(find ../ -name "configure")
        if [[ $CfgFile != "" ]];then
            dos2unix $CfgFile && export CXXFLAGS="-fPIC"
            echo -e "\033[32m $CfgFile --prefix=$DstDir/$InstallDir $CurFlags \033[0m" 
            $CfgFile --prefix=$DstDir/$InstallDir $CurFlags  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
            make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
            make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1; }
        fi
    popd
}

function MesonInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3"
    local InstallDir=$4
    meson build -Dprefix=$DstDir/$InstallDir $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[2]} ${BASH_LINENO[2]} "; exit 1;  }  
    meson compile -C build #ninja -j8
    meson install -C build #ninja install
}

function AutoInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3"
    local InstallDir=$(echo $SrcDir | tr -s "." "_")
    pushd $SrcDir
    if [ -f CMakeLists.txt ];then
        CMakeInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
    elif [ -f setup.py ];then
        sudo python setup.py install 
    elif [ -f autogen.sh ];then
        AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
    elif [ -f configure ];then
        CfgInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
    elif [ -f Makefile ];then
        make $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    elif [ -f meson.build ];then
        MesonInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
    else
        echo -e "\033[31m Install $InstallDir Fail, cfg file not exist !!! \033[0m"
        exit 1
    fi
    popd
}

function SpecInstall()
{
    local SrcDir=$1
    local DstDir=$2
    local CurFlags="$3"
    local InstallDir=$(echo $SrcDir | tr -s "." "_")
    pushd $SrcDir
    case $v in
        CMake*)
            CMakeInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
        ;;
        Python*)
            sudo python setup.py install 
        ;;
        AutoGen*)
            AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
        ;;
        Cfg*)
            CfgInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
        ;;
        Make*)
            make $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        ;;
        Meson*)
            MesonInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
        ;;
        FindCfg*)
            FindCfgInstall "$SrcDir" "$DstDir" "$CurFlags" "$InstallDir"
        ;;
        *)
            echo -e "\033[31m Install $InstallDir Fail, Use AutoInstall !!! \033[0m"
        ;;
    esac
    popd
}

function TarFileInstall()
{
    TarFile=$1
    DstDir=$2
    CurFlags="$3"
    Spec=$4
    FileDir=$(tar -tf $TarFile | cut -f1 -d'/' | uniq | sed -n '1p')
    echo -e "\033[32mFile:\033[0m$TarFile \033[32mDir:\033[0m$FileDir"
    tar xf $TarFile
    if [[ "$Spec" != "" ]];then
        SpecInstall "$FileDir" "$DstDir" "$CurFlags" "$Spec"
    else
        AutoInstall "$FileDir" "$DstDir" "$CurFlags"
    fi
}

function ZipFileInstall()
{
    ZipFile=$1
    DstDir=$2
    CurFlags="$3"
    Spec=$4
    FileDir=$(unzip -v $ZipFile | awk '{print $8}' | grep "/$" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
    FileName=${ZipFile%.*}
    echo -e "\033[32mFile:$ZipFile Dir:$FileDir FileName:$FileName\033[0m"
    if [ "$FileDir" = "$FileName" ];then
        unzip -q $ZipFile 
    else
        mkdir $FileName
        unzip -q $ZipFile -d $FileName
        DstDir=$FileName
    fi
    if [[ "$Spec" != "" ]];then
        SpecInstall "$FileDir" "$DstDir" "$CurFlags" "$Spec"
    else
        AutoInstall "$FileDir" "$DstDir" "$CurFlags"
    fi
}

function TarXFFile()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    Spec=$4
    pushd ./
    SrcFileList=$SrcDir
    for PkgFile in $SrcFileList
    do
        case $PkgFile in
            *.tar.*)
                TarFileInstall "$PkgFile" "$DstDir" "$CurFlags" "$Spec"
                ;;
            *.zip)
                ZipFileInstall "$PkgFile" "$DstDir" "$CurFlags" "$Spec"
                ;;
        esac;
    done
    popd
}

####################################环境变量配置#####################################

function GenFileNameByFile()
{
    file="$1"
    case $file in
        *.tar.*)
            FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
            ;;
        *.zip)
            #FileDir=$(unzip -v $file |awk '{print $8}' | grep "/" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
            FileDir=$(unzip -v $file |awk '{print $8}' | grep "/$" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
            ;;
    esac;
    FileDir=$(echo $FileDir | tr -s "." "_")
    echo $FileDir
}

function GenFileNameVar()
{
    FileList="$(ls *.zip )"
    FileDir=""

    echo "" >env.txt
    for file in $FileList
    do
        FileDir=$(GenFileNameByFile $file)
        echo $FileDir >>env.txt
    done
}

function GenEnvVar()
{
    BASHRC="${HOME}/.bashrc"
    echo "fileList=\"$(cat env.txt)\""  >>${BASHRC}
    echo "for tmpFile in \${fileList}" >>${BASHRC}
    echo "do" >>${BASHRC}
    echo "    TMP_FILE_HOME=\${HOME}/opt/\${tmpFile}" >>${BASHRC}
    echo "    export C_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${C_INCLUDE_PATH}" >>${BASHRC}
    echo "    export CPLUS_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${CPLUS_INCLUDE_PATH}" >>${BASHRC}
    echo "    export CMAKE_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${CPLUS_INCLUDE_PATH}" >>${BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export CMAKE_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export CMAKE_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LD_LIBRARY_PATH}" >>${BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LD_LIBRARY_PATH}" >>${BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib/pkgconfig/:\${PKG_CONFIG_PATH}" >>${BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib64/pkgconfig/:\${PKG_CONFIG_PATH}" >>${BASHRC}
    echo "    export CMAKE_MODULE_PATH=\${TMP_FILE_HOME}/lib/cmake/:\${CMAKE_MODULE_PATH}" >>${BASHRC}
    echo "    export PATH=\${TMP_FILE_HOME}/bin:\${TMP_FILE_HOME}/sbin:\$PATH" >>${BASHRC}
    echo "done" >>${BASHRC}
}

#GenFileNameVar 
#GenEnvVar 

#TarXFFile "libpng-1.6.37.tar.gz" "${HOME}/opt/" "" 
#TarXFFile "libjpeg-turbo-2.1.1.tar.gz" "${HOME}/opt/" "" 
#TarXFFile "openjpeg-2.4.0.tar.gz" "${HOME}/opt/" "" 

#TarXFFile "icu-release.zip" "${HOME}/opt/" ""
#TarXFFile "tiff-4.3.0.zip" "${HOME}/opt/" "" 
#TarXFFile "leptonica.zip" "${HOME}/opt/" " -DBUILD_SHARED_LIBS=true " 

#TarXFFile "pcre2-10.39.tar.gz" "${HOME}/opt/" "" 

#TarXFFile "pcre-8.45.tar.gz" "${HOME}/opt/" " -DBUILD_SHARED_LIBS=true " 
#TarXFFile "libffi-3.4.2.tar.gz" "${HOME}/opt/" "" 
#TarXFFile "zlib-1.2.11.tar.gz" "${HOME}/opt/" "" 

#TarXFFile "freetype-2.11.0.tar.gz" "${HOME}/opt/" " -DBUILD_SHARED_LIBS=true " 
#TarXFFile "harfbuzz-3.1.1.tar.gz" "${HOME}/opt/" " -DBUILD_SHARED_LIBS=true " 
#TarXFFile "fontconfig-2.13.94.tar.xz" "${HOME}/opt/" "" 

#TarXFFile "pixman-0.40.0.tar.gz" "${HOME}/opt/" "" 
#TarXFFile "cairo-1.17.4.tar.xz" "${HOME}/opt/" "" 
#TarXFFile "pango-1.49.3.tar.gz" "${HOME}/opt/" "" 

#sed -e 's/text2image pango_training/text2image pango_training harfbuzz/g' -i tesseract/src/training/CMakeLists.txt
#TarXFFile "tesseract.zip" "${HOME}/opt/" " -DBUILD_SHARED_LIBS=true "
#sudo apt install gperf meson
FileList="
libpng-1.6.37.tar.gz
libjpeg-turbo-2.1.2.tar.gz
openjpeg-2.4.0.tar.gz

icu-release-70-1.tar.gz
tiff-4.3.0.tar.gz
leptonica-1.82.0.tar.gz

pcre-8.45.tar.gz
libffi-3.4.2.tar.gz
zlib-1.2.11.tar.gz

freetype-2.11.0.tar.gz
harfbuzz-3.1.2.tar.gz
fontconfig-2.13.94.tar.gz

pixman-0.40.0.tar.gz
cairo-1.17.4.tar.xz
pango-1.49.3.tar.xz"
FileList="
tesseract-5.0.0.tar.gz"

declare -A sermap=(["leptonica-1.82.0.tar.gz"]="AutoGen"
                   ["icu-release-70-1.tar.gz"]="FindCfg"  )

for PkgFile in $FileList
do
    Skip=""
    for k in ${!sermap[@]}
    do
        if [[ "$k" == "$PkgFile" ]];then
            v=${sermap[$k]}
            echo -e "\033[31m TarXFFile "$PkgFile" "${HOME}/opt" " " "$v" \033[0m"
            TarXFFile "$PkgFile" "${HOME}/opt" " " "$v"
            Skip="true"
            break
        fi
    done
    if [[ "$Skip" == "true" ]]; then
        continue
    fi 
    echo -e "\033[32m TarXFFile "$PkgFile" "${HOME}/opt" " " "" \033[0m"
    TarXFFile "$PkgFile" "${HOME}/opt" " " ""
done

export TESSDATA_PREFIX=${HOME}/opt/tesseract-5_0_0/tessdata
