#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"

PATH1="/var/log/shell-script"
FILE1="log.txt"
FULLPATH="$PATH1/$FILE1"

VALIDATE(){
    if [ $1 -eq 0 ]
then 
echo -e "$G $2..succussful" 
else 
echo -e "$R $2 Failed" 
exist 1
fi
}

if [ $USERID -ne 0 ]
then 

echo " User not having sufficent permissions"
exist 1
else
dnf module disable nodejs -y
VALIDATE $? "disable nodejs" 

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs" 

dnf install nodejs -y
VALIDATE $? "install nodejs"

useradd expense

mkdir -p /app

rm -rf /tmp/backend.zip

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

cd /app

unzip /tmp/backend.zip

npm install

cp /home/ec2-user/expense/backend.service /etc/systemd/system/backend.service

systemctl daemon-reload
VALIDATE $? "reload service"

systemctl start backend
VALIDATE $? "start service"

systemctl enable backend
VALIDATE $? "enable service"

dnf install mysql -y
VALIDATE $? "install client"

mysql -h db.aws82s.online -uroot -pExpenseApp@1 < /app/schema/backend.sql

systemctl restart backend
VALIDATE $? "restart install"


  

 
fi


