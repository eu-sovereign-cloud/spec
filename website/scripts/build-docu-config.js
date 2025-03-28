const fs = require("fs");
const path = require("path");

// Helper functions
const capitalizeFirstLetter = (string) =>
  string.charAt(0).toUpperCase() + string.slice(1);

const sanitizeFolderName = (name) => {
  const sanitized = name.replace(/\./g, '-').replace(/[^a-zA-Z0-9-]/g, '');
  return capitalizeFirstLetter(sanitized);
};

const specDirectory = path.join(__dirname, "../../spec"); // Directory containing YAML files

// Read all .yaml specs
const fileList = fs.readdirSync(specDirectory).filter(f => f.endsWith('.yaml'));

if (fileList.length === 0) {
  console.error("No YAML files found in the directory.");
  process.exit(1);
}

if (!fs.existsSync(specDirectory)) {
  console.error(`Error: Directory "${specDirectory}" does not exist!`);
  process.exit(1);
}

const apiConfigs = {};

for (const file of fileList) {
  const id = path.basename(file, '.yaml'); // e.g., "authorization.v1"
  const [group, ...rest] = id.split(".");
  const apiObj = rest.join(".");

  const label = capitalizeFirstLetter(apiObj);
  const folderName = sanitizeFolderName(apiObj); // e.g., "authorization-v1"

  apiConfigs[apiObj] = {
    specPath: `../spec/${file}`,
    outputDir: `docs/api/${capitalizeFirstLetter(group)}/${folderName}`,
    label,
  };
}

const templatePath = path.join(__dirname, '../docusaurus.config.template.js');// Template file
const targetPath = path.join(__dirname, '../docusaurus.config.js');// Final generated file

const template = fs.readFileSync(templatePath, 'utf8');
const result = template.replace('__API_CONFIG__', JSON.stringify(apiConfigs, null, 2));
fs.writeFileSync(targetPath, result);

console.log('✅ docusaurus.config.js generated!');

