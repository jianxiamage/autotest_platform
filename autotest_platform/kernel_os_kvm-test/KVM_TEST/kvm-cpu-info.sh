#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
cpuCount=''
cpuInputNum=0
cpuOnlineCur=''
cpuOnlineStr=''
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
echo "View the cpu info of the KVM Begin..."

#Exit the script if an error happens
#set -e

if [ $# -ne 1 ];then
    echo "usage:kvm-cpu-info.sh cpuInputNum"
    exit 1
fi


trap - ERR

echo "Connecting to the KVM:$kvmName..."
sh connRemoteKVM.sh >/dev/null 2>&1
retCode=$?

trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="Set auto login without password success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:Set auto login without password failed!Please check it!"
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
#echo '============================CPU INFO (cmd:lscpu)============================='
echo "Exec cmd:lscpu Begin..."
#lscpu | tee cpuinfo.txt
lscpu > cpuinfo.txt
echo "Exec cmd:lscpu End"
#echo "View the number of CPUs..."
#cat /proc/cpuinfo | grep "processor" | wc -l
#echo "-----------------------------------------------------------------"

#echo '============================CPU INFO (cmd:lscpu)============================='
echo "Login ssh Node, Test End..."

"

rm -f cpuinfo.txt
scp root@$KVMIP:cpuinfo.txt .

cpuInputNum=$1

#Get the cpu items and check it
echo "======================Intercepting important CPU INFO======================="
cpuCountLines=`cat cpuinfo.txt|grep "CPU(s)"`
echo "$cpuCountLines"
cpuOnline=`cat cpuinfo.txt|grep "在线 CPU 列表"`
echo $cpuOnline
echo "======================Intercepting important CPU INFO======================="
cpuCount=`cat cpuinfo.txt|grep "CPU(s)" |awk '{print $NF}'`
cpuOnlineCur=`cat cpuinfo.txt|grep "在线 CPU 列表" |awk '{print $NF}'`

#echo "cpuCount:$cpuCount"

#Check cpuCount[CPU(s)]
if [ "$cpuInputNum" == "$cpuCount"  ];then
  cmdStr="Check cpu count correct."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error: Check cpu count Error!The current count is:$cpuCount.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  exit 1
fi

#Convert cpuOnlineCount by cpuInputNum
case $cpuInputNum in
1)
    cpuOnlineStr='0'
    ;;
2)
    cpuOnlineStr='0,1'
    ;;
3)
    cpuOnlineStr='0-2'
    ;;
4)
    cpuOnlineStr='0-3'
    ;;

*)
    cmdStr="Your input parameter is wrong,please use[1|2|3|4]"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 2
    ;;
esac

#echo "cpuOnlineCur:$cpuOnlineCur"
#echo "cpuOnlineStr:$cpuOnlineStr"

#Check cpuOnlineCount[在线 CPU 列表:]
if [ "$cpuOnlineCur" == "$cpuOnlineStr"  ];then
  cmdStr="Check cpu Online count correct."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error: Check cpu Online count Error!The current count is:$cpuCountCur.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  exit 1
fi

