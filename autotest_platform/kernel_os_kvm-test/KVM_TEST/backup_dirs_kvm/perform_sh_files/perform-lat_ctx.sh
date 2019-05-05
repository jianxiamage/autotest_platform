#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[lmbench-lat_ctx] Begin-----------------------------------------------"

#cd $srcDir/loongnix-testsuite/shell

while :; do /home/lmbench3/bin/mips64el-linux-gnu/lat_ctx -P 8 -s 8 64 2>&1 |tee  -a lat_ctx.log; done

echo "performance Test:[lat_ctx] End-----------------------------------------------"
