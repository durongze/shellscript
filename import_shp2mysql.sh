#!/bin/bash
HOST="192.168.99.113"
USER="root"
PASS="duyongze"
MYSQL="mysql -u$USER -p$PASS --default-character-set=utf8 -A -N"
#这里面有两个参数，-A、-N，-A的含义是不去预读全部数据表信息，这样可以解决在数据表很多的时候卡死的问题
#-N，很简单，Don't write column names in results，获取的数据信息省去列名称

function ModifyMsqlPass()
{
    mysqladmin -u $USER password "$PASS"
    ModifyPass="GRANT ALL PRIVILEGES ON *.* TO '"$USER"'@'%'IDENTIFIED BY '"$PASS"' WITH GRANT OPTION;"
    FlushPrivi="FLUSH PRIVILEGES;"
    mysql -u$USER -p$PASS -e "$ModifyPass"
}

function ExportTableData()
{
    table=$1
    data=$2
    sql="select * from $table"
    result="$($MYSQL -e "$sql")"
    echo -e "$result" > $data
}

function InsertData2Table()
{
    table=$1
    data=$2
    cat $data | while read id name age
    do
        sql="insert into $table(id, name, age) values(${id}, '${name}', ${age});"
        $MYSQL -e "$sql"
    done
}


function UpdateData2Table()
{
    table=$1
    data=$2
    cat $data | while read src dst
    do
        if [ ! -z "${src}" -a ! -z "${dst}" ]; then
            sql="update $table set name='${dst}' where name='${src}'"
        fi
        if [ ! -z "${src}" -a -z "${dst}" ];then
            sql="delete from $table where name='${src}'"
        fi
        $MYSQL -e "$sql"
    done
}

function ImportShp2Mysql()
{
    ShpDir="$1"
    for ShpFile in $(ls $ShpDir/*.shp)
    do
        ShpFileName=${ShpFile%%.*}
        ShpFileName=${ShpFileName##*/}
        CreateDatabase="create database $ShpFileName;"
        mysql -u$USER -p$PASS -e "$CreateDatabase"
        ogr2ogr -f "MySQL" MySQL:"$ShpFileName,user=$USER,host=$HOST,password=$PASS" -lco engine=MYISAM $ShpFile
    done
}

#ImportShp2Mysql $1
ExportTableData shuangqumianchilun.shuangqumianchilun test.txt
