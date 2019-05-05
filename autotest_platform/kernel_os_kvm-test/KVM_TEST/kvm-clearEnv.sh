#!/bin/bash

#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:delete KVM.End------------------------------------"
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
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------
source ./common-fun-tar.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------

function checkKVMStatToShut()
{
    write_log "INFO" "checkKVMStatShut Begin---------------------------"
    local kvmName=$1
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
        echo "====================${kvmName}开始关机==================="
        virsh shutdown $kvmName

        sleep 5s

        echo "====================${kvmName}关机完成==================="

        if virsh domstate $kvmName |grep -q "关闭";then
            cmdStr="KVM:$kvmName is poweroff."
            echo ${cmdStr}
            write_log "INFO" "${cmdStr}"
        else
            cmdStr="$kvmName is not shutdown normally,Begin to force shutdown..."
            echo ${cmdStr}
            write_log "ERROR" "${cmdStr}"
            sh kvm-forced-shutdown.sh
            return 
        fi

    else
        cmdStr="Please check the KVM:${kvmName} being existed or not"
        echo ${cmdStr}
        write_log "WARN" "${cmdStr}"
        return 
    fi
    write_log "INFO" "checkKVMStatShut End---------------------------"

}
#----------------------------------------------------------------------------------

cmdStr="KVM Test: Clean the kvm Environment.Begin---------------------------------."
echo $cmdStr
write_log "INFO" "$cmdStr"

#kvm_list=`virsh list --all|awk '{print $2}'|xargs echo | cut -d" " -f2-`
kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`

echo "All the current KVM:${kvm_list}"
write_log "INFO" "All the current KVM:${kvm_list}"

echo "======================================================================"
#echo "kvm_list:$kvm_list"
arrayKVM=($kvm_list)
#echo "arrayKVM:${arrayKVM[@]}"
echo "KVM count:${#arrayKVM[*]}"
#echo "======================================================================="
#echo "The current KVM count kvm count not array:${#kvm_list[@]}"
#echo "The current kvm_list-str is:$kvm_list"
#echo "The current kvm_list-array is:${kvm_list[@]}"
echo "======================================================================="
#============================================================================

if [ -z "${kvm_list}" ];then
  cmdStr="Now,No KVM exists.The current environment is clean."
  echo $cmdStr
  write_log "INFO" "$cmdStr"
  exit 
else

    kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
    retStat=''
    nameArray=($kvm_list)
    kvmNum=0
    for item in ${nameArray[@]}
    do
        let kvmNum+=1
        echo "kvmNum:$kvmNum"
        #checkKVMStatToShut "$item"
        sh kvm-enableShutdown-sel.sh $item
        echo "kvmName:$item"
        #echo "kvmName:[$item],retStat is:${retStat}=========================="

        #delete the kvm
        cmdStr="Delete the KVM:${item}..."
        echo "$cmdStr"
        write_log "INFO" "$cmdStr"

        virsh undefine $item

        cmdStr="kvmNum:[$kvmNum], kvmName:${item} is deleted."
        echo "$cmdStr"
        write_log "INFO" "$cmdStr"

    done

fi


#===========================================================================

kvm_list=`virsh list --all|awk '{print $2}'|awk 'NR>1'|xargs echo`
if [ -z "${kvm_list}" ];then
  cmdStr="Now,No KVM exists.The current environment is clean."
  echo $cmdStr
  write_log "INFO" "$cmdStr"
  exit 0
else
  cmdStr="Error,The current environment is not clean.Delete the old kvm failed,Please check it!"
  echo $cmdStr
  write_log "ERROR" "$cmdStr"
  exit 1
fi


cmdStr="KVM Test: Clean the kvm Environment.End---------------------------------."
echo $cmdStr
write_log "INFO" "$cmdStr"

#============================================================================

#In the end,delete the temp xml files except templet.xml(May not use)
#ls *.xml|grep -v templet.xml|xargs rm

#write_log "INFO" "KVM Test:delete KVM.End------------------------------------"
