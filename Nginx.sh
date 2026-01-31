#!/bin/bash

USERID=$(id -u)

if [ "$USERID" -ne 0 ]; then
    echo "Please run this script with sudo access"
    exit 1
fi

echo "Installing nginx"
dnf install nginx -y
