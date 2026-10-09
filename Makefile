PORT ?= 8080
WORKSPACE_DIR ?= diagrams/structurizr-test
IMAGE ?= structurizr/structurizr:latest

.PHONY: run stop

run:
	@test -f "$(WORKSPACE_DIR)/workspace.dsl" || { echo "Missing $(WORKSPACE_DIR)/workspace.dsl"; exit 1; }
	docker run -d --rm --pull=never --name structurizr -p 127.0.0.1:$(PORT):8080 \
		-v "$(abspath $(WORKSPACE_DIR)):/usr/local/structurizr" $(IMAGE) local
	@echo "http://localhost:$(PORT)"

stop:
	-docker stop structurizr
