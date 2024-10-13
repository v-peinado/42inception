
SRC_PATH := ./srcs/
DOCKERCOMP := docker-compose.yml
LOC_VOLUME := /home/vpeinado/data/
DATA_DB := $(LOC_VOLUME)mariadb/*
DATA_WP:=$(LOC_VOLUME)wordpress/*

BUILD := docker compose -f $(SRC_PATH)$(DOCKERCOMP) up -d --build
STOP := docker compose -f $(SRC_PATH)$(DOCKERCOMP) stop
DOWN := docker compose -f $(SRC_PATH)$(DOCKERCOMP) down -v

all:
	$(BUILD)

stop: 
	$(STOP)
clean: stop
	$(DOWN)

wipeout: 
	-docker stop $$(docker ps -q)
	-docker system prune --all --force
	-docker volume prune --all --force
	-docker volume rm $$(docker volume ls -q)

re: clean all	

.PHONY: all stop clean fclean re
