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
dnf install nginx -y 
VALIDATE $? "nginx install"

systemctl enable nginx
VALIDATE $? "nginx enable"

systemctl start nginx
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip

cd /usr/share/nginx/html

unzip /tmp/frontend.zip
cp /home/ec2-user/expense/expense.conf /etc/nginx/default.d/expense.conf

systemctl restart nginx
fi


