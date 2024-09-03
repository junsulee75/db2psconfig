#!/bin/bash

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

##
createInstanceUser(){

    INSTUSER=$1
	for HOST in $pshost
	do
		disp_msglvl2 "create instance user on $HOST"
		#ssh $SSH_NO_BANNER $HOST "groupadd -g 990 db2iadm1" # existing on fyre redhat 8.8
		ssh $SSH_NO_BANNER $HOST "groupadd -g 888 db2iadm1"
		#ssh $SSH_NO_BANNER $HOST "groupadd -g 989 db2fadm1" # existing on fyre redhat 8.8
		ssh $SSH_NO_BANNER $HOST "groupadd -g 889 db2fadm1"
		ssh $SSH_NO_BANNER $HOST "useradd -u 1003 -g db2fadm1 -m -d /home/db2fenc1 -s /usr/bin/ksh db2fenc1"
        ssh $SSH_NO_BANNER $HOST "useradd -u 1002 -g db2iadm1 -m -d /home/$INSTUSER -s /usr/bin/ksh $INSTUSER"
        ssh $SSH_NO_BANNER $HOST "sudo -u $INSTUSER touch /home/$INSTUSER/.profile"
        cmdRetChk
        
	done
}

chkInstUser(){
    INSTUSER=$1
	for HOST in $pshost
	do
		disp_msglvl2 "checking the instance user $INSTUSER on $HOST"
        ssh $SSH_NO_BANNER $HOST "sudo -u $INSTUSER touch /home/$INSTUSER/.profile"
        cmdRetChk
	done
}

createInstanceUser $INST_USER
chkInstUser $INST_USER
