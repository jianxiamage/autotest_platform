#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[speccpu2006] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases
tar zxf spec2006-loongson.tar.gz -C /home
cd /home/spec2006-loongson
./myrun.sh

echo "performance Test:[speccpu2006] End-----------------------------------------------"
