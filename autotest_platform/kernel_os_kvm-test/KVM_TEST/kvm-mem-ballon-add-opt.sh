#/bin/bash

#----------------------------------------------------------------
kvmName=''
xmlName="${kvmName}.xml"
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Add 1G of the KVM memory (ballon) End----------------------------"
KVMIP=''
retCode=0
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
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test: Add 1G of the KVM memory (ballon) Begin----------------------------"

#Exit the script if an error happens
#set -e

trap - ERR

sh kvm-mem-ballon-info.sh 1024
retCode=$?
#echo "=====$retCode"
trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="${xmlName}:now,the memory size is 1G.continue..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="${xmlName}:now,the memory size is not 1G.Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#Begin to test add memory:(1G to 2G)
echo "Add part of memory From 1G to 2G Begin..."
virsh qemu-monitor-command $kvmName --hmp "balloon 2048"

retCode=$?

#trap - ERR

#retCode=$?
#echo "=====$retCode"
#trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="$xmlName:set to default config success"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="${xmlName}:set to default config failed,Exit"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit
fi

#wait a moment to set memory Size to 1024
echo "wait a moment to set memory size from 1G to 2G"
sleep 10s

echo "Add part of memory From 1G to 2G End."

