#!/bin/bash
#得到某文件所依赖的所有文件的绝对路径
方法1 ldd demo | sed -e 's/^.*=>//g' | sed -e 's/(.*)//g'
方法2 ldd demo | cut -f2 -d '>' | cut -f1 -d '('
#去掉ldd命令结果中的前缀
sed -e "s#^.*=>##g" demo.ldd 
#去掉ldd命令结果中的后缀
sed -e "s#(.*)##g" demo.ldd

#获取某文件的两层依赖的所有文件的绝对路径。并去重
ldd demo | cut -f2 -d '>' | cut -f1 -d '(' | xargs ldd  | cut -f2 -d '>' | cut -f1 -d '(' |  cut -f1 -d ':'| sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g'  | sort | uniq 
