FROM	debian:bullseye

RUN		apt-get update && apt-get upgrade -y

RUN 	apt-get install mariadb-server -y

COPY 	conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY	tools/init_mariadb.sh /usr/local/bin/init_mariadb.sh

RUN 	chmod +x  /usr/local/bin/init_mariadb.sh

RUN		mkdir -p /var/run/mysqld

RUN		chown -R mysql:mysql /var/run/mysqld \
		&& chmod 777 /var/run/mysqld
RUN		chown -R mysql:mysql /tmp  /run/mysqld

EXPOSE	3306

ENTRYPOINT	[ "sh", "/usr/local/bin/init_mariadb.sh" ]
