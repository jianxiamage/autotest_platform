#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
cpuInputNum=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Set the init value(2to3) to cpu info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: Set the init value(2to3) to cpu info of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

#First,shutdown the KVM
sh kvm-enableShutdown.sh

#Waiting for the KVM to shut down
echo "Waiting for the KVM to shut down..."
sleep 5s

#Begin to modify the kvm xml file to init configuration

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

#Set cpu count:current->1,Max->4
echo "Set cpu count:current->1,Max->4"
#vcpuSetStr="<vcpu placement='static' current='3'>4</vcpu>"
vcpuSetStr="  <vcpu placement='static' current='3'>4</vcpu>"

echo "The cpu info should be set to:"
echo "-------------------------------------"
echo "$vcpuSetStr"
echo "-------------------------------------"

echo "Begin to check if the current cpu configuration is init value..."

if [ "$line" == "$vcpuSetStr" ];then
  cmdStr="${xmlName}:Now the cpu info is init value,No need to reset.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"

  #Start the KVM
  sh kvm-enableStart.sh

  #Waiting for the machine to start
  echo "Waiting for the machine to start..."
  sleep 5s

  cpuInputNum=3
  sh kvm-cpu-info.sh $cpuInputNum

  exit 0
else
  cmdStr="${xmlName}:Now,the cpu info is not init value,set to init value begin..."
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
  cmdStr="${xmlName}:set to init value config failed,Exit"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit
else
  cmdStr="$xmlName:set to init value config success"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi

rm -f ${xmlFullPath}.bak
#trap 'exit_err $LINENO $?'     ERR

#Make the cpu configuration effective 
virsh define $xmlFullPath

#======================================================================================
#No matter you need to reset the XML file, 
#the following code should be executed without any further error.
#======================================================================================

#Start the KVM
sh kvm-enableStart.sh

#Waiting for the machine to start
echo "Waiting for the machine to start..."
sleep 5s

cpuInputNum=3
sh kvm-cpu-info.sh $cpuInputNum
