#!/bin/bash 	

#----------------------------------------------------------------------------------
source ./kvm-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:Install loongnix-test-release.Begin--------------------------"

#check loongnix-test-release if exists 
yum list installed |grep loongnix-test-release

if [ $? -eq 0 ]; then
  cmdStr="loongnix-test-release has been installed,update new version..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  yum update loongnix-test-release
  #if check? TODO
else
  cmdStr="loongnix-test-release Not installed.Now,begin to install..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  yum install loongnix-test-release && yum makecache
  #if check? TODO
fi


#check the test source if exists
rpm -qa | grep loongnix-test-release


if [ $? -eq 0 ]; then
  cmdStr="loongnix-test-release has been installed(updated) successfully."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="loongnix-test-release installed failed.Exit..."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
fi

write_log "INFO" "KVM Test:Install loongnix-test-release.End--------------------------"

