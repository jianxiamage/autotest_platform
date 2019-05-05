#!/bin/bash

srcDir='/home/loongson'
testCase='testverson'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

echo "performance Test:[ $testCase ] End-----------------------------------------------"

