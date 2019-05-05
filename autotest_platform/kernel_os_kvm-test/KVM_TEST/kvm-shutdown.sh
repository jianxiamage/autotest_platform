#!/bin/bash

#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:shutdown.End------------------------------------"
retNameExists='No'
#---------------------------------------------------------------------------------
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
#----------------------------------------------------------------------------------
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:shutdown.Begin---------------------------------"

#kvm_list=$(virsh list --all|grep fedora21|awk '{print $2}')
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
#echo ${kvm_list[@]}#kvm list
write_log "INFO" "All of the KVM:$kvm_list"

#================================================================================

if [ -z "$kvmName" ];then
  cmdStr="kvmName:$kvmName is null!You may not give it.Please check it.Exit"
  echo $cmdStr
  write_log "Error" "${cmdStr}"
  exit 1
fi

#Find the KVM machine to test
if [ -z "$kvm_list" ];then
  cmdStr="Now,No KVM exists.Exit..."
  echo $cmdStr
  write_log "INFO" "$cmdStr"
  exit 1
else
  #if echo "${kvm_list[@]}" | grep -w ${kvmName} &>/dev/null; then
  retNameExists=$(NameExists $kvmName  $kvm_list)
  echo "retNameExists:$retNameExists"
  if [ $retNameExists == 'Yes' ]; then
     cmdStr="Found the kvm Machine:$kvmName"
     echo ${cmdStr}
     write_log "INFO" "${cmdStr}"
  else
     cmdStr="Not Fonud the kvm Machine:$kvmName,Exit..."
     echo ${cmdStr}
     write_log "INFO" "${cmdStr}"
     exit 1
  fi

fi

#================================================================================

#Check the state of KVM (关机,running)
if virsh domstate $kvmName |grep -q "关闭";then
   cmdStr="$kvmName is poweroff,you should start it now"
   echo $cmdStr
   write_log "WARN" "${cmdStr}"
   cmdStr="KVM:$kvmName is starting up."
   echo ${cmdStr}
   write_log "INFO" "${cmdStr}"
   virsh start $kvmName

   sleep 5s
   if virsh domstate $kvmName |grep -q "running";then
      cmdStr="$kvmName is running,you can test [shutdown] next."
      echo ${cmdStr}
      write_log "INFO" "${cmdStr}"
   else
      cmdStr="$kvmName is not shutdown normally"
      echo ${cmdStr}
      write_log "ERROR" "${cmdStr}"
      exit 1
   fi

elif virsh domstate $kvmName |grep -q "running";then
  cmdStr="$kvmName is running,you can test [shutdown] directly now."
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Please check the KVM:${kvmName} being existed or not"
  echo ${cmdStr}
  write_log "WARN" "${cmdStr}"
  exit 1
fi

#Test: KVM shutdown

cmdStr="KVM:$kvmName is shutting down..."
echo ${cmdStr}
write_log "INFO" "${cmdStr}"
virsh shutdown $kvmName

sleep 5s
if virsh domstate $kvmName |grep -q "关闭";then
   cmdStr="$kvmName shutdown success."
   echo ${cmdStr}
   write_log "INFO" "${cmdStr}"
else
   cmdStr="$kvmName shutdown unnormally!Exit"
   echo ${cmdStr}
   write_log "WARN" "${cmdStr}"
   exit 1
fi

#write_log "INFO" "KVM Test:shutdown.End------------------------------------"
