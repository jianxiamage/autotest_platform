#!/bin/bash

for (( i=0; i<254;i++))
do
{
ping 192.168.122.$i -c 1
}&
done
echo "scan all ip End!"
exit
