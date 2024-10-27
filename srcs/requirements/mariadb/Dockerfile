FROM debian:bullseye
# Establece la imagen base como Debian Bullseye.

# Actualiza el índice de los repositorios y actualiza todos los paquetes instalados a la versión más reciente.
# Instala el servidor de MariaDB en la imagen. En wordpress se usara el cliente de MariaDB, relacion cliente-servidor.
RUN apt-get update && apt-get upgrade -y && \
    apt-get install mariadb-server -y


COPY conf/my.conf /etc/mysql/mariadb.conf.d/50-server.cnf
# Copia el archivo de configuración personalizado 'my.conf' desde el directorio local 'conf' al directorio de configuración de MariaDB dentro del contenedor.

COPY tools/init_mariadb.py /usr/local/bin/init_mariadb.py
# Copia el script 'init_mariadb.py' desde el directorio local 'tools' al directorio '/usr/local/bin/' en el contenedor.

# Da permisos de ejecución al script 'init_mariadb.py'.
# Crea el directorio '/var/run/mysqld' donde MariaDB guarda sus archivos de PID y sockets. Crea la ruta completa si no existe.
# Cambia el propietario de '/var/run/mysqld' a 'mysql' y establece permisos amplios (777) para el directorio. -R indica que el cambio de propietario se aplica recursivamente.
# Cambia el propietario de los directorios '/tmp' y '/run/mysqld' a 'mysql'. Esto es necesario porque MariaDB usa estos directorios durante su ejecución.
RUN chmod +x /usr/local/bin/init_mariadb.py && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld && \
    chown -R mysql:mysql /tmp /run/mysqld

# Instala Python si es necesario (en este caso para ejecutar el script de inicialización en Python)
RUN apt-get install -y python3

# Expone el puerto 3306, usado por MariaDB para las conexiones externas
EXPOSE 3306

# Define el punto de entrada como el script de Python
ENTRYPOINT ["python3", "/usr/local/bin/init_mariadb.py"]
