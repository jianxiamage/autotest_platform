#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[lmbench_preEnv] Begin-----------------------------------------------"
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases

tar zxvf lmbench3-edit.tar.gz -C /home/

cd /home/lmbench3;

make results

#while :; do /home/lmbench3/bin/mips64el-linux-gnu/lat_mem_rd -P 16 8 64 2>&1 | tee -a lat_mem.log; done
#while :; do /home/lmbench3/bin/mips64el-linux-gnu/lat_ctx -P 8 -s 8 64 2>&1 |tee  -a lat_ctx.log; done
echo "performance Test:[lmbench_preEnv] End-----------------------------------------------"
