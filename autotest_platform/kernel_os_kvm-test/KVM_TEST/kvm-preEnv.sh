#!/bin/bash

#set -e

#------------------------------
cmdStr=''
kvmName=''
xmlName="${kvmName}.xml"
checkStr=''
retCode=0
#-------------------------------
cmdEndStr="KVM Test:Be ready for test.End------------------------------------"
#----------------------------------------------------------------------------------
source ./common-fun-tar.sh
kvmName=$(getKVMName)
#----------------------------------------------------------------------------------
source ./kvm-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log
#----------------------------------------------------------------------------------
source ./exceptionTrap.sh
exit_end=$exit_end
exit_err=$exit_err
exit_int=$exit_int
#----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------
write_log "INFO" "KVM Test:Be ready for test.Begin---------------------------------"

cd /home/

echo "Begin to download the qcow2 file..."
rm -f loongnix.qcow2 

#wget  ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/loongnix.qcow2
#trap - ERR
#
#qcow2Name='ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/loongnix.qcow2'
#
#wget --spider $qcow2Name
#retCode=$?
#if [ ${retCode} -eq 0 ]; then
#  wget -c --progress=bar:force $qcow2Name
#  retCode=$?
#  
#  if [ ${retCode} -eq 0 ]; then
#        echo "download {loongnix.qcow2} from remote web success."
#        retCode=0
#        echo "Download the qcow2 file End."
#        exit ${retCode}
#  else
#     echo "Error:Download {loongnix.qcow2} from remote web failed,Maybe your network is disconnected,please check it!"
#     exit ${retCode}
#  fi
#
#fi
#
#echo " File:loongnix.qcow2 is not on the remote web,Begin to download the latest qcow2 file..."
##---------------------
#
#trap 'exit_err $LINENO $?'     ERR

#echo "Download the qcow2 file End."

trap - ERR

#----------------------------------------------------------------------------------
qcow2NameFile=qcow2Name.log

#download qcow2 file
#such as:loongnix-Build49.qcow2
retCode=0
#this file is usefor mark the qcow2 file version
echo "Check for the qcow2Name.log before remotely downloading...."
wget --spider ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$qcow2NameFile
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(qcow2Name.log) on the remote web server,please check it!"
   exit ${retCode}
fi

echo -e "\nBegin to download qcow2Name.log....\n"

wget -c ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$qcow2NameFile
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download qcow2Name.log from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi

#wget ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$qcow2NameFile
qcow2Name=`cat $qcow2NameFile`

#----------------------------------------------------------------------------------
echo "========================qcow2Name:$qcow2Name"

qcow2NameDownAddr="ftp://10.2.5.21/tmp/Kvmtest-From-Gerrit-Build/$qcow2Name"

wget --spider $qcow2NameDownAddr
retCode=$?
if [ ${retCode} -ne 0 ]; then
   echo "Error:There is no resource(loongnix.qcow2) on the remote web server,please check it!"
   exit ${retCode}
fi

wget -c --progress=bar:force $qcow2NameDownAddr
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo "Error:Download {loongnix.qcow2} from remote web failed,Maybe your network is disconnected,please check it!"
   exit ${retCode}
fi

trap 'exit_err $LINENO $?'     ERR

echo "Download the qcow2 file End."

#change the qcow2 file Name to:loongnix.qcow2
mv $qcow2Name loongnix.qcow2

#write_log "INFO" "KVM Test:install KVM.End------------------------------------"
