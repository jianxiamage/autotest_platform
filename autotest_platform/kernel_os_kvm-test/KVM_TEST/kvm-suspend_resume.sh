#!/bin/bash

#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:suspend and resume.End------------------------------------"
retNameExists='No'
retCode=0
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
source ./common-fun-tar.sh
#NameExists=$NameExists
kvmName=$(getKVMName)
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------


write_log "INFO" "KVM Test:suspend and resume.Begin---------------------------------"

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
#Test suspend

trap - ERR

sh kvm-suspend.sh
retCode=$?

echo "=====kvm-suspend.sh retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

echo "========================================================================"

if [ $retCode -eq 0 ]; then
  cmdStr="KVM Test:[suspend] success."
  echo $cmdStr
  echo "========================================================================"
  write_log "INFO" "${cmdStr}"
else
  cmdStr="KVM Test:[suspend] failed!Please check it!"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo "========================================================================"
  exit 1
fi
#=============================================================================
#Test resume

trap - ERR

sh kvm-resume.sh
retCode=$?

echo "=====kvm-resume.sh retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

echo "========================================================================"

if [ $retCode -eq 0 ]; then
  cmdStr="KVM Test:[resume] success."
  echo $cmdStr
  echo "========================================================================"
  write_log "INFO" "${cmdStr}"
else
  cmdStr="KVM Test:[resume] failed!Please check it!"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo "========================================================================"
  exit 1
fi

#echo "========================================================================"
cmdStr="KVM Test:[supend / resume] success."
echo $cmdStr
write_log "INFO" "${cmdStr}"
echo "========================================================================"
#=============================================================================

#write_log "INFO" "KVM Test:start.End------------------------------------"
