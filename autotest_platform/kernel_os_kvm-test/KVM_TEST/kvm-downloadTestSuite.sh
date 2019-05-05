#!/bin/bash

#install git
yum install git -y


echo "======================================================="

echo "Now Begin to download testsuit..."

#chdir to ~
srcDir='/home/loongson'
#cd /home/loongson
cd $srcDir

#download testsuite
#git clone http://10.2.5.20:8081/p/qa/loongson-testsuite.git
#git clone http://10.2.5.20:8081/qa/loongnix-testsuite

#rm -rf loongnix-testsuite  || echo "delete loongnix-testsuite failed!";exit 1
rm -rf loongnix-testsuite

#if [ ! -d "$srcDir/loongnix-testsuite" ]; then
#  git clone http://10.2.5.20:8081/qa/loongnix-testsuite
#fi

git clone http://10.2.5.20:8081/qa/loongnix-testsuite

echo "Now  download testsuit End."

echo "Exec env.sh to download other test items Begin..."

cd $srcDir/loongnix-testsuite
sh env.sh

echo "Exec env.sh to download other test items End..."

echo "======================================================="

echo "Now Begin to install test-release"

#download test-release
yum install loongnix-test-release -y

echo "install test-release End"


echo "======================================================="


#==========================================================================================================

cmdStr="yum install expect Begin--------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#yum update firewalld -y
yum install expect -y

cmdStr="yum install expect End.---------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"

#==========================================================================================================
cmdStr="yum install sysstat Begin--------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"


#yum update firewalld -y
yum install sysstat -y

cmdStr="yum install sysstat End.---------------------------------------------------------------------------"
echo $cmdStr
write_log "INFO" "${cmdStr}"



echo "Now Test environment is ready,performance Test and Stability Test Begin..."
