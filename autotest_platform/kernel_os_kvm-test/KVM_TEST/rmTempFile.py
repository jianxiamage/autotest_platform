#!/usr/bin/env python
import os
import sys
import logging
import log

list = []
list.append('pmonStd.file.tmp')
list.append('pxeStd.file.tmp')
list.append('pmonStd.file.tmp.bak')
list.append('pxeStd.file.tmp.bak')


def DeleteFile(FileList): 
  try:
    
     logging.info('Remove all the temp files Begin.')
     for file in FileList:
       if os.path.isfile(file):
          os.remove(file)
          #print "Temp File:" + file + " was removed!"
          cmdStr="Temp File: %s  was removed!" %(file)
          logging.info(str(cmdStr))
          print '%s' %(cmdStr)

  except:
          cmdStr="Temp File: %s removed failed!" %(file)
          logging.info(str(cmdStr))
          print '%s' %(cmdStr)

  logging.info('Remove all the temp files End.')
 
  return



if __name__ == '__main__':
  #DeleteFile(list)
  strArgs=sys.argv
  #print strArgs
  strArgs=strArgs[1:]
  strTmp='The temp files List: '
  #print strTmp+str(strArgs)
  DeleteFile(strArgs)


