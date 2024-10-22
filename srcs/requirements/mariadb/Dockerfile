FROM debian:bullseye
# Establece la imagen base como Debian Bullseye.

# Actualiza el índice de los repositorios y actualiza todos los paquetes instalados a la versión más reciente.
# Instala el servidor de MariaDB en la imagen.
RUN apt-get update && apt-get upgrade -y && \
    apt-get install mariadb-server -y


COPY conf/my.conf /etc/mysql/mariadb.conf.d/50-server.cnf
# Copia el archivo de configuración personalizado 'my.conf' desde el directorio local 'conf' al directorio de configuración de MariaDB dentro del contenedor.

COPY tools/init_mariadb.sh /usr/local/bin/init_mariadb.sh
# Copia el script 'init_mariadb.sh' desde el directorio local 'tools' al directorio '/usr/local/bin/' en el contenedor.

# Da permisos de ejecución al script 'init_mariadb.sh'.
# Crea el directorio '/var/run/mysqld' donde MariaDB guarda sus archivos de PID y sockets.
# Cambia el propietario de '/var/run/mysqld' a 'mysql' y establece permisos amplios (777) para el directorio.
# Cambia el propietario de los directorios '/tmp' y '/run/mysqld' a 'mysql'. Esto es necesario porque MariaDB usa estos directorios durante su ejecución.
RUN chmod +x /usr/local/bin/init_mariadb.sh && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld && \
    chown -R mysql:mysql /tmp /run/mysqld


EXPOSE 3306
# Expone el puerto 3306, que es el puerto por defecto de MariaDB. Esto permite el acceso externo al servidor MariaDB desde este puerto.

ENTRYPOINT [ "sh", "/usr/local/bin/init_mariadb.sh" ]
# Establece el script de inicio 'init_mariadb.sh' como el punto de entrada del contenedor. Este script se ejecutará cuando el contenedor arranque.
