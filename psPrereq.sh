#!/bin/bash

#source `pwd`/conf ## for /bin/ksh
source config.ini # use /bin/bash for reading from the current directory
source jscommon.sh


pkgInstallPsHost(){    

    for SWNAME in "$@" 
        do
	    for HOST in $pshost
	        do
    		disp_msglvl2 "Installing $SWNAME on $HOST..."
            
            # no need to do command check. it's not command name but software package name. just install without a check. 
    		#ssh $SSH_NO_BANNER root@$HOST which $SWNAME > /dev/null 
            #if [ $? -ne 0 ]; then
                ssh $SSH_NO_BANNER $HOST yum -y install $SWNAME
            #else
            #    echo "$SWNAME is already installed on $HOST"
            #fi
    	done
    done
    
}

# Check package name on DB2 knowledge center 
# https://www.ibm.com/docs/en/db2/11.5?topic=linux-installation-prerequisites-db2-purescale-feature-intel#r0057441__11.5.7_pkg_req   
# 
# old script version 1.0 reference : libstdc++ sg3_utils libstdc++.so.6 perl-Sys-Syslog patch binutils cpp gcc-c++ kernel-3.10.0-693.21.1.el7.x86_64 kernel-devel-3.10.0-693.21.1.el7.x86_64 ntp ksh

# JSTODO : OS version check 
# JSTODO : if kernel package need install  
# JSTODO : if there is RoCE card.   

IB_PREREQ="libibverbs librdmacm rdma-core dapl rdma-core dapl ibacm ibutils"   # only for RoCE or Infiniband users   
IB_PREREQ88="libibverbs libibverbs-utils librdmacm librdmacm-utils rdma-core ibacm infiniband-diags iwpmd libibumad libpsm2 libpsm2-compat mstflint opa-address-resolution opa-basic-tools opa-fastfabric opa-libopamgt perftest qperf srp_daemon"   # only for RoCE or Infiniband users. Redhat 8.8

KERNEL_VER=`uname -r`
KERNEL_PREREQ="kernel-$KERNEL_VER kernel-devel-$KERNEL_VER kernel-headers-$KERNEL_VER"  # should be matched kernel version.   

REDHAT_79_PREREQ="$IB_PREREQ libstdc++ glibc gcc-c++ gcc $KERNEL_PREREQ linux-firmware ntp ntpdate sg3_utils sg3_utils-libs binutils binutils-devel m4 openssh cpp ksh libgcc libgomp make patch perl-Sys-Syslog mksh psmisc python3"    
# save time if IB and RDMA is not necessary 
REDHAT_79_PREREQ_TCPIP="libstdc++ glibc gcc-c++ gcc $KERNEL_PREREQ linux-firmware ntp ntpdate sg3_utils sg3_utils-libs binutils binutils-devel m4 openssh cpp ksh libgcc libgomp make patch perl-Sys-Syslog mksh psmisc python3"  

REDHAT_88_MISSING="perl perl-Net-Ping"  # The necessray packages that are not listed on KC   
REDHAT_88_PREREQ_TCPIP="$REDHAT_79_PREREQ_TCPIP $REDHAT_88_MISSING file"    # 'file' is listed on KC to Redhat 7.9 Prereq

## NOTE : TSA installlation fails if psmisc / mksh is missing   

## Decision to pick up PREREQ
PREREQ_FINAL=""

if [[ "$ID" == "rhel" && "$VERSION_ID" == "7.9" ]]; then
    PREREQ_FINAL=$REDHAT_79_PREREQ_TCPIP
elif [[ "$ID" == "rhel" && "$VERSION_ID" == "8.8" ]]; then
    PREREQ_FINAL=$REDHAT_88_PREREQ_TCPIP
fi

disp_msglvl1 "Prereq. package installation for pureScale"   
pkgInstallPsHost $PREREQ_FINAL
disp_msglvl1 "Installing iscsi-initiator-utils for connecting to iSCSI storage devices over a network"    
pkgInstallPsHost iscsi-initiator-utils 

disp_msglvl1 "Installing targetcli on iscsi storage server"    
ssh $SSH_NO_BANNER $iscsihost yum -y install targetcli


### We can ignore these warning during db2 installation ( or -f sysreq ) 
# DBT3514W  The db2prereqcheck utility failed to find the following 32-bit library file: "libstdc++.so.6".
# DBT3514W  The db2prereqcheck utility failed to find the following 32-bit library file: "/lib/libpam.so*".

### otherwise, use the following logic, but it would not be necessary.   
disp_msglvl1 "Installing few other components that install still complains as warning"   
pkgInstallPsHost "libstdc++.so.6 pam-devel"   

#for HOST in $pshost
#    do 
#        #DBT3514W  The db2prereqcheck utility failed to find the following 32-bit library file: "/lib/libpam.so*".
#        disp_msglvl1 "libpam library check on $HOST"
#        ssh $SSH_NO_BANNER $HOST yum whatprovides '*/libpam.so'
#    done
#done

# you may also find package names that provide files  
# ex) yum whatprovides '*/libpam.so'

