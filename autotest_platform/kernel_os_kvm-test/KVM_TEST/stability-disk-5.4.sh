#!/bin/bash


srcDir='/home/loongson'
testCase='5.4disk'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
runltp_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress
#cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

runltp_end_time=`echo $(date +"%F %T")`
echo "\n performance Test:[ $testCase ] End------------------------------------------------"
echo "start_time:[$runltp_start_time]-----end_time:[$runltp_end_time]----------------------------------------------"

