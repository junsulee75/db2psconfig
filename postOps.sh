#!/bin/bash

# operations to do after installation when necessary

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

##
kshProfileConf(){

	
    INSTUSER=$1
	
	print1 "ksh profile setting for $INSTUSER"

	line="PS1='\$(whoami)@\$(hostname -s):\${PWD} \$ '"
	echo "$line" >> /home/$INSTUSER/.profile	
	echo "set -o vi" >> /home/$INSTUSER/.profile
	echo "set -o vi" >> /home/$INSTUSER/.kshrc  # to replace set -o emacs
	

	for HOST in $pshost_other
	do
		disp_msglvl2 "Copying .profile to $HOST"
		scp /home/$INSTUSER/.profile root@$HOST:/home/$INSTUSER 
        cmdRetChk
		ssh $SSH_NO_BANNER $HOST cat /home/$INSTUSER/.profile 
		disp_msglvl2 "Copying .kshrc to $HOST"
		scp /home/$INSTUSER/.kshrc root@$HOST:/home/$INSTUSER 
        cmdRetChk
		ssh $SSH_NO_BANNER $HOST cat /home/$INSTUSER/.kshrc
        
	done
}

kshProfileConf $INST_USER
