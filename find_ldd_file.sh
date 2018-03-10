#!/bin/bash
#去掉ldd命令结果中的前缀
sed -e "s#^.*=>##g" demo.ldd 
#去掉ldd命令结果中的后缀
sed -e "s#(.*)##g" demo.ldd
