#!/bin/bash

#set -e

#------------------------------
cmdStr=''
kvmName=''
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:install KVM.End------------------------------------"
#----------------------------------------------------------------------------------
source ./common-fun-tar.sh
kvmName=$(getKVMName)
xmlName="${kvmName}.xml"
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
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------
write_log "INFO" "KVM Test:install KVM.Begin---------------------------------"

#install kvm install environment
sh ./kvm-relative-software-instation.sh

#download qcow2 file
echo "Download qcow2 file Begin..."
sh ./kvm-preEnv.sh
echo "Download qcow2 file End"

#Check host environment for test
echo "Check host environment for test Begin..."
sh ./hostEnvAdvance.sh
echo "Check host environment for test End."

##1.install the test source(loongnix-test-release)
#
#yum  install loongnix-test-release  -y && yum makecache
#
##We'll use wget,we can do with Exception here,So we cancel the Err Trap temporarily
##trap - ERR
#
#
## install depend rpms for tarball
#yum install SDL2 autogen-libopts boost-system boost-thread brlapi brltty celt051 corosync corosynclib cyrus-sasl flite glusterfs glusterfs-api glusterfs-cli glusterfs-fuse glusterfs-libs gnutls-dane gnutls-utils libatomic_ops libcacard libfdt libibverbs libiscsi libnfs libqb librados2 librbd1 librdmacm libwsman1 lzop netcf-libs numad radvd sheepdog snappy spice-server tslib usbredir virglrenderer vte3 yajl -y
#
##yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y
#yum install  libvirt-daemon virt-manager virt-viewer  openssh-askpass  -y
#
##download Kvmtest-From-Gerrit.tar
##such as:Kvmtest-From-Gerrit-Build30-20190116-171406.tar.gz
##wget tarball.tar.gz
#
#cd 
#rm -f file*
#wget ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/file.log
##tar vxf tarball.tar.gz
#tarName=`cat file.log`
#
##remove the last version of  kvmtest tar 
#rm -rf *.tar.gz
#
#wget ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$tarName
#pkgName=${tarName%-.tar.gz}
#
#tar zxvf *.tar.gz
#cd result
#
#tar vxf kernel-kvm-host-*.tar.gz -C /
#tar vxf kernel-kvm-guest-*.tar.gz -C /
#tar vxf qemu-*.tar.gz
#\cp -darf tmp/qemu-build/* /
#tar vxf libvirt*tar.gz
#\cp -darf tmp/libvirt-build/var/c* /var/
#\cp -darf tmp/libvirt-build/var/l* /var/
#\cp -darf tmp/libvirt-build/var/r* /


#In order to cache other Exception,Now we'll start the ERR Trap
#trap 'exit_err $LINENO $?'     ERR

#3.install the required packages of KVM

#yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y

#4.Modify the boot file,call set_bootfile.sh

#write_log "INFO" "KVM Test:install KVM.End------------------------------------"
