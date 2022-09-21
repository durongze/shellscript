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

function FlameGraphInstall()
{
    # wget https://codeload.github.com/brendangregg/FlameGraph/zip/refs/heads/master -O FlameGraph-master.zip
    unzip FlameGraph-master.zip
}
CUR_USER_HOME_DIR=${HOME}
PERF_HOME="${CUR_USER_HOME_DIR}/flame/perf-5.15.0/tools/perf"
FLAME_GRAPH_HOME="${CUR_USER_HOME_DIR}/flame/FlameGraph-master"
EXEC_PATH="$(pwd)/enum_test" # 长时间运行

g++ $(pwd)/enum.cc -ggdb -Wl,--build-id -o ${EXEC_PATH}

#cat /proc/version_signature
# sudo apt-get install linux-image-$(uname -r)-dbgsym
# ls "/usr/lib/debug/boot/vmlinux-$(uname -r)"

function GetBuildIdDir()
{
    ProcName=$1
    BuildIdDirPrefix="/usr/lib/debug/.build-id"
    BuildId=$(readelf -n ${ProcName} | grep "Build ID" | cut -d':' -f2)
    echo "$BuildIdDirPrefix/$BuildId"
}

function FlameGraphExec()
{
    FlameGraphHome=$1
    ExecPath=$2
    echo -e "\033[32m ${PERF_HOME}/perf buildid-cache -a $(GetBuildIdDir ${ExecPath}) \033[0m"
    #perf record -F 99 -g --call-graph dwarf ${ExecPath}
    ${PERF_HOME}/perf record -g -a -F 99 -o ${ExecPath}.data ${ExecPath}
    #sudo chown du:du ${ExecPath}.data
    ${PERF_HOME}/perf buildid-list -i ${ExecPath}.data
    ${PERF_HOME}/perf script -i ${ExecPath}.data > ${ExecPath}.perf
    #sudo chown root:root ${ExecPath}.perf

    ${FlameGraphHome}/stackcollapse-perf.pl ${ExecPath}.perf > ${ExecPath}.folded
    ${FlameGraphHome}/flamegraph.pl ${ExecPath}.folded > ${ExecPath}.svg
}

function FlameGraphCfg()
{
    #sudo sh -c "echo -1 > /proc/sys/kernel/perf_event_paranoid"
    #sudo sysctl -w kernel.perf_event_paranoid=-1
    #sudo cat /proc/sys/kernel/perf_event_paranoid
    #sudo ls  /sys/kernel/debug/tracing/events
    #${PERF_HOME}/perf report --stdio
    ${PERF_HOME}/perf buildid-cache -l
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
PerfInstall
#FlameGraphCfg
ELF_LIB_DIR="${CUR_USER_HOME_DIR}/opt/elfutils/lib"
export LD_LIBRARY_PATH=${ELF_LIB_DIR}:$LD_LIBRARY_PATH
ls ${ELF_LIB_DIR}
FlameGraphExec "$FLAME_GRAPH_HOME" "$EXEC_PATH"
