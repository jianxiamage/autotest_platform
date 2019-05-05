#!/bin/bash

srcDir='/home/loongson'
testCase='speccpu2000_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
speccpu2000_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.1SPEC2000/4.1.2DOUBLE

. ./4.1.2ALL.sh

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

speccpu2000_end_time=`echo $(date +"%F %T")`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$speccpu2000_start_time]-----end_time:[$speccpu2000_end_time]----------------------------------------------"

