#!/bin/bash


########################################################################
#when the logPath is set:/var/log/KVM-Test/KVM-Test.log
#logPath=/var/log/KVM-Test/
#logFile=${logPath}KVM-Test.log

#echo $logPath
#echo $logFile

#if [ ! -d "$logPath" ]; then
#   echo "==============================================================="
#   echo "LogPath:$logPath is not existed,it will be created."
#   mkdir "$logPath"
#fi
########################################################################

#Log PATH
logFile=/var/log/KVM-Test.log
########################################################################

#log Function 
function write_log()
{
  local logType=$1
  local logMsg=$2
  #local logName=$3
  echo "[$logType : `date +%Y-%m-%d\ %T`] : $logMsg" >> $logFile
}
