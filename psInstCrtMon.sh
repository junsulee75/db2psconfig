#!/bin/bash

FILENAME=`ls -tlr /tmp |tail  -n 1|awk '{print $9;}'`;echo $FILENAME;echo ; tail -40 $FILENAME


