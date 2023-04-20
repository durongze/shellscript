#!/bin/bash

declare -A sermap=(["leptonica-1.82.0.tar.gz"]="AutoGenInstall"
                   ["icu-release-70-1.tar.gz"]="CfgInstall"
                   ["libxml2-2.9.14.tar.xz"]="CfgInstall"
                   ["apr-1.7.0.tar.gz"]="CfgInstall"
                   ["httpd-2.4.54.tar.gz"]="AutoGenInstall"
                   ["apr-util-1.6.1.tar.gz"]="AutoGenInstall"
                  )

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
    if [ ! -d "$DownloadDir" ];then
        mkdir $DownloadDir
    fi
    pushd $DownloadDir
        for url in $SoftwareUrls
        do
            file=${url##*/}
            if [ -f $file ];then
                echo -e "\033[32m file : $file exist. \033[0m"
                continue
            fi
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
        CmdStr="\033[32m export CXXFLAGS=\"-fPIC\" && cmake .. -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir $CurFlags \033[0m"
        #CmdStr="export CXXFLAGS=\"-fPIC\" && cmake .. -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir $CurFlags"
        export CXXFLAGS="-fPIC" && cmake .. -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir $CurFlags 
        make  || { echo -e "$CmdStr"; exit 1; }
        make install  || { echo -e "$CmdStr"; exit 1; }
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
    if [[ $? -ne 0 ]];then
        echo -e "\033[31m Install $SrcDir failed, gen cfg error !!! \033[0m"
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
        CmdStr="\033[32m ../configure --prefix=$DstDir/$InstallDir $CurFlags \033[0m" 
        #CmdStr="../configure --prefix=$DstDir/$InstallDir $CurFlags"
        ../configure --prefix=$DstDir/$InstallDir $CurFlags  || { echo -e "$CmdStr"; exit 1; }
        make   || { echo -e "$CmdStr"; exit 1; }
        make install   || { echo -e "$CmdStr"; exit 1; }
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

function AutoInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"

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
            MakeInstall "$SrcDir" "$DstDir" "$CurFlags"
        elif [ -f setup.py ];then
            sudo python setup.py install
        else
            echo -e "\033[31m Install $SrcDir failed, cfg file not exist !!! \033[0m"
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

    if [[ $# -eq 4 ]];then
        echo -e "\033[31m $FUNCNAME $LINENO ARGS:$* \033[0m"
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
                sudo python setup.py install 
                ;;
            *)
                echo -e "\033[31m Install $SrcDir failed, Method:$Method \033[0m"
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
    echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir  \033[32mMethod:\033[0m$Method"
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
    echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
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

