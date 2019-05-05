#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:View the memory info of the KVM (ballon) End----------------------------"
KVMIP=''
retCode=0
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
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test: View the memory info of the KVM (ballon) Begin----------------------------"

#Exit the script if an error happens
#set -e

if [ $# -ne 1 ];then
    echo "usage:kvm-mem-ballon-info.sh memInputNum"
    exit 1
fi

#memSize=`virsh dommemstat fedora21-1|grep 'actual'|awk '{print $2}'`
memSizeLine=`virsh qemu-monitor-command fedora21-1 --hmp "info balloon"`
echo $memSizeLine
memSize=`echo $memSizeLine|awk -F"=" '{print $2}'`

echo "-----------get kvm memory size by cmd:virsh qemu-monitor-command--------------"
memSizeInt=`echo $memSize | awk '{print int($0)}'`
echo "memSizeInt:$memSizeInt"
echo "-----------get kvm memory size by cmd:virsh qemu-monitor-command--------------"

#Find a problem:memSizeLen is 5(it should be 4)
#echo $memSize > memSize.txt
#memSizeFromTxt=$(cat memSize.txt)
#echo "memSizeFromTxt:$memSizeFromTxt"
#echo "memSizeFromTxtLen:${#memSizeFromTxt}"
##echo "memSize:$memSize"|sed 's/[[:space:]]//g'
#echo "memSize:$memSize" | tr -d '[ \t]'
#echo "memSizeLen:${#memSize}"
#stdMemSize=2048
#echo "stdMemSizeLen:${#stdMemSize}"
#if [ "$memSize" == "$stdMemSize" ]; then

#stdMemSize=2048
stdMemSize=$1
memConv=''

echo "Given the current memory size is:${stdMemSize}MB."

if [ $stdMemSize -eq 2048 ]; then
  memConv="2G"
  echo "Need set to $memConv for test"
elif [ $stdMemSize -eq 1024 ]; then
  memConv="1G"
  echo "Need set to $memConv for test"
else
  memConv="Unknown"
  echo "Unknown size"
  cmdStr="Error:Unknown value to set memory.!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

echo "Check to see if the current memory size is:$memConv ..."

echo "=================================Memory Size===================================="
if [ $memSizeInt -eq $stdMemSize ]; then
  cmdStr="---------------------Memory Size is:$memConv"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo "=================================Memory Size===================================="
else
  cmdStr="Error:The current memory is not $memConv!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  echo "=================================Memory Size===================================="
  exit 1
fi
