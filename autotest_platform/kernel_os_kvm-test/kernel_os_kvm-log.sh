#!/bin/bash

#Log PATH
logFile=/var/log/kernel_os_kvm_Test.log
########################################################################

#log Function 
function write_log()
{
  local logType=$1
  local logMsg=$2
  #local logName=$3
  echo "[$logType : `date +%Y-%m-%d\ %T`] : $logMsg" >> $logFile
}
