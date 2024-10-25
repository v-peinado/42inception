FROM debian:bullseye

# Actualiza los repositorios y paquetes
RUN apt-get update && apt-get upgrade -y

# Instala curl, PHP 7.4, PHP-FPM, el cliente de MariaDB, y Python3
RUN apt-get install -y curl python3 python3-pip \
    php7.4 php7.4-fpm php7.4-mysqli mariadb-client

# Copia la configuración de PHP-FPM desde el directorio local al directorio de configuración de PHP-FPM
COPY conf/wp_www.conf /etc/php/7.4/fpm/pool.d/

# Descarga wp-cli, una herramienta de línea de comandos para gestionar instalaciones de WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Cambia los permisos del archivo wp-cli.phar para hacerlo ejecutable y lo mueve a /usr/local/bin/wp
# También crea el directorio /run/php y establece los permisos adecuados
RUN chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && mkdir -p /run/php \
    && chmod 755 /run/php

# Copia el script de Python 'init_wp.py' a /usr/local/bin/ y establece permisos de ejecución
COPY --chmod=755 tools/init_wp.py /usr/local/bin/init_wp.py

# Copia cualquier otro archivo de configuración o dependencias de Python si es necesario
# Ejemplo: COPY requirements.txt /usr/local/bin/
# RUN pip3 install -r /usr/local/bin/requirements.txt

# Establece el directorio de trabajo para las instrucciones posteriores en /var/www/html
WORKDIR /var/www/html

# Expone el puerto 9000, que es el puerto utilizado por PHP-FPM para recibir peticiones
EXPOSE 9000

# Establece el script init_wp.py como punto de entrada del contenedor
ENTRYPOINT ["python3", "/usr/local/bin/init_wp.py"]


