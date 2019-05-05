#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test: Add 1 storage of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: KVM Test:Add 1 of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

#First,shutdown the KVM
sh kvm-enableShutdown.sh

#Waiting for the KVM to shut down
echo "Waiting for the KVM to shut down..."
sleep 5s

#Begin to modify the kvm xml file to default configuration

xmlName="${kvmName}.xml"
xmlPath="/etc/libvirt/qemu/"
xmlFullPath=${xmlPath}${xmlName}

storageTempletFile="storageAddTemplet.xml"

qcow2File="${kvmName}.qcow2"
qcow2FileFullPath="/var/lib/libvirt/images/$qcow2File"

#echo $xmlName >> TempFile.list
#echo $xmlName.bak >> TempFile.list

#line=`sed -n "/currentMemory/p" $xmlFullPath`
#echo $line

#First,create qcow file to:/var/lib/libvirt/images/
trap - ERR

echo "Begin to create qcow2 file to /var/lib/libvirt/images ..."
rm -f $qcow2FileFullPath
qemu-img create -f qcow2 $qcow2FileFullPath 8G
retCode=$?
echo "=====qemu-img create retCode:$retCode"

trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="create qcow2 file success."
  #echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo ${cmdStr}
else
  cmdStr="Error:create qcow2 file failed!Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

echo "The KVM xml info should add:"
echo "-------------------------------------"
storageAddStr=`cat $storageTempletFile`
echo "$storageAddStr"
echo "-------------------------------------"

echo "Begin to add new starage info for the current KVM xml file..."

#sed -i "s${line}${memSetStr}g" ${xmlFullPath}

#It should add after the last </disk>
sed -i  "/<\/disk>/r ${storageTempletFile}" ${xmlFullPath}
#retCode=$?
#echo "retCode:$retCode"

trap - ERR

echo "Begin to check if the current KVM xml file is modified..."

diff ${xmlFullPath} "${xmlFullPath}.bak" >/dev/null 2>&1
retCode=$?
#echo "=====$retCode"
trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="${xmlName}:Add new storage info to the current KVM xml file failed,Exit..."
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit
else
  cmdStr="$xmlName:Add new stroage info to the current KVM xml success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi

rm -f ${xmlFullPath}.bak

trap - ERR

echo "Begin to check if the current KVM xml file is modified..."

grep -o "$storageAddStr" $xmlFullPath >/dev/null 2>&1
retCode=$?
#echo "=====grep added storage info:$retCode"

trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="Add storage info to KVM xml file success."
  #echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo ${cmdStr}
else
  cmdStr="Error:Add kvm storage info to KVM xml file failed!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#Make the memory configuration effective 
virsh define $xmlFullPath

#Start the KVM
sh kvm-enableStart.sh

#Waiting for the machine to start
echo "Waiting for the machine to start..."
sleep 30s
