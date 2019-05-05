#!/bin/bash

#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="Auto Test:InitTestEnv start.End------------------------------------"
#----------------------------------------------------------------------------------
source ./kernel_os_kvm-log.sh
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
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "Auto Test:InitTestEnv start.Begin---------------------------------"

#install git
yum install git -y


echo "======================================================="

echo "Now Begin to download testsuit..."

#chdir to ~
srcDir='/home/loongson'
#cd /home/loongson
cd $srcDir

#echo "Begin to download bash files..."

#rm -rf kvm-testsuite/
#git clone -b autotest http://10.2.5.20/cgit/kvm-testsuite.git

#download testsuite

#rm -rf loongnix-testsuite  || echo "delete loongnix-testsuite failed!";exit 1
rm -rf loongnix-testsuite

#if [ ! -d "$srcDir/loongnix-testsuite" ]; then
#  git clone http://10.2.5.20:8081/qa/loongnix-testsuite
#fi

git clone http://10.2.5.20:8081/qa/loongnix-testsuite

echo "Now  download testsuite End."

echo "Exec env.sh to download other test items Begin..."

cd $srcDir/loongnix-testsuite
sh env.sh

echo "Exec env.sh to download other test items End..."

echo "======================================================="

echo "Now Begin to install test-release"

#download test-release
yum install loongnix-test-release -y

echo "install test-release End"


echo "======================================================="


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


yum install sysstat -y

cmdStr="yum install sysstat End.---------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#==========================================================================================================
#update dhcp package to get static IP by Macaddress
yum makecache fast
yum update dhclient -y
#update firewalld package to fix ssh connection bug
yum update firewalld -y 
#start the sshd service and make it start when boot
systemctl start sshd
systemctl enable sshd

#start the firewalld,and make it start when boot
systemctl start firewalld
systemctl enable firewalld

#set current path to system Env
#echo "The old PATH env is:${PATH}"
#echo "set the current directory to system Environment variable"
#export PATH=.:$PATH >> ~/.bashrc  && source ~/.bashrc
#sed -i '$a\export PATH=.:$PATH' /etc/profile
#source /etc/profile
#echo "The new PATH env is:${PATH}"

echo "Now Test environment is ready,performance Test and Stability Test Begin..."
