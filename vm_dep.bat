@echo off
set cur_dir=%cd%
dir
pause
set tools_addr=https://eternallybored.org/misc/wget/releases/wget-1.21.2-win64.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-dep.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/tar/1.13-1/tar-1.13-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/unrar/3.4.3/unrar-3.4.3-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/unzip/5.51-1/unzip-5.51-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/gawk/3.1.6-1/gawk-3.1.6-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-dep.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/grep/2.5.4/grep-2.5.4-bin.zip
@rem set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-bin.zip
@rem set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-lib.zip
@rem set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-dep.zip
set tools_addr=%tools_addr%;https://www.7-zip.org/a/lzma2201.7z
set tools_dir=%cd%\tools_dir

set software_urls=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
set software_dir=%cd%\

set home_dir=%cd%\..\out\windows
set build_type=Release
set auto_install_func=%cd%\auto_func.bat
call %auto_install_func% gen_all_env %software_dir% %home_dir% all_inc all_lib all_bin
echo all_inc:%all_inc%
echo all_lib:%all_lib%
echo all_bin:%all_bin%
set include=%all_inc%;%include%;%tools_dir%\include;
set lib=%all_lib%;%lib%;%tools_dir%\lib;%tools_dir%\bin;
set path=%all_bin%;%path%;%tools_dir%\bin;

@rem set Iconv_LIBRARY=%tools_dir%\bin\libiconv.lib

set CMAKE_INCLUDE_PATH=%include%;
set CMAKE_LIBRARY_PATH=%lib%;
@rem set CMAKE_MODULE_PATH=

@rem call %auto_install_func% install_all_package "%tools_addr%" "%tools_dir%"
@rem call %auto_install_func% install_all_package "%software_urls%" "%software_dir%"
call :thirdparty_lib_install "%software_dir%" %home_dir%
goto :eof

@rem objdump -S E:\program\xz-5.2.6\lib\liblzma.lib | grep -C 5 "lzma_auto_decoder"

:thirdparty_lib_install
    set lib_dir=%software_dir%
    set home_dir=%2
    pushd %lib_dir%
        @rem call %auto_install_func% install_package zlib-1.2.12.tar.gz "%home_dir%"
        @rem call %auto_install_func% install_package capstone-master.zip "%home_dir%"
        @rem call %auto_install_func% install_package SDL-release-2.24.0.zip "%home_dir%"
        call %auto_install_func% install_package unicorn-master.zip "%home_dir%"
    popd
goto :eof



