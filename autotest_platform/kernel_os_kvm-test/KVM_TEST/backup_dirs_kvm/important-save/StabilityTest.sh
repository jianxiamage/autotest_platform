#!/bin/bash

#chdir to the test dir
cd /home

gcc -O2 stream.c -fopenmp -DN=40000000 -o  stream-1

./stream-1 >> result1.log

./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log
./stream-1 >> result1.log

tar zxf spec2006-loongson.tar.gz -C /home
cd /home/spec2006-loongson
./myrun.sh
