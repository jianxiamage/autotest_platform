#!/bin/bash
#-------------------------------
#cmdEndStr="KVM Test:start.End------------------------------------"
#retNameExists='No'
#----------------------------------------------------------------------------------
#source ./kvm-log.sh
#logFile=$logFile
#echo $logFile
#write_log=$write_log
#----------------------------------------------------------------------------------
#source ./exceptionTrap.sh
#exit_end=$exit_end
#exit_err=$exit_err
#exit_int=$exit_int
#----------------------------------------------------------------------------------
#source ./common-fun.sh
#NameExists=$NameExists
#----------------------------------------------------------------------------------
#trap 'exit_end "${cmdEndStr}"' EXIT
#trap 'exit_err $LINENO $?'     ERR
#trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------


write_log "INFO" "KVM Test:start.Begin---------------------------------"

#su root
yum install git -y

cd ~
 
git clone http://10.2.5.20:8081/p/qa/loongson-testsuite.git 
