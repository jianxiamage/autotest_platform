#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
memInputNum=1024
#----------------------------------------------------------------
cmdEndStr="KVM Test:Remove part of the KVM  memory End----------------------------"
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

write_log "INFO" "KVM Test:Remove part of the KVM memory Begin----------------------------"

#Exit the script if an error happens
#set -e

#First,set the memory info to default(memorySize:2G)
sh kvm-mem-ballon-default.sh
echo "kvm-mem-ballon-default.sh retCode:$?"

#TODO:Init the memory info(current:2G,Max:??)
#sh kvm-mem-init.sh
#echo "kvm-mem-init.sh retCode:$?"

#Start the KVM
sh kvm-enableStart.sh

#Waiting for the machine to start
echo "Waiting for the machine to start..."
sleep 5s

trap - ERR

#check the kvm name and status
sh kvm-name_stat.sh

retCode=$?
echo "---------retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="$kvmName is running,continue to test...."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:$kvmName is not running!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


#Begin to test memory remove 
echo "KVM memory test:remove 1G memory (memory config:current->2G,Max:2G)"

trap - ERR

sh kvm-mem-ballon-remove-opt.sh
retCode=$?
echo "---------retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="KVM Test:Modified memory info,continue...."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:Modified memory info failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


#Now,shutdown the KVM
#sh kvm-enableShutdown.sh

#Waiting for the KVM to shut down
#echo "Waiting for the KVM to shut down..."
#sleep 5s

#Now,Start the KVM
#sh kvm-enableStart.sh

#Waiting for the machine to start
#echo "Waiting for the machine to start..."
#sleep 5s

trap - ERR

sh kvm-mem-ballon-info-check.sh $memInputNum
retCode=$?
echo "---------retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

echo "===============================Memory remove test result==============================="
if [  $retCode -eq 0 ]; then
  cmdStr="KVM Test:Remove memory from 2G to 1G success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo "===============================Memory remove test result==============================="
else
  cmdStr="Error:Remove memory frome 2G to 1G failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  echo "===============================Memory remove test result==============================="
  exit 1
fi

