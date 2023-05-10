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

deploy:
	flyctl deploy

rubocop:
	bundle exec rubocop -A

test:
	rspec

er:
#	docker compose exec -it web rails mermaid_erd
	rails mermaid_erd
