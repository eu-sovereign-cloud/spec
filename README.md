# SECA - Sovereign European Cloud API

## Description

An open industry standard, a new Application Programming Interface specification for Cloud Infrastructure Management, paving the way for the EuroStack.

## Features

- Sovereignty, e.g. immunity from foreign government interference keeping API control with founding members
- Common standards reduces costs, e.g. less training, common tooling, faster adoption, …
- Broad provider support will incentivize ISVs to build profitable tools and software ecosystems
- Built-in alignment with EU regulations for resilience, data protection and privacy
- Long-term support of APIs provide reliability and maintainability
- Comparison of compliant providers and increased resources using multiple providers
- Directly address the demand of the public sector to have no vendor lock-in

## Repository structure

### `spec`

 Contains the automatically generated .yaml files, which are used to build the API documentation and website. These files are created using tools like gomplate, based on the resources, templates, and schemas.

#### `name.version.yaml`

 Versioned API definition (added manually or using a template)

#### `schemas`

Includes JSON Schema definitions that structure the API's request and response data. These schemas ensure data consistency and validation.

#### `templates`

 Holds .tpl (template) files that define reusable components for generating OpenAPI specifications dynamically. Tools like gomplate process these templates to create .yaml files.

#### `resources`

Contains all the resource definitions corresponding to different API endpoints, ensuring modular and maintainable API documentation.

### `website`

Contains all the resources and tools to build the Website API

#### `docs`

Contains Markdown documentation files for the API, used by Docusaurus to generate pages.

#### `scripts`

Utility scripts to help manage and deploy the documentation site.

#### `src`

The source code for the website, including React components and page layouts.

#### `static`

Stores static assets such as images, icons, and other resources.

#### `docusaurus.config.js`

Configuration file for the Docusaurus site, defining site structure, themes, and plugins.

#### `package.json`

Manages dependencies and scripts for building the website.

### `Makefile`

Automates the generation and validation of OpenAPI files, ensuring consistency in documentation and schema definitions.

### `config`

Configuration of linter & quality analysis tool.

## Editor

Enable an [editorconfig](https://editorconfig.org/) on your Editor.

## Generating OpenAPI Files Using Makefile

 The OpenAPI files will be used in the website.

### Prerequisites

- [Go](https://go.dev/doc/install) > 1.24

### Website Setup Instructions

```bash
# Clone the repository
git clone https://github.com/eu-sovereign-cloud/spec.git

cd spec/

# Check your Go version using `go version` and skip the instalation step if it is > 1.24
# Download the specified version of Go.
wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz

# Add Go binary to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Go Version
go version
expected: go version go1.24.1 linux/amd64

# Install gotemplate
go install github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest
echo 'export PATH="$HOME/go/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Run the Makefile to run lint and generate the OpenAPI files
make

# Verify that the `dist/specs` directory contains the generated YAML files
ls dist/specs

# Result
extensions.activitylog.v1.yaml    foundation.compute.v1.yaml       foundation.network.v1.yaml        foundation.region.v1.yaml   foundation.workspace.v1.yaml
foundation.authorization.v1.yaml  extensions.loadbalancer.v1.yaml  extensions.objectstorage.v1.yaml  foundation.storage.v1.yaml
```

## Website Installation

### Requirements

- [Node.js](https://nodejs.org/)

### Instructions

```bash
# Clone the repository
git clone https://github.com/eu-sovereign-cloud/spec.git

cd spec/website

# Run the Makefile to install the dependencies
npm install

# Run the Makefile to generate the API Docs and start the web interface
make

# Expected Result
> docs-site@0.0.0 start
> docusaurus start
[INFO] Starting the development server...
[SUCCESS] Docusaurus website is running at: http://localhost:3000/
✔ Client
  Compiled successfully in 1.12m

client (webpack 5.98.0) compiled successfully

# Navigate to `http://localhost:3000/` in your browser to view the website.

```

## Contributing

All contributors are warmly welcome. If you want to become a new contributor, we are so happy! Just, before doing it, read the tips and guidelines presented in the [dedicated documentation page](./CONTRIBUTING.md).

---

## 💰 Funding

This open-source project is sponsored by **Aruba & IONOS SE** and has received public funding from the European Union NextGenerationEU within the IPCEI-CIS program.

![SECA Funding](https://github.com/eu-sovereign-cloud/.github/raw/main/profile/SECA-Funding-Logo.png)

## License

SECA is distributed under the Apache-2.0 [License](./LICENSE). See License for more information.
