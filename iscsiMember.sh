#!/bin/bash

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

targetIQN=""   # target IQN name  

iscsiMemberInstall(){

	disp_msglvl1 "Checking if iscsi software is installed on pureScale hosts"
	for HOST in $pshost
	do	
		ssh $SSH_NO_BANNER $HOST which iscsi-iname
		if [ $? -ne 0 ] ; then
			disp_msglvl2 " $HOST : Installing iscsi-iname on pureScale hosts ( iscsi member client)"    
			ssh $SSH_NO_BANNER $HOST yum -y install iscsi-initiator-utils
		else
			disp_msglvl2 " $HOST : iscsi-initiator-utils is ALREADY INSTALLED. Skipping installation... "
		fi
	done
}

getTargetIQN(){
	targetIQN=`ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/ ls'|grep iqn|grep -v 'Mapped LUNs'|awk '{print $2}'`  
	#if [ -n "$iqn_name" ]; then  # NULL check
	if [[ $targetIQN == "iqn"* ]]; then  # check if iqn_name start with the pattern "ipn".  
		disp_msglvl2 " $iscsihost : iqn (iSCSI Qualified Name) of the target node : $targetIQN"		
	else
		disp_msglvl2 " can't get iqn from target node or wrong pattern name. iqn=$targetIQN. Check iscsi target configuration again.  Exit !!! "	
		exit
	fi
}

confInit(){
	disp_msglvl1 "Configure ISCSI initiator  "		
	disp_msglvl2 "iqn (iSCSI Qualified Name) of the target node : $targetIQN"		
	disp_msglvl2 "IP addresss of the target node : $ISCSI_TARGET_IP"		
	
	disp_msglvl1 " Generating initiator iqn on each pureScale host " 

	for HOST in $pshost
	do
		disp_msglvl2 " $HOST : iscsi initiator configuration " 
		echo " $HOST : move /etc/iscsi/initiatorname.iscsi "   
		ssh $SSH_NO_BANNER $HOST "mv -f /etc/iscsi/initiatorname.iscsi /var/tmp/initiatorname.iscsi.backup"
		echo " $HOST : generate new initiator iqn and save to /etc/iscsi/initiatorname.iscsi. NOTE : Whenever running /sbin/iscsi-iname, it generates new. "
	 	genIQN=`ssh $SSH_NO_BANNER $HOST /sbin/iscsi-iname`	
		echo " $HOST : Save the generated iqn : $genIQN to /etc/iscsi/initiatorname.iscsi. "
	 	ssh $SSH_NO_BANNER $HOST "echo \"InitiatorName=$genIQN\" > /etc/iscsi/initiatorname.iscsi"	
		echo " $HOST : double check /etc/iscsi/initiatorname.iscsi"
		ssh $SSH_NO_BANNER $HOST cat /etc/iscsi/initiatorname.iscsi 
	 	fileIQN=`ssh $SSH_NO_BANNER $HOST cat /etc/iscsi/initiatorname.iscsi|awk -F= '{print $2}'`
		echo " $HOST : get IQN from /etc/iscsi/initiatorname.iscsi  : $fileIQN"
		
		if [ "$genIQN" = "$fileIQN" ]; then
			disp_msglvl2 " $HOST : IQN Check success !! "
			disp_msglvl2 " $iscsihost Creating iqn between target and $HOST "
			ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/'$targetIQN'/tpg1/acls create '$fileIQN
			if [ $? -ne 0 ]; then
				echo "$iscsihost : targetcli creation failure for $HOST. Exit.."
   			    exit 1 
			else
	 		   echo "$iscsihost : targetcli creation SUCCESS for $HOST. !!! "
			fi	
		else 
			disp_msglvl2 " $HOST : IQN Check does not match. Something in the middle. Check again. Exit !! "
			exit 
		fi

	done	
}


confPost(){
	disp_msglvl1 "Post setup for iscsi on each pureScale host "		
	disp_msglvl2 "iqn (iSCSI Qualified Name) of the target node : $targetIQN"		
	disp_msglvl2 "IP addresss of the target node : $ISCSI_TARGET_IP"		
	
	for HOST in $pshost
	do
		disp_msglvl2 " $HOST : discover target IQN name " 
		ssh $SSH_NO_BANNER $HOST "iscsiadm -m discovery -t st -p $ISCSI_TARGET_IP"
	 	discoverIQN=`ssh $SSH_NO_BANNER $HOST iscsiadm -m discovery -t st -p $ISCSI_TARGET_IP | awk '{print $NF}'`	
		echo "discovered IQN : $discoverIQN"
		if [ "$discoverIQN" = "$targetIQN" ]; then		
			echo " $HOST : target IQN value querying from both target and $HOST matches :  SUCCESS !! "
			disp_msglvl2 "$HOST : login to target and setup auto start/login then save. "	
			disp_msglvl2 "$HOST : login to target"
			ssh $SSH_NO_BANNER $HOST  iscsiadm -m node -T $targetIQN -l
			disp_msglvl2 "$HOST : auto start setup setting "
			ssh $SSH_NO_BANNER $HOST  iscsiadm -m node -T $targetIQN -o update -n node.startup -v automatic
			ssh $SSH_NO_BANNER $HOST  iscsiadm -m node -T $targetIQN -o update -n node.conn[0].startup -v automatic

			disp_msglvl2 "$iscsihost : save the configuration for $HOST "
			ssh $SSH_NO_BANNER $iscsihost targetcli saveconfig
		else 
			echo " $HOST : target IQN value querying from both target and $HOST do not match. Exit !! "
			exit 
		fi
	done	
}

startISCSIService(){
	for HOST in $pshost
	do
		disp_msglvl2 "$HOST : start iscsi initiator service"   
		ssh $SSH_NO_BANNER $HOST service iscsi start
		ssh $SSH_NO_BANNER $HOST service iscsi status
		ssh $SSH_NO_BANNER $HOST fdisk -l
	done

}

iscsiMemberInstall
getTargetIQN  # if fail on this, should exit 
confInit
confPost
startISCSIService
