#!/bin/bash

#---------------------------------------------------------------------------------
cmdStr=''
boardinfo="/proc/boardinfo"
pmonBootFile="/boot/boot.cfg"
pxeBootFile="/boot/grub.cfg"
#kunlun: /boot/EFI/BOOT/grub.cfg
#UEFI: /boot/efi/EFI/BOOT/grub.cfg
#kunlun and UEFI are both created softlink file /boot/grub.cfg
#----------------------------------------------------------------------------------

cmdEndStr="KVM Test:kvm install(Modify bootfile).End----------------------------"
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
setPMON=$setPMON
setPxe=$setPxe
checkBootItem=$checkBootItem
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:kvm install(Modify bootfile).Begin--------------------------"

#backup the boot file:(boot.cfg or grub.cfg)

if [ ! -f "$boardinfo" ]; then
 cmdStr="File:${boardinfo} is not existed,you should check you os,exit"
 write_log "WARN" "${cmdStr}"
 exit 1
fi

boardVersion=`grep "Version" ${boardinfo} |awk '{print $NF}'`
cmdStr="The Board Version is: ${boardVersion}"
write_log "INFO" "${cmdStr}"

[[ $boardVersion =~ "PMON" ]] && echo "$boardVersion contains PMON" || echo "$boardVersion not contains PMON"

if [[ $boardVersion =~ "PMON" ]];then
   cmdStr="The The main board Version belongs to PMON"
   echo "${cmdStr}"
   write_log "INFO" "${cmdStr}"
   if [ ! -e "$pmonBootFile" ]; then
     cmdStr="${pmonBootFile} is not existed,you should check you os,exit"
     write_log "WARN" "${cmdStr}"
     exit 1
   fi
   \cp -f $pmonBootFile $pmonBootFile.old
   checkBootItem "$PMONItem" "$pmonBootFile"
   setPMON

else
   cmdStr="The motherboard model does not belong to PMON"
   echo "${cmdStr}"
   write_log "INFO" "${cmdStr}"
   if [ ! -e "$pxeBootFile" ]; then
     cmdStr="${pxeBootFile} is not existed,you should check you os,exit"
     write_log "WARN" "${cmdStr}"
     exit 1
   fi
   \cp -f $pxeBootFile $pxeBootFile.old
   #echo "ret:$?==========================================="
   #exit 1
   checkBootItem "$pxeItem" "$pxeBootFile"
   setPxe

fi


#write_log "INFO" "KVM Test:kvm install(Modify bootfile).End-------------------------"
