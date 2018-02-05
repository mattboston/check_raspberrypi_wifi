#!/bin/bash

INTERFACE="wlan0"
GATEWAY=`route -n | grep 'UG[ \t]' | awk '{print $2}'`
OCTET=`echo ${GATEWAY} | cut -d"." -f1`

if ! [ -x "$(command -v fping)" ]; then
  echo "Error: fping not installed" >&2
  exit 1
fi

ifconfig ${INTERFACE} | egrep -q "inet(.*)${OCTET}"
RESULT1=`echo $?`
fping ${GATEWAY} | grep -q "alive"
RESULT2=`echo $?`

if [ ${RESULT1} -eq 0 ] && [ ${RESULT2} -eq 0 ]
then
  echo "Connection up"
else
  echo "Network connection down! Attempting reconnection."
  ifdown --force ${INTERFACE}
  ifup --force ${INTERFACE}
fi
