#!/bin/bash
#set -x
echo "---------------------------------begin insmod--------------------------------------"
echo "insmod ./testmod.ko"
insmod ./testmod.ko
echo "---------------------------------end insmod----------------------------------------"
echo "---------------------------------verify testmod------------------------------------"
lsmod|grep testmod
echo "---------------------------------dmesg log-----------------------------------------"
dmesg -T|grep "insmod"
