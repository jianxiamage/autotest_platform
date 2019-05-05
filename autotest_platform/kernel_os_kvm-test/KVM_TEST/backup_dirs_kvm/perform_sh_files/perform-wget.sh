#!/bin/bash

srcDir='/home/loongson'
testCase='wget-test'

echo "-----------perform-wget.sh开始测试----------大概运行15h----------------------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
wget_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

wget_end_time=`date`
echo "performance Test:[ $testCase ] End------------------------------------------------ "
echo "start_time:[$wget_start_time]-----end_time:[$wget_end_time]----------------------------------------------"

