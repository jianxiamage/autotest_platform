#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[stressAppTest] Begin-----------------------------------------------"
#xhost +
#su - root
#export DISPLAY=:0.0
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/5.comprehensive_stress

echo "--------运行stressapptest12个小时-----------"
./5.13stressapptest.sh

echo "performance Test:[stressAppTest] End-----------------------------------------------"



echo "performance Test:[ltp] Begin-----------------------------------------------"
echo "--------运行ltp72个小时-----------"
./5.15ltpstress.sh

echo "performance Test:[ltp] End-----------------------------------------------"


echo "performance Test:[runltp] Begin-----------------------------------------------"

echo "--------运行runltp72个小时-----------"
./5.14runltp.sh

echo "performance Test:[runltp] End-----------------------------------------------"


echo "performance Test:[run5压力测试] Begin-----------------------------------------------"

./5.16run.sh

echo "performance Test:[run5压力测试] End-----------------------------------------------"

echo "performance Test:[scp大文件] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/shell
./scp-test.sh

echo "performance Test:[scp大文件] End-----------------------------------------------"


#After finish all the test,ssh logout
#exit
