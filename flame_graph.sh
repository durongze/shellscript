#!/bin/bash
set -x

echo "set CXX_FLAGS=-g"

function FlameGraphInstall()
{
	wget https://codeload.github.com/brendangregg/FlameGraph/zip/refs/heads/master -o flame_graph.zip
	unzip flame_graph.zip
}

FLAME_GRAPH_HOME="${HOME}/FlameGraph-master"
EXEC_PATH="./a.out" # 长时间运行

function FlameGraphExec()
{
    FlameGraphHome=$1
    ExecPath=$2
    #perf record -F 99 -g --call-graph dwarf ${ExecPath}
    sudo perf record -F 99 -g -a ${ExecPath}
    #sudo chown root:root perf.data
    sudo perf script -i perf.data > out.perf
    #sudo chown root:root out.perf

    sudo ${FlameGraphHome}/stackcollapse-perf.pl out.perf > out.folded
    sudo ${FlameGraphHome}/flamegraph.pl out.folded > out.svg
}

function FlameGraphCfg()
{
    sudo sh -c "echo -1 > /proc/sys/kernel/perf_event_paranoid"
}

function PerfInstall()
{
	wget https://mirror.bjtu.edu.cn/kernel/linux/kernel/tools/perf/v5.15.0/perf-5.15.0.tar.gz
	tar xf perf-5.15.0.tar.gz
	pushd perf-5.15.0/tools/perf
	make 
	popd
}

#PerfInstall
#FlameGraphInstall
FlameGraphCfg
FlameGraphExec "$FLAME_GRAPH_HOME" "$EXEC_PATH"
