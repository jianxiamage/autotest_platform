#!/bin/bash
kvmName=''

#----------------------------------------------------------------------------------
source ./common-fun-tar.sh
kvmName=$(getKVMName)
#----------------------------------------------------------------------------------

if [ -s /home/$kvmName.IP ];then
  echo "/home/$kvmName.IP exists"
else
  echo "File:[/home/$kvmName.IP] Not exists or the file content is empty"
  rm -f /home/$kvmName.IP
  exit 1
fi

site=$(cat /home/$kvmName.IP)
#echo "IP:[$site] [KVM:$kvmName]"
if [ -z "$site" ]; then
    echo "IP is empty,exit..."
    rm -f /home/$kvmName.IP
    exit 1
fi 

echo -e "IP-->:\n[$site]"
echo -e "kvmName-->[$kvmName]"

#TODO add check IP format

#site="192.168.1.${siteip}"

ping -c1 -W1 ${site} &> /dev/null

if [ "$?" == "0" ]; then
  echo "$site is UP"
  exit 0
else
  echo "$site is DOWN,you need to retrieve a new IP!"
  rm -f /home/$kvmName.IP
  exit 2
fi


