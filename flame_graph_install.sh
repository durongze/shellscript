#!/bin/bash
set -x

echo "set CXX_FLAGS=-g"

#https://www.modb.pro/db/129464
#https://blog.csdn.net/m0_47696151/article/details/121641019
#https://zhuanlan.zhihu.com/p/471379451
#https://www.freesion.com/article/6047243455/
#https://www.spinics.net/lists//linux-perf-users/msg04247.html
#https://www.php.cn/manual/view/35171.html
#https://blog.csdn.net/wonderdaydream/article/details/120998132
#https://blog.csdn.net/lihui49/article/details/124998574

function FlameGraphInstall()
{
    # wget https://codeload.github.com/brendangregg/FlameGraph/zip/refs/heads/master -O FlameGraph-master.zip
    unzip FlameGraph-master.zip
}

function GetBuildIdDir()
{
    ProcName=$1
    BuildIdDirPrefix="/usr/lib/debug/.build-id"
    BuildIdDirPrefix="/home/${CUR_USER_NAME}/.debug/.build-id"
    BuildId=$(readelf -n ${ProcName} | grep "Build ID" | cut -d':' -f2)
    echo "$BuildIdDirPrefix/${BuildId}"
}

function FlameGraphTest()
{
    FlameGraphHome=$1
    ExecPath=$2
    CaseName=$3
    sudo ${PERF_HOME}/perf test
    sudo ${PERF_HOME}/perf record -g -a -F 99 -o ${CaseName}.data ${ExecPath} "x" *
    sudo chown ${CUR_USER_NAME}:${CUR_USER_NAME} ${CaseName}.data
    ${PERF_HOME}/perf buildid-list -i ${CaseName}.data
    ${PERF_HOME}/perf report -i ${CaseName}.data
}

function FlameGraphExec()
{
    FlameGraphHome=$1
    ExecPath=$2
    CaseName=$3
    echo -e "\033[32m ${PERF_HOME}/perf buildid-cache -a $(GetBuildIdDir ${ExecPath}) \033[0m"
    #perf record -F 99 -g --call-graph dwarf ${ExecPath}
    ${PERF_HOME}/perf record -g -a -F 99 -o ${CaseName}.data ${ExecPath} "x" *
    #sudo chown ${CUR_USER_NAME}:${CUR_USER_NAME} ${CaseName}.data
    ${PERF_HOME}/perf buildid-list -i ${CaseName}.data
    #${PERF_HOME}/perf report -i ${CaseName}.data
    ${PERF_HOME}/perf script -i ${CaseName}.data > ${CaseName}.perf
    #sudo chown ${CUR_USER_NAME}:${CUR_USER_NAME} ${CaseName}.perf

    ${FlameGraphHome}/stackcollapse-perf.pl ${CaseName}.perf > ${CaseName}.folded
    ${FlameGraphHome}/flamegraph.pl ${CaseName}.folded > ${CaseName}.svg
}

function FlameGraphCfgShow()
{
    echo -e "\033[32m =================================== \033[0m"
    sudo cat /proc/sys/kernel/perf_event_paranoid
    sudo cat /proc/sys/kernel/kptr_restrict
    sudo cat /proc/kallsyms | head -10
    cat /proc/modules | head -5

    #sudo ls  /sys/kernel/debug/tracing/events
    #${PERF_HOME}/perf report --stdio
    ${PERF_HOME}/perf buildid-cache -l
}

function FlameGraphCfg()
{
    # /etc/sysctl.conf # kernel.kptr_restrict=0         # sysctl -p /etc/sysctl.conf
    # /etc/sysctl.conf # kernel.perf_event_paranoid=-1  # sysctl -p /etc/sysctl.conf

    #sudo echo 0 > /proc/sys/kernel/kptr_restrict
    #sudo sh -c "echo -1 > /proc/sys/kernel/perf_event_paranoid"

    FlameGraphCfgShow
    sudo sysctl -w kernel.kptr_restrict=0  
    sudo sysctl -w kernel.perf_event_paranoid=-1
    FlameGraphCfgShow
}

function LibDwarfInstall()
{
        #wget https://github.com/davea42/libdwarf-code/archive/refs/tags/libdwarf-0.4.1.tar.gz -O libdwarf-code-libdwarf-0.4.1.tar.gz
        tar xf libdwarf-code-libdwarf-0.4.1.tar.gz
        pushd libdwarf-code-libdwarf-0.4.1
        sed -e 's/.so and use it" FALSE/.so and use it" TRUE/' -i CMakeLists.txt
        if [ -d dyz ];then
            rm dyz -rf
        fi
        mkdir dyz
        pushd dyz/
        cmake -DCMAKE_INSTALL_PREFIX=${CUR_USER_HOME_DIR}/opt/libdwarf ../
        make
        make  install
        popd
        popd
}

function DwarfInstall()
{
        #wget https://github.com/Distrotech/libdwarf/archive/refs/tags/20150507.tar.gz -O libdwarf-20150507.tar.gz
        tar  xf libdwarf-20150507.tar.gz
        pushd libdwarf-20150507
        sed -e 's/.so and use it" FALSE/.so and use it" TRUE/' -i CMakeLists.txt
        if [ -d dyz ];then
            rm dyz -rf
        fi
        mkdir dyz
        pushd dyz/
        cmake -DCMAKE_INSTALL_PREFIX=${CUR_USER_HOME_DIR}/opt/dwarf ../
        make
        make  install
        popd
        popd
}

function ElfUtilsInstall()
{
        #wget ftp://sourceware.org/pub/elfutils/elfutils-latest.tar.bz2
        tar xf elfutils-latest.tar.bz2
        pushd elfutils-0.187/
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/elfutils  --disable-debuginfod  --enable-libdebuginfod=dummy
        #./configure --prefix=${CUR_USER_HOME_DIR}/opt/elfutils   --enable-libdebuginfod=dummy
        make && make install
        popd
}

function PerfInstall()
{
        #wget https://mirror.bjtu.edu.cn/kernel/linux/kernel/tools/perf/v5.15.0/perf-5.15.0.tar.gz
        tar xf perf-5.15.0.tar.gz
        pushd perf-5.15.0/tools/perf
        export DESTDIR=${CUR_USER_HOME_DIR}/opt/perf  && make && make install
        popd
}

function LibelfInstall()
{
        #wget http://www.mr511.de/software/libelf-0.8.13.tar.gz
        #wget http://mirror2.openwrt.org/sources/libelf-0.8.13.tar.gz
        tar xf libelf-0.8.13.tar.gz
        pushd libelf-0.8.13
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/libelf
        make && make install
        popd
}

function NumaInstall()
{
        #https://codeload.github.com/numactl/numactl/tar.gz/refs/tags/v2.0.15
        #wget ftp://ftp.suse.com/pub/people/ak/numa/numa-2.6.1-4.gz
        #wget ftp://ftp.suse.com/pub/people/ak/numa/numactl-0.5.tar.gz
        tar xf numactl-2.0.15.tar.gz
        pushd numactl-2.0.15
        ./autogen.sh
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/numactl 
        make && make install
        popd
}

function LibbfdInstall()
{
        #sudo apt install texinfo
        #wget https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz
        tar xf binutils-2.38.tar.xz
        pushd binutils-2.38
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/binutils --enable-host-shared --enable-shared
        make && make install
        popd
}

function SystemTabInstall()
{
        #wget https://sourceware.org/systemtap/ftp/releases/systemtap-4.7.tar.gz
        tar xf systemtap-4.7.tar.gz
        pushd systemtap-4.7
        ./configure  --with-elfutils=${CUR_USER_HOME_DIR}/opt/elfutils --prefix=${CUR_USER_HOME_DIR}/opt/systemtap
        make && make install
        popd
}

function ZstdInstall()
{
        #wget https://github.com/facebook/zstd/archive/refs/tags/v1.5.1.tar.gz -O zstd-1.5.1.tar.gz
        tar xf zstd-1.5.1.tar.gz
        mkdir zstd-1.5.1/build/cmake/dyz
        pushd zstd-1.5.1/build/cmake/dyz
        cmake .. -DCMAKE_INSTALL_PREFIX=${CUR_USER_HOME_DIR}/opt/zstd
        make && make install
        popd
}

function LibcapInstall()
{
    #wget https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.63.tar.gz
    tar xf libcap-2.63.tar.gz
    pushd libcap-2.63
    export DESTDIR=${CUR_USER_HOME_DIR}/opt/libcap  && make && make install
    popd
}

function LibunwindInstall ()
{
        # wget http://mirror.ossplanet.net/nongnu/libunwind/libunwind-1.6.2.tar.gz
        tar xf libunwind-1.6.2.tar.gz
        pushd libunwind-1.6.2
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/libunwind  --enable-shared
        make && make install
        popd
}

function LibarchiveInstall()
{
        tar xf libarchive-3.6.1.tar.gz
        pushd libarchive-3.6.1
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/libarchive  --enable-shared
        make && make install
        pushd
}

function XzLzmaInstall()
{
        wget https://udomain.dl.sourceforge.net/project/lzmautils/xz-5.2.6.tar.gz
        tar xf xz-5.2.5.tar.gz
        pushd xz-5.2.5
        ./configure --prefix=${CUR_USER_HOME_DIR}/opt/xz  --enable-shared
        make && make install
        popd
}

function PreCfgEnv()
{
    mkdir ${CUR_USER_HOME_DIR}/opt/{libelf,libcap,zstd,elfutils,binutils,numactl,elfutils,libdwarf,dwarf,libunwind,libarchive,xz}
}

export LIBDW_DIR=${CUR_USER_HOME_DIR}/opt/elfutils

fileList="bin binutils boost_1_72_0 dwarf elfutils flame_graph libbfd libcap libelf libtool libunwind numactl openssl_1_0_0s"
fileList="" # ${fileList} openssl_1_1_1p_bak p7zip perf python_2_7_18 python_2_7_18_a qt_5_15_5 ruby ruby_1_8_7 xz zstd"
for tmpFile in ${fileList}
do
    TMP_FILE_HOME=${CUR_USER_HOME_DIR}/opt/${tmpFile}
    export C_INCLUDE_PATH=${TMP_FILE_HOME}/include:${C_INCLUDE_PATH}
    export CPLUS_INCLUDE_PATH=${TMP_FILE_HOME}/include:${CPLUS_INCLUDE_PATH}
    export CMAKE_INCLUDE_PATH=${TMP_FILE_HOME}/include:${CPLUS_INCLUDE_PATH}
    export LIBRARY_PATH=${TMP_FILE_HOME}/lib:${LIBRARY_PATH}
    export LIBRARY_PATH=${TMP_FILE_HOME}/lib64:${LIBRARY_PATH}
    export CMAKE_LIBRARY_PATH=${TMP_FILE_HOME}/lib:${LIBRARY_PATH}
    export CMAKE_LIBRARY_PATH=${TMP_FILE_HOME}/lib64:${LIBRARY_PATH}
    export LD_LIBRARY_PATH=${TMP_FILE_HOME}/lib:${LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH=${TMP_FILE_HOME}/lib64:${LD_LIBRARY_PATH}
    export PKG_CONFIG_PATH=${TMP_FILE_HOME}/lib/pkgconfig/:${PKG_CONFIG_PATH}
    export PKG_CONFIG_PATH=${TMP_FILE_HOME}/lib64/pkgconfig/:${PKG_CONFIG_PATH}
    export CMAKE_MODULE_PATH=${TMP_FILE_HOME}/lib/cmake/:${CMAKE_MODULE_PATH}
    export PATH=${TMP_FILE_HOME}/bin:${TMP_FILE_HOME}/sbin:$PATH
done



#PreCfgEnv
#exit 

#XzLzmaInstall
#ZstdInstall
#LibunwindInstall
#LibelfInstall
#ElfUtilsInstall
#NumaInstall
#LibbfdInstall
#LibDwarfInstall
#DwarfInstall
#LibcapInstall
#LibarchiveInstall
#SystemTabInstall
#FlameGraphInstall
#PerfInstall
#FlameGraphCfg

CUR_USER_NAME="duyongze" #${HOME}
CUR_USER_HOME_DIR="/home/${CUR_USER_NAME}" #${HOME}

PERF_HOME="${CUR_USER_HOME_DIR}/flame/perf-5.15.0/tools/perf"
#PERF_HOME="/usr/bin"
#PERF_HOME="/usr/src/linux-source-5.4.0/linux-source-5.4.0/tools/perf"
FLAME_GRAPH_HOME="${CUR_USER_HOME_DIR}/flame/FlameGraph-master"

EXEC_PATH="$(pwd)/enum_test" # 长时间运行

g++ -g $(pwd)/enum.cc -ggdb -Wl,--build-id -o enum_test

#cat /proc/version_signature
# sudo apt-get install linux-image-$(uname -r)-dbgsym
# ls "/usr/lib/debug/boot/vmlinux-$(uname -r)"

WorkDir=(pwd)
WorkDir=${CUR_USER_HOME_DIR}/code/
pushd ${WorkDir}
    make
    EXEC_PATH=main_test
    FlameGraphExec "$FLAME_GRAPH_HOME" "$EXEC_PATH"  "10"
    #FlameGraphTest "$FLAME_GRAPH_HOME" "$EXEC_PATH" "10"
popd
