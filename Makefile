GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
GOMPLATE = github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest

ROOT = spec
DIST = dist
DIST_ZIP = dist.zip
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml

REDOCLY := npx @redocly/cli
REDOCLY_BUNDLE_FLAGS := --remove-unused-components
REDOCLY_DOCS_FLAGS := --disableGoogleFont

SCHEMAS := $(shell find $(ROOT)/schemas -type f)
SCHEMAS_SOURCES = $(shell find $(ROOT) -maxdepth 1 -name '*.yaml')
SCHEMAS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/specs/%.yaml)

GOMPLATE_TEMPLATE = spec/templates/resource.yaml.tpl
GOMPLATE_SOURCES = $(shell find $(ROOT)/resources -type f -name '*.yaml')
GOMPLATE_FINAL = $(GOMPLATE_SOURCES:$(ROOT)/resources/%.yaml=$(ROOT)/%.yaml)

VACUUM := $(GO) run $(VACUUM)
VACUUM_LINT_FLAGS := -r config/ruleset-recommended.yaml -b

BLUE  = \033[1;34m
GREEN = \033[1;32m
YELLOW = \033[1;33m
RESET = \033[0m

.PHONY: all build clean lint lint-verbose resource-apis

all: $(DIST_ZIP)

$(DIST_ZIP): build
	@command -v zip >/dev/null || { echo "$(YELLOW)⚠️  zip command not found or not executable. Please install zip.$(RESET)"; exit 1; }
	@echo "$(BLUE)Zipping build output...$(RESET)"
	@rm -f $@
	@cd $(DIST) && zip -r ../$@ *


build: $(DIST) resource-apis $(SCHEMAS_FINAL)

resource-apis:
	@echo "$(BLUE)Generating OpenAPI resources with gomplate...$(RESET)"
	@for f in $(GOMPLATE_SOURCES); do \
		group="$$(gomplate -d spec=$$f -i '{{ (ds "spec").group }}')"; \
		name="$$(gomplate -d spec=$$f -i '{{ (ds "spec").name }}' | tr '[:upper:]' '[:lower:]' | tr -d ' -')"; \
		version="$$(gomplate -d spec=$$f -i '{{ (ds "spec").version }}')"; \
		out="$(ROOT)/$${group}.$${name}.$${version}.yaml"; \
		echo "$(GREEN)→ $$out$(RESET) from $$f"; \
		$(GO) run $(GOMPLATE) -d spec=$$f -f $(GOMPLATE_TEMPLATE) -o $$out; \
	done

$(DIST):
	@mkdir -p $(DIST)

$(ROOT)/%.yaml: $(ROOT)/resources/%.yaml $(GOMPLATE_TEMPLATE) $(SCHEMAS) | resource-apis
	@$(GO) run $(GOMPLATE) -d spec=$< -f $(GOMPLATE_TEMPLATE) -o $@

$(DIST)/specs/%.yaml: $(ROOT)/%.yaml $(SCHEMAS)
	@mkdir -p $(dir $@)
	@$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

lint: resource-apis
	@echo "$(YELLOW)Linting OpenAPI specs...$(RESET)"
	@$(MAKE) $(SCHEMAS_FINAL)
	@SCHEMAS="$$(find $(DIST)/specs -type f -name '*.yaml')"; \
	if [ -z "$$SCHEMAS" ]; then \
		echo "$(YELLOW)⚠️  No OpenAPI specs found to lint.$(RESET)"; \
		exit 1; \
	fi; \
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) $$SCHEMAS

lint-verbose: resource-apis
	@echo "$(YELLOW)Linting OpenAPI specs (verbose)...$(RESET)"
	@$(MAKE) $(SCHEMAS_FINAL)
	@SCHEMAS="$$(find $(DIST)/specs -type f -name '*.yaml')"; \
	if [ -z "$$SCHEMAS" ]; then \
		echo "$(YELLOW)⚠️  No OpenAPI specs found to lint.$(RESET)"; \
		exit 1; \
	fi; \
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) -d $$SCHEMAS

clean:
	@echo "$(BLUE)Cleaning up...$(RESET)"
	@rm -rf $(DIST) $(DIST_ZIP) $(OUTPUT) $(ROOT)/*.yaml
