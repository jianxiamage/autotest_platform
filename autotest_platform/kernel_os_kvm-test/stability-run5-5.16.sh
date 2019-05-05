#!/bin/bash

srcDir='/home/loongson'
testCase='5.16run'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
run_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress
#cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

run_end_time=`echo $(date +"%F %T")`
echo "\n performance Test:[ $testCase ] End------------------------------------------------"
echo "start_time:[$run_start_time]-----end_time:[$run_end_time]----------------------------------------------"

