#!/bin/bash
# AUTOMATIC WORDPRESS INSTALLER IN  AWS Ubuntu Server 20.04 LTS (HVM)
# CHANGE DATABASE VALUES BELOW AND PASTE IT TO USERDATA SECTION In ADVANCED SECTION WHILE LAUNCHING EC2
# USE ELASTIC IP ADDRESS AND ALLOW SSH, HTTP AND HTTPS REQUEST IN SECURITY GROUP

#Change these values and keep in safe place
db_root_password=123456789
db_username=wordpressuser
db_user_password=123456789
db_name=wordpress
db_host=10.0.2.12

# install LAMP Server
apt update  -y
apt upgrade -y
#install apache server
apt install -y apache2
 


apt install -y php
apt install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,bcmath,json,xml,intl,zip,imap,imagick}



# starting apache

systemctl enable --now  apache2

# Change OWNER and permission of directory /var/www
usermod -a -G www-data ubuntu
chown -R ubuntu:www-data /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


# Download wordpress package and extract
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/



# Create wordpress configuration file and update database value
cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
sed -i "s/localhost/$db_host/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');

EOF

# Change permission of /var/www/html/
chown -R ubuntu:www-data /var/www/html
chmod -R 774 /var/www/html
rm /var/www/html/index.html
#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf

# restart apache

systemctl restart apache2
