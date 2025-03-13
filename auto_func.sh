#!/bin/bash

function SearchLibrary()
{
    sudo apt-update
    sudo apt-get install apt-file
    sudo apt-file update
}

function MakeDir()
{
    SrcDir=$1
    if [ ! -d $SrcDir ];then
        mkdir -p $SrcDir
    fi
    pushd $SrcDir >>/dev/null
    pwd $SrcDir
    popd >>/dev/null
}

function CMakeInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo "$DstDir/$SrcDir" | tr -s "." "_")
    InstallDir=${InstallDir/\/\_\//}
    echo $InstallDir
    if [[ ! -d dyzbuild ]];then
        mkdir dyzbuild
    fi
    pushd dyzbuild
        #export CXXFLAGS="-fPIC" && cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DCMAKE_INSTALL_PREFIX=$InstallDir $CurFlags    ..
        #echo -e "\033[32m export CXXFLAGS=\"-fPIC\" && cmake .. -DCMAKE_INSTALL_PREFIX=$InstallDir $CurFlags \033[0m"
        CmdStr="\033[32m export CXXFLAGS=\"-fPIC\" && cmake .. -DCMAKE_INSTALL_PREFIX=$InstallDir $CurFlags \033[0m"
        echo -e $CmdStr
        ErrStr="$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} $CmdStr "
        export CXXFLAGS="-fPIC" && cmake .. -DCMAKE_INSTALL_PREFIX=$InstallDir $CurFlags 
        make  || { echo -e "$ErrStr"; exit 1; }
        make install  || { echo -e "$ErrStr"; exit 1; }
    popd
}

function AutoGenInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo "$DstDir/$SrcDir" | tr -s "." "_")
    InstallDir=${InstallDir/\/\_\//}
    if [ -f ./autogen.sh ];then
        ./autogen.sh
    elif [ -f ./buildconf ];then
        ./buildconf
    elif [ -f ./config ];then
        cp ./config ./configure
    fi

    if [[ ! -d dyzbuild ]];then
        mkdir dyzbuild
    fi
    autoreconf --install --force
    pushd dyzbuild
        dos2unix ../configure && export CXXFLAGS="-fPIC"
        CmdStr="\033[32m ../configure --prefix=$InstallDir $CurFlags \033[0m" 
        echo -e $CmdStr
        ErrStr="$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} $CmdStr "
        ../configure --prefix=$InstallDir $CurFlags  || { echo -e "$ErrStr"; exit 1; }
        make   || { echo -e "$ErrStr"; exit 1; }
        make install   || { echo -e "$ErrStr"; exit 1; }
    popd
}

function CfgInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo "$DstDir/$SrcDir" | tr -s "." "_")
    InstallDir=${InstallDir/\/\_\//}
    if [[ ! -d dyzbuild ]];then
        mkdir dyzbuild
    fi
    autoreconf --install --force
    pushd dyzbuild
        dos2unix ../configure && export CXXFLAGS="-fPIC"
        CmdStr="\033[32m ../configure --prefix=$InstallDir $CurFlags \033[0m" 
        echo -e $CmdStr
        ErrStr="$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} $CmdStr "
        dos2unix -f ../configure
        chmod +x ../configure
        ../configure --prefix=$InstallDir $CurFlags  || { echo -e "$ErrStr"; exit 1; }
        make   || { echo -e "$CmdStr"; exit 1; }
        make install   || { echo -e "$CmdStr"; exit 1; }
    popd

}

function AutoInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"

    DstDir=$(MakeDir "$DstDir")
    InstallDir=$(echo "$DstDir/$SrcDir" | tr -s "." "_")
    InstallDir=${InstallDir/\/\_\//}
    pushd $SrcDir
    if [ -f CMakeLists.txt ];then
        CMakeInstall "$SrcDir" "$DstDir" "$CurFlags"
    elif [ -f setup.py ];then
        sudo python setup.py install 
    elif [ -f autogen.sh ] || [ -f buildconf ] || [ -f config ] ;then
        AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags"
    elif [ -f configure ];then
        CfgInstall "$SrcDir" "$DstDir" "$CurFlags"
    elif [ -f Makefile ];then
        make $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
    else
        echo -e "\033[31m Install $InstallDir Fail, cfg file not exist !!! \033[0m"
        exit 1
    fi
    popd
}


function SpecInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    Method=$4

    DstDir=$(MakeDir "$DstDir")
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    if [[ $# -eq 4 ]];then
        echo -e "\033[32m $FUNCNAME $LINENO [$#]ARGS:$* \033[0m"
    fi
    pushd $SrcDir
        case $Method in
            *[Cc][Mm]ake*[Ii]nstall*)
                CMakeInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Cc][Mm]ake*)
                CMakeInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Aa]uto*[Gg]en*[Ii]nstall*)
                AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Aa]uto*)
                AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Cc]*f*g*[Ii]nstall*)
                CfgInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Cc]*f*g*)
                CfgInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Mm]ake*[Ii]nstall*)
                make $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
                ;;
            *[Mm]ake*)
                make $CurFlags || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
                ;;
            *[Pp]ython*[Ii]nstall*)
                sudo python setup.py install 
                ;;
            *[Pp]ython*)
                sudo python setup.py install 
                ;;
            *)
                echo -e "\033[31m $FUNCNAME $LINENO Method:$Method \033[0m"
                ;;
        esac;
    popd
}

function GetTarFileDir()
{
    file=$1
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
    echo $FileDir
}

function TarAndInstall()
{
    file=$1
    DstDir=$2
    CurFlags="$3"
    Method=$4

    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
    echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
    tar xf $file
    if [[ $Method == "" ]];then
        AutoInstall "$FileDir" "$DstDir" "$CurFlags"
    else
        SpecInstall "$FileDir" "$DstDir" "$CurFlags" "$Method"
    fi
}

function GetZipFileDir()
{
    file=$1
    FileDir=$(unzip -v $file |awk '{print $8}' | grep "/$" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
    FileName=${file%.*}
    echo -e "\033[32mFile:$file Dir:$FileDir FileName:$FileName\033[0m"
    if [ "$FileDir" = "$FileName" ];then
        unzip -q $file 
    else
        mkdir $FileName
        unzip -q $file -d $FileName
        FileDir=$FileName
    fi
    echo $FileDir
}

function ZipAndInstall()
{
    file=$1
    DstDir=$2
    CurFlags="$3"
    Method=$4

    FileDir=$(unzip -v $file |awk '{print $8}' | grep "/$" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
    FileName=${file%.*}
    echo -e "\033[32mFile:$file Dir:$FileDir FileName:$FileName\033[0m"
    if [ "$FileDir" = "$FileName" ];then
        unzip -q $file 
    else
        mkdir $FileName
        unzip -q $file -d $FileName
        DstDir=$FileName
    fi
    if [[ $Method == "" ]];then
        AutoInstall "$FileDir" "$DstDir" "$CurFlags"
    else
        SpecInstall "$FileDir" "$DstDir" "$CurFlags" "$Method"
    fi
}

function TarXFFile()
{
    PkgFile=$1
    DstDir=$2
    CurFlags="$3"
    Method=$4
    DstDir=$(MakeDir "$DstDir")
    case $PkgFile in
        *.tar.*)
            TarAndInstall "$PkgFile" "$DstDir" "$CurFlags" "$Method"
            ;;
        *.zip)
            ZipAndInstall "$PkgFile" "$DstDir" "$CurFlags" "$Method"
            ;;
    esac;
}

function TarXFDir()
{
    DstDir=$1
    pushd ./
    SrcFileList=$SrcDir
    for file in $SrcFileList
    do
        TarXFFile "$file" "$DstDir" "" ""
    done
    popd
}

####################################Copy pc#########################################

function CopyPcFile()
{
    PkgFile=$1
    DstDirPrefix=$2

    SrcDir=""    
    case $PkgFile in
        *.tar.*)
            SrcDir=$(GetTarFileDir "$PkgFile" "$DstDir" "$CurFlags" "$Method")
            ;;
        *.zip)
            SrcDir=$(GetZipFileDir "$PkgFile" "$DstDir" "$CurFlags" "$Method")
            ;;
    esac;
    DstDir=$(echo $SrcDir | tr -s "." "_")
    DstDir="$DstDirPrefix/$DstDir/lib/pkgconfig"
    echo -e "\033[31m find $SrcDir -iname \"*.pc\" | xargs -I {} cp {} $DstDir/ \033[0m"
}

####################################Env Cfg#####################################

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

function GenFileNameVarByFile()
{
    FileList="$1"
    EnvFile=$2
    FileDir=""

    echo "" >${EnvFile}
    for cur_file in $FileList
    do
        FileDir=$(GenFileNameByFile $cur_file)
        InstallDir=$(echo $FileDir | tr -s "." "_")
        echo $InstallDir >>${EnvFile}
    done
}

function GenFileNameVarByDir()
{
    DirList="$1"
    EnvFile=$2
    FileDir=""

    echo "" >${EnvFile}
    for cur_dir in $DirList
    do
        FileDir=$cur_dir
        InstallDir=$(echo $FileDir | tr -s "." "_")
        echo $InstallDir >>${EnvFile}
    done
}

function GenEnvVar()
{
    InstallHome=$1
    EnvFile=$2
    BASHRC="$3"
    echo "fileList=\"$(cat ${EnvFile})\""  >${BASHRC}
    echo "for tmpFile in \${fileList}" >>${BASHRC}
    echo "do" >>${BASHRC}
    #echo "    TMP_FILE_HOME=\${HOME}/opt/\${tmpFile}" >>${BASHRC}
    echo "    TMP_FILE_HOME=${InstallHome}/\${tmpFile}" >>${BASHRC}
    echo "    export C_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${C_INCLUDE_PATH}" >>${BASHRC}
    echo "    export CPLUS_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${CPLUS_INCLUDE_PATH}" >>${BASHRC}
    echo "    export CMAKE_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${CMAKE_INCLUDE_PATH}" >>${BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export LD_RUN_PATH=\${TMP_FILE_HOME}/lib:\${LD_RUN_PATH}" >>${BASHRC}
    echo "    export LD_RUN_PATH=\${TMP_FILE_HOME}/lib64:\${LD_RUN_PATH}" >>${BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LD_LIBRARY_PATH}" >>${BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LD_LIBRARY_PATH}" >>${BASHRC}
    echo "    export CMAKE_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${CMAKE_LIBRARY_PATH}" >>${BASHRC}
    echo "    export CMAKE_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${CMAKE_LIBRARY_PATH}" >>${BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib/pkgconfig/:\${PKG_CONFIG_PATH}" >>${BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib64/pkgconfig/:\${PKG_CONFIG_PATH}" >>${BASHRC}
    echo "    export CMAKE_MODULE_PATH=\${TMP_FILE_HOME}/lib/cmake/:\${CMAKE_MODULE_PATH}" >>${BASHRC}
    echo "    export PATH=\${TMP_FILE_HOME}/bin:\${TMP_FILE_HOME}/sbin:\$PATH" >>${BASHRC}
    echo "done" >>${BASHRC}
}

function GenEnvVarByFile()
{
    InstallHome=$1
    FileList="$2"
    EnvFile="env.txt"
    BASHRC="bashrc"

    echo "[$FUNCNAME:$LINENO] DirList:$DirList"

    GenFileNameVarByFile "$FileList" "${EnvFile}"
    GenEnvVar "${InstallHome}" "${EnvFile}" "${BASHRC}"
}

function GenEnvVarByDir()
{
    InstallHome=$1
    SourceHome=$2
    EnvFile="env.txt"
    BASHRC="bashrc"

    if [[ -d $SourceHome ]];then
        pushd $SourceHome
            DirList="$(ls -d */)"
        popd
    else
        echo "Dir '${SourceHome}' does not exist."
        return
    fi

    echo "[$FUNCNAME:$LINENO] DirList:$DirList"

    GenFileNameVarByDir "$DirList" "${EnvFile}"
    GenEnvVar "${InstallHome}" "${EnvFile}" "${BASHRC}"
}
