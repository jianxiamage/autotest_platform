#!/bin/sh

#get the kernel fullname from dir:/boot
kernelPath=`find /boot -name "vmlinuz*kvmhost.mips64el"`
echo "kernelPath:${kernelPath}"
kernelName=${kernelPath##*/boot/}
echo "kernekName:${kernelName}"

#get the oldkernel fulname from file:pmon-ref.std
oldkernelPath=`grep  "vmlinuz" pxe-ref.std`
echo "oldkernelPath:${oldkernelPath}"
oldkernelNameLeft=${oldkernelPath##*/boot/}
oldkernelName=${oldkernelNameLeft%%root*}
echo "oldkernel Length:${#oldkernelName} "
oldkernelName=`echo $oldkernelName | sed 's/ //g'`
echo "after trim oldkernel Length:${#oldkernelName}"
echo "oldkernelName:${oldkernelName}"

#change new version of kernel to pxe-ref.std
sed -i "s/${oldkernelName}/${kernelName}/g" pxe-ref.std
#sed -i "s#vmlinuz#xyz#g" pmon-ref.std

