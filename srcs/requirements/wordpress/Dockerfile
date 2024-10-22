FROM	debian:bullseye

RUN		apt-get update && apt-get upgrade -y

# Instala curl, PHP 7.4, PHP-FPM (FastCGI Process Manager) y el cliente de MariaDB
RUN		apt-get install -y curl php7.4 \
		php7.4-fpm php7.4-mysqli mariadb-client

# Copia la configuración de PHP-FPM desde el directorio local al directorio de configuración de PHP-FPM
COPY	conf/wp_www.conf /etc/php/7.4/fpm/pool.d/

# Descarga wp-cli, una herramienta de línea de comandos para gestionar instalaciones de WordPress
RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Cambia los permisos del archivo wp-cli.phar para hacerlo ejecutable y lo mueve a /usr/local/bin/wp
# También crea el directorio /run/php y establece los permisos adecuados
RUN chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && mkdir -p /run/php \
    && chmod 755 /run/php

# Copia el script init_wp.sh a /usr/local/bin/ y establece permisos de ejecución
COPY	--chmod=755 tools/init_wp.sh /usr/local/bin/init_wp.sh

# Establece el directorio de trabajo para las instrucciones posteriores en /var/www/html
WORKDIR	/var/www/html

# Expone el puerto 9000, que es el puerto utilizado por PHP-FPM para recibir peticiones
EXPOSE	9000

# Establece el script init_wp.sh como punto de entrada del contenedor
ENTRYPOINT	["sh", "/usr/local/bin/init_wp.sh"]

