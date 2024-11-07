SRC_PATH := ./srcs/
DOCKERCOMP := docker-compose.yml
LOC_VOLUME := /home/nicgonza/data/
DATA_DB := $(LOC_VOLUME)mariadb
DATA_WP := $(LOC_VOLUME)wordpress

BUILD := docker compose -f $(SRC_PATH)$(DOCKERCOMP) up -d --build
STOP := docker compose -f $(SRC_PATH)$(DOCKERCOMP) stop
START := docker compose -f $(SRC_PATH)$(DOCKERCOMP) start
DOWN := docker compose -f $(SRC_PATH)$(DOCKERCOMP) down -v

all:
	@if [ ! -d "$(DATA_DB)" ]; then \
		mkdir -p $(DATA_DB); \
	fi
	@if [ ! -d "$(DATA_WP)" ]; then \
		mkdir -p $(DATA_WP); \
	fi
	$(BUILD)

stop:
	$(STOP)

start:
	$(START)

clean: stop
	$(DOWN)

exec_maria_client:
	docker exec -it mariadb mysql -u root -p -e "USE incpetion; SELECT * FROM wp_user;"

addhost:
	@if ! grep -q -P "127.0.0.1\s+nicgonza.42.fr" /etc/hosts; then \
		echo "127.0.0.1 nicgonza.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	else \
		echo "'127.0.0.1 nicgonza.42.fr' ya esta presente en /etc/hosts"; \
	fi

hardclean: clean
	@if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps q); \
	else \
		echo "No hay contenedores en ejecucion"; \
	fi
	
	@docker system prune --all --force

	@docker volume prune --all --force

	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	else \
		echo "No hay volumenes"; \
	fi

hardreset: hardclean
	rm -rf $(DATA_DB) $(DATA_WP)

re: clean all

make_bash:
	docker exec -it "$$(CONTAINER_NAME)" /bin/bash

check_access:
	@if curl -I -k https://nicgonza.42.fr:443; then \
		echo "HTTPS 443 OK"; \
	else \
		echo "HTTPS 443 KO"; \
	fi

	@if curl -I -k http://nicgonza.42.fr:80; then \
		echo "HTTP 80 OK"; \
	else \
		echo "HTTP 80 KO"; \
	fi

	@if curl -I -L http://nicgonza.42.fr; then \
		echo "Acceso rederigido OK"; \
	else \
		echo "Acceso rederigido KO"; \
	fi

.PHONY: all stop clean fclean re reset make_bash check_access exec_maria_client addhost hardclean hardreset
