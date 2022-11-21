#!/bin/bash

function NumactlBindCpus()
{
   local Cpus="$1" #0-1
   local App="$2"
   local CurCmd="numactl -C \"${Cpus}\" ${App}"
   echo "$CurCmd"
   eval "$CurCmd &"
}

function Taskset()
{
   local Pid="$1"
   local CurCmd="taskset -c -p ${Pid}" 
   echo "$CurCmd"
   eval "$CurCmd"
}

AppName="./a.out"
NumactlBindCpus "0" "${AppName}"
Taskset "$(pidof ${AppName})"

killall -10 $AppName
