#!/bin/bash

srcDir='/home/loongson'
testCase='speccpu2000_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
speccpu2000_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

speccpu2000_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$speccpu2000_start_time]-----end_time:[$speccpu2000_end_time]----------------------------------------------"

