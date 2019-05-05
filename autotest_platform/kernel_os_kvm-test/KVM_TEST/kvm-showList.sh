#!/bin/bash

#Function:show the current KVM List
#The user can read the current KVM List by the sh file

#set -e
#------------------------------
cmdStr=''
kvmName=''
xmlName="${kvmName}.xml"
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:showKVMList .End------------------------------------"
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
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

cmdStr="KVM Test:showKVMList.Begin---------------------------------"
echo $cmdStr

write_log "INFO" $cmdStr

#kvm_list=$(virsh list --all|grep fedora21|awk '{print $2}')
#kvm_list=`virsh list --all|awk '{print $2}'|xargs echo | cut -d" " -f2-`
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
echo "kvm_list:$kvm_list"
write_log "INFO" "All the existed KVM Machine:${kvm_list}"
cmdStr="All the existed KVM Machine:${kvm_list}"
echo $cmdStr

#kvm_list=''

#kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`

#echo "Now,the current KVM List:$kvm_list"
