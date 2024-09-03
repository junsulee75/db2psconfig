# Installation output example   

See how it goes.   

## Contents

- [Installation output example](#installation-output-example)
  - [Contents](#contents)
  - [Output](#output)
    - [iscsi target creation](#iscsi-target-creation)
    - [iscsi client configuration](#iscsi-client-configuration)
    - [create pureScale instance](#create-purescale-instance)


## Output  
### iscsi target creation 

```
YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
Note : pureScale configuration
  [ 0 ] : ..
  [ 1 ] : Prereq. packages installation
  [ 2 ] : Db2 pureScale installation on all hosts
  [ 3 ] : create instance user
  [ 4 ] : configure /var/ct/cfg/netmon.cf
  [ 5 ] : setup iscsi target
  [ 6 ] : setup iscsi member clients
  [ 7 ] : create a pureScale instance
  [ 8 ] : quit


Auto pick : option=5, delay=0
prompt=0  parsing : iscsiTarget.sh
/usr/bin/targetcli


###########################################################################################
jspstest5.fyre.ibm.com : targetcli is ALREADY INSTALLED. Skipping installation...
###########################################################################################



###########################################################################################
jspstest5.fyre.ibm.com : start iscsi target service
###########################################################################################

Created symlink from /etc/systemd/system/multi-user.target.wants/target.service to /usr/lib/systemd/system/target.service.
success !!!
● target.service - Restore LIO kernel target configuration
   Loaded: loaded (/usr/lib/systemd/system/target.service; enabled; vendor preset: disabled)
   Active: active (exited) since Tue 2024-05-28 01:12:02 PDT; 2s ago
 Main PID: 8556 (code=exited, status=0/SUCCESS)

May 28 01:12:02 jspstest5.fyre.ibm.com systemd[1]: Starting Restore LIO kernel target configuration...
May 28 01:12:02 jspstest5.fyre.ibm.com target[8556]: No saved config file at /etc/target/saveconfig.json, ok, exiting
May 28 01:12:02 jspstest5.fyre.ibm.com systemd[1]: Started Restore LIO kernel target configuration.


###########################################################################################
jspstest5.fyre.ibm.com : create iscsi target with size and location
###########################################################################################


**********************************************
create backstore with the type, name, location and size
**********************************************

Warning: Could not load preferences file /root/.targetcli/prefs.bin.
Created fileio ps111 with size 64424509440

**********************************************
create iscsi target
**********************************************

Created target iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.

**********************************************
list created targetcli
**********************************************

o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 0]
  | o- fileio ................................................................................................. [Storage Objects: 1]
  | | o- ps111 ............................................................ [/work/iscsi/ps111.ext (60.0GiB) write-thru deactivated]
  | |   o- alua ................................................................................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ....................................................................... [ALUA state: Active/optimized]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 1]
  | o- iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da ....................................................... [TPGs: 1]
  |   o- tpg1 ............................................................................................... [no-gen-acls, no-auth]
  |     o- acls .......................................................................................................... [ACLs: 0]
  |     o- luns .......................................................................................................... [LUNs: 0]
  |     o- portals .................................................................................................... [Portals: 1]
  |       o- 0.0.0.0:3260 ..................................................................................................... [OK]
  o- loopback ......................................................................................................... [Targets: 0]

**********************************************
check the created file store. See the size is expected.
**********************************************

total 0
-rw-r--r-- 1 root root 64424509440 May 28 01:12 ps111.ext


###########################################################################################
jspstest5.fyre.ibm.com : create SCSI
###########################################################################################


**********************************************
jspstest5.fyre.ibm.com : iqn (iSCSI Qualified Name) of the target node : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
**********************************************

Deleted network portal 0.0.0.0:3260

**********************************************
jspstest5.fyre.ibm.com : /iscsi : iSCSI namespace, /tpg1: target portal group (TPG), /portals: Specifies the portals associated with the specified TPG
**********************************************


**********************************************
jspstest5.fyre.ibm.com : create a new iSCSI portal within a specific target portal group (TPG)
**********************************************

Using default IP port 3260
Created network portal 10.11.56.198:3260.

**********************************************
jspstest5.fyre.ibm.com : create a Logical Unit Number (LUN) within a specific target portal group (TPG) in the iSCSI configuration
**********************************************

Created LUN 0.

**********************************************
jspstest5.fyre.ibm.com : list created LUN
**********************************************

o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 0]
  | o- fileio ................................................................................................. [Storage Objects: 1]
  | | o- ps111 .............................................................. [/work/iscsi/ps111.ext (60.0GiB) write-thru activated]
  | |   o- alua ................................................................................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ....................................................................... [ALUA state: Active/optimized]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 1]
  | o- iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da ....................................................... [TPGs: 1]
  |   o- tpg1 ............................................................................................... [no-gen-acls, no-auth]
  |     o- acls .......................................................................................................... [ACLs: 0]
  |     o- luns .......................................................................................................... [LUNs: 1]
  |     | o- lun0 ........................................................ [fileio/ps111 (/work/iscsi/ps111.ext) (default_tg_pt_gp)]
  |     o- portals .................................................................................................... [Portals: 1]
  |       o- 10.11.56.198:3260 ................................................................................................ [OK]
  o- loopback ......................................................................................................... [Targets: 0]

**********************************************
jspstest5.fyre.ibm.com : save configuration
**********************************************

Configuration saved to /etc/target/saveconfig.json


YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
Note : pureScale configuration
Last Command : [5] setup iscsi target => iscsiTarget.sh
  [ 0 ] : ..
  [ 1 ] : Prereq. packages installation
  [ 2 ] : Db2 pureScale installation on all hosts
  [ 3 ] : create instance user
  [ 4 ] : configure /var/ct/cfg/netmon.cf
  [ 5 ] : setup iscsi target
  [ 6 ] : setup iscsi member clients
  [ 7 ] : create a pureScale instance
  [ 8 ] : quit


Auto pick : option=8, delay=0
Keystrokes ['1', '6', '8']


YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
  [ 0 ] : ..
  [ 1 ] : pureScale configuration *
  [ 2 ] : Future usage *
  [ 3 ] : quit


Auto pick : option=1, delay=0


YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
Note : pureScale configuration
  [ 0 ] : ..
  [ 1 ] : Prereq. packages installation
  [ 2 ] : Db2 pureScale installation on all hosts
  [ 3 ] : create instance user
  [ 4 ] : configure /var/ct/cfg/netmon.cf
  [ 5 ] : setup iscsi target
  [ 6 ] : setup iscsi member clients
  [ 7 ] : create a pureScale instance
  [ 8 ] : quit
```
[Content](#contents)  

### iscsi client configuration

```

Auto pick : option=6, delay=0
prompt=0  parsing : iscsiMember.sh


###########################################################################################
Checking if iscsi software is installed on pureScale hosts
###########################################################################################

/usr/sbin/iscsi-iname

**********************************************
jspstest1.fyre.ibm.com : iscsi-initiator-utils is ALREADY INSTALLED. Skipping installation...
**********************************************

/usr/sbin/iscsi-iname

**********************************************
jspstest2.fyre.ibm.com : iscsi-initiator-utils is ALREADY INSTALLED. Skipping installation...
**********************************************

/usr/sbin/iscsi-iname

**********************************************
jspstest3.fyre.ibm.com : iscsi-initiator-utils is ALREADY INSTALLED. Skipping installation...
**********************************************

/usr/sbin/iscsi-iname

**********************************************
jspstest4.fyre.ibm.com : iscsi-initiator-utils is ALREADY INSTALLED. Skipping installation...
**********************************************


**********************************************
jspstest5.fyre.ibm.com : iqn (iSCSI Qualified Name) of the target node : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
**********************************************



###########################################################################################
Configure ISCSI initiator
###########################################################################################


**********************************************
iqn (iSCSI Qualified Name) of the target node : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
**********************************************


**********************************************
IP addresss of the target node : 10.11.56.198
**********************************************



###########################################################################################
Generating initiator iqn on each pureScale host
###########################################################################################


**********************************************
jspstest1.fyre.ibm.com : iscsi initiator configuration
**********************************************

 jspstest1.fyre.ibm.com : move /etc/iscsi/initiatorname.iscsi
 jspstest1.fyre.ibm.com : generate new initiator iqn and save to /etc/iscsi/initiatorname.iscsi. NOTE : Whenever running /sbin/iscsi-iname, it generates new.
 jspstest1.fyre.ibm.com : Save the generated iqn : iqn.1994-05.com.redhat:7b1558ddb8a to /etc/iscsi/initiatorname.iscsi.
 jspstest1.fyre.ibm.com : double check /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.1994-05.com.redhat:7b1558ddb8a
 jspstest1.fyre.ibm.com : get IQN from /etc/iscsi/initiatorname.iscsi  : iqn.1994-05.com.redhat:7b1558ddb8a

**********************************************
jspstest1.fyre.ibm.com : IQN Check success !!
**********************************************


**********************************************
jspstest5.fyre.ibm.com Creating iqn between target and jspstest1.fyre.ibm.com
**********************************************

Created Node ACL for iqn.1994-05.com.redhat:7b1558ddb8a
Created mapped LUN 0.
jspstest5.fyre.ibm.com : targetcli creation SUCCESS for jspstest1.fyre.ibm.com. !!!

**********************************************
jspstest2.fyre.ibm.com : iscsi initiator configuration
**********************************************

 jspstest2.fyre.ibm.com : move /etc/iscsi/initiatorname.iscsi
 jspstest2.fyre.ibm.com : generate new initiator iqn and save to /etc/iscsi/initiatorname.iscsi. NOTE : Whenever running /sbin/iscsi-iname, it generates new.
 jspstest2.fyre.ibm.com : Save the generated iqn : iqn.1994-05.com.redhat:778afc2aee97 to /etc/iscsi/initiatorname.iscsi.
 jspstest2.fyre.ibm.com : double check /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.1994-05.com.redhat:778afc2aee97
 jspstest2.fyre.ibm.com : get IQN from /etc/iscsi/initiatorname.iscsi  : iqn.1994-05.com.redhat:778afc2aee97

**********************************************
jspstest2.fyre.ibm.com : IQN Check success !!
**********************************************


**********************************************
jspstest5.fyre.ibm.com Creating iqn between target and jspstest2.fyre.ibm.com
**********************************************

Created Node ACL for iqn.1994-05.com.redhat:778afc2aee97
Created mapped LUN 0.
jspstest5.fyre.ibm.com : targetcli creation SUCCESS for jspstest2.fyre.ibm.com. !!!

**********************************************
jspstest3.fyre.ibm.com : iscsi initiator configuration
**********************************************

 jspstest3.fyre.ibm.com : move /etc/iscsi/initiatorname.iscsi
 jspstest3.fyre.ibm.com : generate new initiator iqn and save to /etc/iscsi/initiatorname.iscsi. NOTE : Whenever running /sbin/iscsi-iname, it generates new.
 jspstest3.fyre.ibm.com : Save the generated iqn : iqn.1994-05.com.redhat:5ba1c81ce9c to /etc/iscsi/initiatorname.iscsi.
 jspstest3.fyre.ibm.com : double check /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.1994-05.com.redhat:5ba1c81ce9c
 jspstest3.fyre.ibm.com : get IQN from /etc/iscsi/initiatorname.iscsi  : iqn.1994-05.com.redhat:5ba1c81ce9c

**********************************************
jspstest3.fyre.ibm.com : IQN Check success !!
**********************************************


**********************************************
jspstest5.fyre.ibm.com Creating iqn between target and jspstest3.fyre.ibm.com
**********************************************

Created Node ACL for iqn.1994-05.com.redhat:5ba1c81ce9c
Created mapped LUN 0.
jspstest5.fyre.ibm.com : targetcli creation SUCCESS for jspstest3.fyre.ibm.com. !!!

**********************************************
jspstest4.fyre.ibm.com : iscsi initiator configuration
**********************************************

 jspstest4.fyre.ibm.com : move /etc/iscsi/initiatorname.iscsi
 jspstest4.fyre.ibm.com : generate new initiator iqn and save to /etc/iscsi/initiatorname.iscsi. NOTE : Whenever running /sbin/iscsi-iname, it generates new.
 jspstest4.fyre.ibm.com : Save the generated iqn : iqn.1994-05.com.redhat:5eb3f0f3ab8e to /etc/iscsi/initiatorname.iscsi.
 jspstest4.fyre.ibm.com : double check /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.1994-05.com.redhat:5eb3f0f3ab8e
 jspstest4.fyre.ibm.com : get IQN from /etc/iscsi/initiatorname.iscsi  : iqn.1994-05.com.redhat:5eb3f0f3ab8e

**********************************************
jspstest4.fyre.ibm.com : IQN Check success !!
**********************************************


**********************************************
jspstest5.fyre.ibm.com Creating iqn between target and jspstest4.fyre.ibm.com
**********************************************

Created Node ACL for iqn.1994-05.com.redhat:5eb3f0f3ab8e
Created mapped LUN 0.
jspstest5.fyre.ibm.com : targetcli creation SUCCESS for jspstest4.fyre.ibm.com. !!!


###########################################################################################
Post setup for iscsi on each pureScale host
###########################################################################################


**********************************************
iqn (iSCSI Qualified Name) of the target node : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
**********************************************


**********************************************
IP addresss of the target node : 10.11.56.198
**********************************************


**********************************************
jspstest1.fyre.ibm.com : discover target IQN name
**********************************************

10.11.56.198:3260,1 iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
discovered IQN : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
 jspstest1.fyre.ibm.com : target IQN value querying from both target and jspstest1.fyre.ibm.com matches :  SUCCESS !!

**********************************************
jspstest1.fyre.ibm.com : login to target and setup auto start/login then save.
**********************************************


**********************************************
jspstest1.fyre.ibm.com : login to target
**********************************************

Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] (multiple)
Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] successful.

**********************************************
jspstest1.fyre.ibm.com : auto start setup setting
**********************************************


**********************************************
jspstest5.fyre.ibm.com : save the configuration for jspstest1.fyre.ibm.com
**********************************************

Last 10 configs saved in /etc/target/backup/.
Configuration saved to /etc/target/saveconfig.json

**********************************************
jspstest2.fyre.ibm.com : discover target IQN name
**********************************************

10.11.56.198:3260,1 iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
discovered IQN : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
 jspstest2.fyre.ibm.com : target IQN value querying from both target and jspstest2.fyre.ibm.com matches :  SUCCESS !!

**********************************************
jspstest2.fyre.ibm.com : login to target and setup auto start/login then save.
**********************************************


**********************************************
jspstest2.fyre.ibm.com : login to target
**********************************************

Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] (multiple)
Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] successful.

**********************************************
jspstest2.fyre.ibm.com : auto start setup setting
**********************************************


**********************************************
jspstest5.fyre.ibm.com : save the configuration for jspstest2.fyre.ibm.com
**********************************************

Last 10 configs saved in /etc/target/backup/.
Configuration saved to /etc/target/saveconfig.json

**********************************************
jspstest3.fyre.ibm.com : discover target IQN name
**********************************************

10.11.56.198:3260,1 iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
discovered IQN : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
 jspstest3.fyre.ibm.com : target IQN value querying from both target and jspstest3.fyre.ibm.com matches :  SUCCESS !!

**********************************************
jspstest3.fyre.ibm.com : login to target and setup auto start/login then save.
**********************************************


**********************************************
jspstest3.fyre.ibm.com : login to target
**********************************************

Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] (multiple)
Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] successful.

**********************************************
jspstest3.fyre.ibm.com : auto start setup setting
**********************************************


**********************************************
jspstest5.fyre.ibm.com : save the configuration for jspstest3.fyre.ibm.com
**********************************************

Configuration saved to /etc/target/saveconfig.json

**********************************************
jspstest4.fyre.ibm.com : discover target IQN name
**********************************************

10.11.56.198:3260,1 iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
discovered IQN : iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da
 jspstest4.fyre.ibm.com : target IQN value querying from both target and jspstest4.fyre.ibm.com matches :  SUCCESS !!

**********************************************
jspstest4.fyre.ibm.com : login to target and setup auto start/login then save.
**********************************************


**********************************************
jspstest4.fyre.ibm.com : login to target
**********************************************

Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] (multiple)
Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.jspstest5.x8664:sn.30663b1b55da, portal: 10.11.56.198,3260] successful.

**********************************************
jspstest4.fyre.ibm.com : auto start setup setting
**********************************************


**********************************************
jspstest5.fyre.ibm.com : save the configuration for jspstest4.fyre.ibm.com
**********************************************

Configuration saved to /etc/target/saveconfig.json

**********************************************
jspstest1.fyre.ibm.com : start iscsi initiator service
**********************************************

Redirecting to /bin/systemctl start iscsi.service
Redirecting to /bin/systemctl status iscsi.service
● iscsi.service - Login and scanning of iSCSI devices
   Loaded: loaded (/usr/lib/systemd/system/iscsi.service; enabled; vendor preset: disabled)
   Active: active (exited) since Tue 2024-05-28 01:13:35 PDT; 1s ago
     Docs: man:iscsiadm(8)
           man:iscsid(8)
  Process: 32609 ExecStart=/sbin/iscsiadm -m node --loginall=automatic (code=exited, status=0/SUCCESS)
 Main PID: 32609 (code=exited, status=0/SUCCESS)

May 28 01:13:35 jspstest1.fyre.ibm.com systemd[1]: Starting Login and scanning of iSCSI devices...
May 28 01:13:35 jspstest1.fyre.ibm.com systemd[1]: Started Login and scanning of iSCSI devices.

Disk /dev/vda: 268.4 GB, 268435456000 bytes, 524288000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000e8940

   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048     2099199     1048576   83  Linux
/dev/vda2         2099200   524287999   261094400   8e  Linux LVM

Disk /dev/mapper/rhel-root: 250.2 GB, 250181844992 bytes, 488636416 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/rhel-swap: 17.2 GB, 17175674880 bytes, 33546240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 4194304 bytes


**********************************************
jspstest2.fyre.ibm.com : start iscsi initiator service
**********************************************

Redirecting to /bin/systemctl start iscsi.service
Redirecting to /bin/systemctl status iscsi.service
● iscsi.service - Login and scanning of iSCSI devices
   Loaded: loaded (/usr/lib/systemd/system/iscsi.service; enabled; vendor preset: disabled)
   Active: active (exited) since Tue 2024-05-28 01:13:39 PDT; 1s ago
     Docs: man:iscsiadm(8)
           man:iscsid(8)
  Process: 31834 ExecStart=/sbin/iscsiadm -m node --loginall=automatic (code=exited, status=0/SUCCESS)
 Main PID: 31834 (code=exited, status=0/SUCCESS)

May 28 01:13:39 jspstest2.fyre.ibm.com systemd[1]: Starting Login and scanning of iSCSI devices...
May 28 01:13:39 jspstest2.fyre.ibm.com systemd[1]: Started Login and scanning of iSCSI devices.

Disk /dev/vda: 268.4 GB, 268435456000 bytes, 524288000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000e8940

   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048     2099199     1048576   83  Linux
/dev/vda2         2099200   524287999   261094400   8e  Linux LVM

Disk /dev/mapper/rhel-root: 250.2 GB, 250181844992 bytes, 488636416 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/rhel-swap: 17.2 GB, 17175674880 bytes, 33546240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 4194304 bytes


**********************************************
jspstest3.fyre.ibm.com : start iscsi initiator service
**********************************************

Redirecting to /bin/systemctl start iscsi.service
Redirecting to /bin/systemctl status iscsi.service
● iscsi.service - Login and scanning of iSCSI devices
   Loaded: loaded (/usr/lib/systemd/system/iscsi.service; enabled; vendor preset: disabled)
   Active: active (exited) since Tue 2024-05-28 01:13:43 PDT; 1s ago
     Docs: man:iscsiadm(8)
           man:iscsid(8)
  Process: 31910 ExecStart=/sbin/iscsiadm -m node --loginall=automatic (code=exited, status=0/SUCCESS)
 Main PID: 31910 (code=exited, status=0/SUCCESS)

May 28 01:13:43 jspstest3.fyre.ibm.com systemd[1]: Starting Login and scanning of iSCSI devices...
May 28 01:13:43 jspstest3.fyre.ibm.com systemd[1]: Started Login and scanning of iSCSI devices.

Disk /dev/vda: 268.4 GB, 268435456000 bytes, 524288000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000e8940

   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048     2099199     1048576   83  Linux
/dev/vda2         2099200   524287999   261094400   8e  Linux LVM

Disk /dev/mapper/rhel-root: 250.2 GB, 250181844992 bytes, 488636416 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/rhel-swap: 17.2 GB, 17175674880 bytes, 33546240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 4194304 bytes


**********************************************
jspstest4.fyre.ibm.com : start iscsi initiator service
**********************************************

Redirecting to /bin/systemctl start iscsi.service
Redirecting to /bin/systemctl status iscsi.service
● iscsi.service - Login and scanning of iSCSI devices
   Loaded: loaded (/usr/lib/systemd/system/iscsi.service; enabled; vendor preset: disabled)
   Active: active (exited) since Tue 2024-05-28 01:13:47 PDT; 1s ago
     Docs: man:iscsiadm(8)
           man:iscsid(8)
  Process: 30530 ExecStart=/sbin/iscsiadm -m node --loginall=automatic (code=exited, status=0/SUCCESS)
 Main PID: 30530 (code=exited, status=0/SUCCESS)

May 28 01:13:47 jspstest4.fyre.ibm.com systemd[1]: Starting Login and scanning of iSCSI devices...
May 28 01:13:47 jspstest4.fyre.ibm.com systemd[1]: Started Login and scanning of iSCSI devices.

Disk /dev/vda: 268.4 GB, 268435456000 bytes, 524288000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000e8940

   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048     2099199     1048576   83  Linux
/dev/vda2         2099200   524287999   261094400   8e  Linux LVM

Disk /dev/mapper/rhel-root: 250.2 GB, 250181844992 bytes, 488636416 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/rhel-swap: 17.2 GB, 17175674880 bytes, 33546240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 4194304 bytes

```

[content](#contents)   

### create pureScale instance  



```

YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
Note : pureScale configuration
Last Command : [6] setup iscsi member clients => iscsiMember.sh
  [ 0 ] : ..
  [ 1 ] : Prereq. packages installation
  [ 2 ] : Db2 pureScale installation on all hosts
  [ 3 ] : create instance user
  [ 4 ] : configure /var/ct/cfg/netmon.cf
  [ 5 ] : setup iscsi target
  [ 6 ] : setup iscsi member clients
  [ 7 ] : create a pureScale instance
  [ 8 ] : quit


Auto pick : option=8, delay=0
Keystrokes ['1', '7', '8']


YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
  [ 0 ] : ..
  [ 1 ] : pureScale configuration *
  [ 2 ] : Future usage *
  [ 3 ] : quit


Auto pick : option=1, delay=0


YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
Note : pureScale configuration
  [ 0 ] : ..
  [ 1 ] : Prereq. packages installation
  [ 2 ] : Db2 pureScale installation on all hosts
  [ 3 ] : create instance user
  [ 4 ] : configure /var/ct/cfg/netmon.cf
  [ 5 ] : setup iscsi target
  [ 6 ] : setup iscsi member clients
  [ 7 ] : create a pureScale instance
  [ 8 ] : quit


Auto pick : option=7, delay=0
prompt=0  parsing : pSCreateInstance.sh


###########################################################################################
Checking shared iscsi disk information
###########################################################################################

Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
jspstest1.fyre.ibm.com : iscsi disk exists on jspstest1.fyre.ibm.com. GOOD !!!
Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
jspstest2.fyre.ibm.com : iscsi disk exists on jspstest2.fyre.ibm.com. GOOD !!!
Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
jspstest3.fyre.ibm.com : iscsi disk exists on jspstest3.fyre.ibm.com. GOOD !!!
Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
jspstest4.fyre.ibm.com : iscsi disk exists on jspstest4.fyre.ibm.com. GOOD !!!


###########################################################################################
generating command based on 4 hosts
###########################################################################################


**********************************************
command to run : /opt/ibm/db2/V1158/instance/db2icrt -d -m jspstest1.fyre.ibm.com -mnet jspstest1.fyre.ibm.com -m jspstest2.fyre.ibm.com -mnet jspstest2.fyre.ibm.com -cf jspstest3.fyre.ibm.com -cfnet jspstest3.fyre.ibm.com -cf jspstest4.fyre.ibm.com -cfnet jspstest4.fyre.ibm.com -instance_shared_dev /dev/sda -tbdev 10.11.56.198 -u db2fenc1 db2inst1
**********************************************



###########################################################################################
Starting instance creation. Fingers crossed !!
###########################################################################################

DBI1446I  The db2icrt command is running.


DB2 installation is being initialized.

 *****************************************************************************************
*  Systems must only be used for conducting IBMs business.				*
*  IBM may exercise rights to manage and enforce security, monitor use,			*
*  remove access or block traffic to and from this system, as well as			*
*  any other rights listed in ITSS.							*
*											*
*  Users must comply with DevIT service terms of use, IBM policies,			*
*  directives and corporate instructions including, import/export of data,		*
*  BCGs, Corporate Instructions, Standards, Addenda as well as all other		*
*  responsibilities listed in ITSS							*
*****************************************************************************************
*****************************************************************************************
*  Systems must only be used for conducting IBMs business.				*
*  IBM may exercise rights to manage and enforce security, monitor use,			*
*  remove access or block traffic to and from this system, as well as			*
*  any other rights listed in ITSS.							*
*											*
*  Users must comply with DevIT service terms of use, IBM policies,			*
*  directives and corporate instructions including, import/export of data,		*
*  BCGs, Corporate Instructions, Standards, Addenda as well as all other		*
*  responsibilities listed in ITSS							*
*****************************************************************************************
*****************************************************************************************
*  Systems must only be used for conducting IBMs business.				*
*  IBM may exercise rights to manage and enforce security, monitor use,			*
*  remove access or block traffic to and from this system, as well as			*
*  any other rights listed in ITSS.							*
*											*
*  Users must comply with DevIT service terms of use, IBM policies,			*
*  directives and corporate instructions including, import/export of data,		*
*  BCGs, Corporate Instructions, Standards, Addenda as well as all other		*
*  responsibilities listed in ITSS							*
*****************************************************************************************
*****************************************************************************************
*  Systems must only be used for conducting IBMs business.				*
*  IBM may exercise rights to manage and enforce security, monitor use,			*
*  remove access or block traffic to and from this system, as well as			*
*  any other rights listed in ITSS.							*
*											*
*  Users must comply with DevIT service terms of use, IBM policies,			*
*  directives and corporate instructions including, import/export of data,		*
*  BCGs, Corporate Instructions, Standards, Addenda as well as all other		*
*  responsibilities listed in ITSS							*
*****************************************************************************************
*****************************************************************************************
*  Systems must only be used for conducting IBMs business.				*
*  IBM may exercise rights to manage and enforce security, monitor use,			*
*  remove access or block traffic to and from this system, as well as			*
*  any other rights listed in ITSS.							*
*											*
*  Users must comply with DevIT service terms of use, IBM policies,			*
*  directives and corporate instructions including, import/export of data,		*
*  BCGs, Corporate Instructions, Standards, Addenda as well as all other		*
*  responsibilities listed in ITSS							*
*****************************************************************************************
*****************************************************************************************
*  Systems must only be used for conducting IBMs business.				*
*  IBM may exercise rights to manage and enforce security, monitor use,			*
*  remove access or block traffic to and from this system, as well as			*
*  any other rights listed in ITSS.							*
*											*
*  Users must comply with DevIT service terms of use, IBM policies,			*
*  directives and corporate instructions including, import/export of data,		*
*  BCGs, Corporate Instructions, Standards, Addenda as well as all other		*
*  responsibilities listed in ITSS							*
*****************************************************************************************
Total number of tasks to be performed: 11
Total estimated time for all tasks to be performed: 1104 second(s)

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
Description: Compiling GPL
Estimated time 30 second(s)
Task #5 end

Task #6 start
Description: Setting default global profile registry variables
Estimated time 1 second(s)
Task #6 end

Task #7 start
Description: Register NTP
Estimated time 40 second(s)
Task #7 end

Task #8 start
Description: Initializing instance list
Estimated time 5 second(s)
Task #8 end

Task #9 start
Description: Initiating the remote host list
Estimated time 5 second(s)
Task #9 end

Task #10 start
Description: Configuring DB2 instances
Estimated time 300 second(s)
Task #10 end

Task #11 start
Description: Updating global profile registry
Estimated time 3 second(s)
Task #11 end

The execution completed with warnings.

For more information see the DB2 installation log at "/tmp/db2icrt.log.32719".
DBI20182W  Program "db2icrt" completed successfully but with warnings.

**********************************************
db2inst1 instance is created
**********************************************

ID	  TYPE	           STATE		HOME_HOST		CURRENT_HOST		ALERT	PARTITION_NUMBER	LOGICAL_PORT	NETNAME
--	  ----	           -----		---------		------------		-----	----------------	------------	-------
0	MEMBER	         STOPPED		jspstest1		   jspstest1		   NO	               0	           0	jspstest1.fyre.ibm.com
1	MEMBER	         STOPPED		jspstest2		   jspstest2		   NO	               0	           0	jspstest2.fyre.ibm.com
128	CF	         STOPPED		jspstest3		   jspstest3		   NO	               -	           0	jspstest3.fyre.ibm.com
129	CF	         STOPPED		jspstest4		   jspstest4		   NO	               -	           0	jspstest4.fyre.ibm.com

HOSTNAME		   STATE		INSTANCE_STOPPED	ALERT
--------		   -----		----------------	-----
jspstest4		  ACTIVE		              NO	   NO
jspstest3		  ACTIVE		              NO	   NO
jspstest2		  ACTIVE		              NO	   NO
jspstest1		  ACTIVE		              NO	   NO

**********************************************
db2set DB2_SD_ALLOW_SLOW_NETWORK=ON
**********************************************


**********************************************
Start db2inst1 instance.
**********************************************

05/28/2024 02:04:34     1   0   SQL1063N  DB2START processing was successful.
05/28/2024 02:04:35     0   0   SQL1063N  DB2START processing was successful.
SQL1063N  DB2START processing was successful.
ID	  TYPE	           STATE		HOME_HOST		CURRENT_HOST		ALERT	PARTITION_NUMBER	LOGICAL_PORT	NETNAME
--	  ----	           -----		---------		------------		-----	----------------	------------	-------
0	MEMBER	         STARTED		jspstest1		   jspstest1		   NO	               0	           0	jspstest1.fyre.ibm.com
1	MEMBER	         STARTED		jspstest2		   jspstest2		   NO	               0	           0	jspstest2.fyre.ibm.com
128	CF	         PRIMARY		jspstest3		   jspstest3		   NO	               -	           0	jspstest3.fyre.ibm.com
129	CF	         CATCHUP		jspstest4		   jspstest4		   NO	               -	           0	jspstest4.fyre.ibm.com

HOSTNAME		   STATE		INSTANCE_STOPPED	ALERT
--------		   -----		----------------	-----
jspstest4		  ACTIVE		              NO	   NO
jspstest3		  ACTIVE		              NO	   NO
jspstest2		  ACTIVE		              NO	   NO
jspstest1		  ACTIVE		              NO	   NO
ID	  TYPE	           STATE		HOME_HOST		CURRENT_HOST		ALERT	PARTITION_NUMBER	LOGICAL_PORT	NETNAME
--	  ----	           -----		---------		------------		-----	----------------	------------	-------
0	MEMBER	         STARTED		jspstest1		   jspstest1		   NO	               0	           0	jspstest1.fyre.ibm.com
1	MEMBER	         STARTED		jspstest2		   jspstest2		   NO	               0	           0	jspstest2.fyre.ibm.com
128	CF	         PRIMARY		jspstest3		   jspstest3		   NO	               -	           0	jspstest3.fyre.ibm.com
129	CF	         CATCHUP		jspstest4		   jspstest4		   NO	               -	           0	jspstest4.fyre.ibm.com

HOSTNAME		   STATE		INSTANCE_STOPPED	ALERT
--------		   -----		----------------	-----
jspstest4		  ACTIVE		              NO	   NO
jspstest3		  ACTIVE		              NO	   NO
jspstest2		  ACTIVE		              NO	   NO
jspstest1		  ACTIVE		              NO	   NO

**********************************************
db2instance is normal status. Creating sample db. From now on, check things by yourself and do your preferred work manually. Enjoy !!
**********************************************


  Creating database "SAMPLE"...
  Connecting to database "SAMPLE"...
  Creating tables and data in schema "DB2INST1"...
  Creating tables with XML columns and XML data in schema "DB2INST1"...

  'db2sampl' processing complete.



YAML [1.0.0] : menu.yaml , Current working directory = /root/purescale_on_fyre
Note : pureScale configuration
Last Command : [7] create a pureScale instance => pSCreateInstance.sh
  [ 0 ] : ..
  [ 1 ] : Prereq. packages installation
  [ 2 ] : Db2 pureScale installation on all hosts
  [ 3 ] : create instance user
  [ 4 ] : configure /var/ct/cfg/netmon.cf
  [ 5 ] : setup iscsi target
  [ 6 ] : setup iscsi member clients
  [ 7 ] : create a pureScale instance
  [ 8 ] : quit


Auto pick : option=8, delay=0
```

[contents](#contents)   
