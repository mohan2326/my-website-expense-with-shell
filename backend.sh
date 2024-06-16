#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE
dnf module enable nodejs:20 -y &>>$LOGFILE
dnf install nodejs -y &>>$LOGFILE

# useradd expense
# VALIDATE $? "Creating expense user"

# # Output:

#     Please enter DB password:
#     You are super user.
#     Disabling default nodejs... SUCCESS 
#     Enabling nodejs:20 version... SUCCESS 
#     Installing nodejs... SUCCESS 
#     Creating expense user... SUCCESS 

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ sudo sh backed.sh
#     Please enter DB password:
#     You are super user.
#     Disabling default nodejs... SUCCESS 
#     Enabling nodejs:20 version... SUCCESS 
#     Installing nodejs... SUCCESS 
#     useradd: user 'expense' already exists (if we run the script again we are getting this)
#     Creating expense user... FAILURE 

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ id ec2-user
#     uid=1001(ec2-user) gid=1001(ec2-user) groups=1001(ec2-user)

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ echo $?
#     0

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ id expense
#     uid=1002(expense) gid=1002(expense) groups=1002(expense)

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ echo $?
#     0

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ id mohan
#     id: ‘mohan’: no such user

#     [ ec2-user@ip-172-31-16-86 ~/expense-project-with-shell-scripting ]$ echo $?
#     1

# The above can we be written in the based on the number

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE

npm install &>>$LOGFILE

# #check your repo and path
cp /home/ec2-user/expense-project-with-shell-scripting/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

systemctl start backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

systemctl enable mysqld &>>$LOGFILE

systemctl start mysqld &>>$LOGFILE

mysql -h db.mohansaivenna.cloud -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE