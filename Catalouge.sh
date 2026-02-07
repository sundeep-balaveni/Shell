#!/bin/bash

USER_ID=$(id -u)


LOGS_FOLDER="/var/log/roboshop"
LOG_FILE="$LOGS_FOLDER/mongo.log"

mkdir -p $LOGS_FOLDER

if [ $USER_ID -eq 0 ]; then

dnf module disable nodejs -y

dnf module enable nodejs:20 -y

dnf install nodejs -y

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop


mkdir /app 


curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip

cd /app 
npm install 

cp Catalouge.config /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue 
systemctl start catalogue


fi