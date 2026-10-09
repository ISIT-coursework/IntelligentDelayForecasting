PORT ?= 8080
WORKSPACE_DIR ?= diagrams
IMAGE ?= structurizr/structurizr:latest
DIAGRAM_IMAGE ?= structurizr/structurizr@sha256:721136283c2f9cf1ba69037bc9de136c579d66fdcb2d771cb60546ec68def1a5
DIAGRAM_OUTPUT ?= build/diagrams
DIAGRAM_PULL_POLICY ?= never
PYTHON ?= python3

DIAGRAM_DOCKER = docker run --rm --pull=$(DIAGRAM_PULL_POLICY) --network=none \
	--user "$$(id -u):$$(id -g)" \
	-v "$(abspath $(WORKSPACE_DIR)):/workspace:ro" \
	-v "$(abspath $(DIAGRAM_OUTPUT)):/output" $(DIAGRAM_IMAGE)

.PHONY: run stop diagrams-check diagrams-render
.PHONY: diagrams-test diagrams-validate diagrams-export-json diagrams-check-rules diagrams-export-html

run:
	@test -f "$(WORKSPACE_DIR)/workspace.dsl" || { echo "Missing $(WORKSPACE_DIR)/workspace.dsl"; exit 1; }
	docker run -d --rm --pull=never --name structurizr -p 127.0.0.1:$(PORT):8080 \
		-v "$(abspath $(WORKSPACE_DIR)):/usr/local/structurizr" $(IMAGE) local
	@echo "http://localhost:$(PORT)"

stop:
	-docker stop structurizr

diagrams-test:
	$(PYTHON) -m unittest discover -s scripts -p 'test_*.py'

diagrams-validate:
	@test -f "$(WORKSPACE_DIR)/workspace.dsl" || { echo "Missing $(WORKSPACE_DIR)/workspace.dsl"; exit 1; }
	mkdir -p "$(DIAGRAM_OUTPUT)"
	$(DIAGRAM_DOCKER) validate -w /workspace/workspace.dsl

diagrams-export-json:
	mkdir -p "$(DIAGRAM_OUTPUT)/model"
	$(DIAGRAM_DOCKER) export -w /workspace/workspace.dsl -f json -o /output/model

diagrams-check-rules:
	$(PYTHON) scripts/check_diagrams.py "$(DIAGRAM_OUTPUT)/model/workspace.json"

diagrams-export-html:
	mkdir -p "$(DIAGRAM_OUTPUT)/site"
	$(DIAGRAM_DOCKER) export -w /workspace/workspace.dsl -f static -o /output/site
	@test -s "$(DIAGRAM_OUTPUT)/site/index.html"
	@test -s "$(DIAGRAM_OUTPUT)/site/workspace.js"

diagrams-check:
	$(MAKE) diagrams-validate
	$(MAKE) diagrams-export-json
	$(MAKE) diagrams-check-rules

diagrams-render: diagrams-check
	$(MAKE) diagrams-export-html
