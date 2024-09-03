# DB2 pureScale automated installation reference scripts  


Scripts for Db2 pureScale installation and configuration orignially on IBM internal provisioned test systems.  

For freedom to provision a pureScale system with just running a couple of commands with minimum intervention.  

Sharing these for users who are interested in automating the steps.

>Refer these for test systems only, not for production system configuration usage.   

## Contents

- [DB2 pureScale automated installation reference scripts](#db2-purescale-automated-installation-reference-scripts)
  - [Contents](#contents)
  - [Steps](#steps)
    - [1. Prepare systems](#1-prepare-systems)
    - [2. Download the script](#2-download-the-script)
      - [Log in the 1st host](#log-in-the-1st-host)
      - [Download scripts](#download-scripts)
      - [Go to the downloaded directory](#go-to-the-downloaded-directory)
    - [3. Run `0_osenv.sh`](#3-run-0_osenvsh)
    - [4. Run `setup.sh`](#4-run-setupsh)
    - [5. Enjoy](#5-enjoy)
  - [Restriction](#restriction)
  - [Compatibility](#compatibility)


## Steps 
### 1. Prepare systems 

Create VMs like below.    

- x86 
- Redhat 7.9 or 8.8 only    
- Size : Just select largest one. At least 8 GB memory for each host      
- Quantity 5  ( 5 host VMs )  or 3 (3 hosts VMs)    

> At the moment, this script only works with 5 or 3 hosts.   
> 5 hosts : 1/2 members,  3/4 CFs and iscsi targe server for 5 to emulate storage.   
> 3 hosts : Colocated 1 member/cf,  2 member/cf and iscsi targe server for 3 to emulate storage.   
> In the future, planning to cover colocated pureScale/HADR with 5 hosts   
> (primary cluster 1/2 colocated, standby cluster 3/4 colocated and iscsi targe server for 5 to emulate storage.)      

### 2. Download the script 

#### Log in the 1st host  
``` 
ssh root@xxx1.fyre.ibm.com    
```

#### Download scripts

```
git clone https://github.com/junsulee75/db2psconfig
```

#### Go to the downloaded directory

```
cd purescale_on_fyre
```

### 3. Run `0_osenv.sh`

This is for setting up environment for running the script such as python3 and dependent yaml libraries etc.  
```
./0_osenv.sh
```

### 4. Run `setup.sh`

This will do everything until you pureScale instance.   

```
./setup.sh
```

That's it.    

[Contents](#contents)    

### 5. Enjoy

Once the previous script completes successfully, check the instance and create a database manually.   

```
su - db2inst1
db2instance -list 
db2 list db directory
db2 create db testdb
db2 activate db testdb
db2 connect to testdb
```

[Contents](#contents)    


## Restriction  
Scripts assumes the following things.   
- These are written for Fyre environment usage only.    
- Only install DB2 v11.5.8.0 on Redhat 7.9 or DB2 v11.5.9.0 on Redhat 8.8   
- `yum` should be configured in advance.  
- Passwordless root login should be set among hosts   
- For now, only 3 or 5 hosts configurations are supported.    
- hostname convention should be like xxx1, xxx2, xxx3, xxx4 and xxx5.  

[Contents](#contents)    


## Compatibility  

Unfortunately, automatic OS kernel patch may mess up existing working environemnt.  
Best practice is turning off auto patch and you do manual kernel patch in regular basis.   

Here, listing up combination of versions that I could install successfully.   
(I am not saying it as official compatibility but to say it worked to me at least in terms of successful configuration to `db2start`.)

Tested combinations.   

| DB2 | GPFS | TSA  | Redhat kernel version | Red Hat Release |
|:---------------:|:-----------------|:-----------------| :--------------------| :--------------------|
|11.5.9.0 | 5.1.8.1 | 4.1.1.1 | 4.18.0-477.27.1.el8_8.x86_64 | RHEL 8.8 |
|11.5.8.0 | 5.1.2.5 | 4.1.0.7+efix4|3.10.0-1160.114.2.el7.x86_64 | RHEL 7.9 |
|11.5.8.0 | 5.1.2.5 | 4.1.0.7+efix4|3.10.0-1160.108.1.el7.x86_64 | RHEL 7.9 |
|11.5.8.0 | 5.1.2.5 | 4.1.0.7+efix4|3.10.0-1160.105.1.el7.x86_64 | RHEL 7.9 |
|11.5.8.0 | 5.1.2.5 | 4.1.0.7+efix4|3.10.0-1160.102.1.el7.x86_64 | RHEL 7.9 |
|11.5.8.0 | 5.1.2.5 | 4.1.0.7+efix4|3.10.0-1160.99.1.el7.x86_64 | RHEL 7.9 |
|11.5.8.0 | 5.1.2.5 | 4.1.0.7+efix4|3.10.0-1160.88.1.el7.x86_64 | RHEL 7.9 |
|11.5.5.1 | 5.0.5.0 | 4.1.0.5 efix4|3.10.0-1160.25.1.el7.x86_64 | RHEL 7.9 |
|11.5 GA SB 39945 | 5.0.2.3 | 4.1.0.4 efix2  | 3.10.0-1062.18.1.el7.x86_64 | RHEL 7.7 |
|11.1.3 fp3a | 4.1.1.7 |4.1.0.3 efix5| 3.10.0-693.21.1.el7.x86_64 | RHEL 7.4 |



[Red Hat Linux kernel version numbering](https://access.redhat.com/articles/3078)   
[TSA/GPFS version in DB2](https://pages.github.ibm.com/DB2/db2-dev-playbook/release/db2-dependent-product-level.html?highlight=TSA)     
[iscsi target](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/configuring-an-iscsi-target_managing-storage-devices)    
[iscsi initiator](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/configuring-an-iscsi-initiator_managing-storage-devices)   


[Content](#contents)   
