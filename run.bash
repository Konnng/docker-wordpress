#!/bin/bash

chown www-data:www-data /app -R

source /etc/apache2/envvars

if [ ! -d "$APACHE_RUN_DIR" ]; then
	mkdir "$APACHE_RUN_DIR"
	chown $APACHE_RUN_USER:$APACHE_RUN_GROUP "$APACHE_RUN_DIR"
fi

rm -f "$APACHE_PID_FILE"

tail -F /var/log/apache2/* & exec apache2 -D FOREGROUND
