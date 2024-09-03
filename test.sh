#!/bin/bash
set -x
pshost="jspstest1.fyre.ibm.com jspstest2.fyre.ibm.com jspstest3.fyre.ibm.com jspstest4.fyre.ibm.com"
echo $pshost
NUM_PSHOST=`echo $pshost |wc -w`
echo $NUM_PSHOST

#read -ra hosts <<< "$pshost"
IFS=' ' read -r -a tempHosts <<< "$pshost"
echo "${tempHosts[0]}"
echo "${tempHosts[1]}"
echo "${tempHosts[2]}"
echo "${tempHosts[3]}"


# 배열의 각 요소에 대해 반복하여 출력
#for host in "${hosts[@]}"; do
#    echo "Processing host: $host"
#    # 여기에 각 호스트에 대한 작업을 추가
#done