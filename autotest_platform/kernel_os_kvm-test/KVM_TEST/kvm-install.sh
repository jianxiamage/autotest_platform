#!/bin/bash

#------------------------------
cmdStr=''
#-------------------------------
source ./kvm-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log

write_log "INFO" "KVM Test:install KVM.Begin---------------------------------"

#1.install the test source(loongnix-test-release)

yum  install loongnix-test-release  -y && yum makecache

#2.install the required packages of KVM

yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y

#3.Modify the boot file,call set_bootfile.sh


write_log "INFO" "KVM Test:install KVM.End------------------------------------"
