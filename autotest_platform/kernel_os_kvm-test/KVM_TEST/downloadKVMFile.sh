#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
#----------------------------------------------------------------
#-------------------------------
cmdEndStr="KVM Test:DownLoad the system log from KVM Begin----------------------------"
KVMIP=''
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
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:DownLoad the system log from KVM Begin----------------------------"


sh ping-kvm.sh

if [ "$?" == "0" ]; then
  cmdStr="the kvm IP can be route,you need not scan the KVM IP"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  echo "The KVM IP is DOWN or Not Found the KVM IP,and now ,the KVM IP will be found..."
  sh getKVMIP.sh
fi

#sh getKVMIP.sh
KVMIP=$(cat /home/$kvmName.IP)

echo "KVMIP:$KVMIP"

kvmLogDir="${kvmName}_LOG"

if [ ! -d $kvmLogDir ];then
  mkdir $kvmLogDir || exit 1
fi
cmdStr="Directory:$kvmLogDir created,you can read the kvm system log here..."
echo $cmdStr
write_log "INFO" "${cmdStr}"

echo "kvmLogDir:$kvmLogDir"

cmdStr="Now the system log from KVM:$kvmName is being downloaded..."
echo $cmdStr
write_log "INFO" "${cmdStr}"

expect scpFromRemote.exp $KVMIP root loongson /var/log/boot.log $kvmLogDir >/dev/null 2>&1
#expect scpFromRemote.exp $KVMIP root loongson /var/log/messages $kvmLogDir >/dev/null 2>&1


cmdStr="KVM log download complete."
echo $cmdStr
write_log "INFO" "${cmdStr}"

