#!/bin/bash

srcDir='/home/loongson'
testCase='speccpu2006_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
speccpu2006_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.2SPEC2006/4.2.2DOUBLE

. ./4.2.2ALL.sh

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

speccpu2006_end_time=`echo $(date +"%F %T")`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$speccpu2006_start_time]-----end_time:[$speccpu2006_end_time]----------------------------------------------"

