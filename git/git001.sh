#!/bin/bash

#在当前目录创建仓库
git init 

#~/.gitconfig
git config --global user.name 'yongze du'
git config --global user.email 'durongze@qq.com'

#.git/gitconfig
git config  user.name 'yongze du'
git config  user.email 'durongze@qq.com'


#git:three Areas
Repository
Working directory
Staging area / index  #.git/index  物理上来看是在仓库里

Working directory ====(git add)====>Staging area / index ====(git commit)====> Repository
Working directory =========(git commit -a)========> Repository

example:
    git add main.c #将其加入到index中 
    git commit -m "this is 1 commit" #提交到本地仓库中
    git checkout -f HEAD #从本地仓库中恢复文件到工作区

#git:objects (type size content)
#type: blob tree commit
git hash-object main.c #sha1 的hash值

git add .
ls -l .git/object
ls -l .git/object/fc

git commit -m "this is 1 commit" #提交到本地仓库中
ls -l .git/object/
find ./git/objects/ -type -f
git show fc047f
git cat-file -t fc047f
git ls-tree 0593
git show -s --pretty-raw 2364


#References(Branch  Remote Head)
ls -l .git/HEAD
cat .git/HEAD
ls -l .git/refs/
ls -l .git/refs/heads
cat .git/refs/heads/master #HEAD 对应的master
find .git/objects/ -type f #查看和哪个master对应
git cat-file -t cb02
























