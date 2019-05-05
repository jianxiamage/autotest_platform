#!/bin/bash

#set -e
#------------------------------
cmdStr=''
kvmName='fedora21-1'
xmlName="${kvmName}.xml"
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:create .End------------------------------------"
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
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM create:create.Begin---------------------------------"

#kvm_list=$(virsh list --all|grep fedora21|awk '{print $2}')
#kvm_list=`virsh list --all|awk '{print $2}'|xargs echo | cut -d" " -f2-`
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
echo "kvm_list:$kvm_list"
write_log "INFO" "All the existed KVM Machine:${kvm_list}"


#==========================================================================
if [ -z $kvmName ];then
  cmdStr="kvmName:$kvmName is null!You may not give it.Please check it.Exit"
  echo $cmdStr
  write_log "Error" "${cmdStr}"
  exit
fi
if [ -z $kvm_list ];then
  cmdStr="Now,No KVM exists.You can create new"
  echo $cmdStr
  write_log "INFO" "$cmdStr"
else
  #check the name of KVM  if exists
#  checkStr=$(checkKVMExists "$kvm_list" "$kvmName")
#  if [ $checkStr == 'YES' ];then
#    cmdStr="Found the KVM:${kvmName} existed!Now,delete it to create new "
#    echo ${cmdStr}
#    write_log "INFO" "${cmdStr}"
#    #remove the current existed KVM
#    virsh undefine $kvmName
#  elif [ $checkStr == 'NO' ];then
#    #Not Fonud the KVM existed
#    cmdStr="Create new KVM:${kvmName} Begin."
#    echo ${cmdStr}
#    write_log "INFO" "${cmdStr}"
#  else
#    cmdStr="Unknown Error.You may need to check Fun:checkKVMExists Parameter."
#    echo ${cmdStr}
#    write_log "ERROR" "${cmdStr}"
#    exit
#  fi

  retNameExists=$(NameExists $kvmName  $kvm_list)
  if [ $retNameExists == 'Yes' ];then
    cmdStr="Found the KVM:${kvmName} existed!Now,delete it to create new "
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
    #remove the current existed KVM

    #Check the state of KVM (关机,running)
    if virsh domstate $kvmName |grep -q "关闭";then
	 cmdStr="KVM:$kvmName is poweroff,you can delete it now..."
	 echo $cmdStr
	 write_log "INFO" "${cmdStr}"
    elif virsh domstate $kvmName |grep -q "running";then
	 cmdStr="$kvmName is running,you can shutdown it first..."
	 echo ${cmdStr}
	 write_log "INFO" "${cmdStr}"
	 #sleep 5s
	 cmdStr="$kvmName is shutting down..."
	 echo ${cmdStr}
	 write_log "INFO" "${cmdStr}"
	 virsh shutdown $kvmName
	 sleep 5s
    else 
         cmdStr="The state of KVM:$kvmName is unnormal,check the kvm if exists"
	 echo $cmdStr
	 write_log "ERROR" "${cmdStr}"    
         exit 1
    fi
    cmdStr="Begin to delete KVM:${kvmName}..."
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
    virsh undefine $kvmName
  else
    #Not Fonud the KVM existed
    cmdStr="Create new KVM:${kvmName} Begin."
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
  fi

fi
#=========================================================================

#Modify the xml of KVM to create a new KVM

xmlName="${kvmName}.xml"
\cp -f templet.xml ${xmlName}
#sed -i "s/fedora21/${kvmName}/g" ${xmlName}
sed -i.bak "s/fedora21/${kvmName}/" ${xmlName}

echo $xmlName >> TempFile.list
echo $xmlName.bak >> TempFile.list

trap - ERR

diff ${xmlName} "${xmlName}.bak" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  cmdStr="${xmlName} modify kvmName failed,Exit"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit
else
  cmdStr="${xmlName} modify kvmName success"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi

trap 'exit_err $LINENO $?'     ERR


virsh define ${xmlName}

#=========================================================================
#kvm_list=$(virsh list --all|grep ${kvmName}|awk '{print $2}')
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`

#check the name of KVM  if exists
retNameExists=$(NameExists $kvmName  $kvm_list)
if [ $retNameExists == 'Yes' ];then
    cmdStr="KVM:${kvmName} created success "
    echo ${cmdStr}
    write_log "INFO" "${cmdStr}"
else
    #Not Fonud the KVM existed
    cmdStr="KVM:${kvmName} created failed!"
    echo ${cmdStr}
    write_log "WARN" "${cmdStr}"
    exit 1
fi

##########################################################################
#In the end,delete the temp xml files except templet.xml
#ls *.xml|grep -v templet.xml|xargs rm


#write_log "INFO" "KVM Test:create .End------------------------------------"
