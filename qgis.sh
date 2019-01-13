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

function MysqlStart()
{
    groupadd mysql
    useradd -r -g mysql -s /bin/false -M mysql
    mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql-5_7_19 --datadir=/opt/mysql-5_7_19/data 
    cp /opt/mysql-5_7_19/support-files/mysql.server /etc/init.d/mysqld
    chmod a+x /etc/init.d/mysqld
    chkconfig --add mysqld
    chkconfig mysqld on
    chkconfig --list | grep mysqld
    chown mysql.mysql -R /opt/mysql-5_7_19
}

#GenFileNameVar "$(ls *.tar.* *.zip)"
#GenEnvVar
#cat bashrc >>~/.bashrc
#source ~/.bashrc

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
#X11/extensions/XInput.h: No such file or directory #GenInputHeader  # 增加 -lGL
#TarXFFile "freeglut-3.0.0.tar.gz" ~/opt "  -DOPENGL_gl_LIBRARY=/opt/glu-9_0_0/lib/ -DOPENGL_INCLUDE_DIR=/opt/glu-9_0_0/include "

#TarXFFile "gdal-2.3.0.tar.gz" ~/opt ""
#TarXFFile "proj-4.9.1.tar.gz" ~/opt ""
#TarXFFile "geos-3.5.1.tar.bz2" ~/opt " CFLAGS=-fPIC CXXFLAGS=-fPIC --shared "
#TarXFFile "spatialite-2.2.tar.gz" ~/opt ""
#TarXFFile "freexl-1.0.5.tar.gz" ~/opt ""
#TarXFFile "libspatialite-4.3.0.tar.gz" ~/opt ""
#TarXFFile "readosm-1.1.0.tar.gz" ~/opt ""
#TarXFFile "spatialite-tools-4.2.0.tar.gz" ~/opt "  "
#TarXFFile "fftw-3.3.8.tar.gz" ~/opt ""
# configure
#TarXFFile "freetype-2.9.tar.bz2" ~/opt " CFLAGS=-fPIC CXXFLAGS=-fPIC --shared "
#TarXFFile "libpng-1.6.34.tar.gz" ~/opt ""
#TarXFFile "pixman-0.34.0.tar.gz" ~/opt ""
#TarXFFile "cairo-1.14.12.tar.xz" ~/opt ""
#TarXFFile "fontconfig-2.13.0.tar.bz2" ~/opt ""
#TarXFFile "grass-7.4.1.tar.gz" ~/opt " --with-freetype-includes=/opt/freetype-2_9/include/freetype2 --with-geos=/opt/geos-3_5_1/bin/geos-config  --with-mysql=yes --with-mysql-includes=/opt/mysql-5_7_19/include --with-mysql-libs=/opt/mysql-5_7_19/lib  --with-png-includes=/opt/libpng-1_6_34/include/  --with-png-libs=/opt/libpng-1_6_34/lib --with-png=no --with-cairo=no --with-cairo-includes=/opt/cairo-1_14_12/include/  --with-cairo-libs=/opt/cairo-1_14_12/lib "
#TarXFFile "grass-7.4.1.tar.gz" ~/opt " --with-freetype-includes=/home/du/opt/freetype-2_9/include/freetype2 --with-geos=/opt/geos-3_5_1/bin/geos-config  --with-mysql=yes --with-mysql-includes=/opt/mysql-5_7_19/include --with-mysql-libs=/opt/mysql-5_7_19/lib    --with-readline-includes=/opt/readline-7_0/include --with-readline-libs=/opt/readline-7_0/lib --with-postgres=yes --with-postgres-includes=/opt/postgresql-10_4/include  --with-postgres-lib=/opt/postgresql-10_4/lib --with-odbc=yes --with-odbc-includes=/opt/unixODBC-2_3_6/include  --with-odbc-libs=/opt/unixODBC-2_3_6/lib  --with-bzlib=yes --with-bzlib-libs=/opt/bzip2-1_0_6/lib"
#TarXFFile "sqlite-src-3240000.zip" ~/opt " --with-readline-lib=/home/du/opt/readline-7_0/lib/libreadline.so"
#exit
#TarXFFile "spatialindex-src-1.8.5.tar.bz2" ~/opt ""

#TarXFFile "QScintilla_gpl-2.10.4.tar.gz" ~/opt ""
##TarXFFile "qwt-5.2.3.tar.bz2" ~/opt ""
#TarXFFile "qgis-latest.tar.bz2" ~/opt " -DGDAL_INCLUDE_DIR=/opt/gdal-2_3_0/include -DGDAL_LIBRARY=/opt/gdal-2_3_0/lib/ -DPROJ_INCLUDE_DIR=/opt/proj-4_9_1/include/ -DPROJ_LIBRARY=/opt/proj-4_9_1/lib -DQSCINTILLA_INCLUDE_DIR=/opt/qt-everywhere-opensource-src-5.6.3/qtbase/include -DQSCINTILLA_LIBRARY=/opt/qt-everywhere-opensource-src-5.6.3/qtbase/lib/libqscintilla2_qt5.so   -DGEOS_INCLUDE_DIR=/opt/geos-3_5_1/include     -DGEOS_LIBRARY=/opt/geos-3_5_1/lib/libgeos.so"
TarXFFile "qgis-latest.tar.bz2" ~/opt " -DGDAL_INCLUDE_DIR=/opt/gdal-2_3_0/include -DGDAL_LIBRARY=/home/durongze/opt/gdal-2_3_0/lib/libgdal.so -DPROJ_INCLUDE_DIR=/home/durongze/opt/proj-4_9_1/include/ -DPROJ_LIBRARY=/home/durongze/opt/proj-4_9_1/lib/libproj.so   -DQt5Positioning_DIR=/usr/lib/x86_64-linux-gnu -DQSCINTILLA_VERSION_STR=/usr/lib/python3/dist-packages/PyQt5/Qsci.cpython-36m-x86_64-linux-gnu.so"

#cp zlib.pc
#TarXFFile "zlib-1.2.11.tar.gz" ~/opt " --shared "
#TarXFFile "libffi-3.2.1.tar.gz" ~/opt ""
#sudo make install 
#TarXFFile "util-linux-2.32.tar.xz" ~/opt ""
#mv CMakeList.txt dyz.txt
#TarXFFile "pcre-8.42.tar.gz" ~/opt " --enable-utf8 --enable-unicode-properties "
#TarXFFile "glib-2.57.1.tar.xz" ~/opt ""
#TarXFFile "readline-7.0.tar.gz" ~/opt ""
#TarXFFile "sdcv-0.4.2.tar.bz2" ~/opt ""
#TarXFFile "gperf-3.1.tar.gz" ~/opt ""
#Werror    #-fpermissive 
#TarXFFile "liblzma-4.27.1.tar.gz" ~/opt ""
#sudo make install
#TarXFFile "kmod_25.orig.tar.xz" ~/opt ""
#TarXFFile "Python-2.7.15.tar.xz" ~/opt "  --enable-optimizations --with-zlib=/opt/zlib-1_2_11/lib/libz.so  "
#TarXFFile "gobject-introspection-1.56.1.tar.xz" ~/opt ""
#TarXFFile "udev-181.tar.gz" ~/opt " --disable-keymap "
#TarXFFile "libusb-1.0.22.tar.bz2" ~/opt ""
#TarXFFile "usbutils-007.tar.gz" ~/opt ""
#TarXFFile "graphviz.tar.gz" ~/opt ""
#TarXFFile "doxygen-1.8.14.src.tar.gz" ~/opt ""
#TarXFFile "libpciaccess-0.10.9.tar.bz2" ~/opt ""
#TarXFFile "libdrm-2.4.90.tar.gz" ~/opt " --enable-intel --enable-libkms  "
#TarXFFile "libXext-1.3.3-1-src.tar.xz" ~/opt ""
#TarXFFile "libXfixes-5.0.3-1-src.tar.xz" ~/opt ""
#TarXFFile "damageproto-1.2.1.tar.bz2" ~/opt ""
#TarXFFile "libXdamage-1.1.4-1-src.tar.bz2" ~/opt ""
#TarXFFile "xextproto-7.3.0-1-src.tar.xz" ~/opt ""
#TarXFFile "libxshmfence-1.3.tar.bz2" ~/opt ""
#mv dyzCMakeList.txt
#TarXFFile "expat-2.2.5.tar.bz2" ~/opt ""
#TarXFFile "cmake-3.6.3.tar.gz" ~/opt ""
#TarXFFile "mtdev-1.1.5.tar.bz2" ~/opt ""
#TarXFFile "libjpeg-turbo-1.5.3.tar.gz" ~/opt ""
#TarXFFile "bzip2-1.0.6.tar.gz" ~/opt ""
#TarXFFile "mysql-5.7.19.tar.gz" ~/opt " -DMYSQL_DATADIR=/opt/mysql-5_7_19/data      -DDEFAULT_CHARSET=utf8          -DDEFAULT_COLLATION=utf8_general_ci              -DMYSQL_TCP_PORT=3306          -DMYSQL_USER=mysql               -DWITH_MYISAM_STORAGE_ENGINE=1           -DWITH_INNOBASE_STORAGE_ENGINE=1             -DWITH_ARCHIVE_STORAGE_ENGINE=1    -DWITH_BLACKHOLE_STORAGE_ENGINE=1           -DWITH_MEMORY_STORAGE_ENGINE=1               -DENABLE_DOWNLOADS=1                   -DDOWNLOAD_BOOST=1             -DWITH_BOOST=/home/du/code/boost_1_59_0"
#TarXFFile "llvm-6.0.0.src.tar.xz" ~/opt ""
#TarXFFile "unixODBC-2.3.6.tar.gz" ~/opt ""
#TarXFFile "tslib-1.16.tar.bz2" ~/opt ""
#TarXFFile "libXrender-0.9.10.tar.bz2" ~/opt ""
#TarXFFile "libproxy_0.4.15.orig.tar.gz" ~/opt ""
#TarXFFile "qt-everywhere-src-5.11.1.tar.xz" ~/opt " -confirm-license -opensource -no-opengl -no-opengles3 -nomake examples -no-dbus  "
#-prefix  =
#TarXFFile "qt-everywhere-opensource-src-5.8.0.tar.xz" ~/opt " -confirm-license -opensource -no-opengl -no-opengles3 -nomake examples -no-dbus "
#TarXFFile "qt-everywhere-opensource-src-5.6.3.tar.xz" ~/opt " -confirm-license -opensource -no-opengl -no-opengles3 -nomake examples -no-dbus -qt-xcb"
#TarXFFile "postgresql-10.4.tar.bz2" ~/opt ""
#TarXFFile "libxml2-2.7.8.tar.gz" ~/opt ""
#TarXFFile "liblzma-4.27.1.tar.gz" ~/opt ""
#TarXFFile "kea-1.4.0.tar.gz" ~/opt ""
#TarXFFile "openssl-1.1.0h.tar.gz" ~/opt " "
#TarXFFile "gdal-2.3.0.tar.xz" ~/opt " --with-mysql=/opt/mysql-5_7_19/bin/mysql_config --with-sqlite3=/opt/sqlite-src-3240000  --with-liblzma=yes   --with-expat=/home/du/opt/expat-2_2_5/  --with-cryptopp=/opt/cryptopp700/  --with-spatialite=/opt/libspatialite-4_3_0/  --with-teigha=/usr/local/bin/TeighaFileConverter  --with-teigha-plt=Linux"
#TarXFFile "grass-7.4.1.tar.gz" ~/opt " --with-freetype-includes=${HOME}/opt/freetype-2_9/include/freetype2 "
#TarXFFile "postgis-2.4.4.tar.gz" ~/opt ""
#TarXFFile "libelf-0.8.13.tar.gz" ~/opt ""
#TarXFFile "mesa-18.0.2.tar.gz" ~/opt " --enable-llvm  --with-llvm-prefix=/opt/llvm-6_0_0_src "
#glew-2.1.0.zip
#TarXFFile "MesaGLUT-7.9.2.tar.bz2" ~/opt ""
#TarXFFile "glu-9.0.0.tar.bz2" ~/opt ""
#TarXFFile "freeglut-3.0.0.tar.gz" ~/opt ""
#TarXFFile "proj-4.9.1.tar.gz" ~/opt ""
#TarXFFile "geos-3.5.1.tar.bz2" ~/opt " CFLAGS=-fPIC CXXFLAGS=-fPIC "
###TarXFFile "spatialite-2.2.tar.gz" ~/opt ""
#TarXFFile "freexl-1.0.5.tar.gz" ~/opt ""
#TarXFFile "libxml2-2.7.8.tar.gz" ~/opt ""
#TarXFFile "libspatialite-4.3.0.tar.gz" ~/opt " --with-geosconfig=${HOME}/opt/geos-3_5_1/bin/geos-config "
#TarXFFile "readosm-1.1.0.tar.gz" ~/opt ""
#TarXFFile "spatialite-tools-4.2.0.tar.gz" ~/opt ""
#TarXFFile "fftw-3.3.8.tar.gz" ~/opt ""
#TarXFFile "freetype-2.9.tar.bz2" ~/opt " CFLAGS=-fPIC CXXFLAGS=-fPIC "
#TarXFFile "cairo-1.14.12.tar.xz" ~/opt ""
#TarXFFile "tiff-4.0.9.tar.gz" ~/opt ""
#TarXFFile "spatialindex-src-1.8.5.tar.bz2" ~/opt ""
#TarXFFile "QScintilla_gpl-2.10.4.tar.gz" ~/opt ""
#TarXFFile "qwt-5.2.3.tar.bz2" ~/opt ""
#TarXFFile "qgis-latest.tar.bz2" ~/opt ""

