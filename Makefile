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
	@echo "$(BLUE)==> Creating host data directories...$(RESET)"
	@mkdir -p $(MARIADB_DIR)
	@mkdir -p $(WORDPRESS_DIR)

build: dirs
	@echo "$(BLUE)==> Building Docker images...$(RESET)"
	@$(COMPOSE) build

up: dirs
	@echo "$(GREEN)==> Starting infrastructure...$(RESET)"
	@$(COMPOSE) up -d

down:
	@echo "$(RED)==> Stopping infrastructure...$(RESET)"
	@$(COMPOSE) down

clean:
	@echo "$(RED)==> Cleaning containers and networks...$(RESET)"
	@$(COMPOSE) down --rmi all -v

fclean: clean
	@echo "$(RED)==> Destroying permanent data and wiping Docker cache...$(RESET)"
	@sudo rm -rf $(DATA_PATH)
	@docker system prune -af --volumes

re: fclean all

.PHONY: all dirs build up down clean fclean re
