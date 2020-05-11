const jsonSchema = require('json-schema-to-typescript');
const { promises: fs } = require('fs');
const fsSync = require('fs');
const path = require('path');

const DEFINITION_DIR = 'json-schema/target/generated-resources/definitions';
const DEFINITION_FIELDS_DIR = DEFINITION_DIR + '/fields';
const DEFINITION_OUTPUT_DIR = 'fix.d/';
const DEFINITION_FIELDS_OUTPUT_DIR = DEFINITION_OUTPUT_DIR + 'fields/';
const PARENT_FULL_DIR = () => {
  const cwd = process.cwd().split(path.sep);
  cwd.pop();
  return cwd.join(path.sep);
};

(async () => {
  try {
    console.log('Starting TypeScript interface generation');
    createOutputDirectories();
    const items = await fs.readdir('../' + DEFINITION_DIR);
    await generateFieldsInterfaces(items);
    await generateFixInterfaces(items);
    await generateFixPInterfaces(items);
    await cleanAndImportDefs(DEFINITION_OUTPUT_DIR, './fields');
    await generateChartsInterfaces();
    console.log('Finished TypeScript interface generation');
  } catch(e) {
    console.log('Failed to convert TypeScript interfaces');
  }

})();

function createOutputDirectories() {
  if (!fsSync.existsSync(DEFINITION_OUTPUT_DIR) ||
    !fsSync.existsSync(DEFINITION_FIELDS_OUTPUT_DIR) ||
    !fsSync.existsSync(DEFINITION_OUTPUT_DIR + 'charts/')){

    fsSync.mkdirSync(DEFINITION_OUTPUT_DIR);
    fsSync.mkdirSync(DEFINITION_FIELDS_OUTPUT_DIR);
    fsSync.mkdirSync(DEFINITION_OUTPUT_DIR + 'charts/');
  }
}

async function generateFieldsInterfaces(items) {
  for (const i of items) {
    if (i === 'fields') {
      const fields = await fs.readdir(`../${DEFINITION_DIR}/${i}`);
      for (const i of fields) {
        await generateSchema(i, `${PARENT_FULL_DIR()}/${DEFINITION_FIELDS_DIR}/${i}`, DEFINITION_FIELDS_OUTPUT_DIR);
      }
    }
  }
}

async function generateFixInterfaces(items) {
  const mainResponses = items.filter(i => i !== 'fields');
  const generatedFixInterfaces = [];
  for (const directory of mainResponses) {
    const inputDir = `${PARENT_FULL_DIR()}/${DEFINITION_DIR}/${directory}`;
    const files = await fs.readdir(inputDir);
    for (const file of files) {
      const input = `${inputDir}/${file}`;
      const outputDir = `${DEFINITION_OUTPUT_DIR}`;
      const cwd = `${PARENT_FULL_DIR()}/${DEFINITION_DIR}/${file}/`;
      await generateSchema(file, input, outputDir, { cwd, declareExternallyReferenced: false });
    }
  }
}

async function generateFixPInterfaces() {
  const cwd = PARENT_FULL_DIR().replace('/ig-us-rfed', '/fixp/json-schema/src/main/resources');
  const fixpSchemaFiles = await fs.readdir('../../fixp/json-schema/src/main/resources');
  for (const i of fixpSchemaFiles) {
    await generateSchema(i, `${cwd}/${i}`, `${DEFINITION_OUTPUT_DIR}`, {
      cwd,
      declareExternallyReferenced: false
    });
  }
}

async function generateChartsInterfaces() {
  const cwd = PARENT_FULL_DIR().replace('/ig-us-rfed', '/chart-data/java-binding/target/json-schema');
  const chartSchemaFiles = await fs.readdir('../../chart-data/java-binding/target/json-schema');
  const generatedChartInterfaces = [];
  chartSchemaFiles.forEach((i) => {
    generatedChartInterfaces.push(generateSchema(i, `${cwd}/${i}`, `${DEFINITION_OUTPUT_DIR}charts/`, {
      cwd,
      declareExternallyReferenced: false
    }));
  });

  const result = await Promise.all(generatedChartInterfaces);
  if (result) {
    await cleanAndImportDefs(DEFINITION_OUTPUT_DIR + 'charts/', '../fields');
  }
}

async function generateSchema(file, inputDir, outputDir, opts) {
  const filename = file.replace('.json', '') + '.d.ts';

  try {
    const schema = await jsonSchema.compileFromFile(inputDir, opts);
    await fs.writeFile(outputDir + filename, schema);
    return true;
  } catch(e) {
    console.log('error is ' + e);
  }
}

async function cleanAndImportDefs(path, fieldsDir) {
  const items = await fs.readdir(path);
  items.filter(i => i.includes('.ts')).forEach(async (def) => {
    const file = await fs.readFile(path + def);
    if (Buffer.isBuffer(file)) {
      let className = def.replace('.d.ts', '');
      let filePerLine = file.toString().trim().split('\n');
      let mainClassIndex = filePerLine.findIndex(s => s.includes('interface ' + className) || s.includes('type ' + className));
      let finalOutput = '';
      // iterate from interface declaration onwards to iterate each property line.
      for (let i = mainClassIndex; i < filePerLine.length; i++) {
        if (filePerLine[i]) {
          /*
          * same definitions are somehow generated as different definitions
          * for example: { high: {$ref: 'CandlePrice'}, low: {$ref: 'CandlePrice'}, open: {$ref: 'CandlePrice'} }
          * generated as interface x { high: CandlePrice, low: CandlePrice1, open: CandlePrice2 etc.. }
          * */
          finalOutput += filePerLine[i].replace(/[0-9]+/, '') + '\n';
          const isLinePropertyAndType = filePerLine[i] && filePerLine[i].match(/\??: [A-Z]/g);

          if (isLinePropertyAndType) {
            let foundClass = filePerLine[i].split(':')[1].trim();
            const tsInterface = foundClass.replace(/(\[\])*;/, '').replace(/[0-9]+/, '');
            finalOutput = await addImportStatement(items, foundClass, tsInterface, finalOutput, fieldsDir);
          }
          const isEndOfFile = (filePerLine[i + 1] && filePerLine[i + 1].includes('/')) || i === filePerLine.length;
          if (isEndOfFile) {
            break;
          }
        }
      }
      await fs.writeFile(path + def, '');
      await fs.writeFile(path + def, finalOutput);
    }

  })
}

async function addImportStatement(items, foundClass, tsInterface, finalOutput, fieldsDir) {
  if (items.includes(foundClass.replace(/(\[\])*;/, '.d.ts'))) {
    if (!items.includes(`import { ${tsInterface} }`)) {
      const toImportValue = foundClass.replace(/(\[\])*;/, '.d\';');
      finalOutput = `import { ${tsInterface} } from './${toImportValue}\n${finalOutput}`;
    }
  } else {
    try {
      await fs.access(`./fix.d/fields/${tsInterface}.d.ts`);
      const toImportValue = foundClass.replace(';', '.d\';');
      finalOutput = `import { ${tsInterface} } from '${fieldsDir}/${toImportValue}\n${finalOutput}`;
    } catch (e) {
    }

    try {
      await fs.access(`./fix.d/${tsInterface}.d.ts`);
      const toImportValue = foundClass.replace(';', '.d\';');
      finalOutput = `import { ${tsInterface} } from '../${toImportValue}\n${finalOutput}`;
    } catch(e) {}
  }
  return finalOutput;
}