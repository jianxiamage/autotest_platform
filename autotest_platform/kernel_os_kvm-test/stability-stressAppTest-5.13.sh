#!/bin/bash

stressAppTest='5.13-stressapptest'
srcDir='/home/loongson'


echo "performance Test:[stressAppTest] Begin-----------------------------------------------"

#cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases

#tar zxvf stressapptest-1.0.2_autoconf.tar.gz -C /home

#cd /home/stressapptest-1.0.2_autoconf


#echo "运行stressapptest12个小时，内存压力要达到80%"

#Exec 12 hours
#timeout 43200 ./OS_stressAppTest.sh

#echo "查看内存运行是否有误"
#xhost +
#su - root
#export DISPLAY=:0.0
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress
stressapp_start_time=`echo $(date +"%F %T")`

echo "--------stressapptest测试开始-----------"
./5.13stressapptest.sh

stressapp_end_time=`echo $(date +"%F %T")`
echo "performance Test:[stressAppTest] End-----------------------------------------------"
echo "start_time:[$stressapp_start_time]-----end_time:[$stressapp_end_time]----------------------------------------------"

