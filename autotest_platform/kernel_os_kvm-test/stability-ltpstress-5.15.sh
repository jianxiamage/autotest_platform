#!/bin/bash

srcDir='/home/loongson'
testCase='5.15ltpstress'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
ltpstress_start_time=`date`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress
#cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
		exit 1
fi

ltpstress_end_time=`date`		
echo "\n performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$ltpstress_start_time]-----end_time:[$ltpstress_end_time]----------------------------------------------"

