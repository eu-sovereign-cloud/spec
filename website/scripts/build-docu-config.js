const fs = require("fs");
const path = require("path");

const specDirectory = path.join(__dirname, "../../spec"); // Directory containing YAML files
const templateFile = path.join(__dirname, "../docusaurus.config.template.js"); // Template file
const outputFilePath = path.join(__dirname, "../docusaurus.config.js"); // Final generated file

if (!fs.existsSync(specDirectory)) {
  console.error(`Error: Directory "${specDirectory}" does not exist!`);
  process.exit(1);
}

// Read all YAML files from the directory
const fileList = fs.readdirSync(specDirectory)
  .filter(file => file.endsWith(".yaml"));

if (fileList.length === 0) {
  console.error("No YAML files found in the directory.");
  process.exit(1);
}

// Generate authorization object dynamically
const authorizationObjects = fileList
  .map(file => {
    const baseName = path.basename(file, ".yaml"); // Remove .yaml extension
    const keyName = baseName.replace(".v1", ""); // Extract only the key (remove `.v1`)

    return `    "${keyName}": {
      specPath: "../spec/${file}",
      outputDir: "docs/api/${keyName}",
      label: "${keyName}"
    }`;
  })
  .join(",\n");

const authorizationConfig = `{\n${authorizationObjects}\n  }`;

// Read the template file
if (!fs.existsSync(templateFile)) {
  console.error("Error: Template file (template.js) not found!");
  process.exit(1);
}

let templateContent = fs.readFileSync(templateFile, "utf-8");

// Replace placeholder with generated authorization config
templateContent = templateContent.replace("__API_CONFIG__", authorizationConfig);

// Write the final generated file
fs.writeFileSync(outputFilePath, templateContent);

console.log(`✅ Docusaurus OpenAPI config generated in ${outputFilePath}`);
