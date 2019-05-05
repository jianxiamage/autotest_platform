#!/bin/bash

srcDir='/home/loongson'

echo "comprehensive-stress Test:[scp大文件] Begin-----------------------------------------------"
scp_start_time=`echo $(date +"%F %T")`

ping -s 16000 10.2.5.24

scp_end_time=`echo $(date +"%F %T")`
echo "comprehensive-stress Test:[scp大文件] End-----------------------------------------------"
echo "start_time:[$scp_start_time]-----end_time:[$scp_end_time]----------------------------------------------"

