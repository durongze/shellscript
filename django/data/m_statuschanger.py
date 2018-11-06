# 
#-*-coding:utf-8 -*-
# m_statuschanger.py 
# 主要代码 
def Pub(message_, method_): 
    channel.basic_publish(exchange='topic_test', routing_key=method_, body=message_) 
    
def StartChange(instructions): 
    #To do redis changer 
    no = instructions[1] 
    operation = instructions[2] 
    r.set(table[no], operation) 
    
def Main(msg_): 
    # To do 
    _params = {} 
    _params["retcode"] = -1 
    _str = msg_["params"]["instructions"] 
    instructions = _str.split("~") 
    if instructions[0] == "S" and instructions[3] == "S": 
        StartChange(instructions) 
        _params["retcode"] = 0 
        _params["operation"] = _str 
        return Packer(_params) 
    
def callback(ch, method, properties, body): 
    # To do 
    message = Main(json.loads(body)) 
    Pub(message, "echo")
