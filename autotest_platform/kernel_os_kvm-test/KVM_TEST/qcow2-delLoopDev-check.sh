#!/bin/bash


LOOP_DEV=$(losetup -a)
echo -e "LOOP_DEV:\n${LOOP_DEV}"

echo "--------------------------------------------------------------"

qcow2LoopLine=$(losetup -a|grep loongnix.img)
echo "qcow2 Loop Device:${qcow2LoopLine}"

echo "--------------------------------------------------------------"

#LOOP_PART="${LOOP_DEV#/dev/}p1"
qcow2_Loop="${qcow2LoopLine%%:*}"
echo "qcow2_Loop:${qcow2_Loop}"

echo "--------------------------------------------------------------"

mountArray=(ext3 squashfs iso)

for dir in ${mountArray[@]}
do
   echo "check Dir："${dir}
   sh check-mount.sh $dir
   if [ $? -eq 0 ]; then
      echo "Dir:${dir} is mounted,it will be umounted..."
      umount ${dir}
   fi

done

echo "--------------------------------------------------------------"

LOOP_DEV=$(losetup -a)
echo -e "LOOP_DEV:\n${LOOP_DEV}"

qcow2_Loop="${qcow2LoopLine%%:*}"
echo "qcow2_Loop:${qcow2_Loop}"

FSMount=rootfs
if [ -z "${qcow2_Loop}" ];then
  cmdStr="Now,No Loop device exists."
  echo $cmdStr
  #exit 0
else
  #umount rootfs
  sh check-mount.sh ${FSMount}

  if [ $? -eq 0 ]; then
     echo "Dir:${FSMount} is mounted,it will be umounted..."
     umount ${FSMount}
  fi

  kpartx -d ${qcow2_Loop}
  echo "qcow2_Loop:${qcow2_Loop}"
fi

echo "--------------------------------------------------------------"

losetup -D

#Finally check if Loop devices exists..
echo "Check if there are loopback devices not uninstalled..."
umountLoopDev=$(losetup -a)
#echo "unmount Loop Device:${umountLoopDev}"

if [ -z "$umountLoopDev" ];then
  cmdStr="Now,There is no Loop Devices existed,all the mounted devices are umounted successfully."
  echo "${cmdStr}"
else
  echo "unmount Loop Device:${umountLoopDev}"
  cmdStr="Error,unmount Loop Device:${umountLoopDev}.Please check it!"
  echo "${cmdStr}"
  exit 1
fi

#=========================================================================
#echo "Umount Loop Devices Finished."
#umount rootfs
#kpartx -d ${qcow2_Loop}
#
#
#umount ext3
#umount squashfs
#umount iso
#losetup -D
#=========================================================================
