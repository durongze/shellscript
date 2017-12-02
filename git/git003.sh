#!/bin/bash
#放弃本地修改使用远程的库就可以。
git fetch --all
git reset --hard origin/master
