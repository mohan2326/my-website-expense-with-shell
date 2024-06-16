#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>>$LOGFILE

systemctl enable nginx &>>$LOGFILE

systemctl start nginx &>>$LOGFILE

systemctl status nginx &>>$LOGFILE

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE

#check your repo and path
cp /home/ec2-user/my-website-expense-with-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE

systemctl restart nginx &>>$LOGFILE

systemctl status nginx &>>$LOGFILE

ps -ef |grep nginx &>>$LOGFILE

telnet backend.mohansaivenna.cloud 8080 &>>$LOGFILE

ping -c 3 mohansaivenna.cloud &>>$LOGFILE