#!/bin/bash
#!/bin/expect

userName="wanglei"
passWord="loongson"
ipAddr="10.2.5.22"
dirname="spec2006-loongson"
MAX_COUNT=0
count=0

srcDir='/home/loongson'

echo "performance Test:[scp文件夹] Begin-----------------------------------------------"

#cd $srcDir/loongnix-testsuite/shell
cd $srcDir/loongnix-testsuite/9-内核及稳定性测试/kernel-test/cases
echo "----------------------------------------------------------------------------------"
echo "Begin to unzip $dirname"
tar xvf spec2006-loongson.tar.gz
echo "unzip $dirname End"
echo "----------------------------------------------------------------------------------"

#服务器启动ssh服务
#systemctl start sshd

while [ $count -lt $MAX_COUNT -o $MAX_COUNT -eq 0 ]; do
expect -c "
spawn scp -r $dirname $userName@$ipAddr:/tmp 
expect {
        \"*password:\"  { send -- \"$passWord\r\"; interact}
        \"*yes/no\" {send \"yes\r\"; exp_continue }
}
"
count=$(($count + 1))
echo "copy $count times!"
echo "copy $count times!" > $srcDir/loongnix-testsuite/shell/scp-dir.log
#sleep 1
done

echo "performance Test:[scp文件夹] End-----------------------------------------------"

