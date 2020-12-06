#!/bin/bash

PushClient="${HOME}/cli"

function InputWords()
{
    declare -A sermap=(["A"]="*"
                       ["B"]="#"
                       ["C"]="*"
                       ["D"]="#"
                       ["E"]="7"
                       ["F"]="7"
                       ["G"]="7"
                       ["H"]="7"
                       ["I"]="#"
                       ["J"]="*"
                       ["K"]="#"
                       ["L"]="*"  )
                       #["\\"]="/")
    for k in ${!sermap[@]}
    do 
        v=${sermap[$k]}
        keycode="KEYCODE_$v"
        echo "adb shell input keyevent $keycode"
        if [[ ! -z "$PushClient" ]];then
            $PushClient "\"adb shell input keyevent $keycode \""
        fi
    done
}

function DialNumber()
{
    local Number=$1
    if [[ "$Number" == "" ]];then
        return 1
    else
	    $PushClient "\"adb shell service call phone 1 s16 $Number \""
        return 0
    fi
}

function OpenDebugMode()
{
    DialNumber "%2A%23%2A%237777%23%2A%23%2A"
}

function GetUiCtx()
{
    local uiXml=$1
	$PushClient "\"adb shell uiautomator dump /sdcard/ui.xml\""
	$PushClient "\"adb pull /sdcard/ui.xml ./$uiXml \""
}

function PressPower()
{
    $PushClient "\"adb shell input keyevent KEYCODE_POWER \""
}

function UnlockScreen()
{
    local password=$1
    $PushClient "\"adb shell input text $password \""
}

function GetEvent()
{
    $PushClient "\"adb shell getevent -p\""
}

function SwipeScreen()
{
    x1=$1
    y1=$2
    x2=$3
    y2=$4
    $PushClient "\"adb shell input swipe $x1 $y1 $x2 $y2\""
    #$PushClient "\"adb shell input swipe $x2 $y2 $x1 $y1\""
}

function OpenViewSvr()
{
	$PushClient "\"adb shell service call window 1 i32 4939\""	
}

function CloseViewSvr()
{
	$PushClient "\"adb shell service call window 2 i32 4939\""	
}

function GetWmSizeW()
{
	local WinW=$($PushClient "\"adb shell wm size\"")	
	local WinW=$(echo $WinW | grep "msg" | cut -f4 -d' ' | cut -f1 -d'x')
	echo "$WinW"
}

function GetWmSizeH()
{
	local WinH=$($PushClient "\"adb shell wm size\"")	
	local WinH=$(echo $WinH | grep "msg" | cut -f4 -d' ' | cut -f2 -d'x')
	echo "$WinH"
}

function GetEventPosW()
{
	local PosW=$($PushClient "\"adb shell getevent -p | grep -e \"0035\" \"")
	local PosW=$(echo $PosW | grep "msg" | cut -f10 -d' ' | cut -f1 -d',')
	echo "$PosW"
}

function GetEventPosH()
{
	local PosH=$($PushClient "\"adb shell getevent -p | grep -e \"0036\" \"")	
	local PosH=$(echo $PosH | grep "msg" | cut -f10 -d' ' | cut -f1 -d',')
	echo "$PosH"
}

function PageDown()
{
	#$PushClient "\"adb shell input keyevent KEYCODE_PAGE_DOWN \""	
    #InitScreen
    if [ $? -ne 0 ];then
	    SwipeScreen "$QWmW" "$QWmH"  "$HalfWmW" "$HalfWmH"
    fi
}

function PageUp()
{
	#$PushClient "\"adb shell input keyevent KEYCODE_PAGE_UP \""	
    #InitScreen
    if [ $? -ne 0 ];then
	    SwipeScreen "$HalfWmW" "$HalfWmH" "$QWmW" "$QWmW"
    fi
}

function GetScreenStat()
{
	local ScreenStat=$($PushClient "\"adb shell dumpsys power | grep \"Display Power: state=\"\"")
	local ScreenStat=$(echo $ScreenStat | grep "msg" | cut -f4 -d' ' | cut -f2 -d'=')
	echo $ScreenStat
}

function OpenScreen()
{
    ScreenStat=$(GetScreenStat)
    if [[ "$ScreenStat" == "OFF" ]];then
	    PressPower
    fi
}

function InitScreen()
{
    WmW=$(GetWmSizeW)
    WmH=$(GetWmSizeH)
    EvtPosW=$(GetEventPosW)
    EvtPosH=$(GetEventPosH)
    if [[ "$WmW" == "" ]] || [[ "$WmH" == "" ]];then
        return 1
    fi
    HalfWmW=$(expr $WmW / 2)
    HalfWmH=$(expr $WmH / 2)
	QWmW=$(expr $WmW / 4)
	QWmH=$(expr $WmH / 4)
    return 0
}

function ShowScreenInfo()
{
    echo "WmW=$WmW"
    echo "WmH=$WmH"
    echo "EvtPosW=$EvtPosW"
    echo "EvtPosH=$EvtPosH"
    echo "HalfWmW=$HalfWmW"
    echo "HalfWmH=$HalfWmH"
	echo "QWmW=$QWmW"
	echo "QWmH=$QWmH"
}

OpenScreen
InitScreen
OpenDebugMode
PageUp
PageUp
PageDown
GetUiCtx "ui.xml"

