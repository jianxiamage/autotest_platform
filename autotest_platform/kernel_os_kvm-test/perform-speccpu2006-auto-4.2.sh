#!/bin/bash

srcDir='/home/loongson'
testCase='speccpu2006_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
speccpu2006_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

speccpu2006_end_time=`echo $(date +"%F %T")`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$speccpu2006_start_time]-----end_time:[$speccpu2006_end_time]----------------------------------------------"
