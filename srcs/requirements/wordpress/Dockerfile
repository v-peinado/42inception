FROM	debian:bullseye

RUN		apt-get update && apt-get upgrade
RUN		apt-get install -y curl php7.4 \
		php7.4-fpm php7.4-mysqli mariadb-client

COPY	conf/wp_www.conf /etc/php/7.4/fpm/pool.d/

# install wp-cli to manage wordpress installation
RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# copy wp-cli to /usr/local/bin/wp and give the right to the user to write in the directory
RUN		chmod +x wp-cli.phar
RUN		mv wp-cli.phar /usr/local/bin/wp

RUN 	mkdir -p /run/php
RUN 	chmod 755 /run/php

COPY	--chmod=755 tools/init_wp.sh /usr/local/bin/init_wp.sh

WORKDIR	/var/www/html

EXPOSE	9000

ENTRYPOINT	["sh", "/usr/local/bin/init_wp.sh"]

