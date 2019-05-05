#!/bin/bash

testCase='lmbench_test'

srcDir='/home/loongson'
testCase='lmbench_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
lmbench_start_time=`date`

#cd $srcDir/loongnix-testsuite/shell
#. ./autotest.sh $testCase
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.4Lmbench
./4.4.1lmbench.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

lmbench_end_time=`date`
echo "performance Test:[ $testCase ] End-------------------------------------------------"
echo "start_time:[$lmbench_start_time]-----end_time:[$lmbench_end_time]----------------------------------------------"

