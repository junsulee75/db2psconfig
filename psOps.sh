#!/bin/bash

mode=$1    # mode to run

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh


psStop(){

	disp_msglvl1 "Stopping pureScale for maintenance" 
	disp_msglvl2 "Deactivate db "
	su - $INST_USER -c "db2 -v deactivate db sample"
	disp_msglvl2 "Stop db2 instance"
	su - $INST_USER -c "db2stop force"

	su - $INST_USER -c "db2instance -list"

	for HOST in $pshost
	do
		disp_msglvl2 "Stopping instance on $HOST"
		su - $INST_USER -c "db2stop instance on $HOST"
	done

	su - $INST_USER -c "db2instance -list"
	
	disp_msglvl2 "Enter CM maintenance"
	export DB2INSTANCE=$INST_USER
	# Should set DB2INSTANCE variable  	
	# https://www.ibm.com/support/pages/change-when-entering-purescale-maintenance-db2-v111-fp3  
	# The DB2INSTANCE environment variable has not been set. Set the DB2INSTANCE environment variable to the instance name and re-issue the command
	$DB2_INSTALL_PATH/bin/db2cluster -cm -enter -maintenance -all   # error if not using -all option  
	disp_msglvl2 "Enter CFS maintenance"
	$DB2_INSTALL_PATH/bin/db2cluster -cfs -enter -maintenance -all 

}

psStart(){
	disp_msglvl1 "Starting pureScale"
	disp_msglvl2 "Exit CM maintenance"
	export DB2INSTANCE=$INST_USER
	# Should set DB2INSTANCE variable  	
	# https://www.ibm.com/support/pages/change-when-entering-purescale-maintenance-db2-v111-fp3  
	# The DB2INSTANCE environment variable has not been set. Set the DB2INSTANCE environment variable to the instance name and re-issue the command
	$DB2_INSTALL_PATH/bin/db2cluster -cm -exit -maintenance -all
	disp_msglvl2 "Exit CFS maintenance"
	$DB2_INSTALL_PATH/bin/db2cluster -cfs -exit -maintenance -all 

	for HOST in $pshost
	do
		disp_msglvl2 "Starting instance on $HOST"
		su - $INST_USER -c "db2start instance on $HOST"
	done

	su - $INST_USER -c "db2instance -list"
	
	disp_msglvl2 "Start db2 instance"
	su - $INST_USER -c "db2start"

	su - $INST_USER -c "db2instance -list"

	disp_msglvl2 "activate db "
	su - $INST_USER -c "db2 -v activate db sample"

}

case $mode in
	stop )
		psStop
		;;
	start )
		psStart
		;;
	* ) 
		echo "Missing input operation : $0 [stop|start|status]"
		;;
esac

