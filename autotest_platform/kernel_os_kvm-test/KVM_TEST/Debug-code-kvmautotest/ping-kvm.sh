#!/bin/bash
kvmName=''
kvmName="fedora21-1"

if [ -f /home/$kvmName.IP ];then
  echo "/home/$kvmName.IP exists"
else
  echo "/home/$kvmName.IP Not exists"
  exit 1
fi

site=$(cat /home/$kvmName.IP)
echo "IP:$site [KVM:$kvmName]"

#TODO add check IP format

#site="192.168.1.${siteip}"

ping -c1 -W1 ${site} &> /dev/null

if [ "$?" == "0" ]; then
  echo "$site is UP"
  exit 0
else
  echo "$site is DOWN"
  exit 2
fi


