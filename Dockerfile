FROM ubuntu:xenial
ARG CACHE_DATE=201702082234
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt-get update
RUN apt-get -yq install python-software-properties software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update

RUN apt-get install -yq vim zip curl apache2 mysql-client
RUN apt-get install -yq php5.6 php5.6-cli=5.6.30-1+deb.sury.org~xenial+1 php5.6-dev php5.6-mysql php5.6-mcrypt php5.6-gd libapache2-mod-php5.6
RUN apt-get install -yq php5.6 php5.6-curl php5.6-mbstring php5.6-xml php5.6-xmlrpc
RUN apt-get install -yq php-ssh2


RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i "s/<\/VirtualHost>/\n\t<Directory \/var\/www\/html>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t<\/Directory>\n\n<\/VirtualHost>/g" /etc/apache2/sites-enabled/000-default.conf

RUN cat /etc/apache2/sites-enabled/000-default.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
RUN usermod -u 1000 www-data

EXPOSE 80

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
WORKDIR /app
COPY . /app

COPY run.bash /run.bash
RUN chmod 755 /*.bash

CMD ["/run.bash"]
