#!/bin/bash

USER_ID=$(id -u)


LOGS_FOLDER="/var/log/roboshop"
LOG_FILE="$LOGS_FOLDER/mongo.log"

mkdir -p $LOGS_FOLDER


if [ $USER_ID -eq 0 ]; then

cp Mongo.repo  /etc/yum.repos.d/mongo.repo 

dnf install mongodb-org -y 

systemctl enable mongod 

systemctl start mongod

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

systemctl restart mongod



if [ $? -eq 0 ]; then

echo "Mongo is installed succesfully "

else 

echo "insatlling failed"  | tee -a  $LOG_FILE
exit 1 

fi

else

echo "Please run As root-user"


fi 






    



