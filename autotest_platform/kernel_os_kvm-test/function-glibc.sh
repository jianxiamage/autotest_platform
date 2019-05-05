#!/bin/bash

srcDir='/home/loongson'
testCase='glibc'

echo "-----------function-glibc.sh开始测试----------大概运行18h----------------------------"
echo "Function Test:[ $testCase ] Begin-----------------------------------------------"
wget_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/15-工具链测试

. ./${testCase}.sh

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

wget_end_time=`echo $(date +"%F %T")`
echo "Function Test:[ $testCase ] End------------------------------------------------ "
echo "start_time:[$wget_start_time]-----end_time:[$wget_end_time]----------------------------------------------"

