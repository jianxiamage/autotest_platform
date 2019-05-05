#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
cpuCount=''
cpuInputNum=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:View the cpu info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: View the cpu info of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

#First,set the cpu info to default(cpus:2)
sh kvm-cpu-default.sh
echo "kvm-cpu-default.sh retCode:$?"

#Init the cpu info(current:1,Max:4)
sh kvm-cpu-init-1to4.sh
echo "kvm-cpu-init-1to4.sh retCode:$?"

#Begin to test cpu add
echo "KVM cpu test:add 2 cpu (cpu config:current->1,Max:4)"
virsh setvcpus $kvmName 3

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

#Now,shutdown the KVM
sh kvm-enableShutdown.sh

#Waiting for the KVM to shut down
echo "Waiting for the KVM to shut down..."
sleep 5s

#Now,Start the KVM
sh kvm-enableStart.sh

#Waiting for the machine to start
echo "Waiting for the machine to start..."
sleep 5s


#After restarting the virtual machine, the CPU information is restored to the configuration before modification
echo "Now,begin to check:After restarting the KVM,whether the cpu info is restored to the configuration before modification"

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

