#!/bin/sh
set -e
set -x

retCode=0

#### download loongnix iso
echo "Check for the iso before remotely downloading...."
#First,remove the old iso file
rm -f loongnix-*.iso
wget --spider http://ftp.loongnix.org/os/loongnix/1.0/liveinst/loongnix-20180930.iso
retCode=$?
if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(iso) on the remote web server,please check it!"
   exit ${retCode}
fi

wget -c http://ftp.loongnix.org/os/loongnix/1.0/liveinst/loongnix-20180930.iso
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
rm -rf {iso,squashfs,ext3,rootfs}

mkdir {iso,squashfs,ext3,rootfs} || :

#turn off auto mount
systemctl stop udisks2.service

mount -o loop loongnix*.iso iso
mount -t squashfs iso/LiveOS/squashfs.img squashfs
mount -o loop squashfs/LiveOS/ext3fs.img ext3

truncate -s 50G loongnix.img
#echo -e "n\np\n1\n\n\nw\nq\n" | fdisk loongnix.img > /dev/null 2>&1

# add Primary and swap partitions
echo -e "n\np\n1\n\n+15G\nn\np\n2\n\n+30G\nn\np\n3\n\n\nw\n" | fdisk loongnix.img > /dev/null 2>&1
echo -e "t\n3\n82\nw\nq\n" | fdisk loongnix.img > /dev/null 2>&1

LOOP_DEV=$(losetup -f loongnix.img --show)
kpartx -a ${LOOP_DEV}
LOOP_PART="${LOOP_DEV#/dev/}p1"
sleep 1
echo y|mkfs.ext4 /dev/mapper/${LOOP_PART}
mount /dev/mapper/${LOOP_PART} rootfs
echo "Now,wait about 17 minutes to copy file system........."
rsync -pogAXtlHrDx ext3/* rootfs/

# copy guest kernel
cp kvm-guest-vmlinuz rootfs/boot
\cp -darf usr rootfs/

# modify grub.cfg
cat > rootfs/boot/efi/EFI/BOOT/grub.cfg <<EOF
set default=0
set timeout=15
set menu_color_normal=white/black
set menu_color_highlight=yellow/black

menuentry 'Loongnix KVM GUEST'{
set root=(\${root})
linux /boot/kvm-guest-vmlinuz root=/dev/vda1 rw console=ttyS0 force_legacy=1
boot
}
EOF

# set passwd
cat > rootfs/set_pwd.sh <<EOF
#!/bin/bash
# set root passwd
echo "loongson" | passwd --stdin root

# add user: loongson
useradd loongson
echo "loongson" | passwd --stdin loongson

# enable sshd
ln -sf /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/sshd.service

rm -f \$0                                    
EOF
chmod +x rootfs/set_pwd.sh

chroot rootfs /set_pwd.sh

# set libvirtd
chroot rootfs yum remove libvirt -y

cat >rootfs/start_swap.sh <<EOF
#!/bin/bash
echo "/dev/vda3 swap swap defaults 0 0" >> /etc/fstab
rm -rf /usr/lib/systemd/system/libvirtd.servic*
rm -rf /usr/lib/systemd/system/virtlockd.socke*
rm -rf /usr/lib/systemd/system/virtlogd.socke*

EOF
chmod +x rootfs/start_swap.sh
chroot rootfs /start_swap.sh 

sync

umount -d rootfs

kpartx -d $LOOP_DEV

# convert raw -> qcow2
qemu-img convert -f raw loongnix.img -O qcow2 loongnix.qcow2

umount ext3
umount squashfs
umount iso
#umount -d /media/root/*
losetup -D
echo "systemctl start udisks2.service"
systemctl start udisks2.service
echo "begin to update new qcow2 file"
# begin to update qcow2 file
ftp -v -n 10.2.5.21 << EOF
user anonymous guest@unknown
binary
hash
cd tmp/Kvmtest-From-Gerrit-Build
rm -rf loongnix.qcow2
lcd /home/workspace/$JOB_NAME
put loongnix.qcow2

bye
EOF


set +x
set +e
