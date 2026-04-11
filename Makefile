COMPOSE ?= docker-compose
COMPOSE_FILE := -f srcs/docker-compose.yml
DC := $(COMPOSE) $(COMPOSE_FILE)

.PHONY: build up down logs ps clean fclean re

build:
	$(DC) build mariadb

up:
	$(DC) up -d mariadb

down:
	$(DC) down

logs:
	$(DC) logs -f --tail=100 mariadb

ps:
	$(DC) ps

clean:
	$(DC) down

fclean:
	$(DC) down -v --rmi local

re: fclean build up
