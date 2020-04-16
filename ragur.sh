#!/bin/bash
#usermod -a -G root ec2-user
if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi
sudo yum update -y
sudo yum install epel-release -y
sudo yum install git -y
sudo yum install httpd -y
sudo systemctl start httpd && sudo systemctl enable httpd
sudo setenforce 0
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum install php70w php70w-opcache php70w-mbstring php70w-gd php70w-xml php70w-pear php70w-fpm php70w-mysql php70w-pdo -y

sudo yum -y install mariadb-server
sudo systemctl start mariadb && sudo systemctl enable mariadb

#MySQL Consider changing values from drupaldb, drupaluser, and password
sudo echo "CREATE DATABASE wordpress CHARACTER SET utf8 COLLATE utf8_general_ci;;" | mysql
sudo echo "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql
sudo echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';" | mysql
sudo echo "FLUSH PRIVILEGES;" | mysql

sudo cd /var/www/html

sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

sudo php wp-cli.phar --info
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp --info

sudo cd /var/www/html/
sudo wp core download
sudo wp config create --dbname=zippyopsdb --dbuser=zippyops --dbpass=zippyops --locale=ro_RO
sudo wp core install --url=zippyops.co.in --title=zippyops --admin_user=zippyops --admin_password=zippyops --admin_email=admin@zippyops.com

