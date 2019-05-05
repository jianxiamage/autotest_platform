#!/bin/bash

srcDir='/home/loongson'
testCase='lmbench_test'

echo "------------lmbench 编译测试--------------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
lmbench_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

lmbench_end_time=`date`		
echo "performance Test:[ $testCase ] End---------------------------------------------"
echo "start_time:[$lmbench_start_time]-----end_time:[$lmbench_end_time]----------------------------------------------"

