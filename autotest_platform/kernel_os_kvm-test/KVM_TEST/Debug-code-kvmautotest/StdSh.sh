#!/bin/bash

#set -e
#------------------------------
cmdStr=''
kvmName='fedora21-1'
xmlName="${kvmName}.xml"
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:create .End------------------------------------"
retNameExists='No'
#----------------------------------------------------------------------------------
source ./kvm-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log
#----------------------------------------------------------------------------------
source ./exceptionTrap.sh
exit_end=$exit_end
exit_err=$exit_err
exit_int=$exit_int
#----------------------------------------------------------------------------------
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM create:create.Begin---------------------------------"

#==========================================================================
#\cp templet.xml ${xmlName} -f
#sed -i "s/fedora21/${kvmName}/g" ${xmlName}

trap - ERR

#diff ${xmlName} "${xmlName}.bak" >/dev/null 2>&1
#if [ $? -eq 0 ]; then
#  cmdStr="${xmlName} modify kvmName failed,Exit"
#  echo $cmdStr
#  write_log "ERROR" "${cmdStr}"
#  exit
#else
#  cmdStr="${xmlName} modify kvmName success"
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#fi

trap 'exit_err $LINENO $?'     ERR

#=========================================================================
#write_log "INFO" "KVM Test:create .End------------------------------------"
