#include <string> 
#include <fstream> 
#include <sstream> 
std::string sh_script_ctx="\
TTY_NAME=$(tty | cut -f3-4 -d'/')\n\
\n\
ClientIp=$(who | grep \"${TTY_NAME}\" |grep -E \"[0-9]{1,3}(\\.[0-9]{1,3}){3}\" | cut -f2 -d'(' | cut -f1 -d')')\n\
ServerIpList=$(ifconfig | grep \"inet \" | awk '{print $2}')\n\
\n\
ServerIpList=$(ip addr | grep \"inet \" | awk -F' ' '{print $2}' | awk -F'/' '{print $1}')\n\
\n\
function GetServerIp()\n\
{\n\
    local cip=\"$1\"\n\
    local sip=\"$2\"\n\
    local realIp=\"\"\n\
    local max=0\n\
\n\
    for curIp in $sip\n\
    do\n\
        local cnt=0\n\
        for idx in $(echo $curIp | tr -s \".\" \" \" | wc | awk '{print $2}' | xargs seq)\n\
        do\n\
            curSubNet=$(echo $curIp | awk -F'.' '{print $'\"$idx\"'}')\n\
            cSubNet=$(echo $cip | awk -F'.' '{print $'\"$idx\"'}')\n\
            if [[ \"$curSubNet\" = \"$cSubNet\" ]];then\n\
                cnt=$(expr $cnt + 1)\n\
            fi\n\
        done\n\
\n\
        if [[ $cnt -gt $max ]];then\n\
            max=$cnt\n\
            realIp=$curIp\n\
        fi\n\
    done\n\
    echo \"$realIp\"\n\
}\n\
\n\
ServerIp=$(GetServerIp \"$ClientIp\" \"$ServerIpList\")\n\
\n\
GateWay=$(ip route | grep \"default\" | awk -F' ' '{print $3}')\n\
export PS1=\"\\u@${ServerIp} <= ${ClientIp}\\n\\w\\n$\"\n\
\n\
fileList=\"$(ls ${HOME}/opt)\"\n\
for tmpFile in ${fileList}\n\
do\n\
    TMP_FILE_HOME=${HOME}/opt/${tmpFile}\n\
    export C_INCLUDE_PATH=${TMP_FILE_HOME}/include:${C_INCLUDE_PATH}\n\
    export CPLUS_INCLUDE_PATH=${TMP_FILE_HOME}/include:${CPLUS_INCLUDE_PATH}\n\
    export LIBRARY_PATH=${TMP_FILE_HOME}/lib:${LIBRARY_PATH}\n\
    export LIBRARY_PATH=${TMP_FILE_HOME}/lib64:${LIBRARY_PATH}\n\
    export LD_LIBRARY_PATH=${TMP_FILE_HOME}/lib:${LD_LIBRARY_PATH}\n\
    export LD_LIBRARY_PATH=${TMP_FILE_HOME}/lib64:${LD_LIBRARY_PATH}\n\
    export PKG_CONFIG_PATH=${TMP_FILE_HOME}/lib/pkgconfig/:${PKG_CONFIG_PATH}\n\
    export PKG_CONFIG_PATH=${TMP_FILE_HOME}/lib64/pkgconfig/:${PKG_CONFIG_PATH}\n\
    export CMAKE_MODULE_PATH=${TMP_FILE_HOME}/lib/cmake/:${CMAKE_MODULE_PATH}\n\
    export PATH=${TMP_FILE_HOME}/bin:${TMP_FILE_HOME}/sbin:$PATH\n\
done\n\
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH\n\
export PATH=$PATH:/home/duyongze/code/chrome/depot_tools\n\
export TESSDATA_PREFIX=${HOME}/opt/tesseract/tessdata\n\
";
int gen_shell_script(const char* sh_file) 
{ 
    {
        std::fstream sh_fs(sh_file, std::ios::out | std::ios::trunc);
        sh_fs << sh_script_ctx; sh_fs << std::endl;
    }
    std::string cmd = "chmod +x ";
    cmd += sh_file;
    system(cmd.c_str());
    return 0;
} 
#ifndef ENV_MAIN 
int main(int argc, char** argv)
{
    if (argc == 2)
    gen_shell_script(argv[1]);
    return 0;
}
#endif 
