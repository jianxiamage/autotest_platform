#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
diskCount=''
diskInputNum=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:View the storage(disk) info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: View the storage(disk) info of the KVM Begin----------------------------"
echo "Check default disk info of the KVM Begin..."

#Exit the script if an error happens
#set -e

#if [ $# -ne 1 ];then
#    echo "usage:kvm-disk-info.sh diskInputNum"
#    exit 1
#fi

#virsh dumpxml $kvmName >/dev/null 2>&1

trap - ERR

diskCount=`virsh dumpxml $kvmName | grep "<disk"|wc -l`

trap 'exit_err $LINENO $?'     ERR

if [  $diskCount -eq 1 ]; then
  cmdStr="The KVM has only 1 disk info.Continue..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:Maybe the KVM has not only 1 disk info or other error!Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#Start the KVM to test
sh kvm-enableStart.sh

#virsh domblklist $kvmName 

trap - ERR

virsh domblklist $kvmName |grep "vda"
retCode=$?

trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="The KVM has vda disk,it is default disk info,continue..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:The KVM has vda disk,it is not default disk info,Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


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
  #sh getKVMIP.shdd
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
#echo '============================Storage INFO (cmd:lsblk)============================='
echo "Exec cmd:lsblk Begin..."
lsblk | tee diskinfo.txt
#lsblk > diskinfo.txt
echo "Exec cmd:lsblk End"
#echo "View the number of disks.."
#echo '============================Storage INFO (cmd:lsblk)============================='
echo "Login ssh Node, Test End..."

"

rm -f diskinfo.txt
scp root@$KVMIP:diskinfo.txt .

#diskInputNum=$1

#Get the disk items and check it
#echo "======================Intercepting important Disk INFO======================="
#cat diskinfo.txt
#diskLines_a=`cat diskinfo.txt|grep "vda"`
#echo "diskLines_a:$diskLines_a"
#diskLines_b=`cat diskinfo.txt|grep "vdb"`
#echo "diskLines_b:$diskLines_b"
#echo "======================Intercepting important Disk INFO======================="

trap - ERR

cat diskinfo.txt|grep "vda"
retCode=$?

trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="The KVM has vda disk,it is default disk info,continue to check if other disk info exists..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  cmdStr="Error:The KVM has no vda disk,it is not default disk info,Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

trap - ERR

cat diskinfo.txt | grep "vdb"
retCode=$?

trap 'exit_err $LINENO $?'     ERR

if [  $retCode -eq 0 ]; then
  cmdStr="The KVM has vdb disk,it is default disk info.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  exit 1
else
  cmdStr="The KVM has no other disk except [vda],it is default disk info."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  cmdStr="Check default disk info success."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"

  exit 0
fi
