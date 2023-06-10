# https://makefiletutorial.com/

SHELL := /bin/bash

# copy .env file based on environment
SRC := $(shell os=$$(uname -s); \
	if [[ "$$os" == "Linux" ]]; then \
		cp ./ops/.env.prod ./src/.env; \
		cp ./docker-prod.yml ./src/docker-compose.yml; \
	elif [[ "$$os" == "Darwin" ]]; then \
		cp ./ops/.env.dev ./src/.env; \
		cp ./docker-dev.yml ./src/docker-compose.yml; \
	else \
		exit 1; \
	fi)

# load .env file
include ./src/.env

repo:
	@echo -e "\033[31mEnter directory name:\033[0m "; \
	read -r code; \
	cd ~/dev/web/dclm/$$code; \
	git init && git add . && git commit -m "DCLM Academy"; \
	echo -e "\033[31mEnter Github repo name :\033[0m "; \
	read -r repo; \
	gh repo create dclmict/$$repo --public --source=. --remote=origin; \
	git push --set-upstream origin main

git:
	@if git status --porcelain | grep -q '^??'; then \
		echo -e "\033[31mUntracked files found::\033[0m \033[32mPlease enter commit message:\033[0m"; \
		read -r msg1; \
		git add -A; \
		git commit -m "$$msg1"; \
		read -p "Do you want to push your commit to GitHub? (yes|no): " choice; \
		case "$$choice" in \
			yes|Y|y) \
				echo -e "\033[32mPushing commit to GitHub...:\033[0m"; \
				git push; \
				;; \
			no|N|n) \
				echo -e "\033[32m Nothing to be done. Thank you...:\033[0m"; \
				exit 0; \
				;; \
			*) \
				echo -e "\033[32m No choice. Exiting script...:\033[0m"; \
				exit 1; \
				;; \
		esac \
	else \
		echo -e "\033[31mThere are no new files::\033[0m \033[32mPlease enter commit message:\033[0m"; \
		read -r msg2; \
		git commit -am "$$msg2"; \
		read -p "Do you want to push your commit to GitHub? (yes|no): " choice; \
		case "$$choice" in \
			yes|Y|y) \
				echo -e "\033[32mPushing commit to GitHub...:\033[0m"; \
				git push; \
				;; \
			no|N|n) \
				echo -e "\033[32m Nothing to be done. Thank you...:\033[0m"; \
				exit 0; \
				;; \
			*) \
				echo -e "\033[32m No choice. Exiting script...:\033[0m"; \
				exit 1; \
				;; \
		esac \
	fi

build:
	make down
	@if docker images | grep -q $(DIN); then \
		echo -e "\033[31mRemoving all dangling images\033[0m image"; \
		echo y | docker image prune --filter="dangling=true"; \
		echo -e "Building \033[31m$(DIN):$(DIV)\033[0m image"; \
		docker build -t $(DIN):$(DIV) .; \
		docker images | grep $(DIN); \
	else \
		echo -e "Building \033[31m$(DIN):$(DIV)\033[0m image"; \
		docker build -t $(DIN):$(DIV) .; \
		docker images | grep $(DIN); \
	fi
	make up

push:
	echo ${DLP} | docker login -u opeoniye --password-stdin
	docker push $(DIN):$(DIV)

up:
	@echo -e "\033[31mStarting container...\033[0m"; \
	cp ops/app/config.php src/app/config.php; \
	if [[ "$$(uname -s)" == "Linux" ]]; then \
		if [ -f ops/.env.prod]; then \
			echo -e "\033[32mPaste .env content and save with :wq\033[0m"; \
			vim ops/.env.prod; \
			cp ./ops/.env.prod ./src/.env; \
			docker pull $(DIN):$(DIV); \
			docker compose -f ./src/docker-compose.yml --env-file ./src/.env up -d; \
		else \
			touch ops/.env.prod; \
			echo -e "\033[32mPaste .env content and save with :wq\033[0m"; \
			vim ops/.env.prod; \
			cp ./ops/.env.prod ./src/.env; \
			docker pull $(DIN):$(DIV); \
			docker compose -f ./src/docker-compose.yml --env-file ./src/.env up -d; \
		fi \
	elif [[ "$$(uname -s)" == "Darwin" ]]; then \
		docker compose -f ./src/docker-compose.yml --env-file ./src/.env up -d; \
	else \
		exit 1; \
	fi

down:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env down

start:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env start

stop:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env stop

restart:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env restart

destroy:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env down --volumes

shell:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env exec -it $(CN) bash

ps:
	docker compose -f ./src/docker-compose.yml ps

log:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env logs -f $(CN)

run:
	@echo "\033[31mEnter command to run inside container: \033[0m"; \
	read -r cmd; \
	docker compose -f ./src/docker-compose.yml exec $(CN) bash -c "$$cmd"

update:
	git restore .
	git pull