#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
cpuInputNum=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:View the cpu info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: View the cpu info of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

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
echo '===========================================CPU INFO(active)============================================'
#echo "-----------------------------------------------------------------"
#echo "View the active info of CPUs..."

#cat /proc/cpuinfo | grep "processor" | wc -l
rm -rf active_cpuinfo.txt
#mpstat -P ON | tee "${kvmName}_active_cpuinfo"
#mpstat -P ON | tee active_cpuinfo.txt
cat /proc/stat | grep cpu |tee active_cpuinfo.txt
#echo "-----------------------------------------------------------------"

echo '===========================================CPU INFO(active)============================================'
echo "Login ssh Node, Test End..."

"

rm -f active_cpuinfo.txt

scp root@$KVMIP:active_cpuinfo.txt .


cpuInputNum=$1

#check active_cpuinfo whether the cpu count is cpuInputNum
#cpuCount=`sed -n '/all/,$p' active_cpuinfo.txt|awk 'NR>1'|wc -l`
cpuCount=`cat active_cpuinfo.txt|awk 'NR>1'|wc -l`
if [ "$cpuCount" == "$cpuInputNum" ]; then
  cmdStr="--------The current active cpu count is:$cpuInputNum.Test success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:--------The current active cpu count is not $cpuInputNum.Test failed!Please check it."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi




