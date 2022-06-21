'''
/*
<#include "MicrochipDisclaimer.ftl">
*/
'''

import socket
from string import rstrip

s = socket.socket()
host = socket.gethostname()
port = 1337

s.bind((host,port))
print ('Socket bound')

s.listen(5)

c, addr = s.accept()
print ('Connection from', addr[0], '\n')

c.settimeout(5.0)

try:
    (c.recv(1024))
    c.send("Proceed\n")
    
    print("Remote: " + c.recv(1024))
    
    response = "Who's there?\n"
    c.send(response)
    print("Server: " + response)
    
    whos = rstrip((c.recv(1024)))
    print("Remote: " + whos + "\n")
    
    response = (whos + " who?\n")
    c.send(response)
    print("Server: " + response)
    
    print("Remote: " + c.recv(1024))
    
except socket as timeout:
    print ('Receive timed out')
    
c.close()
print ("Connection closed")
s.close()
print ("Socket closed")