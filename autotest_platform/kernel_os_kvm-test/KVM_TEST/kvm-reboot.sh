#!/bin/bash

#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:reboot.End------------------------------------"
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


write_log "INFO" "KVM Test:reboot.Begin---------------------------------"

#kvm_list=`virsh list --all|awk '{print $2}'|xargs echo | cut -d" " -f2-`
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
#echo ${kvm_list[@]}#kvm list
write_log "INFO" "All the current KVM :${kvm_list}"

#==================================================================================

#Find the KVM to test

if [ -z "$kvmName" ];then
  cmdStr="kvmName:$kvmName is null!You may not give it.Please check it.Exit"
  echo $cmdStr
  write_log "Error" "${cmdStr}"
  exit
fi

if [ -z "$kvm_list" ];then
  cmdStr="Now,No KVM exists,Exit..."
  echo $cmdStr
  write_log "INFO" "$cmdStr"
  exit 1
else
#  if echo "${kvm_list[@]}" | grep -w ${kvmName} &>/dev/null; then
  retNameExists=$(NameExists $kvmName  $kvm_list)
  if [ $retNameExists == 'Yes' ]; then
     cmdStr="Found the KVM:${kvmName}"
     echo ${cmdStr}
     write_log "INFO" "${cmdStr}"
  else
     cmdStr="Not Fonud the KVM:${kvmName},exit"
     echo ${cmdStr}
     write_log "INFO" "${cmdStr}"
     exit 1
  fi

fi

#=============================================================================
#Check the state of KVM (关机,running)
if virsh domstate $kvmName |grep -q "关闭";then

   cmdStr="$kvmName is poweroff,you will start it to test for reboot"
   echo $cmdStr
   write_log "WARNING" "${cmdStr}"
elif virsh domstate $kvmName |grep -q "running";then
  cmdStr="$kvmName is running.Begin to test [reboot]..."
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"

  trap - ERR

  sh kvm-reboot-opt.sh
  retCode=$?

  echo "=====kvm-reboot.sh retCode:$retCode"
  trap 'exit_err $LINENO $?'     ERR
  echo "===============================Test:[reboot] Result===================================="
  if [ $retCode -eq 0 ]; then
    cmdStr="Test for reboot success."
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    echo "===============================Test:[reboot] Result===================================="
    exit 0
  else
    cmdStr="Test for reboot failed.Please check it!"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    echo "===============================Test:[reboot] Result===================================="
    exit 1
  fi

else
  cmdStr="KVM:${kvmName} state is wrong.Please check it!"
  echo ${cmdStr}
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#Test: KVM start
cmdStr="KVM:${kvmName} is restarting..."
echo ${cmdStr}
write_log "INFO" "${cmdStr}"

virsh start $kvmName
#Mark,the state of KVM(on,off)
sleep 30s
if virsh domstate $kvmName |grep -q "running";then
   cmdStr="$kvmName is running.KVM:$kvmName start success"
   echo ${cmdStr}
   write_log "INFO" "${cmdStr}"
 
   trap - ERR

   sh kvm-reboot-opt.sh
   retCode=$?

   echo "=====kvm-reboot.sh retCode:$retCode"
   trap 'exit_err $LINENO $?'     ERR

else
   cmdStr="$kvmName is not started normally"
   echo ${cmdStr}
   write_log "ERROR" "${cmdStr}"
   exit 1
fi

echo "===============================Test:[reboot] Result===================================="
if [ $retCode -eq 0 ]; then
  cmdStr="Test for reboot success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo "===============================Test:[reboot] Result===================================="
  exit 0
else
  cmdStr="Test for reboot failed!Please check it!"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo "===============================Test:[reboot] Result===================================="
  exit 1
fi
#write_log "INFO" "KVM Test:start.End------------------------------------"
