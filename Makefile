LOGIN 			= wweerasi
DATA_PATH 		= /home/$(LOGIN)/data
MARIADB_DIR 	= $(DATA_PATH)/mariadb
WORDPRESS_DIR 	= $(DATA_PATH)/wordpress

COMPOSE 		= docker compose -f ./srcs/docker-compose.yml

GREEN 			= \033[1;32m
RED 			= \033[1;31m
BLUE 			= \033[1;34m
RESET 			= \033[0m

all: build up

dirs:
	@printf "$(BLUE)==> Creating host data directories...$(RESET)\n"
	@mkdir -p $(MARIADB_DIR)
	@mkdir -p $(WORDPRESS_DIR)

build: dirs
	@printf "$(BLUE)==> Building Docker images...$(RESET)\n"
	@$(COMPOSE) build

up: dirs
	@printf "$(GREEN)==> Starting infrastructure...$(RESET)\n"
	@$(COMPOSE) up -d

down:
	@printf "$(RED)==> Stopping infrastructure...$(RESET)\n"
	@$(COMPOSE) down

clean:
	@printf "$(RED)==> Cleaning containers and networks...$(RESET)\n"
	@$(COMPOSE) down --rmi all -v

fclean: clean
	@printf "$(RED)==> Destroying permanent data and wiping Docker cache...$(RESET)\n"
	@sudo rm -rf $(DATA_PATH)
	@docker system prune -af --volumes

re: fclean all

.PHONY: all dirs build up down clean fclean re
