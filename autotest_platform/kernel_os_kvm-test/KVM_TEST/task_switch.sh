#!/bin/bash

srcDir='/home/loongson'

echo "kvm special Test:[task_switch] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/11-kvm/7.2-task_switch/

chmod +x a20
chmod +x b20
chmod +x x.sh
./x.sh

if [ $? -ne 0 ]; then
	echo "task_switch test error, something wrong, check it ....."
	exit 1
fi

echo "performance Test:[task_switch] End--------------------------------------------------"

