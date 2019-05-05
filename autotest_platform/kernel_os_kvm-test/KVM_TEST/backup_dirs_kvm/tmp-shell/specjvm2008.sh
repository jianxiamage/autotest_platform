#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[specjvm2008] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/shell

oldName='TEST_UNITS=(stream_test lmbench_test specjvm2008_test unixbench_test unixbench2d_test speccpu2000_test)'
newName='TEST_UNITS=(specjvm2008_test)'

\cp -f $srcDir/loongnix-testsuite/shell/autotest.sh specjvm2008_test.sh
sed -i "s/${oldName}/${newName}/g" specjvm2008_test.sh

chmod +x specjvm2008_test.sh
./specjvm2008_test.sh

echo "Find result(Log path):/home/loongson/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases/test-log/specjvm2008.log"
echo "performance Test:[specjvm2008] End-----------------------------------------------"


#After finish all the test,ssh logout
#exit
