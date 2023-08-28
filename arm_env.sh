#!/bin/bash
UTLILS_ROOT=$(pwd)

export ARM_COMPILER_PATH=${UTLILS_ROOT}/rvct22/linux-pentium
export ARMTOOLS=RVCT221
export ARMROOT=${UTLILS_ROOT}/rvct22/
export ARMLIB=${ARMROOT}/lib
export ARMINCLUDE=${ARMROOT}/include/unix
export ARMINC=${ARMINCLUDE}
export ARMCONF=${ARMROOT}/linux-pentium
export ARMDLL=${ARMROOT}/linux-pentium
export ARMBIN=${ARMROOT}/linux-pentium
export ARMHOME=${ARMROOT}
export ARMLMD_LICENSE_FILE=${UTLILS_ROOT}/license.dat

export PATH=${PYTHON_PATH}:${MAKE_PATH}:${ARM_COMPILER_PATH}:${PATH}

LIC_FILE_DST="license.dat"
LIC_FILE_BAK="license.bak"
if [[ -f '${LIC_FILE_BAK}' ]]; then
    echo "backup ${LIC_FILE_BAK}"
    cp ${LIC_FILE_DST} ${LIC_FILE_BAK}
else 
    echo "${LIC_FILE_BAK} does exist."
    cp ${LIC_FILE_BAK} ${LIC_FILE_DST}
fi

echo sed  ':a;N;$!ba;s#\\$\n##g' -i ${LIC_FILE_DST}
sed  ':a;N;$!ba;s#\\\n##g' -i ${LIC_FILE_DST}
sed 's/31-dec-2020/31-dec-2070/g'  -i ${LIC_FILE_DST}
MAC_ADDRS=$(ifconfig  | grep  "ether\s*" | awk '{print $2}')

LOC_MAC_ADDR=""
for mac in ${MAC_ADDRS}
do
    #LOC_MAC_ADDR="${LOC_MAC_ADDR}${mac//:/} "
    LOC_MAC_ADDR="${mac//:/}"
    break
done
#LOC_MAC_ADDR=$(echo ${LOC_MAC_ADDR} | tr 'a-z' 'A-Z')

DST_MAC_ADDR=$(grep "HOSTID" ${LIC_FILE_DST} | cut -d'=' -f3 | cut -d'"' -f2)
echo "{LOC_MAC_ADDR} ---- ${LOC_MAC_ADDR}"
echo "{DST_MAC_ADDR} ---- "
echo "${DST_MAC_ADDR}"
IFS_OLD=$IFS
IFS=$'\n'
for DST in ${DST_MAC_ADDR}
do
    echo -e "\033[32m sed -e 's/'"${DST}"'/'"${LOC_MAC_ADDR}"'/' -i ${LIC_FILE_DST} \033[0m"
    sed -e 's/'"${DST}"'/'"${LOC_MAC_ADDR}"'/' -i ${LIC_FILE_DST}
done
IFS=${IFS_OLD}

#sed -e 's/'"${DST_MAC_ADDR}"'/'"DST_MAC_ADDR"'/' ${LOC_MAC_ADDR}
#diff ${LIC_FILE_BAK} ${LIC_FILE_DST}
CUR_TIME=$(date "+%F %T")
#sudo date -s "20200808 09:09"
echo $LINENO $(date "+%F %T")
armcc
echo $LINENO $(date "+%F %T")
sudo date -s "${CUR_TIME}"
