#!/bin/bash
#set -x
echo "---------------------------------begin rmmod--------------------------------------"
echo "rmmod ./testmod.ko"
rmmod ./testmod.ko
echo "lsmod|grep testmod"
lsmod|grep testmod
echo "---------------------------------end rmmod----------------------------------------"
echo "---------------------------------dmesg log----------------------------------------"
dmesg -T|grep "rmmod"
