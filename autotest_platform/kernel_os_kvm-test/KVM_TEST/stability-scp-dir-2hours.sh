#!/bin/bash

userName="wanglei"
passWord="loongson"
ipAddr="10.2.5.22"
#dirname="spec2006-loongson"
remote_cmd="rm -rf /tmp/spec2006-loongson"
MAX_COUNT=0
count=0

srcDir='/home/loongson'

echo "performance Test:[scp文件夹] Begin-----------------------------------------------"
scp_start_time=`echo $(date +"%F %T")`

#cd $srcDir/loongnix-testsuite/shell

#压力测试:scp 文件夹,测试2个小时
echo "Begin to test scp directory for 2 hours..."
timeout 7200 ./stability-scp-dir.sh

echo "Now,test scp End..............................."
#测试完毕，对拷贝到远程机器上的文件夹执行删除操作
echo "--------------------------------------------------------------------------------"
echo "Begin to delete the dir on remote node"
expect -c "
spawn ssh $userName@$ipAddr $remote_cmd
expect {
        \"*password:\"  { send -- \"$passWord\r\"; interact}
        \"*yes/no\" {send \"yes\r\"; exp_continue }
}
"

echo "delete the dir on remote node End."
scp_end_time=`echo $(date +"%F %T")`

echo "--------------------------------------------------------------------------------"
echo "performance Test:[scp文件夹] End-----------------------------------------------"
echo "start_time:[$scp_start_time]-----end_time:[$scp_end_time]----------------------------------------------"

