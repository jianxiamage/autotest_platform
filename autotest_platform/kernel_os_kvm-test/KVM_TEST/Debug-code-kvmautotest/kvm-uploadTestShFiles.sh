#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#kvmName='fedora21-1'
xmlName="${kvmName}.xml"
checkStr=''
#-------------------------------
cmdEndStr="KVM Test:Upload Test Sh files to KVM.End------------------------------------"
retNameExists='No'
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
source ./common-fun.sh
NameExists=$NameExists
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "Upload Test Sh files to KVM.Begin---------------------------------"

#==========================================================================

#=========================================================================

##########################################################################
#In the end,delete the temp xml files except templet.xml
#ls *.xml|grep -v templet.xml|xargs rm


#write_log "INFO" "KVM Test:create .End------------------------------------"
