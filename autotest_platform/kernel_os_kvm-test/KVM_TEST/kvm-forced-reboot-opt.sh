#!/bin/bash

#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:forced reboot.End------------------------------------"
retNameExists='No'
#----------------------------------------------------------------------------------
source ./common-fun-tar.sh
kvmName=$(getKVMName)
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
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:forced reboot.Begin---------------------------------"
echo "KVM Test:[forced reboot].Begin---------------------------------"

#Test:reboot kvm
virsh reset $kvmName

cmdStr="KVM:${kvmName} is starting(forced)..."
echo ${cmdStr}
write_log "INFO" "${cmdStr}"

#Mark,the state of KVM(on,off)
sleep 30s
if virsh domstate $kvmName |grep -q "running";then
   cmdStr="$kvmName is running.KVM:$kvmName forced reboot success."
   echo ${cmdStr}
   write_log "INFO" "${cmdStr}"
else
   cmdStr="$kvmName is not running,Please check it!"
   echo ${cmdStr}
   write_log "ERROR" "${cmdStr}"
   exit 1
fi

#write_log "INFO" "KVM Test:start.End------------------------------------"
