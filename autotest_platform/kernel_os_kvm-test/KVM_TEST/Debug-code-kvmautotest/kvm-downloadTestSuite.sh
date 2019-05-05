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

if [ ! -d "$srcDir/loongnix-testsuite" ]; then
  git clone http://10.2.5.20:8081/qa/loongnix-testsuite
fi

echo "Now  download testsuit End."

echo "======================================================="

echo "Now Begin to install test-release"

#download test-release
yum install loongnix-test-release -y

echo "install test-release End"


echo "======================================================="

echo "Now Test environment is ready,performance Test and Stability Test Begin..."
