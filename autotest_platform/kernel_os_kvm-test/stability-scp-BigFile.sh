#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[scp大文件] Begin-----------------------------------------------"
scp_start_time=`echo $(date +"%F %T")`

cd $srcDir/loongnix-testsuite/shell
./scp-test.sh

scp_end_time=`echo $(date +"%F %T")`
echo "performance Test:[scp大文件] End-----------------------------------------------"
echo "start_time:[$scp_start_time]-----end_time:[$scp_end_time]----------------------------------------------"

