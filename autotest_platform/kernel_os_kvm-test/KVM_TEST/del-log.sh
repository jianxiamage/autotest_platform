#!/bin/bash

#----------------------
#Function:delete LogFile
#----------------------
source ./kvm-log.sh
logFile=$logFile

#############################################################
#logPath=/var/log/KVM-Test/
#logFile=${logPath}KVM-Test.log
#
#if [ -d "$logPath" ]; then
#   echo "====================================================="
#   echo "LogPath:$logPath will be deleted."
#   rm -rf "$logPath"
#fi

#############################################################


if [ -f "${logFile}" ];then
   echo "The log file:${logFile} will be deleted,wating..."
   rm "${logFile}"
   echo "${logFile} is deleted!"
else
   echo "${logFile} is not existed,nothing to do"
fi
