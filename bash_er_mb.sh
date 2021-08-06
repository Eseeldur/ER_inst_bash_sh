#!/bin/bash

# pwd
# whoami

echo -e "\n------------------------------------------------------\n"
echo "This script will install Unified Registry application"
echo "!!!     Note:script will overwrite this files:    !!!"
echo "!!!                     /etc/nginx/nginx.conf     !!!"
echo "!!!                     /etc/nginx/conf.d/er.conf !!!"
echo "!!!                     /etc/php-fpm.d/www.conf   !!!"
echo -e "\n------------------------------------------------------\n"


: << 'END OF COMMENT'
# updating packages
yum update -y

# gentleman's pack installing
yum install -y mc wget htop iotop iftop net-tools sysstat tcpdump psmisc lsof unzip

# requiring packages installing


yum -y install epel-release yum-utils
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum -y install gcc \
               make \
               screen \
               nginx \
               systemtap-sdt-devel \
               php \
               php-devel \
               php-pear \
               php-mbstring \
               php-gd \
               php-xml \
               php-soap \
               php-ldap \
               php-cli \
               php-common \
               php-fpm \
               php-opcache \
               php-process \
               php-pecl-jsonc \
               php-pecl-zip \
               php-pecl-jsonc-devel \
               php-pecl-igbinary \
               php-pgsql \
               php-zip


setenforce 0 && sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config


echo -e "\n------------------------------------------------------\n"
echo "         Start configuring nginx,er,php-fpm files       "
echo -e "\n------------------------------------------------------\n"i

# Let's configure NGINX and PHP-FPM
cat nginx.txt > /etc/nginx/nginx.conf

cat er.txt > /etc/nginx/conf.d/er.conf

cat www.txt > /etc/php-fpm.d/www.conf


echo -e "\n------------------------------------------------------\n"
echo "         Changing rights for php"
echo -e "\n------------------------------------------------------\n"

chown -R root.nginx /var/lib/php/session
chown -R root.nginx /var/lib/php/opcache
chown -R root.nginx /var/lib/php/wsdlcache





echo -e "\n------------------------------------------------------\n"
echo "                    DBMS Configuring"
echo -e "\n------------------------------------------------------\n"

yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql11-server

( echo postgres ; echo postgres ) | passwd postgres

END OF COMMENT

su - postgres
echo PATH=$PATH:/usr/pgsql-11/bin/>>~/.bash_profile
echo export PATH>>~/.bash_profile
logout
su - postgres
initdb --locale=ru_RU.UTF-8 --encoding=UTF8 --username=postgres -W -k
logout
systemctl enable postgresql-11
systemctl start postgresql-11



echo -e "\n------------------------------------------------------\n"
echo "                 ER installing is done by Ildar              "
echo -e "\n------------------------------------------------------\n"
