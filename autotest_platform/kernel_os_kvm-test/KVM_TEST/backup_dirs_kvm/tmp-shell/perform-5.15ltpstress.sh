#!/bin/bash

#0. check user
if [ ! ${UID} -eq 0 ]; then
        echo "Must be run as root!"
        exit 1
fi

srcDir='/home/loongson'
testCase='5.15ltpstress'

echo "-----------------ltpstress测试开始，测试时间为3天-----------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
ltpstress_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
		exit 1
fi
		
ltpstress_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$ltpstress_start_time]-----end_time:[$ltpstress_end_time]----------------------------------------------"

