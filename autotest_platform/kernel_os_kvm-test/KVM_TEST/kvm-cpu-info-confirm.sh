#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
cpuCount=''
KvmModelName=''
hostModelName=''
KvmOSInfo=''
HostOSInfo=''
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

trap - ERR

echo "Connecting to the KVM:$kvmName..."
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
#echo '============================CPU INFO (cmd:lscpu)============================='
echo "Exec cmd:lscpu Begin..."
lscpu | tee cpuinfo.txt
#lscpu > cpuinfo.txt
echo "Exec cmd:lscpu End"
#echo "View the number of CPUs..."
#cat /proc/cpuinfo | grep "processor" | wc -l
#echo "-----------------------------------------------------------------"

#echo '============================CPU INFO (cmd:lscpu)============================='
echo "Login ssh Node, Test End..."

"

#Find cpu info on the host Machine:(型号名称)
lscpu > hostCpuinfo.txt

#---------------------------------------------------------------------------------

rm -f cpuinfo.txt
scp root@$KVMIP:cpuinfo.txt .

echo '==========================CPU INFO(KVM Model Name)==========================='
KvmModelName=`cat cpuinfo.txt|grep "型号名称"`
echo "KvmModelName:$KvmModelName"
echo '==========================CPU INFO(KVM Model Name)==========================='

#lscpu |grep "型号名称"|awk NR=5'{print $NR}'

echo '==========================CPU INFO(Host Model Name)==========================='
hostModelName=`cat hostCpuinfo.txt|grep "型号名称"`
echo "hostModelName:$hostModelName"
echo '==========================CPU INFO(Host Model Name)==========================='

echo '------------------------------------------------------------------------------'

echo '==================CPU INFO(KVM OS info from cpuinfo)=================='
KvmOSInfo=`cat cpuinfo.txt |grep "型号名称"|awk NR=5'{print $NR}'`
echo "KvmOSInfo:$KvmOSInfo"
echo '==================CPU INFO(KVM OS info from cpuinfo)=================='

#lscpu |grep "型号名称"|awk NR=5'{print $NR}'

echo '======================CPU INFO(Host Model Name)======================='
HostOSInfo=`cat hostCpuinfo.txt| grep "型号名称"|awk NR=5'{print $NR}'`
echo "HostOSInfo:$HostOSInfo"
echo '======================CPU INFO(Host Model Name)======================='

#---------------------------------------------------------------------------------

#Check model name form cpu info(compare hostModelName and KvmModelName)
if [ "$KvmOSInfo" == "$HostOSInfo"  ];then
  cmdStr="Check whether the OS version of the host machine and the KVM is the same.YES."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="ERROR:Check whether the OS version of the host machine and the KVM is the same.NO"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

