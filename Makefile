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
SCHEMAS_SOURCES := $(shell ls $(ROOT)/*.yaml)
SCHEMAS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/specs/%.yaml)

GOMPLATE_TEMPLATE = spec/templates/resource.yaml.tpl
GOMPLATE_SOURCES = $(shell find $(ROOT)/resources -type f -name '*.yaml')
GOMPLATE_FINAL = $(GOMPLATE_SOURCES:$(ROOT)/resources/%.yaml=$(ROOT)/%.yaml)

VACUUM := $(GO) run $(VACUUM)
VACUUM_LINT_FLAGS := -r config/ruleset-recommended.yaml -b

all: $(DIST_ZIP)

$(DIST_ZIP): build
	rm -f $@
	cd $(DIST) && zip -r ../$@ *

build: $(DIST) $(GOMPLATE_FINAL) $(SCHEMAS_FINAL)

resource-apis: $(GOMPLATE_FINAL)

$(DIST): $(ASSETS_FILES) 
	@mkdir -p $(DIST)/$(ASSETS)
	@find $(ASSETS) -type f -exec cp {} $(DIST)/$(ASSETS)/ \;

$(ROOT)/%.yaml: $(ROOT)/resources/%.yaml $(GOMPLATE_TEMPLATE)
	$(GO) run $(GOMPLATE) -d spec=$< -f $(GOMPLATE_TEMPLATE) -o $@

$(DIST)/specs/%.yaml: $(ROOT)/%.yaml $(SCHEMAS)
	@mkdir -p $(shell dirname $@)
	$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

.PHONY: lint
lint: $(GOMPLATE_FINAL) $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) $(SCHEMAS_FINAL)

.PHONY: lint-verbose
lint-verbose: $(GOMPLATE_FINAL) $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) -d $(SCHEMAS_FINAL)

.PHONY: clean
clean:
	rm -rf $(DIST) $(DIST_ZIP)
