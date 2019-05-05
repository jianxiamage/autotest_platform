#!/bin/bash

#set NoPassword login for ssh
#sh connRemoteKVM.sh

#kvmName='fedora21-1'

#sh getKVMIP.sh
#KVMIP=$(cat /home/$kvmName.IP)

#scp /home/stream.c root@$KVMIP:/home

#scp /home/spec2006-loongson.tar.gz root@$KVMIP:/home

#ssh $KVMIP

srcDir='/home/loongson'


echo "kvm special Test:[task_switch] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/11-kvm/task_switch

chmod +x a20
chmod +x b20
chmod +x x.sh
./x.sh

echo "performance Test:[task_switch] End--------------------------------------------------"

