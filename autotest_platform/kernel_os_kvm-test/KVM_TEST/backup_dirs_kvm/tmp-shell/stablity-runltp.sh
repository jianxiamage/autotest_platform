#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[runltp] Begin-----------------------------------------------"
runltp_start_time=`date`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress

#Exec 72 hours
#timeout 259200./5.14runltp.sh
./5.14runltp.sh

runltp_end_time=`date`
echo "performance Test:[runltp] End-----------------------------------------------"
echo "start_time:[$runltp_start_time]-----end_time:[$runltp_end_time]----------------------------------------------"
