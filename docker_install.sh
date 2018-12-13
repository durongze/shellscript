#!/bin/bash
file="harbor-offline-installer-v1.5.0.tgz"
harbor_cfg="harbor.cfg"
docker_compose_yml="docker-compose.yml"
registry_config_yml="common/templates/registry/config.yml"
prepare_script="prepare"
host_ip="192.168.99.141"
host_http_port="1180"
case $file in
    *.tar.* | *.tar | *.tgz)
        tar -xf $file
        FileDir=$(tar -tf $file | cut -f1 -d'/' | uniq | sed -n '1p')
        ;;
    *.zip)
        unzip $file
        FileDir=$(unzip -v $file |awk '{print $8}' | grep "/$" | uniq | sed -n '1p')
        ;;
esac;
FileDir="harbor"
pushd $FileDir
cp $harbor_cfg ${harbor_cfg}_dyzbak
sed -i 's/^hostname = .*$/ hostname = '"${host_ip}"'/g'  $harbor_cfg
echo -e "\033[32mdiff $harbor_cfg ${harbor_cfg}_dyzbak\033[0m"
diff $harbor_cfg ${harbor_cfg}_dyzbak
cp $docker_compose_yml ${docker_compose_yml}_dyzbak
sed -i 's/^.*80:80.*$/      - '"${host_http_port}"':80/g'  $docker_compose_yml
echo -e "\033[32mdiff $docker_compose_yml ${docker_compose_yml}_dyzbak\033[0m"
diff $docker_compose_yml ${docker_compose_yml}_dyzbak
cp $registry_config_yml ${registry_config_yml}_dyzbak
sed -i 's#^.*realm: \$public_url.*/service/token.*$#    realm: \$public_url:'"${host_http_port}"'/service/token  #g'  $registry_config_yml
echo -e "\033[32mdiff $registry_config_yml ${registry_config_yml}_dyzbak\033[0m"
diff $registry_config_yml ${registry_config_yml}_dyzbak
cp $prepare_script ${prepare_script}_dyzbak
sed -i 's#^.*empty_subj = ".*$#    empty_subj = "/C=US/ST=California/L=Palo Alto/O=VMware, Inc./OU=Harbor/CN=notarysigner"#g'  $prepare_script
echo -e "\033[32mdiff $prepare_script ${prepare_script}_dyzbak\033[0m"
diff $prepare_script ${prepare_script}_dyzbak
popd
