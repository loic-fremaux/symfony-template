.PHONY: help
.DEFAULT_GOAL = help

dc = docker-compose
de = $(dc) exec
dec = $(de) php
sy = $(dec) bin/console
composer = $(dec) php -d memory_limit=-1 /usr/local/bin/composer
npm = npm install

## —— Docker 🐳  ———————————————————————————————————————————————————————————————
.PHONY: start
start:	## Start docker stack
	$(dc) up -d

.PHONY: build
build:	## Install composer and nodejs dependencies
	$(dc) up -d
	$(composer) install
	$(dc) exec php bash -c 'npm install'
	$(dc) up

.PHONY: start
stop:	## Stop all containers
	$(dc) stop

.PHONY: rm
down:    ## Stop and remove all containers
	$(dc) down

.PHONY: restart
restart: down start	## Restart (rebuild) containers

.PHONY: in-dc
in-dc:	## Run into php container
	$(de) php bash

.PHONY: dev ## Run dev server
dev:
	$(dc) up

## —— Symfony ———————————————————————————————————————————————————————————————

.PHONY: vendor-install
vendor-install: ## Install composer dependencies
	$(COMPOSER) install

.PHONY: vendor-update
vendor-update:	## Update composer dependencies
	$(COMPOSER) update

.PHONY: clean-vendor
clean-vendor: cc-hard ## Reinstall dependencies
	$(de) rm -Rf vendor
	$(de) rm composer.lock
	$(COMPOSER) install

.PHONY: cc-hard
cc-hard: ## Remove cache folder
	$(de) rm -fR var/cache/*

.PHONY: cc
cc:	## Clear cache using php console
	$(sy) c:c

.PHONY: migration
migration:	## Create migration
	$(sy) make:migration

.PHONY: migrate
migrate:	## Execute pending migrations
	$(sy) d:m:m

.PHONY: form
form:	## Create a form
	$(sy) make:form

.PHONY: controller
controller:	## Create a controller
	$(sy) make:controller

.PHONY: login
login:	## Create auth interface
	$(sy) make:auth

.PHONY: register
register:	## Create registration interface
	$(sy) make:registration-form

.PHONY: user
user:	## Create user entity
	$(sy) make:user

.PHONY: clean-db
clean-db: ## Clear database
	- $(sy) d:d:d --force --connection
	$(sy) d:d:c
	$(sy) d:m:m --no-interaction

## —— Others 🛠️️ ———————————————————————————————————————————————————————————————
help: ## Show help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
