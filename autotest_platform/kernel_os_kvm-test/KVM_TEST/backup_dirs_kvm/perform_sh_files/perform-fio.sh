#!/bin/bash

#srcDir='/home/loongson'
#testCase='graphics'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
graphics_start_time=`date`

#cd $srcDir/loongnix-testsuite/shell

echo "============================================================================================================="
echo "利用fio测试虚拟机磁盘性能IOPS。测试项：随机读，随机写，顺序读，顺序写，随机读写的IOPS和IO带宽。"
echo "说明："
echo "filename=/dev/vda1   测试文件名称，通常选择需要测试的盘的data目录。只能是分区，不能是目录，会破坏数据。"
echo "direct=1                     测试过程绕过机器自带的buffer。使测试结果更真实。"
echo "iodepth 1                   队列深度，只有使用libaio时才有意义，这是一个可以影响IOPS的参数，通常情况下为1。"
echo "rw=randwrite             测试随机写的I/O"
echo "rw=randrw                 测试随机写和读的I/O"
echo "ioengine=psync          io引擎使用pync方式 "
echo "bs=4k                        单次io的块文件大小为4k"
echo "bsrange=512-2048      同上，提定数据块的大小范围"
echo "size=30G                  本测试文件大小为30g，以每次4k的io进行测试,此大小不能超过filename的大小，否则会报错。"
echo "numjobs=10               本测试的线程为10."
echo "runtime=1000             测试时间为1000秒，如果不写则一直将5g文件分4k每次写完为止。"
echo "rwmixwrite=30           在混合读写的模式下，写占30%"
echo "group_reporting         关于显示结果的，汇总每个进程的信息。"
echo "lockmem=1g              只使用1g内存进行测试。"
echo "zero_buffers              用0初始化系统buffer。"
echo "nrfiles=8                    每个进程生成文件的数量。"
 
echo "read 顺序读"
echo "write 顺序写"
echo "randwrite 随机写"
echo "randread 随机读"
echo "randrw 随机混合读写"
echo "rw,readwrite 顺序混合读写(一般不做要求)"
echo "============================================================================================================="

echo "--------------------1 安装-------------------------"
if [ ! `rpm -qa|grep fio` ];then
	yum install fio -y
fi
echo "--------------------2 随机读：---------------------"
fio -filename=/dev/vda1 -direct=1 -iodepth 1 -thread -rw=randread -ioengine=psync -bs=4k -size=30G -numjobs=30 -runtime=1000 -group_reporting -name=mytest
if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
echo "--------------------3 随机写：---------------------"
fio -filename=/dev/vda1 -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=psync -bs=4k -size=30G -numjobs=30 -runtime=1000 -group_reporting -name=mytest
if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
echo "--------------------4 顺序读：---------------------"
fio -filename=/dev/vda1 -direct=1 -iodepth 1 -thread -rw=read -ioengine=psync -bs=4k -size=30G -numjobs=30 -runtime=1000 -group_reporting -name=mytest
if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
echo "--------------------5 顺序写：---------------------"
fio -filename=/dev/vda1 -direct=1 -iodepth 1 -thread -rw=write -ioengine=psync -bs=4k -size=30G -numjobs=30 -runtime=1000 -group_reporting -name=mytest
if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
echo "--------------------6 混合随机读写：---------------"
fio -filename=/dev/vda1 -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=70 -ioengine=psync -bs=4k -size=30G -numjobs=30 -runtime=100 -group_reporting -name=mytest -ioscheduler=noop
if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
	
echo "----------------------记录结果 BW（IO带宽，磁盘吞吐量）、IOPS()磁盘的每秒读写次数值--------------------------"

graphics_end_time=`date`
echo "performance Test:[ $testCase ] End--------------------------------------------------"
echo "start_time:[$graphics_start_time]-----end_time:[$graphics_end_time]----------------------------------------------"
