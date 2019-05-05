#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[lmbench-lat_mem_rd] Begin-----------------------------------------------"

#cd $srcDir/loongnix-testsuite/shell

while :; do /home/lmbench3/bin/mips64el-linux-gnu/lat_mem_rd -P 16 8 64 2>&1 | tee -a lat_mem.log; done

echo "performance Test:[lat_mem_rd] End-----------------------------------------------"
