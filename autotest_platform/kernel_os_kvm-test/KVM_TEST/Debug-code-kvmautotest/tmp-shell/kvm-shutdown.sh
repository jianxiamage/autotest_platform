#!/bin/bash

#------------------------------
#logDir=$HOME/KVM-Test.log
cmdStr=''
kvmName='fedora21'
#-------------------------------
source /home/sh.config
logFile=$logFile
echo $logFile
write_log=$write_log

write_log FATAL "something error" log.txt


cmdStr='当前所有kvm虚拟机状态:'
echo $cmdStr >> $logFile
virsh list --all >> $logFile
kvm_list=$(virsh list --all|grep fedora21|awk '{print $2}')
echo ${kvm_list[@]} 
if echo "${kvm_list[@]}" | grep -w ${kvmName} &>/dev/null; then
    echo "Find the kvm machine:${kvmName}" >> ${logFile}
else
    echo "kvm machine:${kvmName} Not Found,exit" >> ${logFile}
    exit 1
fi

if virsh domstate $kvmName |grep -q "关机";then

   cmdStr='$kvmName 已经关机，要测试关机，请先将其开机'
   echo $cmdStr >> $logFile
   virsh start $kvmName
elif virsh domstate $kvmName |grep -q "running";then
  virsh shutdown $kvmName
else
  echo "异常情况，请确认虚拟机$kvmName 是否存在"
  exit 1
fi
sleep 10s
if virsh domstate $kvmName |grep -q "关机";then
   echo "$kvmName 已正常关机" >> $logFile
else
   echo "$kvmName 出现异常，未正常关机,请重新测试" >> $logFile
   exit 1
fi




 




