#!/bin/bash
#1.install
sudo python -m pip install "django<2"
#2.check
python
    #>>> import django
    #>>> django.VERSION
    #(1, 6, 0, 'final', 0)
    #>>> 
    #>>> django.get_version()
    #'1.6.0'
#3.新建项目
django-admin.py startproject http
    #创建成功后会有以下目录结构
    #http
    #├── manage.py
    #└── http
    #├── __init__.py
    #├── settings.py
    #├── urls.py
    #└── wsgi.py

#4.新建应用
cd http
python manage.py startapp httpmodule  # httpmodule 是一个app的名称

#5.修改配置
    #views.py    # 这个是我这个项目的主要文件，所有逻辑也会在这里进行体现
    #urls.py     # 网页对应的内容 
    #settings.py # 配置
    #wsgi.py     # 配置apache要用到
    
    #5.1 修改/http/http/settings.py
    #把我们新定义的app加到settings.py中的INSTALL_APPS中
    INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'httpmodule',
    )
    #5.2 修改/http/http/urls.py

    from django.conf.urls import patterns, include, url 
    from django.contrib import admin
    admin.autodiscover()
    from httpmodule import views as http_views

    urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'http.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^get/$', http_views.get, name='get'), # 新增get方法 需要对应到views.py
    url(r'^set/$', http_views.set, name='set'), # 新增set方法 需要对应到views.py
    )

    #这里的方法定义成功后，相对应的访问http请求就变成 ：
    #http://ip:port/get | http://ip:port/set

    #5.3 修改wsgi.py
    #这个文件需要搭配apache,一般先要安装一下wsgi的环境包
    sudo apt-get install apache2-dev  #缺少apxs时安装
    sudo pip install mod_wsgi
    #如果安装失败，可以下载源码包进行安装，同时要注意的是不同的python版本可能需要对应不同版本的mod_wsgi
    #然后修改http/http/wsgi.py
    import os
    from os.path import join,dirname,abspath

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "http.settings")
    PROJECT_DIR = dirname(dirname(abspath(__file__)))                   
    import sys                                                          
    sys.path.insert(0,PROJECT_DIR)                                          

    from django.core.wsgi import get_wsgi_application
    application = get_wsgi_application()

    #5.4 修改http/httpmodule/views.py
    from django.shortcuts import render
    from django.http import HttpResponse

    # Create your views here.
    def set(request):
    # To do
    #example:
        message = request.GET.get('a','error')
        return HttpResponse(message)

    def get(requset):
    # To do
        return HttpResponse(result)
    # To do可以写上自己的逻辑代码，也可以调用自己封装的python脚本。

    #request:请求包
    #比如http请求是 http://ip:port/set?a=hello
    #那么 message获取到的内容就是hello
    #HttpResponse(message)就会返回内容，如果打开浏览器，正常的话应该能看到“hello”

#6. 配置httpd.conf
#编辑/etc/httpd/conf/httpd.conf #如果是yum安装的就是这个配置文件
#在配置文件最后加上

<VirtualHost *:8000>
ServerName example.com
ServerAlias example.com
ServerAdmin example@163.com

Alias /httpmodule /home/smart/web/http/httpmodule #需要修改

<Directory /home/smart/web/http/httpmodule>       #需要修改
Options Indexes FollowSymLinks
Order deny,allow
Allow from all
</Directory>

WSGIScriptAlias / /home/smart/web/http/http/wsgi.py #需要修改
#WSGIDaemonProcess www.example.com python-path=/usr/local/lib/python2.6/site-packages

<Directory /home/smart/web/http/http>  #需要修改
<Files wsgi.py>
Order deny,allow
Allow from all
</Files>
</Directory>
</VirtualHost>


#7.然后启动httpd
service httpd start
#8. sudo python manage.py migrate 
#9. sudo python manage.py runserver
