FROM ubuntu:xenial

ARG CACHE_DATE
ARG DEBIAN_FRONTEND
ARG APACHE_PORT
ARG APACHE_RUN_USER

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
	&& apt-get -yq install python-software-properties software-properties-common locales

ENV LANG=en_US.UTF-8
RUN locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8

RUN add-apt-repository -y ppa:ondrej/php && apt-get update \
  && apt-get install -yq vim zip curl apache2 mysql-client
RUN apt-get install -yq php5.6 php5.6-cli php5.6-dev php5.6-mysql php5.6-mcrypt php5.6-gd libapache2-mod-php5.6 \
	php5.6 php5.6-curl php5.6-mbstring php5.6-xml php5.6-xmlrpc php5.6-ssh2 php5.6-exif

RUN a2enmod rewrite expires setenvif deflate headers filter include \
	&& echo "ServerName localhost" >> /etc/apache2/apache2.conf \
	&& sed -i "s/<\/VirtualHost>/\n\t<Directory \/var\/www\/html>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t<\/Directory>\n\n<\/VirtualHost>/g" /etc/apache2/sites-enabled/000-default.conf

RUN echo "display_errors=On\nmemory_limit=512M\nupload_max_filesize=64M\npost_max_size=64M\nmax_execution_time=300" > /etc/php/5.6/apache2/conf.d/99-docker.ini

RUN usermod -u 1000 $APACHE_RUN_USER

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

WORKDIR /app
