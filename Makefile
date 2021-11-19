init:
	@make down
	@make build
	@make up

down:
	@docker-compose down --remove-orphans

build:
	@docker-compose build --no-cache

stop:
	@docker-compose stop

up:
	@docker-compose up -d

ps:
	@docker-compose ps

bash:
	@docker-compose exec -u www-data php-apache bash

psql:
	@docker-compose exec -u postgres postgres psql

redis-cli:
	@docker-compose exec redis redis-cli

logs:
	@docker-compose logs -f
