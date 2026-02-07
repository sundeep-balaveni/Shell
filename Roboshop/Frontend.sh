#!/bin/bash

#!/bin/bash

USER_ID=$(id -u)


LOGS_FOLDER="/var/log/roboshop"
LOG_FILE="$LOGS_FOLDER/mongo.log"

mkdir -p $LOGS_FOLDER

if [ $USER_ID -eq 0 ]; then

echo "checking the current module and installing ................."

dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y

systemctl enable nginx 
systemctl start nginx 

rm -rf /usr/share/nginx/html/* 

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip


cp Roboshop/Frontend.conf /etc/nginx/nginx.conf


systemctl restart nginx 





fi
