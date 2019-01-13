
wget -i -c http://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
yum -y install mysql80-community-release-el7-1.noarch.rpm 
yum -y install mysql-community-server

systemctl start  mysqld.service
systemctl status mysqld.service

grep "password" /var/log/mysqld.log

mysql -uroot -p

#ALTER USER 'root'@'localhost' IDENTIFIED BY 'new password';

#SHOW VARIABLES LIKE 'validate_password%';

#set global validate_password_policy=0;
#set global validate_password_length=1;
