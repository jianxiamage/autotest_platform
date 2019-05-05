#!/bin/bash

#需要跟perform-lat_mem_rd_10hours.sh同时执行

srcDir='/home/loongson'
shDir='/home'

echo "-----------------perform-lat_ctx_10hours.sh测试开始，测试时间为10h-----------------"
echo "performance Test:[perform-lat_ctx_10hours] Begin-----------------------------------------------"
lmbench_lat_ctx_start_time=`date`

#Exec 10 hours
timeout 36000 ./perform-lat_ctx.sh

lmbench_lat_ctx_end_time=`date`
echo "performance Test:[perform-lat_ctx_10hours] End-----------------------------------------------"
echo "start_time:[$lmbench_lat_ctx_start_time]-----end_time:[$lmbench_lat_ctx_end_time]----------------"

#After finish all the test,ssh logout
#exit
