# 
#-*-coding:utf-8 -*-
# m_redispush.py 
# 主要代码 

def Pub(message_, method_): 
    channel.basic_publish(exchange='topic_test', routing_key=method_, body=message_) 
    
def Main(msg_): 
    # To do 
    params_ = {} 
    if msg_["method"] == "redispush": 
        r.lpush(queue,msg_["params"]["instructions"]) 
        params_["pushresult"] = "true" 
        params_["instructions"] = msg_["params"]["instructions"] 
        return Packer(params_) 
    
def callback(ch, method, properties, body): 
    # To do 
    #print(" [x] %r:%r" % (method.routing_key, body)) 
    message = Main(json.loads(body)) 
    Pub(message, "echo")
