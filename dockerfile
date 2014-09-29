FROM ubuntu:14.04

MAINTAINER Jean Lasson <jean.lasson@free.fr>

 

# Tout en Français

ENV LANGUAGE fr_FR.UTF-8

ENV LANG fr_FR.UTF-8

ENV LC_ALL fr_FR.UTF-8

RUN locale-gen fr_FR.UTF-8

RUN dpkg-reconfigure locales

 

# Variables

ENV APACHE_RUN_USER www-data

ENV APACHE_RUN_GROUP www-data

ENV APACHE_LOG_DIR /var/log/apache2

 

# Mise à jour

RUN apt-get update

RUN apt-get -y upgrade

 

 

# Installation des packages nécessaires

RUN apt-get -y install apache2 mysql-server php5 php5-mysql php5-ldap php5-mcrypt php5-cli php5-soap && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 

# Options PHP

RUN apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-tidy php5-xmlrpc php5-xsl

 

# MySQL

# Config : Autoriser les connexions remote

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Creation de la DATABASE et de l'Utilisateur

RUN /usr/bin/mysqld_safe & \

                    sleep 10s &&\

                    echo "CREATE DATABASE ITOP;" | mysql &&\

                    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY ''; FLUSH PRIVILEGES" | mysql

 

# récupération de la version ITOP

 

wget http://sourceforge.net/projects/itop/files/itop/2.0.3/iTop-2.0.3-1916.zip

unzip iTop-2.0.2-1476.zip

cp -fr web/ /var/www/itop

# mkdir /var/www/itop/conf

# mkdir /var/www/itop/data

# mkdir /var/www/itop/env-production

# mkdir /var/www/itop/log

# chmod 777 /var/www/itop/conf/

# chmod 777 /var/www/itop/data

# chmod 777 /var/www/itop/env-production/

# chmod 777 /var/www/itop/log

 

# Expose ports

 

# Port MYSQL

EXPOSE 3306

# Port APACHE

EXPOSE 80

 

CMD ["/usr/bin/mysqld_safe"]

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
