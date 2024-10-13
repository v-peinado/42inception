#! /bin/sh

service mariadb start ;

if [ ! -d /var/lib/mysql/${DB_NAME} ];
then
	echo "Building Database ${DB_NAME}"
	#Create the Database at startup if doesn'tn exist
	mysql -u ${DB_ROOT} -p${DB_ROOT_PWD} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

	#Create anew user (if not exist) and assign it to D
	mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PWD}';"

	#Assign all rights to user on DB and sub-tables
	mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;"

	#Update all
	mysql -e "FLUSH PRIVILEGES;"
	echo "Database ${DB_NAME} : Done"
fi

mysqladmin -u ${DB_ROOT} -p${DB_ROOT_PWD} shutdown

mysqld
