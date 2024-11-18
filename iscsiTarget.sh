#!/bin/bash

# Jun Su Lee : 
# Reference doc : https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/configuring-an-iscsi-target_managing-storage-devices    

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

iscsiTargetInstall(){
	
	ssh $SSH_NO_BANNER $iscsihost which targetcli	
	if [ $? -ne 0 ] ; then
		disp_msglvl1 " $iscsihost : Installing targetcli on iscsi storage server"    
		ssh $SSH_NO_BANNER $iscsihost yum -y install targetcli
	else
		disp_msglvl1 " $iscsihost : targetcli is ALREADY INSTALLED. Skipping installation... "
	fi
}

startisci(){

	disp_msglvl1 " $iscsihost : start iscsi target service " 
	ssh $SSH_NO_BANNER $iscsihost systemctl start target
	ssh $SSH_NO_BANNER $iscsihost systemctl enable target ; cmdRetChk
	ssh $SSH_NO_BANNER $iscsihost systemctl status target
}

iscsiCreateBackstore(){
	disp_msglvl1 " $iscsihost : create iscsi target with size and location"
	ssh $SSH_NO_BANNER $iscsihost mkdir -p /work/iscsi
	disp_msglvl2 " create backstore with the type, name, location and size"
	ssh $SSH_NO_BANNER $iscsihost targetcli '/backstores/fileio create ps111 /work/iscsi/ps111.ext 60GB write_back=false'
	#Let's create one disk only in this script. For adding disk, will use other function in separate script file.   
	#That would be better for assigning device name by orer /dev/sda here, then for added one later, /dev/sdb ...
	#ssh $SSH_NO_BANNER $iscsihost targetcli '/backstores/fileio create tb111 /work/iscsi/tb111.ext 5GB write_back=false' # for tiebreaker disk  
	disp_msglvl2 " create iscsi target"
	ssh $SSH_NO_BANNER $iscsihost targetcli /iscsi/ create
	disp_msglvl2 " list created targetcli"
	ssh $SSH_NO_BANNER $iscsihost targetcli ls
	disp_msglvl2 " check the created file store. See the size is expected. " 
	ssh $SSH_NO_BANNER $iscsihost "ls -l /work/iscsi"   
}

iscsiCreateLUN(){
	
	disp_msglvl1 " $iscsihost : create SCSI"
	# iqn (iSCSI Qualified Name) of the target node. At this time, there should be only one iqn   
	iqn_name=`ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/ ls'|grep iqn|grep -v 'Mapped LUNs'|awk '{print $2}'`
	disp_msglvl2 " $iscsihost : iqn (iSCSI Qualified Name) of the target node : $iqn_name"
	
	ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/'$iqn_name'/tpg1/portals delete ip_address=0.0.0.0 ip_port=3260'
	disp_msglvl2 " $iscsihost : /iscsi : iSCSI namespace, /tpg1: target portal group (TPG), /portals: Specifies the portals associated with the specified TPG"   

	disp_msglvl2 " $iscsihost : create a new iSCSI portal within a specific target portal group (TPG)"  # multiple iqn can share one IP
	ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/'$iqn_name'/tpg1/portals/ create '$ISCSI_TARGET_IP
	
	disp_msglvl2 " $iscsihost : create a Logical Unit Number (LUN) within a specific target portal group (TPG) in the iSCSI configuration"
	ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/'$iqn_name'/tpg1/luns create /backstores/fileio/ps111'
	#ssh $SSH_NO_BANNER $iscsihost targetcli '/iscsi/'$iqn_name'/tpg1/luns create /backstores/fileio/tb111'

	# targetcli '/iscsi/'$iqn_name'/tpg1/acls create iqn.1991-05.com.microsoft:tyro1'
	# targetcli '/iscsi/'$iqn_name'/tpg1/acls create iqn.1994-05.com.redhat:e2526c54a41'
	disp_msglvl2 " $iscsihost : list created LUN" 
	ssh $SSH_NO_BANNER $iscsihost targetcli ls
	
	disp_msglvl2 " $iscsihost : save configuration"
	ssh $SSH_NO_BANNER $iscsihost targetcli saveconfig
}

iscsiTargetInstall
startisci
iscsiCreateBackstore
iscsiCreateLUN


