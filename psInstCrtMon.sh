#!/bin/bash

source jscommon.sh

while true
do

    FILENAME=`ls -tlr /tmp |tail  -n 1|awk '{print $9;}'`;echo "/tmp/$FILENAME";echo 
    if [ -d "/tmp/$FILENAME" ]; then # if /tmp/xxx is directory
        FILENAME2=`ls -tlr /tmp/$FILENAME |tail  -n 1|awk '{print $9;}'`
        FILE2TAIL="/tmp/$FILENAME/$FILENAME2"
    else
        FILE2TAIL="/tmp/$FILENAME"
    fi
    print1 "Currently tracking $FILE2TAIL"    
    date;echo
    tail -40 $FILE2TAIL
    
    sleep 5
done