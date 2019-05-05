#!/bin/sh
set -e
set -x

retCode=0

#### download loongnix iso
echo "Check for the iso before remotely downloading...."
#First,remove the old iso file
rm -f loongnix-*.iso
wget --spider ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/Fedora-MATE-KVM-BUILD48.iso 
retCode=$?
if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(iso) on the remote web server,please check it!"
   exit ${retCode}
fi

wget -c ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/Fedora-MATE-KVM-BUILD48.iso
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download the iso from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi


####downlaod the last kvm kernel
#First,remove the old file.log
rm -f file.log
echo "Check for the file.log before remotely downloading...."
wget --spider ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/file.log
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(file.log) on the remote web server,please check it!"
   exit ${retCode}
fi

wget -c ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/file.log
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download file.log from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi


result=$(cat file.log)
echo "result="$result
rm -rf file.log

wget --spider ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$result
retCode=$?
if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(${result}) on the remote web server,please check it!"
   exit ${retCode}
fi

wget -c ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$result
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download ${result} from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi

#Before decompressing, delete the old directory:result
rm -rf result/

tar xvf $result
rm -rf $result
cd result
tar xvf kernel-kvm-guest*
cd ..
cp ./result/boot/kvm-guest-vmlinuz ./
\cp -darf ./result/usr ./

#####begin to build qcow2
#First,remove the existed dirs
rm -rf {iso,squashfs,ext3,rootfs,guestiso,newsquashfs,initrdkvm}

mkdir {iso,squashfs,ext3,rootfs,guestiso,newsquashfs,initrdkvm} || :

#turn off auto mount
systemctl stop udisks2.service

mount -o loop Fedora*.iso iso
mount -t squashfs iso/LiveOS/squashfs.img squashfs
mount -o loop squashfs/LiveOS/ext3fs.img ext3


###### build new ext3fs.img

truncate -s 8G loongnix.img
#echo -e "n\np\n1\n\n\nw\nq\n" | fdisk loongnix.img > /dev/null 2>&1
#dd if=/dev/zero of=loongnix.img count=8000000
# add Primary and swap partitions
#echo -e "n\np\n1\n\n+8G\nn\np\n2\n\n\nw\n" | fdisk loongnix.img > /dev/null 2>&1

sleep 1
echo y|mkfs.ext3 loongnix.img

#LOOP_DEV=$(losetup -f loongnix.img --show)
#kpartx -a ${LOOP_DEV}
#LOOP_PART="${LOOP_DEV#/dev/}p1"
#sleep 1
#echo y|mkfs.ext3 /dev/mapper/${LOOP_PART}
mount loongnix.img rootfs
#mount /dev/mapper/${LOOP_PART} rootfs
#echo "Now,wait about 10 minutes to copy file system........."
rsync -pogAXtlHrDx ext3/* rootfs/

# copy guest kernel
\cp -r kvm-guest-vmlinuz rootfs/boot/vmlinuz-3.10.0-7.fc21.loongson.kvmguest.mips64el
#\cp -darf usr/lib/modules/3.10.0+/* rootfs/usr/lib/modules/3.10.0-7.fc21.loongson.kvmguest.mips64el/
\cp -darf usr rootfs/
#\cp -darf usr/lib/firmware/* rootfs/usr/lib/firmware/

sync

umount -d rootfs
#kpartx -d $LOOP_DEV
mv loongnix.img ext3fs.img

##### build new squashfs.img

rsync -pogAXtlHrDx --exclude "ext3fs.img" squashfs/* newsquashfs/
# copy ext3fs.img
\cp -draf ext3fs.img newsquashfs/LiveOS/
mksquashfs newsquashfs squashfs.img

# begin build iso
rsync -pogAXtlHrDx --exclude "squashfs.img" iso/* guestiso/
\cp -draf squashfs.img guestiso/LiveOS/

#umount -d /media/root/*

# update initrdkvm.img file
cp iso/boot/initrdkvm.img initrdkvm/
cd initrdkvm
/usr/lib/dracut/skipcpio *.img | zcat | cpio -imd
rm -rf initrdkvm.img
\cp -darf ../usr ./
find .| cpio -o -H newc|gzip -9 > initrdkvm.img
cd ..
\cp -r kvm-guest-vmlinuz guestiso/boot/vmlinuz.kvm
\cp -r initrdkvm/initrdkvm.img guestiso/boot/initrdkvm.img

mkisofs -V Fedora-MATE -r -o Fedora-MATE-GUEST.iso guestiso/

umount ext3
umount squashfs
umount iso
losetup -D
echo "systemctl start udisks2.service"
systemctl start udisks2.service

set +x
set +e
