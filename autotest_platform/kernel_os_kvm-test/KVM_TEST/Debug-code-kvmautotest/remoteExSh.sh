#/bin/bash

#----------------------------------------------------------------
kvmName=fedora21-1
MacAddress=''
cmdStr=''
#----------------------------------------------------------------
#-------------------------------
cmdEndStr="KVM Test:x.sh End----------------------------"
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
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test: x.sh Begin----------------------------"

trap - ERR

sh ping-kvm.sh

if [ "$?" == "0" ]; then
  cmdStr="the kvm IP can be route,you need not scan the KVM IP"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
else
  echo "$site is DOWN or Not Found the KVM IP,and now ,the KVM IP will be found..."
  sh getKVMIP.sh
fi

trap 'exit_err $LINENO $?'     ERR

#sh getKVMIP.sh
KVMIP=$(cat /home/$kvmName.IP)

echo "KVMIP:$KVMIP"

cmdStr="Begin to excuete sh file:x.sh to test on KVM:$kvmName ..."
echo $cmdStr
write_log "INFO" "${cmdStr}"

#expect scpFromRemote.exp $KVMIP root loongson /var/log/messages $kvmLogDir >/dev/null 2>&1
#expect sshExecCmd.exp host username password shName

#cat << EOF >/home/test.sh
#echo "This is a test file"
#echo "When you see it,the remote bash file can work"
#EOF
#
#cat /home/test.sh


expect sshExecCmd.exp $KVMIP root loongson "/home/x.sh"

cmdStr="The test:x.sh on KVM:$kvmName is end normally."
echo $cmdStr
write_log "INFO" "${cmdStr}"

