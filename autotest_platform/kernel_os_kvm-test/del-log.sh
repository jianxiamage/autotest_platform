#!/bin/bash

#----------------------
#Function:delete LogFile
#----------------------
source ./kernel_os_kvm-log.sh
logFile=$logFile
#############################################################

if [ -f "${logFile}" ];then
   echo "The log file:${logFile} will be deleted,wating..."
   rm "${logFile}"
   echo "${logFile} is deleted!"
else
   echo "${logFile} is not existed,nothing to do"
fi
