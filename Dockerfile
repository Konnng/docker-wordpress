FROM ubuntu:xenial
ARG CACHE_DATE=20170724
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
	&& apt-get -yq install python-software-properties software-properties-common
RUN add-apt-repository -y ppa:ondrej/php \
  && apt-get update && && apt-get install -yq vim zip curl apache2 mysql-client \
 	&& php5.6 php5.6-cli php5.6-dev php5.6-mysql php5.6-mcrypt php5.6-gd libapache2-mod-php5.6 \
 	&& apt-get install -yq php5.6 php5.6-curl php5.6-mbstring php5.6-xml php5.6-xmlrpc \
	&& apt-get install -yq php-ssh2


RUN a2enmod rewrite expires setenvif deflate headers filter include \
	&& echo "ServerName localhost" >> /etc/apache2/apache2.conf \
	&& sed -i "s/<\/VirtualHost>/\n\t<Directory \/var\/www\/html>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t<\/Directory>\n\n<\/VirtualHost>/g" /etc/apache2/sites-enabled/000-default.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
# Uncomment line below to use enviroment variable in your application (feel free to change the value too)
# ENV APPLICATION_ENV=docker

RUN usermod -u 1000 www-data

EXPOSE 80

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
WORKDIR /app

COPY run.bash /run.bash
RUN chmod 755 /*.bash

CMD ["/run.bash"]
