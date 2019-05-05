#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
cpuCount=''
cpuInputNum=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:remove 1 cpu(4to3) of the KVM End----------------------------"
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

write_log "INFO" "KVM Test:remove 1 cpu(4to3) of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

#First,set the cpu info to default(cpus:2)
sh kvm-cpu-default.sh
echo "kvm-cpu-default.sh retCode:$?"

#Init the cpu info(current:1,Max:4)
sh kvm-cpu-init-1to4.sh
echo "kvm-cpu-init-1to4.sh retCode:$?"

#Begin add 4 cpus
echo "KVM cpu test:set cpu to 3(cpu config:current->1,Max:4)"
virsh setvcpus $kvmName 3

#wait 30s after cpu remove
echo "wait a moment to become effective..."
sleep 30s


trap - ERR

cpuInputNum=3
sh kvm-cpu-info.sh $cpuInputNum
retCode=$?
echo "---------retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="View CPU Information success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:View CPU Information failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#TODO:top to check active cpu info

trap - ERR

cpuInputNum=3
sh kvm-cpu-activeinfo.sh $cpuInputNum
retCode=$?
echo "kvm-cpu-activeinfo.sh retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="View active cpu info success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:View active cpu info failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

echo "=================add cpu to 3(1to3) End===================="

#Begin to test cpu remove
echo "KVM cpu test:set cpu to 1(3to1)"
virsh setvcpus $kvmName 1

#wait 30s after cpu remove
echo "wait a moment to become effective..."
sleep 30s


trap - ERR

cpuInputNum=1
sh kvm-cpu-info.sh $cpuInputNum
retCode=$?
echo "---------retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="View CPU Information success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:View CPU Information failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#TODO:top to check active cpu info

trap - ERR

cpuInputNum=1
sh kvm-cpu-activeinfo.sh $cpuInputNum
retCode=$?
echo "kvm-cpu-activeinfo.sh retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="View active cpu info success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:View active cpu info failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


##after test:reboot to check cpu info
##Now,shutdown the KVM
#sh kvm-enableShutdown.sh
#
##Waiting for the KVM to shut down
#echo "Waiting for the KVM to shut down..."
#sleep 5s
#
##Now,Start the KVM
#sh kvm-enableStart.sh
#
##Waiting for the machine to start
#echo "Waiting for the machine to start..."
#sleep 5s
#
#trap - ERR
#
#cpuInputNum=1
#sh kvm-cpu-info.sh $cpuInputNum
#retCode=$?
#echo "---------retCode:$retCode"
#trap 'exit_err $LINENO $?'     ERR
#
#if [  $retCode -eq 0 ]; then
#  cmdStr="View CPU Information success."
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#else
#  cmdStr="Error:View CPU Information failed!Please check it."
#  echo $cmdStr
#  write_log "ERROR" "${cmdStr}"
#  exit 1
#fi
#
##TODO:top to check active cpu info
#
#trap - ERR
#
#cpuInputNum=1
#sh kvm-cpu-activeinfo.sh $cpuInputNum
#retCode=$?
#echo "kvm-cpu-activeinfo.sh retCode:$retCode"
#trap 'exit_err $LINENO $?'     ERR
#
#if [  $retCode -eq 0 ]; then
#  cmdStr="View active cpu info success."
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#else
#  cmdStr="Error:View active cpu info failed!Please check it."
#  echo $cmdStr
#  write_log "ERROR" "${cmdStr}"
#  exit 1
#fi

