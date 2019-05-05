#!/bin/bash

#------------------------------
cmdStr=''
kvmName='fedora21-1'
#-------------------------------
cmdEndStr="KVM Test:delete KVM.End------------------------------------"
retNameExists='No'
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
trap 'exit_int'                INT
#----------------------------------------------------------------------------------
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
write_log "INFO" "KVM Test:delete KVM.Begin---------------------------------"

#kvm_list=`virsh list --all|awk '{print $2}'|xargs echo | cut -d" " -f2-`
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
#echo ${kvm_list[@]}#kvm list
write_log "INFO" "All the current KVM:${kvm_list}"


#============================================================================
#Find the KVM to test

if [ -z $kvmName ];then
  cmdStr="kvmName:$kvmName is null!You may not give it.Please check it.Exit..."
  echo $cmdStr
  write_log "Error" "${cmdStr}"
  exit
fi

if [ -z $kvm_list ];then
  cmdStr="Now,No KVM exists.Exit"
  echo $cmdStr
  write_log "ERROR" "$cmdStr"
  exit 1
else
#  if echo "${kvm_list[@]}" | grep -w ${kvmName} &>/dev/null; then
  retNameExists=$(NameExists $kvmName  $kvm_list)
  if [ $retNameExists == 'Yes' ]; then
     cmdStr="Found the kvm Machine:$kvmName,you can begin to test."
     echo ${cmdStr}
     write_log "INFO" "${cmdStr}"
  else
    cmdStr="Not Fonud the kvm Machine:$kvmName,Exit..."
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
    exit 1
  fi

fi


#============================================================================
#Check the state of KVM (关机,running)
if virsh domstate $kvmName |grep -q "关闭";then

   cmdStr="KVM:$kvmName is poweroff,you can delete it now..."
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
elif virsh domstate $kvmName |grep -q "running";then
  cmdStr="$kvmName is running,you can shutdown it..."
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
  #sleep 5s
  cmdStr="$kvmName is shutting down..."
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
  virsh shutdown $kvmName

  sleep 5s
  if virsh domstate $kvmName |grep -q "关闭";then
    cmdStr="KVM:$kvmName is poweroff."
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
  else
    cmdStr="$kvmName is not shutdown normally"
    echo ${cmdStr}
    write_log "WARN" "${cmdStr}"
    exit 1
  fi

else
  cmdStr="Please check the KVM:${kvmName} being existed or not"
  echo ${cmdStr}
  write_log "WARN" "${cmdStr}"
  exit 1
fi

#delete KVM
#virsh destroy $kvmName #force to shutdown
virsh undefine $kvmName

#kvm_list=`virsh list --all|awk '{print $2}'|xargs echo | cut -d" " -f2-`
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
#echo ${kvm_list[@]}
write_log "INFO" "After delete kvm,all the current KVM List:${kvm_list}"
#=============================================================================

#After delete KVM,Find the KVM if exists

if [ -z $kvm_list ];then
  cmdStr="Now,No KVM exists,delete KVM $kvmName success"
  echo $cmdStr
  write_log "INFO" "$cmdStr"
else
  
#  if echo "${kvm_list[@]}" | grep -w ${kvmName} &>/dev/null; then
  retNameExists='No'
  if [ $retNameExists == 'Yes' ]; then
      cmdStr="Found the kvm Machine:$kvmName,delete KVM failed!"
      echo ${cmdStr}
      write_log "ERROR" "${cmdStr}"
      #Test End......
      #exit 1
  else
    cmdStr="Not Fonud the kvm Machine:$kvmName,delete KVM success."
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
    #Test End.....
  fi

fi


#In the end,delete the temp xml files except templet.xml(May not use)
#ls *.xml|grep -v templet.xml|xargs rm

#write_log "INFO" "KVM Test:delete KVM.End------------------------------------"
