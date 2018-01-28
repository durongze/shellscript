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


#References(Branches  RemoteBranches HEAD)
ls -l .git/HEAD
cat .git/HEAD
ls -l .git/refs/
ls -l .git/refs/heads
cat .git/refs/heads/master #HEAD 对应的master
find .git/objects/ -type f #查看和哪个master对应
git cat-file -t cb02

#tag
ls -l .git/refs/tags/
git tag v1.0
cat .git/refs/tags/v1.0
git cat-file -t 9e7b
find .git/objects/ -type f | wc -l
#以上tag非对象

git tag -a milestone1.0 -m "This is the first stable version"
find .git/objects/ -type f | wc -l
#以上tag是个对象
ls -l .git/refs/tags/
cat .git/refs/tags/milestone1.0

#取出归档版本代码
git archive --format=tar --prefix=ruby/ v1.0 | gzip > /tmp/ruby1.0.tar.gz

#通过tag取代码
git checkout v0.1 ===> .git/refs/tags/v0.1 ===> tag:0c819c  ===> commit:a11bef























