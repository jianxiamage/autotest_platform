#!/bin/sh

project_path=''
echo "test fork"
project_path=$(cd `dirname $0`; pwd)

#./Taska;
#./Taskb;
${project_path}/Taska;
${project_path}/Taskb;
sleep 2s;
echo "sleep 10m";
sleep 10m;
echo ""
echo ""
echo ""
echo "=======================test result============================"
echo "The number of Taska tasks that still exist is $(pgrep Taska|wc -w)"
echo "The number of Taskb tasks that still exist is $(pgrep Taskb|wc -w)"
ps -efww|grep -w 'Taska'|grep -v grep|cut -c 9-15|xargs kill -9;
ps -efww|grep -w 'Taskb'|grep -v grep|cut -c 9-15|xargs kill -9;

~                                                                        
