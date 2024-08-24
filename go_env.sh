#!/bin/bash

function GoEnvSet ()
{
    echo "$FUNCNAME:$LINENO"

}

function GoEnvShow()
{
    local GoEnvCfgFile=$1
    echo "$FUNCNAME:$LINENO"

    echo "GOROOT=$GOROOT"
    echo "GOPATH=$GOPATH"
    go env >$GoEnvCfgFile
}


GoEnvSet ""
GoEnvShow "go_env.cfg"
