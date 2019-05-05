#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:View the memory info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: View the memory info of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

if [ $# -ne 1 ];then
    echo "usage:kvm-mem-gen-info-check.sh memInputNum"
    exit 1
fi


trap - ERR

sh connRemoteKVM.sh >/dev/null 2>&1
retCode=$?

trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
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


#check if the IP file exists
if [ -f /home/$kvmName.IP ];then
  echo "/home/$kvmName.IP exists"
else
  echo "/home/$kvmName.IP Not exists"
  echo "Not Found the KVM IP!exit..."
  exit 1
fi

#sh getKVMIP.sh
KVMIP=$(cat /home/$kvmName.IP)
echo "The current KVM IP:$KVMIP"

ssh -tt root@$KVMIP "
echo "Login ssh Node, Test Begin..."
echo "============================Memory INFO============================="
echo "Exec cmd:free -m Begin..."
free -m | tee mem-free.txt
echo "Exec cmd:free -m End"
#free -h
#echo 'cat /proc/meminfo'
#cat /proc/meminfo | grep "MemTotal"
#echo "-----------------------------------------------------------------"

echo "============================Memory INFO============================="
echo "Login ssh Node, Test End..."

"

scp root@$KVMIP:mem-free.txt .

memInputNum=$1

echo "The memInputNum is $memInputNum"
echo "The stdandard memory size is $memFree"

#check memory size(cmd:free -m)
memTotalSizeStr=`cat mem-free.txt|grep "Mem" | awk '{print $2}'`
echo "memory total size:$memTotalSizeStr"

memTotalSize=`echo "$memTotalSizeStr"| awk '{print int($0)}'`
echo "memTotalSize:$memTotalSize"

#memTotalSizeInt=`expr $memTotalSize / 1000`
memTotalSizeInt=`echo "scale=4;  $memTotalSize / 1000" | bc`

echo "memTotalSizeInt:$memTotalSizeInt"

#Begin to check the current memory size
memFreeMSize=`echo "$memTotalSizeInt" | awk '{printf("%0.f\n",$0)}'`

echo "memFreeMSize:$memFreeMSize"

#Convert memFree by memInputNum
case $memInputNum in
1)
    memFreeRef=1
    ;;
2)
    memFreeRef=2
    ;;

*)
    cmdStr="Your input parameter is wrong,please use[1|2]"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 2
    ;;
esac

if [ "$memFreeRef" == "$memFreeMSize"  ];then
  cmdStr="Check whether the memory size of the KVM is ${memInputNum}G.[YES]."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:Check whether the memory size of the KVM is ${memInputNum}G.[NO]."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


