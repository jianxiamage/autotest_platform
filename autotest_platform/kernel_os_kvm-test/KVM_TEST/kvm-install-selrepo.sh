#!/bin/bash

#set -e

#------------------------------
cmdStr=''
kvmName=''
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:install.End------------------------------------"
retNameExists='No'
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
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "KVM Test:install KVM.Begin---------------------------------"

#1.install the test source(loongnix-test-release)

yum  install loongnix-test-release  -y && yum makecache

#We'll use wget,we can do with Exception here,So we cancel the Err Trap temporarily
trap - ERR

#2.select repo(for libvirt,qemu,host,guest) and install these repos
case $1 in
qemu)
    #cmdStr='You select qemu,add qemu repo,exit'
    #wget ftp://10.2.5.21/loongnix-rpms/qemu/qemu.repo || echo $cmdStr;write_log "ERROR" "${cmdStr}";exit 1

    wget ftp://10.2.5.21/loongnix-rpms/qemu/qemu.repo

    if [ $? -eq 0 ]; then
      cmdStr="wget qemu.repo success."
      echo $cmdStr
      write_log "INFO" "${cmdStr}"
    else
      cmdStr="wget qemu.repo failed!"
      echo $cmdStr
      write_log "ERROR" "${cmdStr}"
      exit 1
    fi
    
    \cp -f qemu.repo /etc/yum.repos.d/
    #yum makecache fast
    ;;
libvirt)
    #cmdStr="You select libvirt,add libvirt repo"
    #wget xxx.repo || echo $cmdStr;write_log "ERROR" "${cmdStr}";exit 1

    wget ftp://10.2.5.21/loongnix-rpms/libvirt/libvirt.repo

    if [ $? -eq 0 ]; then
      cmdStr="wget libvirt.repo success."
      echo $cmdStr
      write_log "INFO" "${cmdStr}"
    else
      cmdStr="wget libvirt.repo failed!"
      echo $cmdStr
      write_log "ERROR" "${cmdStr}"
      exit 1
    fi

    \cp -f libvirt.repo /etc/yum.repos.d/
    #yum makecache fast
    ;;
host)
    #cmdStr="You select host,add host repo"
    #wget xxx.repo || echo $cmdStr;write_log "ERROR" "${cmdStr}";exit 1

    wget ftp://10.2.5.21/loongnix-rpms/kernel-kvm-host/kernel-kvm-host.repo

    if [ $? -eq 0 ]; then
      cmdStr="wget host.repo success."
      echo $cmdStr
      write_log "INFO" "${cmdStr}"
    else
      cmdStr="wget host.repo failed!"
      echo $cmdStr
      write_log "ERROR" "${cmdStr}"
      exit 1
    fi

    \cp -f host.repo /etc/yum.repos.d/
    #yum makecache fast
    ;;
guest)
    #cmdStr="You select guest,add guest repo"
    #wget xxx.repo || echo $cmdStr;write_log "ERROR" "${cmdStr}";exit 1

    wget ftp://10.2.5.21/loongnix-rpms/kernel-kvm-guest/kernel-kvm-guest.repo

    if [ $? -eq 0 ]; then
      cmdStr="wget guest.repo success."
      echo $cmdStr
      write_log "INFO" "${cmdStr}"
    else
      cmdStr="wget guest.repo failed!"
      echo $cmdStr
      write_log "ERROR" "${cmdStr}"
      exit 1
    fi
    
    \cp -f guest.repo /etc/yum.repos.d/
    #yum makecache fast
    ;;

*)
    cmdStr="Your input parameter is wrong,please use[qemu|libvirt|host|guest]"
    echo $cmdStr
    write_log "INFO" "${cmdStr}"
    exit 2
    ;;
esac

#After add new repo file,you should Execute cmd:yum makecache fast to update yum database
yum makecache fast

if [ $? -eq 0 ]; then
   cmdStr="yum makecache success."
   echo $cmdStr
   write_log "INFO" "${cmdStr}"
else
   cmdStr="yum makecache failed!"
   echo $cmdStr
   write_log "ERROR" "${cmdStr}"
   exit 1
fi

#In order to cache other Exception,Now we'll start the ERR Trap
trap 'exit_err $LINENO $?'     ERR

#3.install the required packages of KVM

yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y

#4.Modify the boot file,call set_bootfile.sh

#write_log "INFO" "KVM Test:install KVM.End------------------------------------"
