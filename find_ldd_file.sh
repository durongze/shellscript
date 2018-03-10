#!/bin/bash
#得到某文件所依赖的所有文件的绝对路径
方法1 ldd demo | sed -e 's/^.*=>//g' | sed -e 's/(.*)//g'
方法2 ldd demo | cut -f2 -d '>' | cut -f1 -d '('
#去掉ldd命令结果中的前缀
sed -e "s#^.*=>##g" demo.ldd 
#去掉ldd命令结果中的后缀
sed -e "s#(.*)##g" demo.ldd

