#!/bin/bash
workdir=$(pwd)
src_target=test_args.exe
dst_dir=dst



function get_path_by_file ()
{
    myfile=$1
    mypath=${myfile%/*}
    myname=${myfile#*/}
    myname=${myname%.*}
    myext=${myfile#*.}
    echo "$mypath $myname $myext"
}

function replace_all_cmd ()
{
    workdir=$1
    src_target=$2
    dst_dir=$3

    set mypath=
    set myname=
    set myext=

    if [ ! -d $dst_dir ];then
        mkdir $dst_dir
    fi

    pushd $workdir
    for f in $(ls -l * | grep ^- | awk '{print $9}')
    do
        i=0
        echo -e "\033[32m file name:$f \033[0m"
        str_list=$(get_path_by_file $f)
        for str in $str_list
        do
            case $i in
                0):
                mypath=$str
            ;;
                1):
                myname=$str
            ;;
                2):
                myext=$str
            ;;
            esac;
            i=$(expr $i + 1)
        done
        if [[ "${myname}${myext}" == "" ]] || [[ "${myname}" == "${myext}" ]];then
            echo -e "\tcp  $src_target  $dst_dir/${f}"
        else
            echo -e "\tcp  $src_target  $dst_dir/${myname}.${myext}"
        fi
    done
    popd
}

replace_all_cmd $workdir $src_target  $dst_dir

