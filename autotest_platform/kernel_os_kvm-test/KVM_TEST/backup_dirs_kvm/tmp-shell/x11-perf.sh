#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[x11perf] Begin-----------------------------------------------"

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
echo "performance Test:[x11perf] End-----------------------------------------------"
