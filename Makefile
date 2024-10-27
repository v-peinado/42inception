SRC_PATH := ./srcs/
DOCKERCOMP := docker-compose.yml
LOC_VOLUME := /home/victor/data/
DATA_DB := $(LOC_VOLUME)mariadb
DATA_WP:=$(LOC_VOLUME)wordpress

BUILD := docker compose -f $(SRC_PATH)$(DOCKERCOMP) up -d --build
STOP := docker compose -f $(SRC_PATH)$(DOCKERCOMP) stop
START := docker compose -f $(SRC_PATH)$(DOCKERCOMP) start
DOWN := docker compose -f $(SRC_PATH)$(DOCKERCOMP) down -v

all:
	@echo "Verificando si existen los directorios $(DATA_DB) y $(DATA_WP)..."
	@if [ ! -d "$(DATA_DB)" ]; then \
		echo "Creando directorio para MariaDB: $(DATA_DB)"; \
		mkdir -p $(DATA_DB); \
	fi
	@if [ ! -d "$(DATA_WP)" ]; then \
		echo "Creando directorio para WordPress: $(DATA_WP)"; \
		mkdir -p $(DATA_WP); \
	fi
	@echo "Directorios verificados."
	$(BUILD)

stop: 
	$(STOP)

start:
	$(START)

clean: stop
	$(DOWN)

exec_maria_client:
	docker exec -it mariadb mysql -u root -p -e "USE inception; SELECT * FROM wp_users;"

exec_nginx:
	docker exec -it nginx /bin/sh

addhost:
	@echo "Verificando si '127.0.0.1 vpeinado.42.fr' ya está en /etc/hosts..."
	@if ! grep -q -P "127.0.0.1\s+vpeinado.42.fr" /etc/hosts; then \
		echo "Agregando '127.0.0.1 vpeinado.42.fr' a /etc/hosts"; \
		echo "127.0.0.1 vpeinado.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	else \
		echo "'127.0.0.1    vpeinado.42.fr' ya está presente en /etc/hosts"; \
	fi

hardclean: clean
	@echo "Deteniendo todos los contenedores en ejecución..."
	@if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps -q); \
	else \
		echo "No hay contenedores en ejecución para detener."; \
	fi

	@echo "Podando objetos no utilizados de Docker..."
	@docker system prune --all --force

	@echo "Podando volúmenes no utilizados de Docker..."
	@docker volume prune --all --force

	@echo "Eliminando todos los volúmenes de Docker..."
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	else \
		echo "No hay volúmenes para eliminar."; \
	fi

hardreset: hardclean
	@echo "Borrando contenido de los directorios de la base de datos y WordPress..."
	@rm -rf $(DATA_DB) $(DATA_WP)
	@echo "Contenido borrado. Listo para nueva configuración."

re: clean all

help:
	@echo "Uso: make [all | stop | clean | hardclean | hardreset | re]"
	@echo "all: Inicia los contenedores de WordPress y MariaDB."
	@echo "stop: Detiene los contenedores de WordPress y MariaDB."
	@echo "start: Inicia los contenedores de WordPress y MariaDB."
	@echo "clean: Detiene y elimina los contenedores de WordPress y MariaDB."
	@echo "addhost: Agrega la entrada '127.0.0.1    vpeinado.42.fr' al archivo /etc/hosts."
	@echo "hardclean: Detiene y elimina todos los contenedores y volúmenes de Docker."
	@echo "hardreset: Borra el contenido de los directorios de la base de datos y WordPress."

check_access:
	@echo "Comprobando acceso HTTPS en puerto 443..."
	@if curl -I -k https://vpeinado.42.fr:443; then \
		echo "Acceso HTTPS en puerto 443 OK"; \
	else \
		echo "Error al acceder a HTTPS en puerto 443"; \
	fi
	@echo "Comprobando acceso HTTP en puerto 80..."
	@if curl -I -k http://vpeinado.42.fr:80; then \
		echo "Acceso HTTP en puerto 80 OK"; \
	else \
		echo "Error al acceder a HTTP en puerto 80"; \
	fi
	@echo "Comprobando acceso redirigido en HTTP..."
	@if curl -I -L http://vpeinado.42.fr; then \
		echo "Acceso redirigido OK"; \
	else \
		echo "Error al acceder a la URL redirigida"; \
	fi

	
.PHONY: all stop clean fclean re reset
