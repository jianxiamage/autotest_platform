#!/bin/bash

#set -e
#------------------------------
cmdStr=''
kvmName=''
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:create Test Dir and upload test file to kvm.End------------------------------------"
retNameExists='No'
retCode=0
#----------------------------------------------------------------------------------
source ./common-fun-tar.sh
kvmName=$(getKVMName)
xmlName="${kvmName}.xml"
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
#source ./common-fun.sh
source ./common-fun-tar.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:create Test Dir and upload test files to kvm.Begin---------------------------------"

echo "create Test Dir and upload test files to kvm.Begin---------------------------------"

srcHostDir='/root/KVM-SHELL-DIR/shell-file'
srcGuestDir='/root/KVM-TEST-DIR'

#sh getKVMIP.sh

trap - ERR

sh ping-kvm.sh
retCode=$?
trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="the kvm IP can be route,you need not scan the KVM IP"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:The KVM IP is DOWN or Not Found the KVM IP,Maybe the KVM is not started correctly!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
  #sh getKVMIP.sh
fi

#trap 'exit_err $LINENO $?'     ERR


KVMIP=$(cat /home/$kvmName.IP)
echo "The current KVM IP:$KVMIP"
echo "$KVMIP"
#create KVM-TEST-DIR on KVM
ssh -tt root@$KVMIP "
echo "Login ssh Node,create testFile Dir on KVM Begin..."
srcGuestDir='/root/KVM-Test-DIR/'

if [ ! -d "${srcGuestDir=}" ]; then
    echo "---------------------${srcGuestDir} Not Exists, build it----------------------------------"
    #mkdir /root/KVM-TEST-DIR 
    mkdir ${srcGuestDir}
    echo "-----------------------Create Dir:${srcGuestDir} success!---------------------------------"
else
    echo "----------------${srcGuestDir} is already existed,Now delete it to recreate new-----------"
    rm -rf ${srcGuestDir}
    mkdir ${srcGuestDir}
    echo "---------------------------Recreate Dir:${srcGuestDir} success!--------------------------"
fi

echo "Login ssh Node,create testFile Dir on KVM End..."

"

#scp testFiles to KVM

#scp /root/KVM-SHELL-DIR/shell-file/perform-* root@192.168.122.77:/root/KVM-TEST-DIR

#cmd="scp  $srcHostDir/perform-* root@${KVMIP}:$srcGuestDir"
#echo "cmd is:=============${cmd}==============="

trap - ERR

#kvm-downloadTestSuite.sh
echo "Begin to upload kvm-downloadTestSuite.sh..."
scp  $srcHostDir/kvm-downloadTestSuite.sh root@${KVMIP}:$srcGuestDir
if [ $? -ne 0 ]; then
    echo "upload kvm-downloadTestSuite.sh failed!exit..."
    exit 1
else
    echo "upload kvm-downloadTestSuite.sh success"
fi

#task_switch
echo "Begin to upload task_switch.sh..."
scp  $srcHostDir/task_switch.sh root@${KVMIP}:$srcGuestDir
if [ $? -ne 0 ]; then
    echo "upload task_switch.sh failed!exit..."
    exit 1
else
    echo "upload task_switch.sh success"
fi

#perform test files
echo "Begin to upload perform test files..."
scp  $srcHostDir/perform-* root@${KVMIP}:$srcGuestDir 
if [ $? -ne 0 ]; then
    echo "upload perform test files failed!exit..."
    exit 1
else
    echo "upload perform test files success"
fi

#stablity test files
echo "Begin to upload stablity test files..."
scp  $srcHostDir/stablity-* root@${KVMIP}:$srcGuestDir 
if [ $? -ne 0 ]; then
    echo "upload stablity test files failed!exit..."
    exit 1
else
    echo "upload stablity test files success"
fi

echo "create Test Dir and upload test files to kvm.End---------------------------------"
