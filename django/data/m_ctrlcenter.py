# 
#-*-coding:utf-8 -*-
# m_ctrlcenter.py 
# 主要代码 
def Pub(message_, method_): 
    channel.basic_publish(exchange='topic_test', routing_key=method_, body=message_) 
    
def StartPush(msg):
    _params = {} 
    _params["instructions"] = msg["params"]["message"] 
    _params["method"] = "redispush" 
    pubmsg = Packer(_params) 
    #To do redis push 
    Pub(pubmsg, _params["method"]) 
    return pubmsg 

def StartChange(msg): 
    _params = {} 
    _params["instructions"] = msg["params"]["message"] 
    _params["method"] = "statuschanger" 
    pubmsg = Packer(_params) 
    #To do redis changer 
    Pub(pubmsg, _params["method"]) 
    return pubmsg 

def Main(msg_): 
    # To do 
    if msg_["params"]["retcode"] == 0: 
        if msg_["params"]["type"] == 1: 
            return StartChange(msg_) 
        elif msg_["params"]["type"] == 2: 
            return StartPush(msg_) 
        return Packer(msg_) 
    
def callback(ch, method, properties, body): 
    # To do 
    #print(" [x] %r:%r" % (method.routing_key, body)) 
    message = Main(json.loads(body)) 
    Pub(message, "echo") 
