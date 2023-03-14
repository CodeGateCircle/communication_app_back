DOCKER_WEB = docker compose exec -it web

.PHONY: bash
bash:
	$(DOCKER_WEB) bash

.PHONY: up
up:
	docker compose up -d --build
	$(DOCKER_WEB) rails db:migrate
	docker ps

.PHONY: down
down:
	docker compose down