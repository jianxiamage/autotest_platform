#!/bin/bash

#set -x
srcHostDir='/root/KVM-SHELL-DIR/shell-file'
srcGuestDir='/root/KVM-TEST-DIR'
#----------------------------------------------------------------------------------

kvmName=''
source ./common-fun-tar.sh
kvmName=$(getKVMName)
#----------------------------------------------------------------------------------
#sh getKVMIP.sh
KVMIP=$(cat /home/$kvmName.IP)
echo "The current KVM IP:$KVMIP"
echo "$KVMIP"
#create KVM-TEST-DIR on KVM
ssh -tt root@$KVMIP "
echo "Login ssh Node,create testFile Dir on KVM Begin..."
srcGuestDir='/root/KVM-Test-DIR/'

if [ ! -d "/root/KVM-TEST-DIR" ]; then
    echo "===================================================KVM-TEST-DIR is not exists"
    echo "/root/KVM-TEST-DIR Not Exist, build it"
    mkdir /root/KVM-TEST-DIR  && echo "create Dir:${srcGuestDir} success!" echo "create Dir:${srcGuestDir} failed!" ;exit 1
else
    echo "===================================================KVM-TEST-DIR is exists"
    echo "/root/KVM-TEST-DIR is already exist"
fi

echo "Login ssh Node,create testFile Dir on KVM End..."

"

#scp testFiles to KVM


#scp /root/KVM-SHELL-DIR/shell-file/perform-* root@192.168.122.77:/root/KVM-TEST-DIR

cmd="scp  $srcHostDir/perform-* root@${KVMIP}:$srcGuestDir"

#echo "cmd is:=============${cmd}==============="


scp  $srcHostDir/perform-* root@${KVMIP}:$srcGuestDir  && echo "upload perform test files success" || echo "upload perform test files failed!"

scp  $srcHostDir/stablity-* root@${KVMIP}:$srcGuestDir  && echo "upload perform test files success" || echo "upload perform test files failed!"
