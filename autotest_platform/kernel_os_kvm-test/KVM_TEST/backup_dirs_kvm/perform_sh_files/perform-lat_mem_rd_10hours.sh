#!/bin/bash

srcDir='/home/loongson'
shDir='/home'

echo "-----------------perform-lat_mem_rd_10hours.sh测试开始，测试时间为10h-----------------"
echo "performance Test:[perform-lat_mem_rd_10hours] Begin-----------------------------------------------"
lmbench_lat_mem_rd_start_time=`date`

#Exec 10 hours
timeout 36000 ./perform-lat_mem_rd.sh

lmbench_lat_mem_rd_end_time=`date`
echo "performance Test:[perform-lat_mem_rd_10hours] End-----------------------------------------------"
echo "start_time:[$lmbench_lat_mem_rd_start_time]-----end_time:[$lmbench_lat_mem_rd_end_time]----------------"

