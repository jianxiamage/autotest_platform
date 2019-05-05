#!/bin/bash

srcDir='/home/loongson'
testCase='3.3.1.4scp-server'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
run_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/3.special_subsystem/3.3network_subsystem/3.3.1onboard_nic
#cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

run_end_time=`echo $(date +"%F %T")`
echo "\n performance Test:[ $testCase ] End------------------------------------------------"
echo "start_time:[$run_start_time]-----end_time:[$run_end_time]----------------------------------------------"

