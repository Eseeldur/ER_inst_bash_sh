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



#su - postgres
su - postgres -c 'echo PATH=$PATH:/usr/pgsql-11/bin/>>~/.bash_profile'
su - postgres -c 'echo export PATH>>~/.bash_profile'

( echo postgres ; echo postgres ) | su - postgres -c 'initdb --locale=ru_RU.UTF-8 --encoding=UTF8 --username=postgres -W -k'
systemctl enable postgresql-11
systemctl start postgresql-11
sed -i 's/trust/md5/g' /var/lib/pgsql/11/data/pg_hba.conf
sed -i "s/#listen_addresses = 'localhost'/listen_addresses='*'/g" /var/lib/pgsql/11/data/postgresql.conf
sed -i "s/datestyle = 'iso, dmy'/datestyle = 'german, dmy'/g" /var/lib/pgsql/11/data/postgresql.conf

sudo -u postgres -H -- psql -c "create role dev login password 'dev' superuser inherit createdb createrole replication;"
echo "firewall-cmd --zone=public --add-port=80/tcp --permanent" >> /etc/sysconfig/iptables
systemctl restart firewalld

mv d3_nl /var/www/html
mv er_19.09.0.pd3 /var/www/html
END OF COMMENT


cd /var/www/html
chmod +x d3_nl
( echo dev ; echo y ; echo postgres ; echo postgres ; echo y ; echo y ; echo y ) | d3_nl -f localinstall er_19.09.0.pd3 

mv er_19.09.0 /tmp/
mv /var/www/html/Etc/conf.inc.default /var/www/html/Etc/conf.inc


echo "done"


echo -e "\n------------------------------------------------------\n"
echo "                 ER installing is done by Ildar              "
echo -e "\n------------------------------------------------------\n"
