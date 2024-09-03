#!/bin/bash
#set -x
#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

##
checkDisk(){

	disp_msglvl1 "Checking shared iscsi disk information"   
	
	for HOST in $pshost
	do
		ssh $SSH_NO_BANNER $HOST fdisk -l |grep sda
		if [ $? -ne 0 ]; then
			disp_msglvl2 "$HOST : iscsi disk does not exist on $HOST. Exit.."
  		    exit 1 
		else
	 	   echo "$HOST : iscsi disk exists on $HOST. GOOD !!! "
		fi	
	done
}

pureScaleInstCreate(){
	disp_msglvl1 "generating command based on $NUM_PSHOST hosts"

	pshosts_concatenated=$(echo "$pshost" | tr '\n' ' ')  # pshost is hostnames split by linefeed. Changing it to space splitted  
	#echo "|$pshost|"
	#pshost2="jspstest1.fyre.ibm.com jspstest2.fyre.ibm.com jspstest3.fyre.ibm.com jspstest4.fyre.ibm.com"	 # works.  
	#echo "|$pshost2|"
	#read -ra tempHosts <<< "$testHosts"
	
	# vectorize hostnames 
	IFS=' ' read -r -a tempHosts <<< "$pshosts_concatenated"
	#echo "${tempHosts[0]}"
	#echo "${tempHosts[1]}"
	#echo "${tempHosts[2]}"
	#echo "${tempHosts[3]}" 
	
	MEM0HOST=""
	MEM1HOST=""
	CF128HOST=""
	CF129HOST=""

	if (( $NUM_PSHOST == 4 )); then 
		MEM0HOST="${tempHosts[0]}"
		MEM1HOST="${tempHosts[1]}"
		CF128HOST="${tempHosts[2]}"
		CF129HOST="${tempHosts[3]}"

	elif (( $NUM_PSHOST == 2 )); then

		# colocated 	
		MEM0HOST="${tempHosts[0]}"
		MEM1HOST="${tempHosts[1]}"
		CF128HOST="${tempHosts[0]}"
		CF129HOST="${tempHosts[1]}"

	else
		disp_msglvl1 "$NUM_PSHOST hosts are not supported in this script. Exit !!" 
	fi

	disp_msglvl2 "command to run : $DB2_INSTALL_PATH/instance/db2icrt -d -m $MEM0HOST -mnet $MEM0HOST -m $MEM1HOST -mnet $MEM1HOST -cf $CF128HOST -cfnet $CF128HOST -cf $CF129HOST -cfnet $CF129HOST -instance_shared_dev /dev/sda -tbdev $ISCSI_TARGET_IP -u db2fenc1 db2inst1"
	disp_msglvl1 "Starting instance creation. Fingers crossed !! "  
	$DB2_INSTALL_PATH/instance/db2icrt -d -m $MEM0HOST -mnet $MEM0HOST -m $MEM1HOST -mnet $MEM1HOST -cf $CF128HOST -cfnet $CF128HOST -cf $CF129HOST -cfnet $CF129HOST -instance_shared_dev /dev/sda -tbdev $ISCSI_TARGET_IP -u db2fenc1 db2inst1

}

pureScaleInstChk(){
	INSTCHK=`$DB2_INSTALL_PATH/instance/db2ilist`
	#if [ -n "$iqn_name" ]; then  # NULL check
	if [[ $INSTCHK == $INST_USER ]]; then  # check if the expected instance exists
		disp_msglvl2 " $INST_USER instance is created"
		su - $INST_USER -c "db2instance -list"
		disp_msglvl2 " db2set DB2_SD_ALLOW_SLOW_NETWORK=ON "  
		su - $INST_USER -c "db2set DB2_SD_ALLOW_SLOW_NETWORK=ON"
		disp_msglvl2 "Start $INST_USER instance."
		su - $INST_USER -c "db2start"
		su - $INST_USER -c "db2instance -list"

	else
		disp_msglvl2 " $INST_USER instance is not created. Check !!"
		exit
	fi
}

createSampleDB(){
	su - $INST_USER -c "db2instance -list"
	if [ $? -eq 0 ] ; then
		disp_msglvl2 " db2instance is normal status. Creating sample db. From now on, check things by yourself and do your preferred work manually. Enjoy !! "
		su - $INST_USER -c "db2sampl"
	else
		disp_msglvl2 " db2instance is not fully normal. Check and create a DB manually"
		exit
	fi
}

checkDisk
pureScaleInstCreate
pureScaleInstChk
createSampleDB
