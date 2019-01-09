#!/bin/bash

. auto_install_func.sh

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

function ImagingModify()
{
    JPEG_ROOT = libinclude("/home/duyongze/opt/jpeg-9c")
    ZLIB_ROOT = libinclude("/home/duyongze/opt/zlib-1_2_11")
    TIFF_ROOT = libinclude("/home/duyongze/opt/libffi-3_2_1")
    FREETYPE_ROOT = libinclude("/home/duyongze/opt/freetype-2_9")
    LCMS_ROOT = libinclude("/home/duyongze/opt/lcms2-2_9")
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
#########TarXFFile "tensorboard-1.12.0.zip" "" ""
#TarXFFile "pbr-5.1.1.tar.gz" "" ""
#TarXFFile "mock-2.0.0.tar.gz" "" ""
#TarXFFile "pycparser-2.19.tar.gz" "" ""
#TarXFFile "libffi-3.2.1.tar.gz" "${HOME}/opt" ""
#TarXFFile "cffi-1.11.5.tar.gz" "" "" 
#sudo apt-get install  libssl-dev
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
#TarXFFile "subprocess32-3.5.3.tar.gz" "" ""
#TarXFFile "backports.functools_lru_cache-1.5.tar.gz" "" ""
#TarXFFile "kiwisolver-1.0.1.tar.gz" "" "" 
#TarXFFile "pytz-2018.7.tar.gz" "" ""
#TarXFFile "python-dateutil-2.7.5.tar.gz" "" ""
#TarXFFile "pyparsing-2.3.0.tar.gz" "" ""
#TarXFFile "cycler-0.10.0.tar.gz" "" ""
#TarXFFile "matplotlib-2.2.3.tar.gz" "" "" #sudo apt-get install libfreetype6-dev
#TarXFFile "cairocffi-0.9.0.tar.gz" "" ""
#TarXFFile "packaging-18.0.tar.gz" "" "" 
#TarXFFile "scikit-build-0.8.1.tar.gz" "" ""
#TarXFFile "opencv-python-19.tar.gz" "" ""  ####pip install opencv-python
#TarXFFile "zlib-1.2.11.tar.gz" "${HOME}/opt" "--shared" 
#TarXFFile "freetype-2.9.tar.bz2" "${HOME}/opt" " CFLAGS=-fPIC CXXFLAGS=-fPIC --enable-shared "
#TarXFFile "jpegsrc.v9c.tar.gz" "${HOME}/opt" ""
#TarXFFile "libpng-1.6.34.tar.gz" "${HOME}/opt" "" # move CMakeList.txt dyz.txt
#TarXFFile "tiff-4.0.9.tar.gz" "${HOME}/opt" ""
TarXFFile "Imaging-1.1.7.tar.gz" "" ""  #sudo pip install Pillow-PIL
#TarXFFile "lcms2-2.9.zip" "${HOME}/opt" ""
