#!/bin/bash

export DJANGO_PROJ_DIR=$(pwd)
export DJANGO_PROJ_NAME=http
export DJANGO_APP_MOD=httpmodule
export PYTHON_APP=$DJANGO_PROJ_DIR/venv/bin/python3

function CreatePythonEnv
{
	python -m venv venv
}

function InstallDjangoLib()
{
	$PYTHON_APP -m pip install django
}

function CreateDjangoProj()
{
	$PYTHON_APP django-admin.py startproject $DJANGO_PROJ_NAME
}

function CreateDjangoAppMod()
{
	$PYTHON_APP manage.py startapp $DJANGO_APP_MOD
}

function AddAppModToProj()
{
	echo "$FUNCNAME:$LINENO"
	local CfgFile="http/http/setting.py"
	local UrlFile="http/http/urls.py"
	local CgiFile="http/http/wsgi.py"
	local ViewFile="http/http/views.py"
}

function InstallFastCGI_Win()
{
	$PYTHON_APP -m pip install wfastcgi
} 

function EnableFastCGI()
{

}

function CreateDjangoWebCfg()
{

	echo "<configuration>                                                   "  >> $DJANGO_WEB_CFG
	echo "  <system.webServer>                                              "  >> $DJANGO_WEB_CFG
	echo "    <handlers>                                                    "  >> $DJANGO_WEB_CFG
	echo "      <add name="Python FastCGI"                                  "  >> $DJANGO_WEB_CFG
	echo "           path="*"                                               "  >> $DJANGO_WEB_CFG
	echo "           verb="*"                                               "  >> $DJANGO_WEB_CFG
	echo "           modules="FastCgiModule"                                "  >> $DJANGO_WEB_CFG
	echo "           scriptProcessor=\"C:\\Python39\\python.exe|C:\\Python39\\Lib\\site-packages\\wfastcgi.py\"          "  >> $DJANGO_WEB_CFG
	echo "           resourceType="Unspecified"                             "  >> $DJANGO_WEB_CFG
	echo "           requireAccess="Script" />                              "  >> $DJANGO_WEB_CFG
	echo "    </handlers>                                                   "  >> $DJANGO_WEB_CFG
	echo "  </system.webServer>                                             "  >> $DJANGO_WEB_CFG
	echo "  <appSettings>                                                   "  >> $DJANGO_WEB_CFG
	echo "    <add key="WSGI_HANDLER" value="django.core.wsgi.get_wsgi_application\(\)" />       "  >> $DJANGO_WEB_CFG
	echo "    <add key="PYTHONPATH" value="C:\\path\\to\\your\\django_project"/>                 "  >> $DJANGO_WEB_CFG
	echo "    <add key="DJANGO_SETTINGS_MODULE" value="your_project.settings" />                 "  >> $DJANGO_WEB_CFG
	echo "  </appSettings>                                                  "  >> $DJANGO_WEB_CFG
	echo "</configuration>                                                  "  >> $DJANGO_WEB_CFG

}

function InstallNginx()
{
	
}

function InstallFastCGI_Linux()
{
	 $PYTHON_APP -m pip install flup
}

function EnableFastCGI_Nginx()
{
	local SERVER_IP="192.168.99.177"
    local NGINX_PROJ_CFG="/etc/nginx/sites-available/$DJANGO_PROJ_NAME"
	echo "server {                                                  "     > $NGINX_PROJ_CFG 
	echo "    listen 80;                                            "    >> $NGINX_PROJ_CFG 
	echo "    server_name $SERVER_IP;                               "    >> $NGINX_PROJ_CFG 
	echo "                                                          "    >> $NGINX_PROJ_CFG 
	echo "    location / {                                          "    >> $NGINX_PROJ_CFG 
	echo "        include fastcgi_params;                           "    >> $NGINX_PROJ_CFG 
	echo "        fastcgi_pass 127.0.0.1:8000;                      "    >> $NGINX_PROJ_CFG  
	echo "        fastcgi_param PATH_INFO $fastcgi_script_name;     "    >> $NGINX_PROJ_CFG   
	echo "        fastcgi_param REQUEST_METHOD $request_method;     "    >> $NGINX_PROJ_CFG     
	echo "        fastcgi_param QUERY_STRING $query_string;         "    >> $NGINX_PROJ_CFG   
	echo "        fastcgi_param CONTENT_TYPE $content_type;         "    >> $NGINX_PROJ_CFG    
	echo "        fastcgi_param CONTENT_LENGTH $content_length;     "    >> $NGINX_PROJ_CFG   
	echo "        fastcgi_param SERVER_PROTOCOL $server_protocol;   "    >> $NGINX_PROJ_CFG    
	echo "        fastcgi_param REQUEST_URI $request_uri;           "    >> $NGINX_PROJ_CFG    
	echo "        fastcgi_param REMOTE_ADDR $remote_addr;           "    >> $NGINX_PROJ_CFG   
	echo "    }                                                     "    >> $NGINX_PROJ_CFG 
	echo "                                                          "    >> $NGINX_PROJ_CFG 
	echo "    location /static/ {                                   "    >> $NGINX_PROJ_CFG   
	echo "        alias $DJANGO_PROJ_DIR/$DJANGO_PROJ_NAME/static/; "    >> $NGINX_PROJ_CFG  
	echo "    }                                                     "    >> $NGINX_PROJ_CFG    
	echo "                                                          "    >> $NGINX_PROJ_CFG    
	echo "    location /media/ {                                    "    >> $NGINX_PROJ_CFG      
	echo "        alias $DJANGO_PROJ_DIR/$DJANGO_PROJ_NAME/media/;  "    >> $NGINX_PROJ_CFG
	echo "    }                                                     "    >> $NGINX_PROJ_CFG    
	echo "}                                                         "    >> $NGINX_PROJ_CFG              
}

function RunNginx()
{
	$PYTHON_APP manage.py runfcgi method=threaded host=127.0.0.1 port=8000
	sudo systemctl restart nginx
}

function InstallPythonLibs()
{
	$PYTHON_APP pip install --upgrade django 
    $PYTHON_APP pip install django-dbbackup mysqlclient openpyxl pandas pyecharts py7zr 
    $PYTHON_APP pip install requests bokeh requests_toolbelt cryptography
}
