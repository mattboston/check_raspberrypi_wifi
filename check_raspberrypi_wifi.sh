#!/bin/bash

if ifconfig wlan0 | grep -q "inet addr:" ; then
  echo "Connection up"
else
  echo "Network connection down! Attempting reconnection."
  ifdown --force wlan0
  ifup --force wlan0
fi
