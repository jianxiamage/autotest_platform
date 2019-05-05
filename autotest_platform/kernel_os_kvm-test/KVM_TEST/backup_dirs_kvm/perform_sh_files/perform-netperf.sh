#!/bin/bash


srcDir='/home/loongson'

testCase='4.7netperf'

echo "---------------netperf网线直连测试---------------------"
echo "performance Test:[ $testCase ] Begin--------------------------------------------]"
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.7netperf
netperf_direct_start_time=`date`

./4.7.3netperf_direct.sh
#echo "You can find"

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

netperf_direct_end_time=`date`
echo "performance Test:[ $testCase ] End--------------------------------------------"
echo "start_time:[$netperf_direct_start_time]-----end_time:[$netperf_direct_end_time]----------------------------------------------"
