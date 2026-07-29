GO ?= go
GO_TOOL := $(GO) -C ./tools run -mod=mod

REDOCLY := npx @redocly/cli
REDOCLY_BUNDLE_FLAGS := --remove-unused-components

DIST = dist

SPEC_ROOT = spec
SPEC_SCHEMAS := $(shell find $(SPEC_ROOT)/schemas -type f)
SPEC_SOURCES = $(shell find $(SPEC_ROOT) -maxdepth 1 -name '*.yaml')
SPEC_FINAL = $(SPEC_SOURCES:$(SPEC_ROOT)/%.yaml=$(DIST)/spec/%.yaml)

GOMPLATE = github.com/hairyhenderson/gomplate/v4/cmd/gomplate
GOMPLATE_TEMPLATE = spec/templates/resource.yaml.tpl
GOMPLATE_SOURCES = $(shell find $(SPEC_ROOT)/resources -type f -name '*.yaml')

VACUUM = github.com/daveshanley/vacuum
VACUUM_LINT_FLAGS := -r $(CURDIR)/config/vacuum/ruleset.yaml -b

BLUE  = \033[1;34m
GREEN = \033[1;32m
YELLOW = \033[1;33m
RESET = \033[0m

.PHONY: all build resource-apis lint clean tag

all: clean build lint

build: $(DIST) resource-apis $(SPEC_FINAL)

resource-apis:
	@echo "$(BLUE)Generating Spec OpenAPI resources with gomplate...$(RESET)"
	@for f in $(GOMPLATE_SOURCES); do \
		group="$$($(GO_TOOL) $(GOMPLATE) -d spec=$(CURDIR)/$$f -i '{{ (ds "spec").group }}')"; \
		name="$$($(GO_TOOL) $(GOMPLATE) -d spec=$(CURDIR)/$$f -i '{{ (ds "spec").name }}' | tr '[:upper:]' '[:lower:]' | tr -d ' -')"; \
		version="$$($(GO_TOOL) $(GOMPLATE) -d spec=$(CURDIR)/$$f -i '{{ (ds "spec").version }}')"; \
		out="$(SPEC_ROOT)/$${group}.$${name}.$${version}.yaml"; \
		echo "$(GREEN)→ $$out$(RESET) from $$f"; \
		$(GO_TOOL) $(GOMPLATE) -d spec=$(CURDIR)/$$f -f $(CURDIR)/$(GOMPLATE_TEMPLATE) -o $(CURDIR)/$$out; \
	done

$(DIST):
	@mkdir -p $(DIST)

$(SPEC_ROOT)/%.yaml: $(SPEC_ROOT)/resources/%.yaml $(GOMPLATE_TEMPLATE) $(SPEC_SCHEMAS) | resource-apis
	@$(GO_TOOL) $(GOMPLATE) -d spec=$(CURDIR)/$< -f $(CURDIR)/$(GOMPLATE_TEMPLATE) -o $(CURDIR)/$@

$(DIST)/spec/%.yaml: $(SPEC_ROOT)/%.yaml $(SPEC_SCHEMAS)
	@mkdir -p $(dir $@)
	@$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

lint: build
	@echo "$(YELLOW)Linting Spec OpenAPI files...$(RESET)"
	@$(MAKE) $(SPEC_FINAL)
	@SCHEMAS="$$(find $(CURDIR)/$(DIST)/spec -type f -name '*.yaml')"; \
	if [ -z "$$SCHEMAS" ]; then \
		echo "$(YELLOW)⚠️  No Spec OpenAPI files found to lint.$(RESET)"; \
		exit 1; \
	fi; \
	$(GO_TOOL) $(VACUUM) lint $(VACUUM_LINT_FLAGS) -d $$SCHEMAS --fail-severity warn

clean:
	@echo "$(BLUE)Cleaning up...$(RESET)"
	@rm -rf $(DIST) $(SPEC_ROOT)/*.yaml

tag:
	@if [ -z "$(VERSION)" ]; then \
		echo "ERROR: VERSION is required. Usage: make tag VERSION=v0.1.0"; \
		exit 1; \
	fi
	@echo "Tagging $(VERSION)..."
	git tag $(VERSION)
	git push origin $(VERSION)
