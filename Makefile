git:
	@if [ -z "$(git status --porcelain | grep '^??' | cut -d' ' -f1)" ]; then \
		git add .; \
		echo "\033[31mUntracked files found::\033[0m \033[32mPlease enter commit message:\033[0m"; \
		read -r msg1; \
		git commit -m "$$msg1"; \
	else \
		echo "\033[31mThere are no new files::\033[0m \033[32mPlease enter commit message:\033[0m"; \
		read -r msg2; \
		git commit -am "$$msg2"; \
	fi

build:
	@if docker images | grep -q opeoniye/dclm-moodle; then \
		echo "Removing \033[31mopeoniye/dclm-moodle\033[0m image"; \
		echo y | docker image prune --filter="dangling=true"; \
		docker image rm opeoniye/dclm-moodle; \
		echo "Building \033[31mopeoniye/dclm-moodle\033[0m image"; \
		docker build -t opeoniye/dclm-moodle:latest .; \
		docker images | grep opeoniye/dclm-moodle; \
	else \
		echo "Building \033[31mopeoniye/dclm-moodle\033[0m image"; \
		docker build -t opeoniye/dclm-moodle:latest .; \
		docker images | grep opeoniye/dclm-moodle; \
	fi

push:
	cat ops/docker/pin | docker login -u opeoniye --password-stdin
	docker push opeoniye/dclm-moodle:latest

up:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env up --detach

dev:
	cp ./ops/.env.dev ./src/.env
	cp ./docker-dev.yml ./src/docker-compose.yml
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env up -d

prod:
	cp ./ops/.env.prod ./src/.env
	cp ./docker-prod.yml ./src/docker-compose.yml
	docker pull opeoniye/dclm-moodle:latest
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env up -d

down:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env down

start:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env start

stop:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env stop

restart:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env.dev restart

destroy:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env down --volumes

shell:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env exec -it moodle-app bash

log:
	docker compose -f ./src/docker-compose.yml --env-file ./src/.env logs -f moodle-app