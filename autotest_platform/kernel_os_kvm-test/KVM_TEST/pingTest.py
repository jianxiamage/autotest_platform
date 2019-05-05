# -*- coding: utf-8 -*-
from socket import *
import logging
import log

try:
  mSocket = socket(AF_INET,SOCK_DGRAM)
  for i in xrange(2,254):
	strip = "192.168.122."+str(i)
#	print strip
	mSocket.sendto("a".encode("utf-8"),(strip,80))
        #cmdStr="send udp error!"
        #logging.info(str(cmdStr))
        #print '%s' %(cmdStr)

except:
       cmdStr="send udp error!"
       logging.error(str(cmdStr))
       print '%s' %(cmdStr)

logging.info('Remove all the temp files End.')

