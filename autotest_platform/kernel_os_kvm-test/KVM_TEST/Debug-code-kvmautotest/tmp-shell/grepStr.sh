#!/bin/sh


kernelNameX=`ls /boot | grep  '^vmlinuz-.*kvmhost.mips64el'`
#kernelNameX=$(ls -l)
#kernelNameX=`ls -l`
echo ------------------------------AAAAAAA
echo "$kernelNameX"

