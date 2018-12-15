#!/bin/bash

function AutoInstall()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    InstallDir=$(echo $SrcDir | tr -s "." "_")
    echo "DstDir:$DstDir InstallDir:$InstallDir CurFlags:$CurFlags"
    pushd $SrcDir
    if [ -f CMakeLists.txt ];then
        mkdir dyzbuild  
        pushd dyzbuild
        export CXXFLAGS="-fPIC" && cmake  -DCMAKE_INSTALL_PREFIX=$DstDir/$InstallDir ..
        make  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        make install  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        popd
    elif [ -f setup.py ];then
        sudo python setup.py install 
    elif [ -f configure ];then
        mkdir dyzbuild
        pushd dyzbuild
        dos2unix ../configure
        ../configure --prefix=$DstDir/$InstallDir $CurFlags  || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        make   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        make install   || { echo "$FUNCNAME $LINENO failed,${FUNCNAME[1]} ${BASH_LINENO[1]} "; exit 1; }
        popd
    else
        echo -e "\033[31m Install $InstallDir Fail，cfg file not exist !!! \033[0m"
        exit 1
    fi
    popd
}

function TarXFFile()
{
    SrcDir=$1
    DstDir=$2
    CurFlags="$3"
    pushd ./
    SrcFileList=$SrcDir
    for file in $SrcFileList
    do
        case $file in
            *.tar.*)
                FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
                echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
                tar xf $file
                AutoInstall "$FileDir" "$DstDir" "$CurFlags"
                ;;
            *.zip)
                FileDir=$(unzip -v $file |awk '{print $8}' | grep "/$" | uniq | sed -n '1p')
                FileDir=$(unzip -v $file |awk '{print $8}' | grep "/" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
                FileName=${file%.*}
                echo -e "\033[32mFile:$file Dir:$FileDir FileName:$FileName\033[0m"
                if [ "$FileDir" = "$FileName" ];then
                    unzip -q $file 
                else
                    mkdir $FileName
                    unzip -q $file -d $FileName
                    DstDir=$FileName
                fi
                AutoInstall "$FileDir" "$DstDir" "$CurFlags"
                ;;
        esac;
    done
    popd
}

function GenFileNameVar()
{
    FileList="$1"
    FileDir=""

    echo "" >env.txt
    for file in $FileList
    do
        case $file in
            *.tar.*)
                FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
                ;;
            *.zip)
                FileDir=$(unzip -v $file |awk '{print $8}' | grep "/$" | uniq | sed -n '1p')
                FileDir=$(unzip -v $file |awk '{print $8}' | grep "/" | uniq | sed -n '1p' | awk -F'/' '{print $1}')
                echo -e "\033[32mFile:\033[0m$file \033[32mDir:\033[0m$FileDir"
                ;;
        esac;
        FileDir=$(echo $FileDir | tr -s "." "_")
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
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LIBRARY_PATH}" >>${BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib:\${LD_LIBRARY_PATH}" >>${BASHRC}
    echo "    export LD_LIBRARY_PATH=\${TMP_FILE_HOME}/lib64:\${LD_LIBRARY_PATH}" >>${BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib/pkgconfig/:\${PKG_CONFIG_PATH}" >>${BASHRC}
    echo "    export PKG_CONFIG_PATH=\${TMP_FILE_HOME}/lib64/pkgconfig/:\${PKG_CONFIG_PATH}" >>${BASHRC}
    echo "    export PATH=\${TMP_FILE_HOME}/bin:\${TMP_FILE_HOME}/sbin:\$PATH" >>${BASHRC}
    echo "done" >>${BASHRC}
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

function InstallQGisDep()
{
    sudo pip install SIP 
    sudo pip3 install sip 
    sudo apt install python3-pip
    sudo apt-get install libsip-api-java 
    sudo apt-get install libsipwitch-dev 
    sudo apt-get install libsipxtapi-dev 
    sudo pip3 install PyQt
    sudo pip install pyqtconfig
    sudo pip install sipconfig
    sudo apt install  pyqt5.qsci-dev 
    sudo apt install  pyqt5-dev
    sudo apt install  pyqt5-dev-tools 
    sudo apt-get install QScintilla
    sudo apt-get install libqscintilla2-qt5-dev 
    sudo apt-get install libqtkeychain1 
    sudo apt-get install qtkeychain-dev 
    sudo apt-get install libqwt-dev 
    sudo apt-get install libspatialite-dev 
    sudo apt-get install libqt5xmlpatterns5-dev 
    sudo apt-get install pyqt5-dev-tools 
    sudo apt-get install pyqt5-dev
    sudo apt-get install libgsl-dev 
    sudo apt-get install libspatialindex-dev 
    sudo apt-get install python3-pyqt5.qsci
    sudo apt-get install python3-pyqt5.qsci-dbg 
    sudo apt install  pyqt5-dev-tools
    sudo apt install  pyqt5-dev
    sudo apt install  pyqt5.qsci-dev 
    sudo apt-get install python3-pyqt5.qtsql
    sudo apt-get install libpq-dev 
    sudo apt-get install libpqxx-dev 
    sudo apt-get install libpqxx-doc 
}

#GenFileNameVar "$(ls *.tar.* *.zip)"
#GenEnvVar
#TarXFFile "setuptools-40.6.2.zip" "" ""
#TarXFFile "pip-18.1.tar.gz" "" ""
#TarXFFile "astor-0.7.1.tar.gz" "" ""
#TarXFFile "six-1.11.0.tar.gz" "" ""
#TarXFFile "Keras_Preprocessing-1.0.5.tar.gz" "" ""
#TarXFFile "gast-0.2.0.tar.gz" "" "" 
#TarXFFile "enum34-1.1.6.tar.gz" "" ""
#TarXFFile "protobuf-3.6.1.tar.gz" "/opt" ""
#TarXFFile "absl-py-0.6.1.tar.gz" "" "" 
#TarXFFile "setuptools_scm-3.1.0.tar.gz" "" ""
#TarXFFile "backports.weakref-1.0.post1.tar.gz" "" ""
#TarXFFile "wheel-0.32.3.tar.gz" "" "" 
#TarXFFile "termcolor-1.1.0.tar.gz" "" ""
#TarXFFile "bazel-0.19.1-dist.zip" "" "" # install jdk8
#TarXFFile "Markdown-3.0.1.tar.gz" "" ""
#TarXFFile "futures-3.2.0.tar.gz" "" ""
#TarXFFile "Werkzeug-0.14.1.tar.gz" "" ""
#sudo apt-get install python-dev
#TarXFFile "grpcio-1.17.1.tar.gz" "" ""
########TarXFFile "tensorboard-1.12.0.zip" "" ""
#TarXFFile "pbr-5.1.1.tar.gz" "" ""
#TarXFFile "mock-2.0.0.tar.gz" "" ""
#TarXFFile "pycparser-2.19.tar.gz" "" ""
#TarXFFile "libffi-3.2.1.tar.gz" "${HOME}/opt" ""
#TarXFFile "cffi-1.11.5.tar.gz" "" "" 
## sudo apt-get install  libssl-dev
#TarXFFile "ipaddress-1.0.22.tar.gz" "" "" 
#TarXFFile "asn1crypto-0.24.0.tar.gz" "" ""
#TarXFFile "idna-2.8.tar.gz" "" ""
#TarXFFile "cryptography-2.4.2.tar.gz" "" ""
#TarXFFile "pyasn1-0.4.4.tar.gz" "" ""
#TarXFFile "PyNaCl-1.3.0.tar.gz" "" ""
#TarXFFile "bcrypt-3.1.5.tar.gz" "" ""
#TarXFFile "paramiko-2.4.2.tar.gz" "" ""
#TarXFFile "PyYAML-3.13.tar.gz" "" ""
#TarXFFile "MarkupSafe-1.1.0.tar.gz" "" ""
#TarXFFile "Jinja2-2.10.tar.gz" "" ""
#TarXFFile "ansible-2.7.5.tar.gz" "" ""
#TarXFFile "suitable-0.14.0.tar.gz" "" ""
#TarXFFile "pkgconfig-1.4.0.tar.gz" "" ""
#TarXFFile " Cython-0.29.2.tar.gz" "" "" 
#TarXFFile "hdf5-1.8.4.tar.bz2" "${HOME}/opt" "" 
#TarXFFile "h5py-2.8.0.tar.gz" "" "" ####pkg-config
#TarXFFile "funcsigs-1.0.2.tar.gz" "" ""
#TarXFFile "Keras_Applications-1.0.6.tar.gz" "" ""
