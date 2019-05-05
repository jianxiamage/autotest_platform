#!/bin/bash


#0. check user
if [ ! ${UID} -eq 0 ]; then
        echo "Must be run as root!"
        exit 1
fi

srcDir='/home/loongson'
testCase='5.14runltp'

echo "-----------------5.14runltp.sh测试开始，测试时间为3天-----------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
runltp_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
		
runltp_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$runltp_start_time]-----end_time:[$runltp_end_time]----------------------------------------------"
