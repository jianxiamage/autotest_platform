#!/bin/bash

#set -e
#------------------------------
cmdStr=''
enpFile='enpxx0.std'
br0File='br0.std'
#-------------------------------
enpName=''
enpDEVICE=''
enpHWADDR=''
#-------------------------------
cmdEndStr="KVM Test:Set Bridge Environment.End------------------------------------------------------"
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

write_log "INFO" "KVM Test:Set Bridge Environment.Begin----------------------------------------------------"

#=======================================================================================================
#get the current NetWork Card information
#enpDEVICE=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g'|grep enp`
enpDEVICE=`ls /sys/class/net|grep enp|head -n 1`

#get MacAddress
#ifconfig enp7s0|grep ether|grep -o  "[a-f0-9A-F]\\([a-f0-9A-F]\\:[a-f0-9A-F]\\)\\{5\\}[a-f0-9A-F]"
enpHWADDR=`ifconfig $enpDEVICE|grep ether|grep -o  "[a-f0-9A-F]\\([a-f0-9A-F]\\:[a-f0-9A-F]\\)\\{5\\}[a-f0-9A-F]"`

device="DEVICE=${enpDEVICE}"

hwLine="HWADDR=${enpHWADDR}"

\cp -f $enpFile ${enpFile}.bak
\cp -f $br0File ${enpFile}.bak

sed -i "s/ DEVICE=enp7s0/${device}/" ${enpFile}.bak
sed -i "1 i\$hwLine" ${enpFile}.bak

cmdStr="set bridge environment Begin..."
echo $cmdStr
write_log "INFO" "${cmdStr}"

echo "set nic file..."
\cp -f  /etc/sysconfig/network-scripts/ifcfg-${enpDEVICE} /etc/sysconfig/network-scripts/ifcfg-${enpDEVICE}.bak
\cp -f  ${enpFile}.bak /etc/sysconfig/network-scripts/ifcfg-${enpDEVICE}

echo "set br0 file..."
\cp -f  ${enpFile}.bak /etc/sysconfig/network-scripts/ifcfg-br0

cmdStr="set bridge environment Finished.And now,you need reboot or restart the network service to enable bridge env."
echo $cmdStr
write_log "INFO" "${cmdStr}"


#TODO
#set GATEWAY???,DNS???



