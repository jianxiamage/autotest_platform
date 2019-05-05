#!/bin/bash


srcDir='/home/loongson'

testCase='iozone_test'

echo "performance Test:[ $testCase ] Begin--------------------------------------------]"
iozone_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.6iozone

./4.6.1iozone.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

iozone_end_time=`echo $(date +"%F %T")`
echo "performance Test:[ $testCase ] End--------------------------------------------"
echo "start_time:[$iozone_start_time]-----end_time:[$iozone_end_time]----------------------------------------------"
