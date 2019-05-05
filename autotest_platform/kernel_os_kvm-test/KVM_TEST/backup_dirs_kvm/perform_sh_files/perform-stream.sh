#!/bin/bash

srcDir='/home/loongson'
testCase='stream_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
stream_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

stream_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$stream_start_time]-----end_time:[$stream_end_time]----------------------------------------------"

