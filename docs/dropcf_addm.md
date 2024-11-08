# Drop CF and add member example 

This example is just to show the technocal concept dropping and adding a CF or a member concentually.    
It's not realistic scenario as having one CF is not recommened as it is single point of failure. 

## Contents

- [Drop CF and add member example](#drop-cf-and-add-member-example)
  - [Contents](#contents)
  - [Steps](#steps)
    - [Drop a CF](#drop-a-cf)
    - [add a member](#add-a-member)


## Steps 

### Drop a CF


```
[root@jspstest1 purescale_on_fyre]# /opt/ibm/db2/V1159/instance/db2iupdt -d -drop -cf jspstest4.fyre.ibm.com  db2inst1 
DBI1446I  The db2iupdt command is running.


DB2 installation is being initialized.


Total number of tasks to be performed: 3 
Total estimated time for all tasks to be performed: 310 second(s) 

Task #1 start
Description: Initializing instance list 
Estimated time 5 second(s) 
Task #1 end 

Task #2 start
Description: Initiating the remote host list 
Estimated time 5 second(s) 
Task #2 end 

Task #3 start
Description: Configuring DB2 instances 
Estimated time 300 second(s) 
Task #3 end 

The execution completed with warnings.

For more information see the DB2 installation log at
"/tmp/db2iupdt.log.217368".
DBI20182W  Program "db2iupdt" completed successfully but with warnings. 
[root@jspstest1 purescale_on_fyre]# su - db2inst1
Last login: Thu Jul 18 18:07:27 PDT 2024 on pts/0
$ db2instance -list
ID	  TYPE	           STATE		HOME_HOST		CURRENT_HOST		ALERT	PARTITION_NUMBER	LOGICAL_PORT	NETNAME
--	  ----	           -----		---------		------------		-----	----------------	------------	-------
0	MEMBER	         STARTED		jspstest1		   jspstest1		   NO	               0	           0	jspstest1.fyre.ibm.com
1	MEMBER	         STARTED		jspstest2		   jspstest2		   NO	               0	           0	jspstest2.fyre.ibm.com
128	CF	         PRIMARY		jspstest3		   jspstest3		   NO	               -	           0	jspstest3.fyre.ibm.com

HOSTNAME		   STATE		INSTANCE_STOPPED	ALERT
--------		   -----		----------------	-----
jspstest3		  ACTIVE		              NO	   NO
jspstest2		  ACTIVE		              NO	   NO
jspstest1		  ACTIVE		              NO	   NO
$ exit
```

[content](#contents)

### add a member  

```
[root@jspstest1 purescale_on_fyre]# /opt/ibm/db2/V1159/instance/db2iupdt -d -add -m jspstest4.fyre.ibm.com  -mnet jspstest4.fyre.ibm.com db2inst1 
DBI1446I  The db2iupdt command is running.


DB2 installation is being initialized.


Total number of tasks to be performed: 10 
Total estimated time for all tasks to be performed: 1074 second(s) 

Task #1 start
Description: Installing DB2 files on remote hosts 
Estimated time 600 second(s) 
Task #1 end 

Task #2 start
Description: Installing or updating DB2 HA scripts for IBM Tivoli System Automation for Multiplatforms (Tivoli SA MP) 
Estimated time 40 second(s) 
Task #2 end 

Task #3 start
Description: Installing or updating DB2 Cluster Scripts for IBM Spectrum Scale (GPFS) 
Estimated time 40 second(s) 
Task #3 end 

Task #4 start
Description: Registering licenses on remote hosts 
Estimated time 40 second(s) 
Task #4 end 

Task #5 start
Description: Setting default global profile registry variables 
Estimated time 1 second(s) 
Task #5 end 

Task #6 start
Description: Register NTP 
Estimated time 40 second(s) 
Task #6 end 

Task #7 start
Description: Initializing instance list 
Estimated time 5 second(s) 
Task #7 end 

Task #8 start
Description: Initiating the remote host list 
Estimated time 5 second(s) 
Task #8 end 

Task #9 start
Description: Configuring DB2 instances 
Estimated time 300 second(s) 
Task #9 end 

Task #10 start
Description: Updating global profile registry 
Estimated time 3 second(s) 
Task #10 end 

The execution completed with warnings.

For more information see the DB2 installation log at
"/tmp/db2iupdt.log.237112".
DBI20182W  Program "db2iupdt" completed successfully but with warnings. 
[root@jspstest1 purescale_on_fyre]# su - db2inst1
Last login: Thu Jul 18 18:34:24 PDT 2024 on pts/0
$ db2instance -list
ID	  TYPE	           STATE		HOME_HOST		CURRENT_HOST		ALERT	PARTITION_NUMBER	LOGICAL_PORT	NETNAME
--	  ----	           -----		---------		------------		-----	----------------	------------	-------
0	MEMBER	         STARTED		jspstest1		   jspstest1		   NO	               0	           0	jspstest1.fyre.ibm.com
1	MEMBER	         STARTED		jspstest2		   jspstest2		   NO	               0	           0	jspstest2.fyre.ibm.com
2	MEMBER	         STOPPED		jspstest4		   jspstest4		   NO	               0	           0	jspstest4.fyre.ibm.com
128	CF	         PRIMARY		jspstest3		   jspstest3		   NO	               -	           0	jspstest3.fyre.ibm.com

HOSTNAME		   STATE		INSTANCE_STOPPED	ALERT
--------		   -----		----------------	-----
jspstest4		  ACTIVE		              NO	   NO
jspstest3		  ACTIVE		              NO	   NO
jspstest2		  ACTIVE		              NO	   NO
jspstest1		  ACTIVE		              NO	   NO
$ db2start member 2
07/18/2024 18:57:51     2   0   SQL1063N  DB2START processing was successful.
SQL1063N  DB2START processing was successful.
$ db2instance -list
ID	  TYPE	           STATE		HOME_HOST		CURRENT_HOST		ALERT	PARTITION_NUMBER	LOGICAL_PORT	NETNAME
--	  ----	           -----		---------		------------		-----	----------------	------------	-------
0	MEMBER	         STARTED		jspstest1		   jspstest1		   NO	               0	           0	jspstest1.fyre.ibm.com
1	MEMBER	         STARTED		jspstest2		   jspstest2		   NO	               0	           0	jspstest2.fyre.ibm.com
2	MEMBER	         STARTED		jspstest4		   jspstest4		   NO	               0	           0	jspstest4.fyre.ibm.com
128	CF	         PRIMARY		jspstest3		   jspstest3		   NO	               -	           0	jspstest3.fyre.ibm.com

HOSTNAME		   STATE		INSTANCE_STOPPED	ALERT
--------		   -----		----------------	-----
jspstest4		  ACTIVE		              NO	   NO
jspstest3		  ACTIVE		              NO	   NO
jspstest2		  ACTIVE		              NO	   NO
jspstest1		  ACTIVE		              NO	   NO
```

[contents](#contents)   


