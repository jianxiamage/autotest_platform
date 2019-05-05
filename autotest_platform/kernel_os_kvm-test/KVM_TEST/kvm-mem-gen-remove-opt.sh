#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Remove 1G of the KVM  memory End----------------------------"
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

write_log "INFO" "KVM Test: KVM Test:Remove 1G of the KVM  memory Begin----------------------------"

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

#echo $xmlName >> TempFile.list
#echo $xmlName.bak >> TempFile.list

line=`sed -n "/currentMemory/p" $xmlFullPath`
#echo $line

echo "Now,the current configuration information of memory is:"
echo "-------------------------------------"
echo "$line"
echo "-------------------------------------"

#Set memory size:current->2G,current->1G
echo "remove memory:current->2G,current->1G"
memSetStr="  <currentMemory unit='KiB'>1048576</currentMemory>"

echo "The memory info should be set to:"
echo "-------------------------------------"
echo "$memSetStr"
echo "-------------------------------------"

if [ "$line" == "$memSetStr" ];then
  cmdStr="${xmlName}:Now the current value of memory is what we need,No need to reset.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  exit 0
else
  cmdStr="${xmlName}:Now,the current value of memory begin to set a new value for test..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi


echo "Begin to check if the current memory configuration is modified..."

sed -i.bak "s@${line}@${memSetStr}@g" ${xmlFullPath}
#sed -i "s${line}${memSetStr}g" ${xmlFullPath}

trap - ERR

diff ${xmlFullPath} "${xmlFullPath}.bak" >/dev/null 2>&1
retCode=$?
#echo "=====$retCode"
trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="${xmlName}:set to default config failed,Exit"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit
else
  cmdStr="$xmlName:set to default config success"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi

rm -f ${xmlFullPath}.bak
#trap 'exit_err $LINENO $?'     ERR

#Make the memory configuration effective 
virsh define $xmlFullPath


#Start the KVM
sh kvm-enableStart.sh

#Waiting for the machine to start
echo "Waiting for the machine to start..."
sleep 30s

