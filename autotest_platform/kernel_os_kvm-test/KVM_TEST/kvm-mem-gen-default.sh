#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="KVM Test:Set the default memory info of the KVM End----------------------------"
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

write_log "INFO" "KVM Test: Set the default memory info of the KVM Begin----------------------------"

#Exit the script if an error happens
#set -e

#check the current memory size if it is 2G
trap - ERR

sh kvm-mem-gen-info-advanced.sh 2048
retCode=$?

echo "=====kvm-mem-gen-info-advanced.sh retCode:$retCode"
trap 'exit_err $LINENO $?'     ERR

############################################################################
#if [ $retCode -eq 0 ]; then
#  cmdStr="The current memory size is 2G,No need to reset."
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#  exit 0
#elif  [ $retCode -eq 1 ]; then
#  cmdStr="kvm-mem-gen-info-advanced.sh has no parameter.Please check it!"
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#  exit 1
#elif  [ $retCode -eq 2 ]; then
#  cmdStr="kvm-mem-gen-info-advanced.sh parameter is wrong!.Please check it!"
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#  exit 2
#else
#  cmdStr="The current memory size is not 2G,Begin to reset..."
#  echo $cmdStr
#  write_log "INFO" "${cmdStr}"
#fi

############################################################################
#There are many branches in judgment.So use case mode...
case $retCode in
0)
    cmdStr="The current memory size is 2G,No need to reset."
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 0
    ;;

1)
    cmdStr="kvm-mem-gen-info-advanced.sh has no parameter.Please check it!"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 1

    ;;
2)
    cmdStr="kvm-mem-gen-info-advanced.sh parameter is wrong!.Please check it!"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 2

    ;;

3)
  cmdStr="The current memory size is not 2G,Begin to reset..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"

    ;;
*)
    cmdStr="Error:Unknown Error.Please check it!"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 3
    ;;
esac

#Begin to reset the configuration to default.First,shutdown the KVM
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

memSetStr="  <currentMemory unit='KiB'>2097152</currentMemory>"

echo "The default memory info should be set to:"
echo "-------------------------------------"
echo "$memSetStr"
echo "-------------------------------------"

echo "Begin to check if the current memory configuration is default..."

if [ "$line" == "$memSetStr" ];then
  cmdStr="${xmlName}:Now the memory info is default,No need to reset.Exit..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  exit 0
else
  cmdStr="${xmlName}:Now,the memory info is not default,set to default begin..."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
fi   


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
  exit 1
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
sleep 5s

#check the default memory info 
sh kvm-mem-gen-info.sh
