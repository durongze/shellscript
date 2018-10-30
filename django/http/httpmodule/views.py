# -*- coding: utf-8 -*-
from __future__ import unicode_literals

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

def index(request):
    return HttpResponse("welcom to raspberrypi!!")
