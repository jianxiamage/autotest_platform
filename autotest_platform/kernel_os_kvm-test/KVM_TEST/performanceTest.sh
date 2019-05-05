#!/bin/bash

srcDir='/home/loongson'
shDir='/home'
pushd .
#==========================================================
# 1.graphics test
#==========================================================
#是否能够用远程链接方式进行图形相关测试，暂不确定，该测试项暂不使用
testCase='graphics'
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
graphics_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi
		
graphics_end_time=`date`
echo "performance Test:[ $testCase ] End--------------------------------------------------"
echo "start_time:[$graphics_start_time]-----end_time:[$graphics_end_time]----------------------------------------------"

#==========================================================
# 2.stream test
#==========================================================
testCase='stream_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
stream_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

stream_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$stream_start_time]-----end_time:[$stream_end_time]----------------------------------------------"

#==========================================================
# 3.unixbench2d test
#==========================================================
testCase='unixbench2d_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
unixbench2d_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

unixbench2d_end_time=`date`	
echo "performance Test:[ $testCase ] End-----------------------------------------------"
echo "start_time:[$unixbench2d_start_time]-----end_time:[$unixbench2d_end_time]----------------------------------------------"

#==========================================================
# 4.unixbench test
#==========================================================
testCase='unixbench_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
unixbench_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

unixbench_end_time=`date`	
echo "performance Test:[ $testCase ] End-----------------------------------------------"
echo "start_time:[$unixbench_start_time]-----end_time:[$unixbench_end_time]----------------------------------------------"

#==========================================================
# 5.wget test
#==========================================================
testCase='wget-test'

echo "-----------perform-wget.sh开始测试----------大概运行15h----------------------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
wget_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./${testCase}.sh

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

wget_end_time=`date`
echo "performance Test:[ $testCase ] End------------------------------------------------ "
echo "start_time:[$wget_start_time]-----end_time:[$wget_end_time]----------------------------------------------"
#==========================================================
# 6.specjvm2008 test
#==========================================================
testCase='specjvm2008_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
specjvm2008_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

specjvm2008_end_time=`date`	
echo "performance Test:[ $testCase ] End--------------------------------------------------"
echo "start_time:[$specjvm2008_start_time]-----end_time:[$specjvm2008_end_time]----------------------------------------------"
#==========================================================
# 7.speccpu2006 test
#==========================================================
testCase='speccpu2006_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
speccpu2006_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

speccpu2006_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$speccpu2006_start_time]-----end_time:[$speccpu2006_end_time]----------------------------------------------"
#==========================================================
# 8.speccpu2000 test
#==========================================================
testCase='speccpu2000_test'

echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
speccpu2000_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
    echo " $testCase test failed, check it ........."
    exit 1
fi

speccpu2000_end_time=`date`
echo "performance Test:[ $testCase ] End----------------------------------------------"
echo "start_time:[$speccpu2000_start_time]-----end_time:[$speccpu2000_end_time]----------------------------------------------"

#==========================================================
# 9.lmbench test
#==========================================================

#if [ ! `rpm -qa|grep gnome-terminal` ];then
#	yum install gnome-terminal -y
#fi

testCase='lmbench_test'

echo "------------lmbench 编译测试--------------------"
echo "performance Test:[ $testCase ] Begin-----------------------------------------------"
lmbench_start_time=`date`

cd $srcDir/loongnix-testsuite/shell

. ./autotest.sh $testCase

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

lmbench_end_time=`date`		
echo "performance Test:[ $testCase ] End---------------------------------------------"
echo "start_time:[$lmbench_start_time]-----end_time:[$lmbench_end_time]----------------------------------------------"

#==========================================================
# 10.lmbench lat_ctx test
#==========================================================
#需要跟perform-lat_mem_rd_10hours.sh同时执行
echo "-----------------perform-lat_ctx_10hours.sh测试开始，测试时间为10h-----------------"
echo "performance Test:[perform-lat_ctx_10hours] Begin-----------------------------------------------"
lmbench_lat_ctx_start_time=`date`

popd
#Exec 10 hours
timeout 36000 ./perform-lat_ctx.sh
#gnome-terminal -e "./perform-lat_ctx.sh" -t "perform-lat_ctx_10hours.sh"

lmbench_lat_ctx_end_time=`date`
echo "performance Test:[perform-lat_ctx_10hours] End-----------------------------------------------"
echo "start_time:[$lmbench_lat_ctx_start_time]-----end_time:[$lmbench_lat_ctx_end_time]----------------"

#==========================================================
# 11.lmbench lat_mem_rd test
#==========================================================
#需要跟perform-lat_ctx_10hours.sh同时执行
echo "-----------------perform-lat_mem_rd_10hours.sh测试开始，测试时间为10h-----------------"
echo "performance Test:[perform-lat_mem_rd_10hours] Begin-----------------------------------------------"
lmbench_lat_mem_rd_start_time=`date`

#Exec 10 hours
timeout 36000 ./perform-lat_mem_rd.sh
#gnome-terminal -e "./perform-lat_mem_rd.sh" -t "perform-lat_mem_rd_10hours.sh"
pushd .

lmbench_lat_mem_rd_end_time=`date`
echo "performance Test:[perform-lat_mem_rd_10hours] End-----------------------------------------------"
echo "start_time:[$lmbench_lat_mem_rd_start_time]-----end_time:[$lmbench_lat_mem_rd_end_time]----------------"

#==========================================================
# 12.iozone test
#==========================================================
testCase='iozone_test'
echo "performance Test:[ $testCase ] Begin--------------------------------------------]"
iozone_start_time=`date`

cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.6iozone

./4.6.1iozone.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

iozone_end_time=`date`
echo "performance Test:[ $testCase ] End--------------------------------------------"
echo "start_time:[$iozone_start_time]-----end_time:[$iozone_end_time]----------------------------------------------"

#==========================================================
# 13.netperf test
#==========================================================
testCase='4.7netperf'

echo "---------------netperf网线直连测试---------------------"
echo "performance Test:[ $testCase ] Begin--------------------------------------------]"
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/scripts/4.performance_testing/4.7netperf
netperf_direct_start_time=`date`

./4.7.3netperf_direct.sh

if [ $? -ne 0 ]; then
	    echo " $testCase test failed, check it ........."
	    exit 1
fi

netperf_direct_end_time=`date`
echo "performance Test:[ $testCase ] End--------------------------------------------"
echo "start_time:[$netperf_direct_start_time]-----end_time:[$netperf_direct_end_time]----------------------------------------------"


#==========================================================
# 14.x11perf test
#==========================================================

#是否能够用远程链接方式进行图形相关测试，暂不确定，该脚本暂不使用
#0. check user

echo "----------开始运行perform-x11-perf.sh---------运行2h---------------------------"
echo "performance Test:[x11perf] Begin-----------------------------------------------"
x11perf_start_time=`date` 	
popd

if [ ! `rpm -qa|grep xorg-x11-apps` ];then
	yum install x11perf -y
fi

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

x11perf_end_time=`date`
echo "performance Test:[x11perf] End-----------------------------------------------"
echo "start_time:[$x11perf_start_time]-----end_time:[$x11perf_end_time]----------------------------------------------"


#After finish all the test,ssh logout
#exit
