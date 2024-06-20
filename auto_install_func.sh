#!/bin/bash

declare -A sermap=(["leptonica-1.82.0.tar.gz"]="AutoGenInstall"
                   ["icu-release-70-1.tar.gz"]="CfgInstall"
                   ["libxml2-2.9.14.tar.xz"]="CfgInstall"
                   ["apr-1.7.0.tar.gz"]="CfgInstall"
                   ["httpd-2.4.54.tar.gz"]="AutoGenInstall"
                   ["apr-util-1.6.1.tar.gz"]="AutoGenInstall"
                  )

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

function GetInstallMethod()
{
    PkgFile=$1
    Method=""
    for k in ${!sermap[@]}
    do
        if [[ "$k" == "$PkgFile" ]];then
            v=${sermap[$k]}
            Method="$v"
            break
        fi
    done
    echo $Method
}

function FixPkgCtx()
{
    SrcDir="$1"
    case $SrcDir in
        *[Ll]ua*)
            FixLuaPkg
            ;;
        *[Aa]pache*)
            FixApachePkg
            ;;
    esac;
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
    pushd dyzbuild
        dos2unix ../configure && export CXXFLAGS="-fPIC"
        CmdStr="../configure --prefix=$DstDir/$InstallDir $CurFlags" 
        EchoInfo "$CmdStr"
        eval $CmdStr  || { EchoError "$CmdStr"; exit 1; }
        make   || { EchoError "$CmdStr"; exit 2; }
        make install   || { EchoError "$CmdStr"; exit 3; }
    popd

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
            EchoError "Install $SrcDir failed, cfg file not exist !!!"
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
                EchoError "Install $SrcDir failed, Method:$Method"
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

####################################环境变量配置#####################################

function GenFileNameVar()
{
    ENV_TXT="env.txt"
    echo "" >${ENV_TXT}

    SrcFileList=$(ls)
    for file in $SrcFileList
    do
        echo -e "\033[32m $file <-> $FileDir . \033[0m"
        FileDir=$(GetInstallDir $file)
        if [ "$FileDir" == "" ];then
            echo -e "\033[31m $file <-> $FileDir . \033[0m"
        else
            echo $FileDir >>${ENV_TXT}
        fi
    done
}

function GenEnvVar()
{
    MY_BASHRC="$1"
    ENV_TXT="env.txt"
    if [ "$MY_BASHRC" == *.bashrc ] || [ "$MY_BASHRC" == "" ] ;then
        MY_BASHRC="mybashrc"
        echo "MY_BASHRC:$MY_BASHRC ."
    fi
    echo "fileList=\"$(cat ${ENV_TXT})\""  >${MY_BASHRC}
    echo "for tmpFile in \${fileList}" >>${MY_BASHRC}
    echo "do" >>${MY_BASHRC}
    echo "    TMP_FILE_HOME=\${HOME}/opt/\${tmpFile}" >>${MY_BASHRC}
    echo "    export C_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${C_INCLUDE_PATH}" >>${MY_BASHRC}
    echo "    export CPLUS_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${CPLUS_INCLUDE_PATH}" >>${MY_BASHRC}
    echo "    export CMAKE_INCLUDE_PATH=\${TMP_FILE_HOME}/include:\${CMAKE_INCLUDE_PATH}" >>${MY_BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LIBRARY_PATH}" >>${MY_BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LIBRARY_PATH}" >>${MY_BASHRC}
    echo "    export LD_RUN_PATH=\${TMP_FILE_HOME}/lib:\${LD_RUN_PATH}" >>${MY_BASHRC}
    echo "    export LD_RUN_PATH=\${TMP_FILE_HOME}/lib64:\${LD_RUN_PATH}" >>${MY_BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LD_LIBRARY_PATH}" >>${MY_BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LD_LIBRARY_PATH}" >>${MY_BASHRC}
    echo "    export CMAKE_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${CMAKE_LIBRARY_PATH}" >>${MY_BASHRC}
    echo "    export CMAKE_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${CMAKE_LIBRARY_PATH}" >>${MY_BASHRC}
    echo "    export PKG_CONFIG=\${TMP_FILE_HOME}/lib/pkgconfig/:\${PKG_CONFIG}" >>${MY_BASHRC}
    echo "    export PKG_CONFIG=\${TMP_FILE_HOME}/lib64/pkgconfig/:\${PKG_CONFIG}" >>${MY_BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib/pkgconfig/:\${PKG_CONFIG_PATH}" >>${MY_BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib64/pkgconfig/:\${PKG_CONFIG_PATH}" >>${MY_BASHRC}
    echo "    export CMAKE_MODULE_PATH=\${TMP_FILE_HOME}/lib/cmake/:\${CMAKE_MODULE_PATH}" >>${MY_BASHRC}
    echo "    export PATH=\${TMP_FILE_HOME}/bin:\${TMP_FILE_HOME}/sbin:\$PATH" >>${MY_BASHRC}
    echo "done" >>${MY_BASHRC}
}

function AddEnvVarToBashrc()
{
    MY_BASHRC=$1
    mv $MY_BASHRC ${HOME}/
    IsExist=$(grep "$MY_BASHRC" ${HOME}/.bashrc)
    if [ "$IsExist" == "" ];then
        echo "source \${HOME}/$MY_BASHRC" >> ${HOME}/.bashrc
    else
        echo -e "\033[32m $MY_BASHRC in ${HOME}/.bashrc \033[0m"
    fi
    source ${HOME}/$MY_BASHRC
    #source ${HOME}/.bashrc
}

function GenEnvVarByPkgDir()
{
    PkgDir=$1
    MY_BASHRC="mybashrc"
    pushd $PkgDir
        GenFileNameVar 
        GenEnvVar "$MY_BASHRC"
        AddEnvVarToBashrc "$MY_BASHRC"
        echo "PATH:$PATH"
    popd
}

