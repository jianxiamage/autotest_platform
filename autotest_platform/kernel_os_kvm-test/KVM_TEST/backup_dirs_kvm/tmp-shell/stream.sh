#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[stream] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases

gcc -O2 stream.c -fopenmp -DN=40000000 -o  stream-1

./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log

#exec 5 times,and get the average value
echo "exec 5 times,and get the average value"

grep Copy result1.log

grep Scale result1.log

grep Add  result1.log

grep Triad result1.log

echo "performance Test:[stream] End-----------------------------------------------"

#set timeout 2 hours

