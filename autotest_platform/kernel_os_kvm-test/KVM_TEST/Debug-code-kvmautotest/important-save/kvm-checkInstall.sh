#!/bin/bash

# This is a libvirtd detection script
# To check the KVM env
 
retStat=`systemctl status libvirtd | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`
 
if [ "$retStat" == "running" ];then
   echo "libvirtd 服务正在运行!"
   echo "KVM Environment is installed successfully!"
else
   echo "Error:KVM Environment is not installed successfully!"
   cmdStr='Maybe you can use cmd:systemctl start libvirtd by hand'
   #systemctl start libvirtd
   
fi



