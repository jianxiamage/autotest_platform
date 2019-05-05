# -*- coding: utf-8 -*-
from socket import *
mSocket = socket(AF_INET,SOCK_DGRAM)
for i in xrange(2,254):
	strip = "192.168.122."+str(i)
#	print strip
	mSocket.sendto("a".encode("utf-8"),(strip,80))

