#!/bin/bash

srcDir='/home/loongson'
testCase='4.4.1lmbench'

echo "------------lmbench 编译测试--------------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
lmbench_start_time=`echo $(date +"%F %T")`

#cd $srcDir/loongnix-testsuite/shell
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.4Lmbench

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

lmbench_end_time=`echo $(date +"%F %T")`
echo "performance Test:[ $testCase ] End---------------------------------------------"
echo "start_time:[$lmbench_start_time]-----end_time:[$lmbench_end_time]----------------------------------------------"

