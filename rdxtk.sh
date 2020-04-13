#!/bin/bash
usermod -a -G root ec2-user
sudo yum update -y
sudo amazon-linux-extras install epel -y 
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

sudo yum install wget -y

sudo cd /tmp && wget http://wordpress.org/latest.tar.gz

sudo tar -xvzf latest.tar.gz -C /var/www/html

sudo chown -R apache /var/www/html/wordpress
cd /home/ec2-user/
sudo git clone https://github.com/Ragu3492/wordpress.git
sudo cp /home/ec2-user/wordpress/wp-config.php /var/www/html/wordpress/

sudo systemctl restart httpd
