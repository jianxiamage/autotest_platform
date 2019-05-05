#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[runltp] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress

#Exec 72 hours
timeout 259200./5.14runltp.sh

echo "performance Test:[runltp] End-----------------------------------------------"
