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


echo "performance Test:[stressAppTest] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases

tar zxvf stressapptest-1.0.2_autoconf.tar.gz -C /home

cd /home/stressapptest-1.0.2_autoconf


echo "运行stressapptest12个小时，内存压力要达到80%"

#Exec 12 hours
timeout 43200 ./OS_stressAppTest.sh

echo "查看内存运行是否有误"

echo "performance Test:[stressAppTest] End-----------------------------------------------"



echo "performance Test:[ltp] Begin-----------------------------------------------"
#Not found the test dir,TODO!!!

#cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases

echo "performance Test:[ltp] End-----------------------------------------------"


echo "performance Test:[scp大文件] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/shell
./scp-test.sh

echo "performance Test:[scp大文件] End-----------------------------------------------"


echo "performance Test:[runltp] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress

#Exec 72 hours
timeout 259200./5.14runltp.sh

echo "performance Test:[runltp] End-----------------------------------------------"


echo "performance Test:[run5压力测试] Begin-----------------------------------------------"

#cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress
#./5.16run.sh

echo "performance Test:[run5压力测试] End-----------------------------------------------"

#After finish all the test,ssh logout
#exit
