#!/bin/bash

srcDir='/home/loongson'
testCase='specjvm2008_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
specjvm2008_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

specjvm2008_end_time=`date`	
echo "performance Test:[ $testCase ] End--------------------------------------------------"
echo "start_time:[$specjvm2008_start_time]-----end_time:[$specjvm2008_end_time]----------------------------------------------"
