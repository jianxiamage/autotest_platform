#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:View the memory info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: View the memory info of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

#Start the KVM(virsh dommemstat should be used when kvm is running)
sh kvm-enableStart.sh

memSize=`virsh dommemstat fedora21-1|grep 'actual'|awk '{print $2}'`

echo "Now,the current memory size is:$memSize"

if [ "$memSize" == "2097152" ]; then
  cmdStr="------Memory Size is:2G.Now,the memory size is default."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:------Memory size is not default(2G)!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi
