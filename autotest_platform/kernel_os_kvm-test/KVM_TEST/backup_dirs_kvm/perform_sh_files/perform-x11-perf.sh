#!/bin/bash

srcDir='/home/loongson'

#是否能够用远程链接方式进行图形相关测试，暂不确定，该脚本暂不使用
#0. check user
if [ ! ${UID} -eq 0 ]; then
	echo "Must be run as root!"
	exit 1
fi

echo "----------开始运行perform-x11-perf.sh---------运行2h---------------------------"
echo "performance Test:[x11perf] Begin-----------------------------------------------"
x11perf_start_time=`date` 	

#1. 启动终端
#2. 安装x11perf ：yum install -y x11perf （如果已有则此步骤可省略）
#yum install -y x11perf
#3. 循环执行命令“x11perf -all”
#4. 共运行 2 小时


yum install -y x11perf
#create sh file:x11perf.sh to  Loop execution 
cat >> x11perf.sh <<EOF 
#!/bin/bash
while true
do
	x11perf -all
done

EOF

#sh x11perf.sh
chmod +x x11perf.sh
#set timeout 2 hours
timeout 7200 ./x11perf.sh

echo "Find result:~/loongson-testsuite/result/117-x11perf.log"
x11perf_end_time=`date`
echo "performance Test:[x11perf] End-----------------------------------------------"
echo "start_time:[$x11perf_start_time]-----end_time:[$x11perf_end_time]----------------------------------------------"
