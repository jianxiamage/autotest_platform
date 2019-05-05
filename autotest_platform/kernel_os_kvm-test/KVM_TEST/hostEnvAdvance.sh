#!/bin/bash

#set -e
#------------------------------
cmdStr=''
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:Check host environment for test.End------------------------------------------------------"
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

write_log "INFO" "KVM Test:Check host environment for test.Begin----------------------------------------------------"

#=========================================================================================================

cmdStr="Check whether the sshd service is started and set it to boot automatically Begin------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


retStat=`systemctl status sshd| grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`

if [ "$retStat" == "running" ];then
   cmdStr="sshd is running"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

   cmdStr="Set ssh service to boot automatically."
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
   systemctl enable sshd

else
   cmdStr="sshd is not running!"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

   cmdStr="Now,start the sshd and set ssh service to boot automatically !"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
   systemctl start sshd
   systemctl enable sshd
fi

cmdStr="Check whether the sshd service is started and set it to boot automatically End--------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#=========================================================================================================
#First install test repo(loongnix-test-release),and then update the firewalld to the latest version

cmdStr="Install loongnix-test-release---------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"

yum install loongnix-test-release -y  && yum makecache

cmdStr="Install loongnix-test-release End.----------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#after loongnix-test-release installed,update firewalld(for a bug of firewalld,maybe cannot connect to net)

cmdStr="yum install firewalld Begin-----------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#yum update firewalld -y
yum install firewalld -y

cmdStr="yum install firewalld End.------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"

#==========================================================================================================

cmdStr="Check whether the firewalld service is started and set it to boot automatically Begin-------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


retStat=`systemctl status firewalld| grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`

if [ "$retStat" == "running" ];then
   cmdStr="firewalld is running!"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

   cmdStr="Set firewalld service to boot automatically."
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
   systemctl enable firewalld

else
   cmdStr="firewalld is not running"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"

   cmdStr="Now,start the sshd and set firewalld service to boot automatically!"
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
   systemctl start firewalld
   systemctl enable firewalld
fi

cmdStr="Check whether the firewalld service is started and set it to boot automatically End---------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"

#==========================================================================================================

cmdStr="yum install expect Begin--------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#yum update firewalld -y
yum install expect -y

cmdStr="yum install expect End.---------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"

#==========================================================================================================
cmdStr="yum install sysstat Begin--------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#yum update firewalld -y
yum install sysstat -y

cmdStr="yum install sysstat End.---------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"

#write_log "INFO" "KVM Test:host environment for test.End---------------------------------"
