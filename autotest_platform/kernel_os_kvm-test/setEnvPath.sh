#!/bin/bash

#set current path to system Env
echo "The old PATH env is:${PATH}"
echo "set the current directory to system Environment variable"
export PATH=.:$PATH
source /etc/profile
echo "The new PATH env is:${PATH}"


#sed-i"/###BEGIN\/etc\/grub.d\/10_linux###/r${pxeStdtmp}"${pxeBootFile}
sed -i '$a\export PATH=.:$PATH' /etc/profile

