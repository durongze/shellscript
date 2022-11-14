@rem #创建流量转发，其中listenaddress为内网ip（也就是ipconfig中所显示的IP），listenport为监听的本机对外端口，后两个分别是需转发的目标主机IP和端口。
set local_svr=
set phone_ip=
netsh interface portproxy add v4tov4 listenaddress=%local_svr% connectaddress=%phone_ip%
@rem netsh interface portproxy add v4tov4 listenport=3340 listenaddress=%local_svr% connectport=3389 connectaddress=%phone_ip%
 
@rem #查看有什么转发
netsh interface portproxy show v4tov4
 
@rem #删除刚才那个转发
netsh interface portproxy delete v4tov4 listenaddress=%local_svr%

@rem 
netsh interface portproxy show all

@rem
netsh interface portproxy reset
