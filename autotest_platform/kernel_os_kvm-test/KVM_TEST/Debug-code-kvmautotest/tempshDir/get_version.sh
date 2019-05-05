#!/bin/sh

boardVersion=`grep "Version" boardinfo |awk '{print $NF}'`
echo ${boardVersion}

[[ $boardVersion =~ "PMON" ]] && echo "$boardVersion contains PMON"

if [[ $boardVersion =~ "PMON" ]];then
   cmdStr="The board Version is PMON"
   echo "${cmdStr}"
else
   cmdStr="The board Version is not PMON"
   echo "${cmdStr}"
fi

#get the kernel fullname from dir:/boot
kernelPath=`find /boot -name "vmlinuz*kvmhost.mips64el"`
echo "kernelPath:${kernelPath}"
kernelName=${kernelPath##*/boot/}
echo "kernekName:${kernelName}"

#get the oldkernel fulname from file:pmon-ref.std
oldkernelPath=`grep  "vmlinuz" pmon-ref.std`
echo "oldkernelPath:${oldkernelPath}"
oldkernelName=${oldkernelPath##*/boot/}
echo "oldkernelName:${oldkernelName}"

#change new version of kernel to pmon-ref.std
sed -i "s/${oldkernelName}/${kernelName}/g" pmon-ref.std
#sed -i "s#vmlinuz#xyz#g" pmon-ref.std

var=$(cat pmon-ref.std)
echo ${var}
tag="showmenu 1"
cmd='/showmenu 1/a\\${var}'
sed -i "$cmd" boot.cfg

#sed -i "/showmenu 1/a\${var}" boot.cfg
#sed -i  '/showmenu 1/r pmon-ref.std' boot.cfg
echo $?


