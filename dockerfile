FROM tutum/lamp:latest
MAINTAINER Jean Lasson <jean.lasson@free.fr>

# Tout en Français
ENV LANGUAGE fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8
RUN locale-gen fr_FR.UTF-8
RUN dpkg-reconfigure locales

# Installation des packages nécessaires
RUN apt-get update && \
  apt-get -y install php5-mcrypt php5-gd php5-ldap php5-cli php-soap php5-json graphviz wget unzip
RUN php5enmod mcrypt ldap gd

# récupération de la version ITOP
RUN mkdir -p /tmp/itop
RUN wget -O /tmp/itop/itop.zip http://sourceforge.net/projects/itop/files/itop/2.2.0/iTop-2.2.0-2459.zip
RUN unzip /tmp/itop/itop.zip -d /tmp/itop/

# Configure /app 
RUN rm -fr /app
RUN mkdir -p /app && cp -r /tmp/itop/web/* /app && rm -rf /tmp/itop
RUN chown -R www-data:www-data /app

#Environment variables
ENV PHP_UPLOAD_MAX_FILESIZE 8M
ENV PHP_POST_MAX_SIZE 10M

# Expose ports
# Port MYSQL
EXPOSE 3306
# Port APACHE
EXPOSE 80

CMD ["/run.sh"]

