#!/bin/bash

#------------------------------
#logDir=$HOME/KVM-Test.log
cmdStr=''
#kvmName='fedora21-1'
#-------------------------------
source ./kvm-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log

write_log "INFO" "KVM Test:install KVM.Begin---------------------------------"

#1.install the test source(loongnix-test-release)

yum  install loongnix-test-release  -y && yum makecache

#2.select repo(for libvirt,qemu,host,guest) and install
case $1 in
qemu)
    echo "You select qemu,add qemu repo"
    wget xxx.repo
    \cp -f xxx.repo /etc/yum.repos.d/
    yum makecache
    ;;
libvirt)
    echo "You select libvirt,add libvirt repo"
    wget xxx.repo
    \cp -f xxx.repo /etc/yum.repos.d/
    yum makecache
    ;;
host)
    echo "You select host,add host repo"
    wget xxx.repo
    \cp -f xxx.repo /etc/yum.repos.d/
    yum makecache
    ;;
guest)
    echo "You select guest,add guest repo"
    wget xxx.repo
    \cp -f xxx.repo /etc/yum.repos.d/
    yum makecache
    ;;

*)
    echo "Your input parameter is wrong,please use[qemu|libvirt|host|guest]"
    exit 1
    ;;
esac


#3.install the required packages of KVM

yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y

#4.Modify the boot file,call set_bootfile.sh


write_log "INFO" "KVM Test:install KVM.End------------------------------------"
