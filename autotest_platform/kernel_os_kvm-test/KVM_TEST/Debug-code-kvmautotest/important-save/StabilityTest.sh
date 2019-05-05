#!/bin/bash


#set NoPassword login for ssh
#sh connRemoteKVM.sh

#kvmName='fedora21-1'

#sh getKVMIP.sh
#KVMIP=$(cat /home/$kvmName.IP)

#scp /home/stream.c root@$KVMIP:/home

#scp /home/spec2006-loongson.tar.gz root@$KVMIP:/home

#ssh $KVMIP

#chdir to the test dir
cd /home

gcc -O2 stream.c -fopenmp -DN=40000000 -o  stream-1

./stream-1 >> result1.log

./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log

tar zxf spec2006-loongson.tar.gz -C /home
cd /home/spec2006-loongson
./myrun.sh

#After finish all the test,ssh logout
#exit
