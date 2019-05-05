#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#kvmName='fedora21-1'
#xmlName="${kvmName}.xml"
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:Check kvm install environment .End------------------------------------"
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

write_log "INFO" "KVM Test:Check kvm install environment.Begin---------------------------------"

#=========================================================================================================
retStat=`systemctl status libvirtd | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`

if [ "$retStat" == "running" ];then
   cmdStr="libvirtd 服务正在运行!"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

   cmdStr="KVM Environment is installed successfully!"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

else
   cmdStr="libvirtd 服务没有正在运行!s"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

   cmdStr="KVM Environment is not installed successfully!"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
   exit 1
fi

#==========================================================================================================
#write_log "INFO" "KVM Test:Check kvm install environment.End---------------------------------"
