#/bin/bash

#----------------------------------------------------------------
kvmName=fedora21-1
MacAddress=''
cmdStr=''
#----------------------------------------------------------------
#-------------------------------
cmdEndStr="KVM Test:Upload stablity-scp-BigFile.sh to KVM End----------------------------"
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

write_log "INFO" "KVM Test:Upload stablity-scp-BigFile.sh to KVM Begin----------------------------"

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

cmdStr="KVMIP:$KVMIP Found"
echo $cmdStr
write_log "INFO" "${cmdStr}"


cmdStr="Now the file:stablity-scp-BigFile.sh will be uploaded to the KVM:$kvmName ..."
echo $cmdStr
write_log "INFO" "${cmdStr}"

#expect scp2Remote.exp $KVMIP root loongson testRemoteSh.sh /home >/dev/null 2>&1
expect scp2Remote.exp $KVMIP root loongson stablity-scp-BigFile.sh /home


cmdStr="The file:stablity-scp-BigFile.sh uploadeded completely."
echo $cmdStr
write_log "INFO" "${cmdStr}"

