const fs = require('fs-extra');

const sourceDir = '../spec';
const targetDir = './docs/yaml-specs';

// Ensure target directory exists
fs.ensureDirSync(targetDir);

// Copy all YAML files
fs.copySync(sourceDir, targetDir, {
  filter: (src) => src.endsWith('.yaml') || src.endsWith('.yml'),
});

console.log('✅ YAML specs copied to docs/yaml-specs/');
