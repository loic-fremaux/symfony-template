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
start:	## Lancer les containers docker
	$(dc) up -d

.PHONY: build
build:	## Lancer les containers docker au start du projet
	$(dc) up -d
	$(composer) install
	$(dc) exec php bash -c 'npm install'
	$(dc) up

.PHONY: start
stop:	## Arréter les containers docker
	$(dc) stop

.PHONY: rm
down:    ## Supprimer les containers docker
	$(dc) down

.PHONY: restart
restart: down start	## redémarrer les containers

.PHONY: in-dc
in-dc:	## Connexion au container php
	$(de) php bash

.PHONY: dev ##Lance le serveur de développement
dev:
	$(dc) up

## —— Symfony ———————————————————————————————————————————————————————————————

.PHONY: vendor-install
vendor-install: ## Installation des vendor
	$(COMPOSER) install

.PHONY: vendor-update
vendor-update:	## Mise à jour des vendors
	$(COMPOSER) update

.PHONY: clean-vendor
clean-vendor: cc-hard ## Suppression du répertoire vendor puis un réinstall
	$(de) rm -Rf vendor
	$(de) rm composer.lock
	$(COMPOSER) install

.PHONY: cc-hard
cc-hard: ## Supprimer le répertoire cache
	$(de) rm -fR var/cache/*

.PHONY: cc
cc:	## Vider le cache
	$(sy) c:c

.PHONY: migration
migration:	## Crée une migration
	$(sy) make:migration

.PHONY: migrate
migrate:	## Migré une migration
	$(sy) d:m:m

.PHONY: form
form:	## Crée un formulaire
	$(sy) make:form

.PHONY: controller
controller:	## Crée un controller
	$(sy) make:controller

.PHONY: login
login:	## Crée la partie authentification
	$(sy) make:auth

.PHONY: register
register:	## Crée la partie registration
	$(sy) make:registration-form

.PHONY: user
user:	## Crée l'entity user
	$(sy) make:user

.PHONY: clean-db
clean-db: ## Réinitialiser la base de donnée
	- $(sy) d:d:d --force --connection
	$(sy) d:d:c
	$(sy) d:m:m --no-interaction

## —— Others 🛠️️ ———————————————————————————————————————————————————————————————
help: ## Liste des commandes
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
