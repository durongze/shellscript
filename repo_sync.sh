#!/bin/bash

function RepoSyncAll()
{
    for dev in $devs
    do
        echo "------- $dev -------"
        echo -e "\033[32m repo start $dev --all \033[0m"
        repo start $dev --all

        declare -A cmds=( ["1"]="git checkout $dev"
                          ["2"]="git fetch --prune origin"
                          ["3"]="git reset --hard HEAD"
                          ["4"]="git clean -xdf" )
        for k in ${!cmds[@]}
        do
            cmd=${cmds[$k]}
            echo -e "\033[32m repo forall -c \" ${cmd} \" \033[0m"
            repo forall -c "${cmd}"
        done

        echo -e "\033[32m repo sync --force-sync \033[0m"
        repo sync --force-sync
    done
}
