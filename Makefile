.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Build images and start containers
	@make down
	@make build
	@make up

down: ## Remove stop containers and remove images
	@docker-compose down --remove-orphans

build: ## Build images without cache
	@docker-compose build --no-cache

stop: ## Stop containers
	@docker-compose stop

up: ## Start containers
	@docker-compose up -d

restart: ## Start containers
	@docker-compose restart

ps: ## Show running containers
	@docker-compose ps

bash: ## Shell
	@docker-compose exec -u www-data php-apache bash

bash-root: ## Shell
	@docker-compose exec php-apache bash

psql: ## psql in postgres containers
	@docker-compose exec -u postgres postgres psql

redis-cli: ## redis-cli in redis containers
	@docker-compose exec redis redis-cli

logs: ## show logs
	@docker-compose logs -f
