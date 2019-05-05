#!/bin/bash


#set -e
#------------------------------
cmdStr=''
kvmName=''
#-------------------------------
cmdEndStr="KVM Test:search KVM IP.End----------------------------------------------"
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
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:search KVM IP.Begin------------------------------------"

trap - ERR

#Search KVM IP,If you fail, you have three more chances to try again.
sh getKVMIP.sh
retGetIP=$?

#trap - ERR

if [ $retGetIP -eq 0 ]; then
   cmdStr="Get the KVM IP success."
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
   exit 0
else
   cmdStr="Now,you have 3 more chances to try again..."
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
fi

retryTimes=0
retryCount=3
for i in {1..3}; do
    cmdStr="Get the KVM IP failed!Retry to get KVM IP from new ARP cache[${i}]..."
    echo $cmdStr

    sh getKVMIP.sh
    if [ $? -eq 0 ];then
        cmdStr="Get the KVM IP success."
        echo $cmdStr
        break
    else
        sleep 5s
        let retryTimes+=1
        echo $cmdStr

    fi

done

echo "Get KVMIP retryTimes is ${retryTimes}"

#Check retryTimes to mark if kvm start quickly(normally)
case ${retryTimes} in

#  0)
#    cmdStr='The retryTimes is:$retryTimes,Directly got KVM IP successfully.'
#    echo "${cmdStr}"
#    write_log "INFO" "${cmdStr}"
#    ;;
  0|1|2)
    cmdStr="The retryTimes is:${retryTimes}."
    echo "${cmdStr}"
    write_log "INFO" "${cmdStr}"
    ;;

  *)
    cmdStr="The retryTimes is:${retryTimes}.It is reached the maximum times!"
    echo "${cmdStr}"
    write_log "INFO" "${cmdStr}"

    ;;
esac

trap 'exit_err $LINENO $?'     ERR

if [ ${retryTimes} -ge ${retryCount} ];then
   echo "You have retried 3 times,but also can not get the KVM IP,Please Check the KVM if it is started correctly!"
   exit 1
fi
