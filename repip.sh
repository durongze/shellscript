#!/bin/bash
FILE_NAME=$1
IP=127.1.2.7

awk -F= '{print "'[${FILE_NAME},'" NR "] : " $0 "\t:\t" $1 "\t:\t" $2}' $FILE_NAME

sed -e "s#[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}#${IP}#g" -i $FILE_NAME
#sed -e 's#[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}#"'${IP}'"#g' -i $FILE_NAME

awk -F= '{print "'[${FILE_NAME},'" NR "] : " $0 "\t:\t" $1 "\t:\t" $2}' $FILE_NAME
