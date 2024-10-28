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
	@echo "make_bash: Ejecuta un shell en un contenedor."
	@echo "check_access: Comprueba el acceso a los servicios HTTP y HTTPS."
	@echo "exec_maria_client: Ejecuta un cliente MySQL en el contenedor de MariaDB."
	@echo "example: Crea un contenedor de ejemplo con un mensaje de bienvenida."
	@echo "clean_example: Elimina el contenedor de ejemplo y su directorio."

make_bash:
	@read -p "Introduce el nombre del contenedor: " CONTAINER_NAME; \
	docker exec -it "$$CONTAINER_NAME" /bin/bash

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

# Directorio y nombre del contenedor de ejemplo
EXAMPLE_DIR := ./example_container
EXAMPLE_IMAGE := example_image
EXAMPLE_CONTAINER := example_container

# Comando para construir el contenedor de ejemplo
EXAMPLE_BUILD := docker build -t $(EXAMPLE_IMAGE) $(EXAMPLE_DIR)

# Regla para crear el contenedor de ejemplo
example:
	@echo "Creando directorio para contenedor de ejemplo: $(EXAMPLE_DIR)"
	@mkdir -p $(EXAMPLE_DIR)
	@echo "Escribiendo Dockerfile en $(EXAMPLE_DIR)/Dockerfile"
	@echo 'FROM debian:bullseye' > $(EXAMPLE_DIR)/Dockerfile
	@echo 'RUN apt-get update && apt-get install -y curl' >> $(EXAMPLE_DIR)/Dockerfile
	@echo 'CMD ["echo", "¡Hola desde el CMD predeterminado!"]' >> $(EXAMPLE_DIR)/Dockerfile
	@echo "Construyendo la imagen de ejemplo..."
	$(EXAMPLE_BUILD)
	@echo "Eliminando cualquier contenedor existente llamado $(EXAMPLE_CONTAINER)..."
	@docker rm -f $(EXAMPLE_CONTAINER) 2>/dev/null || true
	@echo "Ejecutando el contenedor de ejemplo con el CMD predeterminado..."
	docker run --rm --name $(EXAMPLE_CONTAINER) $(EXAMPLE_IMAGE)
	@echo "Sobreescribiendo el CMD para este contenedor..."
	docker run --rm --name $(EXAMPLE_CONTAINER) $(EXAMPLE_IMAGE) echo "¡CMD ha sido sobrescrito!"
	@echo "El contenedor se cierrra porque el proceso ha terminado, usando tail -f /dev/null se crea un contendedor que se mantiene en ejecución."

# Regla para limpiar el contenedor de ejemplo y su directorio
clean_example:
	@echo "Deteniendo y eliminando el contenedor de ejemplo, si existe..."
	@docker rm -f $(EXAMPLE_CONTAINER) 2>/dev/null || echo "Contenedor $(EXAMPLE_CONTAINER) no está en ejecución."
	@echo "Eliminando la imagen de ejemplo..."
	@docker rmi $(EXAMPLE_IMAGE) 2>/dev/null || echo "Imagen $(EXAMPLE_IMAGE) no existe."
	@echo "Eliminando el directorio $(EXAMPLE_DIR)..."
	@rm -rf $(EXAMPLE_DIR)
	@echo "Limpieza de contenedor de ejemplo completada."
	
.PHONY: all stop clean fclean re reset example clean_example make_bash check_access exec_maria_client addhost hardclean hardreset
