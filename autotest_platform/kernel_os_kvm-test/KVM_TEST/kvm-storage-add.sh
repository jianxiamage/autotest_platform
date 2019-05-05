#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Add KVM storage(disk) End----------------------------"
KVMIP=''
retCode=0
memInputNum=2
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

write_log "INFO" "KVM Test:Add KVM storage(disk) Begin----------------------------"

#Exit the script if an error happens
#set -e

#First,check the current storage(disk) info if it is default...
#echo "kvm-mem-default.sh retCode:$?"

trap - ERR

sh kvm-storage-info-default.sh
retCode=$?

echo "---------kvm-storage-info-default.sh retCode:$retCode"

trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="KVM Test:The current storage(disk) info is  default.Begin to test [add new storage]"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:The current storage(disk) info is not default!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


#Begin to test storage(disk)  [add new storage]
echo "KVM storage test:[add new storage] "

trap - ERR

sh kvm-storage-add-opt.sh
retCode=$?
echo "---------kvm-storage-add-opt.sh retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="KVM Test:[add new storage] success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="KVM Test:[add new storage] failed!Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

