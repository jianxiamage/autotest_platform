#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
cpuInputNum=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Set the default cpu info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: Set the default cpu info of the KVM Begin----------------------------"

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

line=`sed -n "/vcpu/p" $xmlFullPath`
#echo $line

echo "Now,the current configuration information of cpu is:"
echo "-------------------------------------"
echo "$line"
echo "-------------------------------------"

#vcpuSetStr="  <vcpu placement='static' current='1'>4</vcpu>"
vcpuSetStr="  <vcpu placement='static'>2</vcpu>"

echo "The default cpu info should be set to:"
echo "-------------------------------------"
echo "$vcpuSetStr"
echo "-------------------------------------"

echo "Begin to check if the current cpu configuration is default..."

if [ "$line" == "$vcpuSetStr" ];then
  cmdStr="${xmlName}:Now the cpu info is default,No need to reset.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  exit 0
else
  cmdStr="${xmlName}:Now,the cpu info is not default,set to default begin..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi   

#sed -i s/$vcpuSetStr/$line/g `grep 'vcpu' -rl $xmlFullPath`

sed -i.bak "s@${line}@${vcpuSetStr}@g" ${xmlFullPath}
#sed -i "s${line}${vcpuSetStr}g" ${xmlFullPath}

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

#Make the cpu configuration effective 
virsh define $xmlFullPath

#Start the KVM
sh kvm-enableStart.sh

#Waiting for the machine to start
echo "Waiting for the machine to start..."
sleep 30s

cpuInputNum=2
sh kvm-cpu-info.sh $cpuInputNum
