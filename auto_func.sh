#!/bin/bash

function EchoError()
{
    local str="$1"
    echo -e "\033[31m $str \033[0m"
}

function EchoInfo()
{
    local str="$1"
    echo -e "\033[32m $str \033[0m"
}

function DownloadSoftware()
{
    DownloadDir=$1
    SoftwareUrls="$2"
    Idx=0
    if [ ! -d "$DownloadDir" ];then
        mkdir $DownloadDir
    fi
    pushd $DownloadDir
        for url in $SoftwareUrls
        do
	    Idx=$(expr $Idx + 1)
            file=${url##*/}
            if [ -f $file ];then
                echo -e "\033[32m <$Idx> file : $file exist. \033[0m"
                continue
            fi
            echo -e "\033[33m <$Idx> file : $file downloading. \033[0m"
            wget $url
        done
    popd
}

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

function GetTarFileDir()
{
    file=$1
    FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
    echo $FileDir
}

function TryGetZipFileDir()
{
    file=$1
    FileDir=$(unzip -v $file | awk '{print $8}' | grep "/$" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
    echo $FileDir
}

function GetZipFileDir()
{
    file=$1
    FileName=${file%.*}
    FileDir=$(TryGetZipFileDir "$file")
    if [ "$FileDir" != "$FileName" ];then
        FileDir=$FileName
    fi
    echo $FileDir
}

function DecompressZipFile()
{
    file=$1
    FileName=${file%.*}
    FileDir=$(TryGetZipFileDir "$file")
    if [ "$FileDir" == "$FileName" ];then
        unzip -q $file 
    else
        mkdir $FileName
        unzip -q $file -d $FileName
    fi
}

function DecompressFile()
{
    local PkgFile=$1
    case $PkgFile in
        *.tar.*)
            tar xf $PkgFile
            ;;
        *.zip)
            DecompressZipFile "$PkgFile"
            ;;
    esac;
}

function GetFileDir()
{
    PkgFile=$1
    SrcDir=""
    case $PkgFile in
        *.tar.*)
            SrcDir=$(GetTarFileDir "$PkgFile")
            ;;
        *.zip)
            SrcDir=$(GetZipFileDir "$PkgFile")
            ;;
        *)
            ;;
    esac;
    echo $SrcDir
}

function GetInstallDir()
{
    PkgFile=$1
    SrcDir=$(GetFileDir "$PkgFile")
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    echo $InstallDir
}

function CMakeInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    if [[ ! -d dyzbuild ]];then
        mkdir dyzbuild
    fi
    pushd dyzbuild
        CmdStr="export CXXFLAGS=\"-fPIC\" && cmake .. -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir $CurFlags"
        eval ${CmdStr//\\//}
        cmake --build . || { EchoError "$CmdStr"; exit 1; }
        cmake --install . || { EchoError "$CmdStr"; exit 1; }
    popd
}

function AutoGenInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"

    if [ -f ./autogen.sh ];then
        ./autogen.sh
    elif [ -f ./buildconf ];then
        ./buildconf 
    elif [ -f ./config ];then
        cp ./config ./configure
    fi
    CurStat=$?
    if [[ $CurStat -ne 0 ]];then
        echo -e "\033[31m [$FUNCNAME:$LINENO]Install $SrcDir failed, gen cfg error $CurStat!!! \033[0m"
        echo -e "\033[31m DstDir $DstDir !!! \033[0m"
        echo -e "\033[31m CurFlags $CurFlags !!! \033[0m"
        exit 1;
    fi
    autoreconf --install --force
    CfgInstall "$SrcDir" "$DstDir" "$CurFlags"
}

function CfgInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    if [[ ! -d dyzbuild ]];then
        mkdir dyzbuild
    fi
    #pushd dyzbuild
        dos2unix ./configure && export CXXFLAGS="-fPIC"
		chmod +x ./configure
        CmdStr="./configure --prefix=$DstDir/$InstallDir $CurFlags" 
        EchoInfo "$CmdStr"
        eval $CmdStr  || { EchoError "$CmdStr"; exit 1; }
        make   || { EchoError "$CmdStr"; exit 2; }
        make install   || { EchoError "$CmdStr"; exit 3; }
    #popd

}

function MakeInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    FixPkgCtx "$SrcDir"
    $CurFlags && make || { echo -e "\033[31m Install $SrcDir failed. \033[0m"; exit 1; }
    make install 
}

function PythonInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    CmdStr="sudo python setup.py install"
    eval $CmdStr  || { EchoError "$CmdStr"; exit 1; }
}

function MesonInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    echo "pwd:$(pwd) DstDir:$DstDir"
    CmdStr="meson build/ \"--prefix=$DstDir\"" 
    eval $CmdStr  || { EchoError "$CmdStr"; exit 1; }
}

function AutoInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"

    pushd $SrcDir
        if [ -f CMakeLists.txt ];then
            CMakeInstall "$SrcDir" "$DstDir" "$CurFlags"
        elif [ -f autogen.sh ] || [ -f buildconf ] || [ -f config ] ;then
            AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags"
        elif [ -f configure ];then
            CfgInstall "$SrcDir" "$DstDir" "$CurFlags"
        elif [ -f Makefile ];then
            MakeInstall "$SrcDir" "$DstDir" "$CurFlags"
        elif [ -f setup.py ];then
            PythonInstall "$SrcDir" "$DstDir" "$CurFlags"
        elif [ -f meson.build ];then
            MesonInstall "$SrcDir" "$DstDir" "$CurFlags"
        else
            EchoError "$FUNCNAME:$LINENO Install $SrcDir failed, cfg file not exist !!!"
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

    if [[ $# -ne 4 ]];then
        echo -e "\033[31m[$FUNCNAME:$LINENO] $# ARGS:$* \033[0m"
    fi
    pushd $SrcDir
        case $Method in
            [Cc][Mm]ake[Ii]nstall*)
                CMakeInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Aa]uto[Gg]en[Ii]nstall*)
                AutoGenInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Cc]fg[Ii]nstall*)
                CfgInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            [Mm]ake[Ii]nstall*)
                MakeInstall "$SrcDir" "$DstDir" "$CurFlags" 
                ;;
            *[Pp]ython[Ii]nstall*)
                PythonInstall "$SrcDir" "$DstDir" "$CurFlags"
                ;;
            *[Mm]eson[Ii]nstall*)
                MesonInstall "$SrcDir" "$DstDir" "$CurFlags"
                ;;
            *)
                EchoError "$FUNCNAME:$LINENO Install $SrcDir failed, Method:$Method"
                ;;
        esac;
    popd
}

function TarAndInstall()
{
    file=$1
    DstDirPrefix=$2
    CurFlags="$3"
    Method=$4
    
    FileDir=$(GetTarFileDir "$file")
    echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir  \033[32mMethod:\033[0m$Method \033[32mDstDirPrefix:\033[0m$DstDirPrefix \033[32mCurFlags:\033[0m$CurFlags"
    tar xf $file
    if [[ $Method == "" ]];then
        AutoInstall "$FileDir" "$DstDirPrefix" "$CurFlags"
    else
        SpecInstall "$FileDir" "$DstDirPrefix" "$CurFlags" "$Method"
    fi
}

function ZipAndInstall()
{
    file=$1
    DstDirPrefix=$2
    CurFlags="$3"
    Method=$4

    FileDir=$(GetZipFileDir "$file")
    echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir \033[32mDstDirPrefix:\033[0m$DstDirPrefix \033[32mCurFlags:\033[0m$CurFlags"
    DecompressZipFile "$file"
    if [[ $Method == "" ]];then
        AutoInstall "$FileDir" "$DstDirPrefix" "$CurFlags"
    else
        SpecInstall "$FileDir" "$DstDirPrefix" "$CurFlags" "$Method"
    fi
}

function InstallPkgFile()
{
    PkgFile=$1
    DstDirPrefix=$2
    CurFlags="$3"
    Method=$4
    case $PkgFile in
        *.tar.*)
            TarAndInstall "$PkgFile" "$DstDirPrefix" "$CurFlags" "$Method"
            ;;
        *.zip)
            ZipAndInstall "$PkgFile" "$DstDirPrefix" "$CurFlags" "$Method"
            ;;
    esac;
}

function InstallPkgDir()
{
    PkgDir=$1
    DstDirPrefix=$2
    pushd $PkgDir
        SrcFileList=$(ls)
        for file in $SrcFileList
        do
            Method=$(GetInstallMethod "$file")
            InstallPkgFile "$file" "$DstDirPrefix" "" "$Method"
        done
    popd
}

####################################Copy pc#########################################

function CopyPcFile()
{
    PkgFile=$1
    DstDirPrefix=$2

    DstDir=$(GetInstallDir "$PkgFile")
    PcFileDir="$DstDirPrefix/$DstDir/lib/pkgconfig"
    if [ ! -d $PcFileDir ];then
        mkdir -p $PcFileDir 
        echo -e "\033[31m find $SrcDir -iname \"*.pc\" | xargs -I {} cp {} $PcFileDir/ \033[0m"
        find $SrcDir -iname "*.pc" | xargs -I {} cp {} $PcFileDir/ 
    else
        echo -e "\033[32m ls $PcFileDir/ \033[0m"
        ls $PcFileDir/
    fi
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
