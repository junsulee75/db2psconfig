#!/bin/bash

export PROMPT=0

menu.py 1,1,8   # Prereq. packages installation

menu.py 1,2,8    # Db2 pureScale installation on all hosts
menu.py 1,3,8    # create instance user
menu.py 1,4,8    # update netmon.cf
menu.py 1,5,8    # setup iscsi target
menu.py 1,6,8    # setup iscsi member clients
menu.py 1,7,8    # create pureScale instance  


