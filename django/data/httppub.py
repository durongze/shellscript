# 
#-*-coding:utf-8 -*-
# httppub.py 
# 主要代码 
def Pub(message_): 
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost')) 
    channel = connection.channel() 
    channel.exchange_declare(exchange='topic_test', type='topic') 
    channel.basic_publish(exchange='topic_test', routing_key=method, body=message_) 
    connection.close() 
    
def Main(param_): 
    #to do 
    msg = Packer(param_) 
    Pub(msg) 
    
def send(param_): 
    Main(param_)
