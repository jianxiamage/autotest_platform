#!/bin/bash


srcDir='/home/loongson'
testCase='unixbench_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
unixbench_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

unixbench_end_time=`date`	
echo "performance Test:[ $testCase ] End-----------------------------------------------"
echo "start_time:[$unixbench_start_time]-----end_time:[$unixbench_end_time]----------------------------------------------"

