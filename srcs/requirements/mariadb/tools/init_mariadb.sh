#! /bin/sh

# Inicia el servicio de MariaDB
service mariadb start ;

# Si no existe un directorio de base de datos con el nombre ${DB_NAME} en /var/lib/mysql/
if [ ! -d /var/lib/mysql/${DB_NAME} ];
then
	echo "Building Database ${DB_NAME}"  # Imprime un mensaje indicando que se está creando la base de datos

	# Crear la base de datos si no existe
	mysql -u ${DB_ROOT} -p${DB_ROOT_PWD} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

	# Crear un nuevo usuario (si no existe) y asignarlo a la base de datos
	mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PWD}';"

	# Asignar todos los privilegios al usuario sobre la base de datos y sus tablas
	mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;"

	# Actualizar los privilegios para que los cambios surtan efecto
	mysql -e "FLUSH PRIVILEGES;"
	echo "Database ${DB_NAME} : Done"  # Indica que la base de datos y el usuario se han configurado
fi

# Apagar el servicio de MariaDB después de la configuración inicial
mysqladmin -u ${DB_ROOT} -p${DB_ROOT_PWD} shutdown

# Iniciar el proceso del servidor de MySQL/MariaDB
mysqld

