#!/bin/bash

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

##
netmonUpdate(){
	IPADDR=$1
	NETMON_LINE="!REQD eth0 $IPADDR"
	disp_msglvl1 "Updating /var/ct/cfg/netmon.cf with the external pingable IP address $IPADDR that is assigned to the interface created on the switch."
	for HOST in $pshost
	do

		
		ssh $SSH_NO_BANNER $HOST  "ls /var/ct/cfg/netmon.cf"
		if [ $? -ne 0 ] ; then
			print2 "$HOST : /var/ct/cfg/netmon.cf does not exist. Skipping This may be Db2 version 12.1 that does not install TSA/RSCT"
		else 
			disp_msglvl2 " $HOST : removing the line having the IP $IPADDR from /var/ct/cfg/netmon.cf "
			ssh $SSH_NO_BANNER $HOST  "sed -i '/$IPADDR/d' /var/ct/cfg/netmon.cf"
			disp_msglvl2 " $HOST : Add $IPADDR from /var/ct/cfg/netmon.cf "
			ssh $SSH_NO_BANNER $HOST  "echo $NETMON_LINE >> /var/ct/cfg/netmon.cf"
			ssh $SSH_NO_BANNER $HOST  "cat /var/ct/cfg/netmon.cf"
		fi
	done
}

netmonUpdate $NETMON_IP
