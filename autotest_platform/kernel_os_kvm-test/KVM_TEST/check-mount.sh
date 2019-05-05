#/bin/bash

check_dev=$1

if [ $# -ne 1 ];then
    echo "usage:./check-mount.sh check_dev"
    exit 2 
fi


if mountpoint -q ${check_dev};then
    echo "${check_dev} is mounted"
    exit 0
else
    echo "${check_dev} is not mounted"
    exit 1
fi
