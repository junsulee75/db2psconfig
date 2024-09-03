#!/bin/bash

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh

##
copyImage(){

	disp_msglvl1 "Downloading DB2 installation image..."
	## download to /root directory   
	# old way using scp
	#scp root@$DB2_IMAGE_DOWNLOAD_SERVER:$DB2_IMAGE_PATH_ON_SERVER/$DB2_IMAGE_FILE_NAME /root
	# new way by curl ( I set web server for this. ) 
	curl http://$DB2_IMAGE_DOWNLOAD_SERVER/$DB2_IMAGE_PATH_ON_SERVER/$DB2_IMAGE_FILE_NAME -o /root/$DB2_IMAGE_FILE_NAME


	for HOST in $pshost_other
	do
		disp_msglvl2 "Copy DB2 installation image to $HOST..."
		scp /root/$DB2_IMAGE_FILE_NAME root@$HOST:/root 
	done
}

extractImage(){

	for HOST in $pshost
	do
		ssh $SSH_NO_BANNER $HOST "test -d \"/root/server_dec\""
		if [ $? -eq 0 ]; then
			disp_msglvl2 "There is existing image path /root/server_dec. Will remove it."  
			ssh $SSH_NO_BANNER $HOST "rm -rf /root/server_dec"
		fi
		disp_msglvl1 "Extracting DB2 installation image on $HOST"
		ssh $SSH_NO_BANNER $HOST "tar xvfz /root/$DB2_IMAGE_FILE_NAME"
	done
}

## We install DB2 on all hosts.   
installDB2(){
	for HOST in $pshost
	do
		disp_msglvl1 "Installing DB2 on $HOST..."  # JSTODO : to ignore libpam.so 32 bit lib warning.  
		ssh $SSH_NO_BANNER $HOST "/root/server_dec/db2_install -y -b $DB2_INSTALL_PATH -f PURESCALE -p server -n"
	done
}

chkDb2Install(){
	disp_msglvl1 "Check the installation"   
	for HOST in $pshost
	do
		disp_msglvl2 "Db2 Installation on $HOST..."
		ssh $SSH_NO_BANNER $HOST "db2ls -c"
	done
}

applyLic(){

	disp_msglvl1 "Downloading DB2 license ..."
	## download to /root directory   
	# old way using scp
	#scp root@$DB2_IMAGE_DOWNLOAD_SERVER:$DB2_IMAGE_PATH_ON_SERVER/$DB2_IMAGE_FILE_NAME /root
	# new way by curl ( I set web server for this. ) 
	curl http://$DB2_IMAGE_DOWNLOAD_SERVER/$DB2115LICPATH/$DB2115LIC -o /root/$DB2115LIC

	for HOST in $pshost_other
	do
		disp_msglvl2 "Copy LIC to $HOST..."
		scp /root/$DB2115LIC root@$HOST:/root 
	done
	
	for HOST in $pshost
	do
		disp_msglvl1 "Apply LIC on $HOST..."
		ssh $SSH_NO_BANNER $HOST "$DB2_INSTALL_PATH/adm/db2licm -a /root/$DB2115LIC"
	done
}

copyImage
extractImage
installDB2
chkDb2Install

applyLic