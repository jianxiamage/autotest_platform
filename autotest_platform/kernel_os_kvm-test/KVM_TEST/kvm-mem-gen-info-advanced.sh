#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Check the memory info of the KVM (gen) End----------------------------"
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

write_log "INFO" "KVM Test: Check the memory info of the KVM (gen) Begin----------------------------"

#Exit the script if an error happens
#set -e

if [ $# -ne 1 ];then
    echo "usage:kvm-mem-gen-info-advanced.sh memInputNum"
    exit 1
fi

memInputNum=$1

#check memInputNum
case $memInputNum in
1024)
    memSizeStr=1048576
    ;;
2048)
    memSizeStr=2097152
    ;;

*)
    cmdStr="Your input parameter is wrong,please use[1024|2048]"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 2
    ;;
esac

echo "=======================================$kvmName info [cmd:virsh dominfo]========================================"
virsh dominfo $kvmName |tee mem-gen-advanced.txt
echo "=======================================$kvmName info [cmd:virsh dominfo]========================================"

getMemSize=`cat mem-gen-advanced.txt|grep "使用的内存"|awk '{print $2}'`

echo "---------------------------------"
echo "Memory Size:${getMemSize} KiB"
echo "---------------------------------"


#check the memory size
if [ "$memSizeStr" == "$getMemSize"  ];then
  cmdStr="Check whether the memory size of the KVM is ${memInputNum}M.[YES]."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:Check whether the memory size of the KVM is ${memInputNum}M.[NO]."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 3
fi
