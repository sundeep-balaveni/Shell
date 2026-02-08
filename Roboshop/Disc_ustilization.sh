#!/bin/bash


THRESHOLD=80


DISK_UTILIZATION=$(df -h / | grep / | awk '{print $5}' | sed 's/%//g')

if [DISK_UTILIZATION -gt THRESHOLD] ; then

  echo "Disk is more than 80 percent"

else

echo "Less than 80 %"

fi

echo "current disk usage : $DISK_UTILIZATION"