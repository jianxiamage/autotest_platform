#!/bin/bash


#是否能够用远程链接方式进行图形相关测试，暂不确定，该脚本暂不使用

srcDir='/home/loongson'
testCase='graphics'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
graphics_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
		
graphics_end_time=`date`
echo "performance Test:[ $testCase ] End--------------------------------------------------"
echo "start_time:[$graphics_start_time]-----end_time:[$graphics_end_time]----------------------------------------------"
