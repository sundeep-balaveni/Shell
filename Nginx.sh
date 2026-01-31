#!/bin/bash

USERID=$(id -u)

if [ USERID -nq 0 ]; then 

    echo ("run this script as sudo access")

fi 

echo "installing ngjnx"

dnf install nginx -y 
