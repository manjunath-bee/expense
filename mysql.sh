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

 dnf list installed |grep mysql 

 if [ $? -eq 0 ]
then 
echo -e "$G Already Installed MYSQL"
else
dnf install mysql-server -y &>$FULLPATH

VALIDATE $? "mysql" 

systemctl enable mysqld &>$FULLPATH
VALIDATE $? "enable mysql" 

systemctl start mysqld &>$FULLPATH
VALIDATE $? "start mysql" 

mysql_secure_installation --set-root-pass ExpenseApp@1 &>$FULLPATH
VALIDATE $? "Set user password" 
fi
fi


