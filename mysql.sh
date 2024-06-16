#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE

systemctl enable mysqld &>>$LOGFILE

systemctl start mysqld &>>$LOGFILE

systemctl status mysqld &>>$LOGFILE

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.mohansaivenna.cloud -uroot -p${mysql_root_password}  -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi

netstat -lntp &>>$LOGFILE

ps -ef | grep mysql &>>$LOGFILE

# idempotency
# ----------------
# it is a nature of program irrespective of how many times you run it should not change result...

# Shell script is not idempotent in nature, so we need to take care

#I don't show the password in the script; so im using my read command to enter the password at the starting

# Output:
#     [ ec2-user@ip-172-31-19-108 ~/expense-project-with-shell-scripting ]$ sudo sh mysql.sh 
#     Please enter DB password:
#     You are super user.
#     Installing MySQL Server... SUCCESS 
#     Enabling MySQL Server... SUCCESS 
#     Starting MySQL Server... SUCCESS 
#     MySQL Root password is already setup... SKIPPING 

#Just validating with trap command by passing a wrong name; it was expected
# Output:
#     [ ec2-user@ip-172-31-26-47 ~/my-website-expense-with-shell ]$ sudo sh mysql.sh
#     You are super user.
#     Please enter DB password:
#     Error occured at line number: 10, error command: dnf install mysql-serverss -y &>> $LOGFILE