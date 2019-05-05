#!/bin/bash

#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:forced shutdown.End------------------------------------"
retNameExists='No'
#---------------------------------------------------------------------------------
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
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:forced shutdown.Begin---------------------------------"

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

  cmdStr="Now,$kvmName has been shut down"
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
  exit 0

elif virsh domstate $kvmName |grep -q "running";then
  cmdStr="$kvmName is running,you can [force to shutdown] directly now."
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
else
  cmdStr="ERROR:KVM state is unnormal!Please check it!"
  echo ${cmdStr}
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#Test: KVM shutdown

cmdStr="KVM:$kvmName is shutting down(forced)..."
echo ${cmdStr}
write_log "INFO" "${cmdStr}"
virsh destroy $kvmName

sleep 5s
if virsh domstate $kvmName |grep -q "关闭";then
   cmdStr="$kvmName shutdown success."
   echo ${cmdStr}
   write_log "INFO" "${cmdStr}"
else
   cmdStr="Error:$kvmName forced shutdown unnormally!Please check it!"
   echo ${cmdStr}
   write_log "ERROR" "${cmdStr}"
   exit 1
fi

#write_log "INFO" "KVM Test:shutdown.End------------------------------------"
