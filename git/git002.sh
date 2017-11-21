#!/bin/bash
#查看分支
git branch

cat .git/HEAD

#创建分支
git brach testing

cat .git/HEAD
ls -l .git/refs/heads
cat .git/refs/heads/master
cat .git/refs/heads/testing
#切换到testing分支
git checkout testing



