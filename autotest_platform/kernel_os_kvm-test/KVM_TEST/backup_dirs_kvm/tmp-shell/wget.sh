#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[wget] Begin-----------------------------------------------"
cd $srcDir/loongnix-testsuite/shell
./wget-test.sh

echo "output files:result.log and md5sumresult.log"
echo "Compare the 2 files..."
#vim -d result.log md5sumresult.log
diff result.log md5sumresult.log
echo "You can find the difference by [vim -d result.log md5sumresult.log] or other way"
echo "performance Test:[wget] End-----------------------------------------------"
