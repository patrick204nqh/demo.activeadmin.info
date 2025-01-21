COMPOSE_FILE=.devcontainer/compose.yml

.PHONY: up
up:
	docker compose -f $(COMPOSE_FILE) up -d

.PHONY: down
down:
	docker compose -f $(COMPOSE_FILE) down

.PHONY: dev
dev:
	docker compose -f $(COMPOSE_FILE) exec web bin/dev
