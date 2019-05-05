#!/bin/bash

cmdStr=''
pmonBootFile="/boot/boot.cfg"
pxeBootFile="/boot/grub.cfg"
#kunlun: /boot/EFI/BOOT/grub.cfg
#UEFI: /boot/efi/EFI/BOOT/grub.cfg
#kunlun and UEFI are both created softlink file /boot/grub.cfg
pmonStd="pmonStd-tar.file"
pxeStd="pxeStd-tar.file"

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
   #change new version of kernel to pmonStd.file.tmp
   pmonStdtmp=${pmonStd}".tmp"
   \cp -f $pmonStd $pmonStdtmp && echo "copy ${pmonStd} success" || echo  "copy ${pmonStd} failed!"
   #sed "s/${oldkernelName}/${kernelName}/g"  ${pmonStd} > ${pmonStdtmp}
   #Because new way to install kvm environment,kernel file has no version number,we can use the Standard file directly
   #sed -i.bak "s/${oldkernelName}/${kernelName}/g" ${pmonStdtmp}

   echo $pmonStdtmp >> TempFile.list
   #echo $pmonStdtmp.bak >> TempFile.list

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
   #change new version of kernel to pxeStd.file.tmp
   pxeStdtmp=${pxeStd}".tmp"
   #sed "s/${oldkernelName}/${kernelName}/g"  ${pxeStd} > ${pxeStdtmp}

   \cp -f $pxeStd $pxeStdtmp && echo "copy ${pxeStd} success" || echo  "copy ${pxeStd} failed!"
   #Because new way to install kvm environment,kernel file has no version number,we can use the Standard file directly
   #sed -i.bak "s/${oldkernelName}/${kernelName}/g" ${pxeStdtmp}

   echo $pxeStdtmp >> TempFile.list
   echo $pxeStdtmp.bak >> TempFile.list

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
     sed -i "/$itemStr/,+3d" $BootFile
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

function getKVMName()
{
  local kvm_name=""
  basepath=$(cd `dirname $0`; pwd)

  kvm_file_name=$basepath/kvmName.txt

  if [ -s $kvm_file_name ]; then
    kvm_name=`cat $basepath/kvmName.txt`
  else
    kvm_name="fedora21-1"
  fi

  echo $kvm_name
}

