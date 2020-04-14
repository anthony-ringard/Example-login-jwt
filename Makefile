# Variables

DOCKER_COMPOSE = docker-compose -f docker-compose.yml -f docker-compose.tools.yml
DOCKER_COMPOSE_RUN = $(DOCKER_COMPOSE) run --rm


# -- Cmd Install --

install: build start

# -- Cmd --

build:
	$(DOCKER_COMPOSE) build

start:
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) stop

ps:
	$(DOCKER_COMPOSE) ps

down:
	$(DOCKER_COMPOSE) down

php:
	$(DOCKER_COMPOSE_RUN) php bash
	
learning-console:
	$(DOCKER_COMPOSE_RUN) learning_php-fpm bin/console ${cmd}


newman:
    $(DOCKER_COMPOSE_RUN) newman run "https://www.getpostman.com/collections/XXXXXXXXXX"

# --
