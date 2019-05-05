#!/bin/bash


cmdStr=''
pmonBootFile="/boot/boot.cfg.tmp"
pxeBootFile="/boot/grub.cfg.tmp"
#kunlun: /boot/EFI/BOOT/grub.cfg
#UEFI: /boot/efi/EFI/BOOT/grub.cfg
#kunlun and UEFI are both created softlink file /boot/grub.cfg
pmonStd="pmonStd.file"
pxeStd="pxeStd.file"

pxeItem="menuentry 'Loongnix-kvm-host'"
PMONItem="title 'Loongnix-kvm-host'"
#-------------------------------
source ./kvm-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log

#-------------------------------
#-------------------------------

function getKernelName()
{
   #get the kernel fullname from dir:/boot
   #kernelPath=`find /boot -name "vmlinuz*kvmhost.mips64el"`
   kernelName=`ls /boot|grep  "^vmlinuz-.*kvmhost.mips64el"`
   echo "${kernelName}" 
}

function getStdKerName()
{
   if [ $# -ne 1 ];then
    echo "usage:getStdkerName StdKerName"
    return
   fi

   local StdKerName=`egrep -o "vmlinuz-.*kvmhost.mips64el"  $1`
   echo ${StdKerName}
}


#-------------------------------
function setPMON()
{
   #getKernelName
   kernelName=$(getKernelName)
   if [ -z "$kernelName" ];then
      cmdStr="Find kernel Name from dir:/boot is null,exit"
      write_log "WARN" "${cmdStr}"
      return
   fi

   cmdStr="current kernekName:[${kernelName}]"
   echo "${cmdStr}" 
   write_log "INFO" "${cmdStr}"

   #Get Kernel Name from:pmonStd.file
   oldkernelName=$(getStdKerName $pmonStd)
#   oldkernelName=""
   if [ -z "$oldkernelName" ];then 
      cmdStr="Kernel Name from ${pmonStd} is null,exit"
      write_log "WARN" "${cmdStr}"
      return
   fi
   cmdStr="Kernel Name from ${pmonStd} is:[${oldkernelName}]"
   echo "${cmdStr}"
   write_log "INFO" "${cmdStr}"

   #change new version of kernel to pmonStd.file.tmp
   pmonStdtmp=${pmonStd}".tmp"
   \cp -f $pmonStd $pmonStdtmp && echo "copy ${pmonStd} success" || echo  "copy ${pmonStd} failed!"
   #sed "s/${oldkernelName}/${kernelName}/g"  ${pmonStd} > ${pmonStdtmp}
   sed -i.bak "s/${oldkernelName}/${kernelName}/g" ${pmonStdtmp}

   echo $pmonStdtmp >> TempFile.list
   echo $pmonStdtmp.bak >> TempFile.list

   diff $pmonStdtmp "${pmonStdtmp}.bak" >/dev/null 2>&1
   if [ $? == 0 ]; then
     cmdStr="replace new kernel name to $pmonStdtmp failed!"
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
     return
     #if failed,exit function(return)
   else
     cmdStr="replace new kernel name to $pmonStdtmp success"
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
   fi

   #Add start menu item to boot file
   #pmonStdtmpStr=`cat $pmonStdtmp`
   #sed -i '/showmenu 1/s/$/"\n${pmonStdtmpStr}"/g' ${pmonBootFile}
   sed -i  "/showmenu 1/r ${pmonStdtmp}" ${pmonBootFile}

   #check append boot item
   tmpStr=$(cat $pmonStdtmp)
   grep -o "$tmpStr" $pmonBootFile >/dev/null 2>&1
   if [ $? == 0 ]; then
     cmdStr="Add kvm boot item success."
     #echo $cmdStr
     write_log "INFO" "${cmdStr}"
     echo ${cmdStr}
   else
     cmdStr="Add kvm boot item failed!"
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
     return
   fi

   #delete the temp files (delete them by trap,so the next line need not)
   #rm -f {$pmonStdtmp,$pmonStdtmp.bak}

}

function setPxe()
{
   #getKernelName
   kernelName=$(getKernelName)
   #kernelName=""
   if [ -z "$kernelName" ];then
      cmdStr="Find kernel Name from dir:/boot is null,exit"
      write_log "WARN" "${cmdStr}"
      return
   fi

   cmdStr="current kernekName:[${kernelName}]"
   echo "${cmdStr}" 
   write_log "INFO" "${cmdStr}"


   #Get Kernel Name from:pxeStd.file
   oldkernelName=$(getStdKerName $pxeStd)
   if [ -z "$oldkernelName" ];then
      cmdStr="Kernel Name from ${pxeStd} is null,exit"
      write_log "WARN" "${cmdStr}"
      return
   fi
   cmdStr="Kernel Name from ${pxeStd} :[${oldkernelName}]"
   echo "${cmdStr}"
   write_log "INFO" "${cmdStr}"

   #change new version of kernel to pxeStd.file.tmp
   pxeStdtmp=${pxeStd}".tmp"
   #sed "s/${oldkernelName}/${kernelName}/g"  ${pxeStd} > ${pxeStdtmp}

   \cp -f $pxeStd $pxeStdtmp && echo "copy ${pxeStd} success" || echo  "copy ${pxeStd} failed!"
   sed -i.bak "s/${oldkernelName}/${kernelName}/g" ${pxeStdtmp}

   echo $pxeStdtmp >> TempFile.list
   echo $pxeStdtmp.bak >> TempFile.list
  

   diff $pxeStdtmp "${pxeStdtmp}.bak" >/dev/null 2>&1
   if [ $? == 0 ]; then
     cmdStr="replace new kernel name to $pxeStdtmp failed!"
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
     return
   else
     cmdStr="replace new kernel name to $pxeStdtmp success"
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
   fi



   #Add start menu item to boot file
   #sed -i  "/### BEGIN \/etc\/grub.d\/10_linux ###/r ${pxeStdtmp}" ${pxeBootFile}

   sed -i  "/### BEGIN \/etc\/grub.d\/10_linux ###/r ${pxeStdtmp}" ${pxeBootFile}

   #check append boot item
   tmpStr=$(cat $pxeStdtmp)
   grep -o "$tmpStr" $pxeBootFile >/dev/null 2>&1
   if [ $? == 0 ]; then
     cmdStr="Add kvm boot item success."
     #echo $cmdStr
     write_log "INFO" "${cmdStr}"
     echo ${cmdStr}
   else
     cmdStr="Add kvm boot item failed!"
     echo $cmdStr
     write_log "ERROR" "${cmdStr}"
     return
   fi

   #delete the temp files (delete them by trap,so the next line need not)
   #rm -f {$pxeStdtmp,$pxeStdtmp.bak}

}

#Delete the old kvm boot items
function checkBootItem()
{

   if [ $# -ne 2 ];then
     echo "usage:checkBootItem itemStr,BootFile"
     return
   fi

   itemStr="$1"
   BootFile="$2"
   echo "itemStr:$itemStr"
   #itemStr="menuentry 'Loongnix-kvm-host'"
   #grep -o "menuentry 'Loongnix-kvm-host'" $pxeBootFile >/dev/null 2>&1
   grep -o "$itemStr" $BootFile >/dev/null 2>&1
   if [ $? == 0 ]; then
     #sed -i "/menuentry 'Loongnix-kvm-host'/,+2d" $pxeBootFile
     sed -i "/$itemStr/,+2d" $BootFile
     cmdStr="Found old kvm boot item,it will be deleted."
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
   else
     cmdStr="Not found old kvm boot item,the new kvm boot item will be added."
     echo $cmdStr
     write_log "INFO" "${cmdStr}"
   fi


}


#=========================================================================

function NameExists()
{
  local ExistsFlag="No"
  name="$1"
  nameArray="$2"
  for item in ${nameArray[@]}
  do
    if [ "$item" == "$name" ];then
      ExistsFlag="Yes"
      echo $ExistsFlag
      return
    fi
  done
  echo $ExistsFlag
}

