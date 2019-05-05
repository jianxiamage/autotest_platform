#!/bin/bash

#set -e

#0. check user
if [ ! ${UID} -eq 0 ]; then
	echo "Must be run as root!"
	exit 1
fi

#1. install the test source(loongnix-test-release)
#check the network is ok?
ping -c 1 114.114.114.114 > /dev/null 2>&1
if [ $? -eq 0 ];then
	echo 检测网络正常
else
	echo "-----------------------------"
	echo 检测网络连接异常
	echo "-----------------------------"
	exit 1
fi

yum install loongnix-test-release -y && yum makecache

#2. install depend rpms for tarball
yum install SDL2 autogen-libopts boost-system boost-thread brlapi brltty celt051 corosync corosynclib cyrus-sasl flite glusterfs glusterfs-api glusterfs-cli glusterfs-fuse glusterfs-libs gnutls-dane gnutls-utils libatomic_ops libcacard libfdt libibverbs libiscsi libnfs libqb librados2 librbd1 librdmacm libwsman1 lzop netcf-libs numad radvd sheepdog snappy spice-server tslib usbredir virglrenderer vte3 yajl libseccomp-devel -y

#3. install others rpms needed
#yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y
yum install libvirt-daemon virt-manager virt-viewer  openssh-askpass  -y

#4. instation work dir is /root/KVM-INSTALL-TAR-DIR and create it if not exist
cd 
if [ ! -d "./KVM-INSTALL-TAR-DIR" ];then
	mkdir KVM-INSTALL-TAR-DIR
fi
cd KVM-INSTALL-TAR-DIR

#5. remove the last version of  kvmtest install files
rm * -fr

#6. download Kvmtest-From-Gerrit*.tar
#such as:Kvmtest-From-Gerrit-Build30-20190116-171406.tar.gz
retCode=0
#this file is usefor mark the tarball version
echo "Check for the file.log before remotely downloading...."
wget --spider ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/file.log
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(file.log) on the remote web server,please check it!"
   exit ${retCode}
fi

echo -e "\nBegin to download file.log....\n"

wget -c ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/file.log
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download file.log from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi

#wget ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/file.log
tarName=`cat file.log`

echo "Check for the tarball before remotely downloading...."

wget --spider ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$tarName
retCode=$?
if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(${result}) on the remote web server,please check it!"
   exit ${retCode}
fi

echo -e "\nBegin to download tarball...\n"

wget -c --progress=bar:force ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$tarName
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download ${result} from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi

#wget ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$tarName
pkgName=${tarName%-.tar.gz}

#7. unpack tar file
tar zxvf ${pkgName}
cd result

tar vxf kernel-kvm-host-*.tar.gz -C /
#tar vxf kernel-kvm-guest-*.tar.gz -C /

tar vxf qemu-*.tar.gz
\cp -darf tmp/qemu-build/* /
tar vxf libvirt*tar.gz
\cp -darf tmp/libvirt-build/var/c* /var/
\cp -darf tmp/libvirt-build/var/l* /var/
\cp -darf tmp/libvirt-build/var/r* /
\cp -darf tmp/libvirt-build/etc /
\cp -darf tmp/libvirt-build/usr /

#bug tiyanhun fixed for kvm bootup
rm -rf /var/cache/libvirt/*
systemctl daemon-reload
systemctl restart libvirtd


