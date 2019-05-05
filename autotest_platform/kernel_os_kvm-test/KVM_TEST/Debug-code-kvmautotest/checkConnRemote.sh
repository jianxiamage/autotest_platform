#!/bin/bash

#The sh file function is to ping the host ip
#In order to find the host machine if boots
#And this sh file is used for Jenkins

#host IP
IP="10.40.40.26"
total="0"
i="0"

while [ $i -lt 10 ]; do

  pingCmd=""
  #echo "ping $IP"
  pingCmd=`ping $IP -c 1 -s 1 -W 1 | grep "100% packet loss" | wc -l`

  if [ "${pingCmd}" != "0" ]; then
    echo "ping failed!"
    total=$((total+1))
  else
    echo "ping ok!"
    total="0"
    break
  fi
  i=$((i+1))
  sleep 5s
done

if [ $total -gt 5 ]; then
  echo "check failed!"
  exit 1
else
  echo "check ok!"
  exit 0
fi
