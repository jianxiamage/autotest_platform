#/bin/bash

#----------------------------------------------------------------
kvmName=fedora21-1
MacAddress=''
cmdStr=''
#----------------------------------------------------------------
#-------------------------------
cmdEndStr="KVM Test:Find the KVM IP.End------------------------------------"
retIP=''
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

write_log "INFO" "KVM Test:Find the KVM IP Begin---------------------------------"

trap - ERR

sh ping-kvm.sh

if [ "$?" == "0" ]; then
  cmdStr="the kvm IP can be route,you need not scan the KVM IP"
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  KVMIP=$(cat /home/$kvmName.IP)
  echo "KVMIP:$KVMIP"

  cmdStr="Found the IP:$KVMIP (KVM:${kvmName})"
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
  exit 0
#else
  #echo "$site is DOWN or Not Found the KVM IP,and now ,the KVM IP will be found..."
  #sh getKVMIP.sh
fi

trap 'exit_err $LINENO $?'     ERR

#clear the current arp cache
arp -n|awk '/^[1-9]/{print "arp -d  " $1}'|sh -x

#check if the kvm is starting up
#if yes,find the current Mac Address
#virsh dumpxml fedora21 | grep mac
MacAddress=`virsh dumpxml $kvmName | grep -w "mac"|grep -w mac |awk -F "/>" '{print $1}'|awk -F "=" '{print $2}'| tr -d "'"|head -n 1`
echo "MacAddress:$MacAddress"
#Check the state of KVM (关机,running)
if virsh domstate $kvmName |grep -q "关闭";then
   cmdStr="$kvmName is poweroff,you must start it to test"
   echo $cmdStr
   write_log "WARNING" "${cmdStr}"
   exit 1
elif virsh domstate $kvmName |grep -q "running";then
  cmdStr="$kvmName is running,please wait a moment to create new arp cache..."
  echo ${cmdStr}
  write_log "INFO" "${cmdStr}"
  #call the pingTest.py to get new arp cache
  python pingTest.py
else
  cmdStr="Please check the KVM:${kvmName} being existed or not"
  echo ${cmdStr}
  write_log "ERROR" "${cmdStr}"
  exit 1
fi


echo "MacAddress:$MacAddress"

arp -a

#arp -a | grep -i 52:54:00:FA:61:75
#Attention:the following cmd may not be OK,then exit
retIP=`arp -a|grep -i ${MacAddress}|grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"`
#retIP=`arp -a|grep -i "${MacAddress}" `
echo $retIP > /home/${kvmName}.IP
echo "retIP:$retIP"

cmdStr="Found the IP:$retIP (KVM:${kvmName})"
echo ${cmdStr}
write_log "INFO" "${cmdStr}"

