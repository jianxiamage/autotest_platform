#/bin/bash

#----------------------------------------------------------------
kvmName=''
MacAddress=''
cmdStr=''
retCode=0
#----------------------------------------------------------------
#-------------------------------
cmdEndStr="KVM Test:Set login without password End----------------------------"
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

write_log "INFO" "KVM Test: Set login without password Begin----------------------------"

#You should remove the file ~/.ssh/known_hosts first,and it
#will avoid the errors like permission denied and so on.
rm -rf ~/.ssh/known_hosts

trap - ERR

sh ping-kvm.sh

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
  #exit 1
  sh getKVMIP.sh
fi

#trap 'exit_err $LINENO $?'     ERR

#sh getKVMIP.sh
KVMIP=$(cat /home/$kvmName.IP)

echo "KVMIP:$KVMIP"

cmdStr="Begin to  auto connect to KVM:$kvmName ..."
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


#expect sshExecCmd.exp $KVMIP root loongson "/home/x.sh"
#ssh-keygen -r rsa
#yes | ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
echo y |ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa  >/dev/null 2>&1
sleep 1s
./sshConnKVM.exp $KVMIP loongson >/dev/null 2>&1
sleep 1s
#-----------------------------------------------------
echo y |ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa >/dev/null 2>&1
sleep 1s
./sshConnKVM.exp $KVMIP loongson >/dev/null 2>&1
sleep 1s
#-----------------------------------------------------
cmdStr="Set ssh conn OK"
echo $cmdStr
write_log "INFO" "${cmdStr}"

