#/bin/bash

#----------------------------------------------------------------
kvmName=''
cmdStr=''
#----------------------------------------------------------------
cmdEndStr="KVM Test:KVM Start simple cmd test End----------------------------"
KVMIP=''
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
source ./common-fun-tar.sh
kvmName=$(getKVMName)
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:KVM Start simple cmd test Begin----------------------------"

trap - ERR

sh ping-kvm.sh

if [ "$?" == "0" ]; then
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

trap 'exit_err $LINENO $?'     ERR

#sh getKVMIP.sh
KVMIP=$(cat /home/$kvmName.IP)

echo "KVMIP:$KVMIP"

cmdStr="Begin to excuete a simple command to check the KVM:$kvmName is working..."
echo $cmdStr
write_log "INFO" "${cmdStr}"

#In order to avoid the problem:IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY,
#you should remove the file ~/.ssh/known_hosts first
rm -rf ~/.ssh/known_hosts

#expect scpFromRemote.exp $KVMIP root loongson /var/log/messages $kvmLogDir >/dev/null 2>&1
#expect sshExecCmd.exp host username password shName
expect sshExecCmd.exp $KVMIP root loongson "cd /home ; ls"

cmdStr="The KVM:$kvmName is working normally."
echo $cmdStr
write_log "INFO" "${cmdStr}"

