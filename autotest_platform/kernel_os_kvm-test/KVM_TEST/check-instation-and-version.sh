#!/bin/bash

tarfile="/root/KVM-INSTALL-TAR-DIR/Kvmtest-From-Gerrit-Build*"
kernelhostfile="/boot/kvm-host-vmlinuz"
kernelguestfile="/boot/kvm-guest-vmlinuz"
qemufile="/usr/bin/qemu-system-mips64el"
libvirtfile="/usr/sbin/libvirtd"
echo "$kernelhostfile
$qemufile
$libvirtfile" > ./checkfile
#$kernelguestfile
tarballdate=`basename $tarfile | cut -d '-' -f 5`
tarballtime=`basename $tarfile | cut -d '-' -f 6 | cut -d '.' -f 1`

tarballseconds=`date -d "${tarballdate:0:4}-${tarballdate:4:2}-${tarballdate:6:2} ${tarballtime:0:2}:${tarballtime:2:2}:${tarballtime:4:2}" +%s`

# set 30 minites as the same version cycle
let tarballmaxtime=$tarballseconds+1800

echo "********************************************************"
echo "**********checking instation is or not success**********"
echo "********************************************************"
#date -d "2019-1-17 19:26:11" +%s
#date -d "2019-1-17 19:33:48" +%s
for file in `cat ./checkfile`;do
if [ -f "$file" ];then
	echo "$file exist,instation successful!!!"
else
	echo "$file not exist,instation failled!!!"
	exit 1	
fi
done

echo "********************************************************"
echo "******checking instation is or not current version******"
echo "********************************************************"
for file in `cat ./checkfile`;do
filedate=`ls -l --time-style '+%Y-%m-%d %H:%M:%S' $file |cut -d ' ' -f 6`
filetime=`ls -l --time-style '+%Y-%m-%d %H:%M:%S' $file |cut -d ' ' -f 7`
fileseconds=`date -d "$filedate $filetime" +%s`
if [ $tarballmaxtime -ge $fileseconds ];then
	if  [ $tarballseconds -le $fileseconds ];then
		echo "installed $file is the current tar version!"
	else
		echo "installed $file is older than current tar version!"
	fi
else
	echo "installed $file is newer than current tar version!"
fi
done
echo "********************************************************"
echo current tar version is $tarfile
echo "********************************************************"
#remove the tmp file
rm -f ./checkfile
