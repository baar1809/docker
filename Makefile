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

bash:
	@docker-compose exec php-apache bash
